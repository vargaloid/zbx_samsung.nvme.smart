#!/usr/bin/env bash

# Variables
DFile="/tmp/zbx.sams.nvme.smart.discovery.txt"
IFile="/tmp/zbx.sams.nvme.smart.items.txt"
Value_In_Bytes="512000"
Bytes_Per_TB="1000000000000"
#Bytes_Per_TB="1099511627776"

# Create files
touch ${IFile} && chmod 664 ${IFile} && cp /dev/null ${IFile}
touch ${DFile} && chmod 664 ${DFile}

# Identify Samsung SSD NVMe
Disks=$(lsblk --nodeps -oNAME,TRAN,MODEL | grep -E "nvme"| awk '{print substr($1, 1, length($1)-2)}')

# Debug
#echo "Disks: "
#echo "$Disks"
#echo "====="

# Create items file
for label in $Disks ; do
	echo -n "$label SerialNumber: " >> $IFile && lsblk --nodeps -oNAME,SERIAL | grep "$label" | awk '{print $2}' >> $IFile
	echo -n "$label Temperature: " >> $IFile && smartctl -A /dev/$label | grep Temperature: | awk '{print $2}' >> $IFile
	AvSpare=$(smartctl -A /dev/$label  | grep "Spare:" | awk '{print $3}' | sed 's/%//')
	AvSpareTr=$(smartctl -A /dev/$label | grep "Spare Threshold:" | awk '{print $4}' | sed 's/%//')
	if [ $AvSpare -le $AvSpareTr ]; then
		Spare="1"
	else
		Spare="0"
	fi
	echo "$label AvailableSpare: $Spare" >> $IFile
	echo -n "$label Used: " >> $IFile && smartctl -A /dev/$label  | grep "Used:" | awk '{print $3}' | sed 's/%//' >> $IFile
	Unit_Read=$(smartctl -A /dev/$label | grep "Units Read:" | awk '{print $4}' | sed -e 's/[^0-9]//g')
	Sum_Unit_Read=$(echo "$Unit_Read * $Value_In_Bytes / $Bytes_Per_TB"| bc)
	echo "$label DataUnitsRead: $Sum_Unit_Read" >> $IFile
	Unit_Write=$(smartctl -A /dev/$label | grep "Units Written:"  | awk '{print $4}' | sed -e 's/[^0-9]//g')
	Sum_Unit_Write=$(echo "$Unit_Write * $Value_In_Bytes / $Bytes_Per_TB"| bc)
	echo "$label DataUnitsWritten: $Sum_Unit_Write" >> $IFile
	echo -n "$label PowerOnHours: " >> $IFile && smartctl -A /dev/$label  | grep "On Hours:" | awk '{print $4}' | sed -e 's/[^0-9]//g' >> $IFile
done

# Create discovery file
echo '{ "data": [' > ${DFile}

cat ${IFile} | grep "SerialNumber:" | awk '{print $1}' | while read LINE
    do
    echo "{\"{#DISK}\":\"$LINE\"}," >> ${DFile}
    done

echo ']}' >> ${DFile}

OMMALINE=$(cat ${DFile} | wc -l)
OMMA=$(echo "${OMMALINE} - 1" | bc)
NEWDFILE=$(sed "${OMMA}s/,//" ${DFile})
echo "${NEWDFILE}" > ${DFile}


echo "1"
