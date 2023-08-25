# ipxe-builder

iPXE compilation via docker

## How to configurate

- Edit `./src/embed.ipxe`

## How to build

- Run `docker build --file Dockerfile --output build .`

- Write `*.usb` file via `Rufus`

- Boot into UEFI mode via iPXE

## Script samples

- WinPE + iSCSI drive (for Windows installation, winpe on tftp required):

```
#!ipxe

dhcp
set gateway 0.0.0.0
set initiator-iqn iqn.1991-05.com.microsoft:stas

sanhook --drive 0x80 iscsi:10.0.0.1::::iqn.2003-01.org.linux-iscsi.stas-server.x8664:sn.d907af099920

kernel wimboot gui
initrd -n bcd BCD bcd
initrd -n boot.sdi boot.sdi boot.sdi
initrd -n boot.wim boot.wim boot.wim
boot
```

- Boot from iSCSI (Windows):

```
#!ipxe

dhcp
set gateway 0.0.0.0
set initiator-iqn iqn.1991-05.com.microsoft:stas

sanboot --keep --drive 0x80 iscsi:10.0.0.1::::iqn.2003-01.org.linux-iscsi.stas-server.x8664:sn.d907af099920
boot
```

- Boot from iSCSI (Ubuntu):

```
#!ipxe

dhcp
set gateway 0.0.0.0
set initiator-iqn iqn.1991-05.com.microsoft:stas

sanboot --filename \EFI\ubuntu\shimx64.efi iscsi:10.0.0.1::::iqn.2003-01.org.linux-iscsi.stas-server.x8664:sn.c727f9503423
boot
```

## Other

- Sanhook with local drives not working in UEFI mode

- Tested with `Mellanox ConnectX-3` (10Gbps nic on client)

- Tested with `targetcli-fb` (iSCSI target on server)

- Tested with `dnsmasq` (DNS + TFTP on server)

- Boot to WinPE or Windows very slow (~3-10 min)

- Very important if windows installation required: https://github.com/ipxe/ipxe/discussions/324
