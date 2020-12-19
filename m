References: <20201216211125.19496-1-lersek@redhat.com>
	<20201216211125.19496-2-lersek@redhat.com>
	<57ec49d2-1540-f693-23ef-12a0cf217a81@arm.com>
	<20201218181335.GG2956@work-vm>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <d560d06f-cc84-d2c6-793b-d4badd461d36@redhat.com>
Date: Sat, 19 Dec 2020 22:16:01 +0100
MIME-Version: 1.0
In-Reply-To: <20201218181335.GG2956@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [edk2 PATCH 01/48] OvmfPkg: introduce VirtioFsDxe
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: virtio-fs@redhat.com, Jordan Justen <jordan.l.justen@intel.com>, devel@edk2.groups.io, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>

(I'm breaking my PTO rules for this, because writing this driver was a
very intense experience for me, and it's not like I can put it out of my
mind from a Friday to a Saturday, after waking with it and going to bed
with it for three weeks... I just couldn't resist checking the mailing
list archive, and then logging in.)

On 12/18/20 19:13, Dr. David Alan Gilbert wrote:
> * Ard Biesheuvel (ard.biesheuvel@arm.com) wrote:
>> On 12/16/20 10:10 PM, Laszlo Ersek wrote:

[...]

>>> +# Permission Model of this driver:
>>> +#
>>> +# Regardless of the UID and GID values this driver send in the FUSE request
>>> +# header, the daemon (that is, the Virtio Filesystem device) always acts with
>>> +# root privileges on the host side. The only time the daemon considers said UID
>>> +# and GID fields is when creating a new file or directory. Thus, the guest
>>> +# driver cannot rely on the host for enforcing any file mode permissions,
>>> +# regardless of the "personality" that the guest driver poses as, because
>>> +# "root" on the host side ignores all file mode bits.
>>> +#
>>> +# Therefore the guest driver has to do its own permission checking, and use the
>>> +# host-side file mode bits only as a kind of "metadata storage" or "reminder"
>>> +# -- hopefully in a way that makes some sense on the host side too.
>>> +#
>>
>> Can you please explain why this is safe? Or should virtio-fs only be
>> used with guests that can be trusted with root privileges on the host?
>
> The daemon sandboxes itself and generally you only expose a private area
> of a filesystem to the guest; i.e. a per-guest rootfs or temporary or
> whatever.

Stefan wrote a document about this:

  [PULL 059/111] virtiofsd: add security guide document
  https://lists.gnu.org/archive/html/qemu-devel/2020-01/msg05464.html

some excerpts:

> +Security Requirements
> +=====================
> +Guests have root access to the shared directory.  This is necessary for root
> +file systems on virtio-fs and similar use cases.

and

> +Deployment Best Practices
> +=========================
> +The shared directory should be a separate file system so that untrusted guests
> +cannot cause a denial-of-service by using up all available inodes or exhausting
> +free space.
> +
> +If the shared directory is also accessible from a host mount namespace, it is
> +recommended to keep a parent directory with rwx------ permissions so that other
> +users on the host are unable to access any setuid executables or device nodes
> +in the shared directory.  The `nosuid` and `nodev` mount options can also be
> +used to prevent this issue.

This document, originally proposed as
"docs/tools/virtiofsd-security.rst", doesn't seem to have made it to the
QEMU tree yet; it was put aside while a good location for it would be
figured out. See this subthread under the v1 PULL:

  https://lists.gnu.org/archive/html/qemu-devel/2020-01/msg05733.html

and then see the PULL v2 changelog -- "drop the docs while we discuss
where they should live":

  https://lists.gnu.org/archive/html/qemu-devel/2020-01/msg05780.html

(If there have been developments in this area since then, I'm not aware
of them; sorry if my info on the docs' location is out-of-date.)

Thanks!
Laszlo

