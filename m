Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <e73b38b8-89d2-4b5d-0b3d-17427b205b67@lrz.uni-muenchen.de>
 <CAJh=p+7OpGqcz1BSbDAQk7Zn2HLh5sUzRwF3QV_LAcDow6n8pQ@mail.gmail.com>
 <87faa352-e6d6-11de-0ed9-f5c291502f95@lrz.uni-muenchen.de>
In-Reply-To: <87faa352-e6d6-11de-0ed9-f5c291502f95@lrz.uni-muenchen.de>
From: German Maglione <gmaglione@redhat.com>
Date: Tue, 11 Apr 2023 18:24:30 +0200
Message-ID: <CAJh=p+4G1VEhSfQ0HCFQ0OZYmHq-ji8H6kL-=q6OKsjvm9X-ZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] virtiofs doesn't accept writable group permissions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: stefanx <stefanx@lrz.uni-muenchen.de>
Cc: virtio-fs@redhat.com

On Tue, Apr 4, 2023 at 8:35=E2=80=AFPM stefanx <stefanx@lrz.uni-muenchen.de=
> wrote:
>
> Hello German,
>
> Am 04.04.23 um 18:06 schrieb German Maglione:
> > Hi Stefan,
> >
> > On Tue, Apr 4, 2023 at 3:58=E2=80=AFPM stefanx <stefanx@lrz.uni-muenche=
n.de> wrote:
> >>
> >> Hello,
> >>
> >> virtiofs doesn't accept writable group permissions (Libvirt/KVM, guest=
 vm and host vm have Ubuntu 22.04):
> >>
> >> Libvirt XML (host vm):
> >>
> >>     <filesystem type=3D'mount' accessmode=3D'passthrough'>
> >>       <driver type=3D'virtiofs'/>
> >>       <source dir=3D'/mnt/xyz'/>
> >>       <target dir=3D'mnt-xyz'/>
> >>       <address type=3D'pci' domain=3D'0x0000' bus=3D'0x08' slot=3D'0x0=
0' function=3D'0x0'/>
> >>     </filesystem>
> >>
> >> /etc/fstab (guest vm):
> >> ```
> >> mnt-xyz       /mnt/xyz            virtiofs rw,_netdev 0 0
> >> ```
> >> In /mnt/xyz/123 I have write permissions at host vm, but not at guest =
vm. host vm and guest vm have the same LDAP users.
> > when you say that you do not have write permission, do you mean that
> > when you try to write, it fails?
> Now I have made more tests: The user has write permissions to existing fi=
les, but cannot create new files on the guest (it's possible on the host)
> > Could you send the output of:
> > 'ls -lnd /mnt/xyz/123'
> > (both in the host and the guest)
> >
> > and also the output of 'id' in the guest (with the user you are trying =
to write)
>
> ls -lnd /mnt/xyz/123
> -rw-r--r-- 1 16009 16100 0 Apr  4 19:32 /mnt/xyz/123

Sorry, I'm a bit confused, I thought "123" was a directory not a regular fi=
le.
So, I'm assuming the owner (in the host) of if /mnt/xyz is not 16009, but t=
he
group is 16100 with write permission, that is a supplementary group of the
user 16009, something like:

drwxrwxr-x 1 0 16100 0 Apr 4 19:32 /mnt/xyz
(I'm just using uid 0 as an example)
is that correct?

> id 16009 gid=3D16000, groups=3D...,16100(...),...
>
>
> We use /mnt/xyz for years in the host without any permission problems, al=
l attributes and permissions for all directories and files in /mnt/xyz/123 =
are exactly the same on host and guest.
>

Which version of virtiofsd are you using?
Is "xyz" a mount point for (or is inside a)  nfs/cephfs?


>
> Stefan
>
>
> >
> >
> >
> >> Any ideas ?
> >>
> >> Thanks Stefan
> >>
> >> _______________________________________________
> >> Virtio-fs mailing list
> >> Virtio-fs@redhat.com
> >> https://listman.redhat.com/mailman/listinfo/virtio-fs
> >
> >
> > --
> > German
> >
>


--=20
German

