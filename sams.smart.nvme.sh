#!/usr/bin/env bash

# Variables
DFile="/tmp/zbx.sams.nvme.smart.discovery.txt"
IFile="/tmp/zbx.sams.nvme.smart.items.txt"

# Create files
touch ${IFile} && chmod 664 ${IFile} && cp /dev/null ${IFile}
touch ${DFile} && chmod 664 ${DFile}

# Identify Samsung SSD NVMe
Disks=$(lsblk --nodeps -oNAME,TRAN,MODEL | grep -E "nvme.*Samsung.*970"| awk '{print $1}')

# Create items file
for label in $Disks ; do
	echo -n "$label Serial Number: " >> $IFile && lsblk --nodeps -oNAME,SERIAL | grep "$label" | awk '{print $2}' >> $IFile
	echo -n "$label Temperature: " >> $IFile && smartctl -A /dev/$label | grep Temperature: | awk '{print $2}' >> $IFile
	AvSpare=$(smartctl -A /dev/$label  | grep "Spare:" | awk '{print $3}' | sed 's/%//')
	AvSpareTr=$(smartctl -A /dev/$label | grep "Spare Threshold:" | awk '{print $4}' | sed 's/%//')
	if [ $AvSpare -le $AvSpareTr ]; then
		Spare="1"
	else
		Spare="0"
	fi
	echo "$label Available Spare: $Spare" >> $IFile
	echo -n "$label Used: " >> $IFile && smartctl -A /dev/$label  | grep "Used:" | awk '{print $3}' | sed 's/%//' >> $IFile
	echo -n "$label Data Units Read: " >> $IFile && smartctl -A /dev/$label  | grep "Units Read:" | awk '{print $5}' | sed 's/\[//' >> $IFile
	echo -n "$label Data Units Written: " >> $IFile && smartctl -A /dev/$label  | grep "Units Written:" | awk '{print $5}' | sed 's/\[//' >> $IFile
	echo -n "$label Power On Hours: " >> $IFile && smartctl -A /dev/$label  | grep "On Hours:" | awk '{print $4}' >> $IFile
done

# Create discovery file
echo '{ "data": [' > ${DFile}

cat ${IFile} | grep "Serial Number:" | awk '{print $1}' | while read LINE
    do
    echo "{\"{#DISK}\":\"$LINE\"}," >> ${DFile}
    done

echo ']}' >> ${DFile}

OMMALINE=$(cat ${DFile} | wc -l)
OMMA=$(echo "${OMMALINE} - 1" | bc)
NEWDFILE=$(sed "${OMMA}s/,//" ${DFile})
echo "${NEWDFILE}" > ${DFile}


echo "1"
