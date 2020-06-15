Date: Mon, 15 Jun 2020 10:54:06 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200615095406.GD2883@work-vm>
References: <1099751591915615@mail.yandex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1099751591915615@mail.yandex.com>
Subject: Re: [Virtio-fs] How is the daemon meant to be started?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Aa Aa <jimbothom@yandex.com>
Cc: virtio-fs@redhat.com

* Aa Aa (jimbothom@yandex.com) wrote:
> Hi
>=20
> I have a few questions about using virtiofsd. I currently have multiple v=
ms share the same mountpoint for their rootfs using 9p, in read only (9p ha=
d a permissions issue but that was overcome). I can start qemu for each of =
them as non root with say only allowing access to /dev/kvm and even have so=
me of the VM running with a different user name.
>=20
> If I wish to change to using virtiofsd, I can just change the init to:
> =A0 mount -t virtiofs -onoatime,nodiratime,noauto,ro rootfs /new=A0 | mou=
nt -t 9p -onoatime,nodiratime,noauto,ro,trans=3Dvirtio,cache=3Dloose root /=
new
> and the qemu command line from using 9p to using a vhost-user-fs-pci devi=
ce.
>=20
> The problem is how do I start virtiofsd. The daemon needs root
> permissions from what I can tell, to start. Thereafter, it listens on the
> socket and only accepts a single connection on the socket. In my case,
> I have a single mount point that I wish to use multiple times. You cannot
> listen on the socket multiple times, so I cannot say that /mnt/root socket
> will be exported as /run/virtiofsd/mounts/mnt-root.socket by something
> that has been started by root independently of qemu, but rather it would
> appear that I need to be root=20

Correct, at the moment you do need to be root; there were some
suggestions for relaxing that but they haven't been sorted out yet.

> and create a socket for each qemu task then
> drop permissions. Is this correct or is there another way to achieve this.

Yes, you need one daemon instance per mount/VM.

Dave

>=20
> Cheers
>=20
> JT
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

