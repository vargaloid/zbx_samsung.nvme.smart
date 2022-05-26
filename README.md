# zabbix_template_samsung.nvme.smart
## Zabbix Template for monitoring S.M.A.R.T. Samsung SSD NVMe with Discovery

#### Tested models:
* Samsung SSD 970 PRO 512GB
* Samsung SSD 970 PRO 1TB
* Samsung MZ1LW960HMJP-00003 (960 GB)
* Samsung MZQLB1T9HAJR-00007 (1,92 TB)
* Samsung MZPLL3T2HAJQ-00005 (3,20 TB)
* Samsung MZPLL6T4HMLA-00005 (6,40 TB)

#### Tested OS:
* Debian 9 (stretch)
* Ubuntu 18.04 (Bionic Beaver)

#### Requirements:
* smartmontools ver. 6.5 or later
* bc

#### Files:
* sams.smart.nvme.sh -- main script
* userparameter_sams.nvme.smart.conf -- Key for zabbix-agent
* zabbix_template_samsung.nvme.smart.xml -- Zabbix Template
* zabbix_template_samsung.nvme.smart.yml -- Ansible playbook
* /tmp/zbx.sams.nvme.smart.discovery.txt -- JSON for Zabbix Discovery
* /tmp/zbx.sams.nvme.smart.items.txt -- Items for monitoring

**Please, enable the necessary triggers after import!**
