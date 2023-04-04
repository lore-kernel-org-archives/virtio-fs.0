Return-Path: <stefanx@lrz.uni-muenchen.de>
Message-ID: <87faa352-e6d6-11de-0ed9-f5c291502f95@lrz.uni-muenchen.de>
Date: Tue, 4 Apr 2023 20:35:32 +0200
MIME-Version: 1.0
References: <e73b38b8-89d2-4b5d-0b3d-17427b205b67@lrz.uni-muenchen.de>
 <CAJh=p+7OpGqcz1BSbDAQk7Zn2HLh5sUzRwF3QV_LAcDow6n8pQ@mail.gmail.com>
From: stefanx <stefanx@lrz.uni-muenchen.de>
In-Reply-To: <CAJh=p+7OpGqcz1BSbDAQk7Zn2HLh5sUzRwF3QV_LAcDow6n8pQ@mail.gmail.com>
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8
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
To: German Maglione <gmaglione@redhat.com>
Cc: virtio-fs@redhat.com

Hello German,

Am 04.04.23 um 18:06 schrieb German Maglione:
> Hi Stefan,
>
> On Tue, Apr 4, 2023 at 3:58=E2=80=AFPM stefanx <stefanx@lrz.uni-muenchen.=
de> wrote:
>>
>> Hello,
>>
>> virtiofs doesn't accept writable group permissions (Libvirt/KVM, guest v=
m and host vm have Ubuntu 22.04):
>>
>> Libvirt XML (host vm):
>>
>>     <filesystem type=3D'mount' accessmode=3D'passthrough'>
>>       <driver type=3D'virtiofs'/>
>>       <source dir=3D'/mnt/xyz'/>
>>       <target dir=3D'mnt-xyz'/>
>>       <address type=3D'pci' domain=3D'0x0000' bus=3D'0x08' slot=3D'0x00'=
 function=3D'0x0'/>
>>     </filesystem>
>>
>> /etc/fstab (guest vm):
>> ```
>> mnt-xyz       /mnt/xyz            virtiofs rw,_netdev 0 0
>> ```
>> In /mnt/xyz/123 I have write permissions at host vm, but not at guest vm=
. host vm and guest vm have the same LDAP users.
> when you say that you do not have write permission, do you mean that
> when you try to write, it fails?
Now I have made more tests: The user has write permissions to existing file=
s, but cannot create new files on the guest (it's possible on the host)
> Could you send the output of:
> 'ls -lnd /mnt/xyz/123'
> (both in the host and the guest)
>
> and also the output of 'id' in the guest (with the user you are trying to=
 write)

ls -lnd /mnt/xyz/123=20
-rw-r--r-- 1 16009 16100 0 Apr  4 19:32 /mnt/xyz/123id 16009gid=3D16000, gr=
oups=3D...,16100(...),...


We use /mnt/xyz for years in the host without any permission problems, all =
attributes and permissions for all directories and files in /mnt/xyz/123 ar=
e exactly the same on host and guest.


Stefan


>
>
>
>> Any ideas ?
>>
>> Thanks Stefan
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://listman.redhat.com/mailman/listinfo/virtio-fs
>
>
> --
> German
>

