Return-Path: <stefanx@lrz.uni-muenchen.de>
Message-ID: <e73b38b8-89d2-4b5d-0b3d-17427b205b67@lrz.uni-muenchen.de>
Date: Tue, 4 Apr 2023 15:50:01 +0200
MIME-Version: 1.0
From: stefanx <stefanx@lrz.uni-muenchen.de>
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [Virtio-fs] virtiofs doesn't accept writable group permissions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


Hello,

virtiofs doesn't accept writable group permissions (Libvirt/KVM, guest vm a=
nd host vm have Ubuntu 22.04):

Libvirt XML (host vm):

=C2=A0=C2=A0=C2=A0 <filesystem type=3D'mount' accessmode=3D'passthrough'>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <driver type=3D'virtiofs'/>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <source dir=3D'/mnt/xyz'/>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <target dir=3D'mnt-xyz'/>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <address type=3D'pci' domain=3D'0x0000' bus=
=3D'0x08' slot=3D'0x00' function=3D'0x0'/>
=C2=A0=C2=A0=C2=A0 </filesystem>

/etc/fstab (guest vm):
```
mnt-xyz=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /mnt/xyz=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 virtiofs rw,_netdev 0 0
```
In /mnt/xyz/123 I have write permissions at host vm, but not at guest vm. h=
ost vm and guest vm have the same LDAP users.

Any ideas ?

Thanks Stefan

