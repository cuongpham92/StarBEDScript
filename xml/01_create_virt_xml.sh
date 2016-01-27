#!/bin/sh
HOST_ID=$(printf "%x" $1);

for NUM in $(seq $2 $3)
do
    MAC=$(printf "%x" ${NUM});
    if [ -e ./openwrt_img_${NUM}.xml ];
    then
        rm openwrt_img_${NUM}.xml;
    fi

    #create overlay image from base image
    qemu-img create -b /home/evaluser/centos_base.qcow2 -f qcow2 /home/evaluser/centos_diff_${NUM}.qcow2 &

    #create XML config file for starting new VM
    echo "<domain type='kvm'>" >> openwrt_img_${NUM}.xml;
    echo "  <name>openwrt_${NUM}</name>" >> openwrt_img_${NUM}.xml;
    echo "  <memory>1024000</memory>" >> openwrt_img_${NUM}.xml;
    echo "  <vcpu>1</vcpu>" >> openwrt_img_${NUM}.xml;
    echo "  <os>" >> openwrt_img_${NUM}.xml;
    echo "    <type arch='x86_64'>hvm</type>" >> openwrt_img_${NUM}.xml;
    echo "    <boot dev='hd'/>" >> openwrt_img_${NUM}.xml;
    echo "  </os>" >> openwrt_img_${NUM}.xml;
    echo "  <features>" >> openwrt_img_${NUM}.xml;
    echo "    <acpi/>" >> openwrt_img_${NUM}.xml;
    echo "    <apic/>" >> openwrt_img_${NUM}.xml;
    echo "    <pae/>" >> openwrt_img_${NUM}.xml;
    echo "  </features>" >> openwrt_img_${NUM}.xml;
    echo "  <clock offset='utc'/>" >> openwrt_img_${NUM}.xml;
    echo "  <on_poweroff>destroy</on_poweroff>" >> openwrt_img_${NUM}.xml;
    echo "  <on_reboot>restart</on_reboot>" >> openwrt_img_${NUM}.xml;
    echo "  <on_crash>restart</on_crash>" >> openwrt_img_${NUM}.xml;
    echo "  <devices>" >> openwrt_img_${NUM}.xml;
    echo "    <emulator>/usr/bin/kvm</emulator>" >> openwrt_img_${NUM}.xml;
    echo "    <disk type='file' device='disk'>" >> openwrt_img_${NUM}.xml;
    echo "      <driver name='qemu' type='qcow2'/>" >> openwrt_img_${NUM}.xml;
    echo "      <source file='/home/evaluser/centos_diff_${NUM}.qcow2'/>" >> openwrt_img_${NUM}.xml;
    echo "      <target dev='hda' bus='ide'/>" >> openwrt_img_${NUM}.xml;
    echo "      <address type='drive' controller='0' bus='0' unit='0'/>" >> openwrt_img_${NUM}.xml;
    echo "    </disk>" >> openwrt_img_${NUM}.xml;
    echo "    <controller type='ide' index='0'>" >> openwrt_img_${NUM}.xml;
    echo "      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>" >> openwrt_img_${NUM}.xml;
    echo "    </controller>" >> openwrt_img_${NUM}.xml;
    echo "    <interface type='bridge'>" >> openwrt_img_${NUM}.xml;
    echo "      <source bridge='default'/>" >> openwrt_img_${NUM}.xml;
    echo "      <model type='e1000'/>" >> openwrt_img_${NUM}.xml;
    echo "    </interface>" >> openwrt_img_${NUM}.xml;
    echo "    <interface type='bridge'>" >> openwrt_img_${NUM}.xml;
    echo "      <mac address='52:54:00:00:${HOST_ID}:${MAC}'/>" >> openwrt_img_${NUM}.xml;
    echo "      <source bridge='olsr'/>" >> openwrt_img_${NUM}.xml;
    echo "      <model type='e1000'/>" >> openwrt_img_${NUM}.xml;
    echo "    </interface>" >> openwrt_img_${NUM}.xml;
    echo "    <serial type='pty'>" >> openwrt_img_${NUM}.xml;
    echo "      <target port='0'/>" >> openwrt_img_${NUM}.xml;
    echo "    </serial>" >> openwrt_img_${NUM}.xml;
    echo "    <console type='pty'>" >> openwrt_img_${NUM}.xml;
    echo "      <target type='serial' port='0'/>" >> openwrt_img_${NUM}.xml;
    echo "    </console>" >> openwrt_img_${NUM}.xml;
    echo "    <input type='mouse' bus='ps2'/>" >> openwrt_img_${NUM}.xml;
    echo "    <graphics type='vnc' port='-1' autoport='yes'/>" >> openwrt_img_${NUM}.xml;
    echo "    <sound model='ich6'>" >> openwrt_img_${NUM}.xml;
    echo "      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>" >> openwrt_img_${NUM}.xml;
    echo "    </sound>" >> openwrt_img_${NUM}.xml;
    echo "    <video>" >> openwrt_img_${NUM}.xml;
    echo "      <model type='cirrus' vram='9216' heads='1'/>" >> openwrt_img_${NUM}.xml;
    echo "      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>" >> openwrt_img_${NUM}.xml;
    echo "    </video>" >> openwrt_img_${NUM}.xml;
    echo "    <memballoon model='virtio'>" >> openwrt_img_${NUM}.xml;
    echo "      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>" >> openwrt_img_${NUM}.xml;
    echo "    </memballoon>" >> openwrt_img_${NUM}.xml;
    echo "  </devices>" >> openwrt_img_${NUM}.xml;
    echo "</domain>" >> openwrt_img_${NUM}.xml;

    virsh define openwrt_img_${NUM}.xml
done