#!/bin/bash
COUSE=$1
NFSHOST=172.25.254.251
NFSRV=${NFSHOST}:/rhca/${COUSE}
RHT=/etc/rht
AVAILABLE_COUSE=$(showmount -e 172.25.254.251 | awk -F"/" '{print $3}'|tr -s ["*"] [" "])
#showmount -e 172.25.254.251 | awk -F"/" '{print $3}' |tr -s ["\n"] [" "]
echo ${AVAILABLE_COUSE}
if [ $# == 0 ]
    then
    echo "Please enter couse ${AVAILABLE_COUSE}"
exit 0
fi
setenforce 0
umount /content
mount -t nfs ${NFSRV} /content/


cat /content/ks/rht > ${RHT}
source ${RHT}
RHT_VMS=$(ls /content/${RHT_VMTREE}/vms |awk -F"-" '{print $2}' |grep -v "xml" |tr -s ["\n"] [" "])
echo "RHT_VMS=\"${RHT_VMS}\"" >>${RHT}
echo "RHT_ENROLLMENT=0" >>${RHT}
# configuration for classroom
MATERIALS_ROOT=/var/www/html/materials
MATERIALS_SOURCE=$(ls /content/courses/${COUSE})
ssh root@classroom setenforce 0
ssh root@classroom umount /content/
ssh root@classroom mount -t nfs ${NFSRV} /content/
ssh root@classroom rm -f /var/www/html/materials
ssh root@classroom ln -s /content/courses/${COUSE}/${MATERIALS_SOURCE}/materials/ ${MATERIALS_ROOT}

echo "Please use rht-vmctl fullreset to build the new environment"
