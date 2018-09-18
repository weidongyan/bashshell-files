for i in $(virsh list --all |grep -v Id| awk '{print $2}' |grep -v classroom); do virsh destroy $i; done

for i in $(virsh list --all |grep -v Id| awk '{print $2}' |grep -v classroom); do virsh undefine $i; done

