# zabbix_template_samsung.nvme.smart
Zabbix Template for monitoring S.M.A.R.T. Samsung SSD NVMe with Discovery

Tested models:
* Samsung SSD 970 PRO 512GB
* Samsung SSD 970 PRO 1TB

Tested OS:
* Debian 9 (stretch)

Requirements:
* smartmontools ver. 6.5 or later
* bc

Files:
* sams.smart.nvme.sh -- main script
* userparameter_sams.nvme.smart.conf -- Key for zabbix-agent
* zabbix_template_samsung.nvme.smart.xml -- Zabbix Template
* /tmp/zbx.sams.nvme.smart.discovery.txt -- JSON for Zabbix Discovery
* /tmp/zbx.sams.nvme.smart.items.txt -- Items for monitoring
