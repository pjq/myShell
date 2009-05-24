#!/bin/bash
mount -t proc /proc /media/sda11/proc
chroot /media/sda11 /bin/bash
