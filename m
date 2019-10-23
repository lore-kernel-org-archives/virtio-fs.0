Date: Wed, 23 Oct 2019 17:31:03 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191023163103.GJ9574@stefanha-x1.localdomain>
References: <tencent_83EAD77D96CB166D185BBAAAC08318A7B308@qq.com>
	<tencent_819DC6AB4BF63D2EEBB5616EB9A89E0F2E0A@qq.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+9faIjRurCDpBc7U"
Content-Disposition: inline
In-Reply-To: <tencent_819DC6AB4BF63D2EEBB5616EB9A89E0F2E0A@qq.com>
Subject: Re: [Virtio-fs] =?utf-8?b?5Zue5aSN77yaYWRkIG5vLXBpdm90IG9wdGlvbiB0?=
 =?utf-8?q?o_virtiofsd_process?=
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?utf-8?B?55m95a6H?= <bekars@qq.com>
Cc: virtio-fs <virtio-fs@redhat.com>


--+9faIjRurCDpBc7U
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2019 at 03:00:01PM +0800, =E7=99=BD=E5=AE=87 wrote:
> From 278d81f5a00c35e431a0a450b6c6eb7b7edca787 Mon Sep 17 00:00:00 2001
> From: bekars <baiyu10@baidu.com>
> Date: Sun, 20 Oct 2019 17:41:11 +0800
> Subject: [PATCH] add no pivot_root to virtiofsd.

Please write a commit description that explains the reason for this
patch.

I have a general concern about this patch:

virtiofsd uses pivot_root for sandboxing.  If the virtiofsd process is
compromised through a security bug there must be no way of accessing
files outside the shared directory.  A simple chroot(2) call is not
equivalent to the pivot_root(2) and namespace setup that is normally
done during startup.  Therefore, I'm not confident that this change
results in the same level of security as with pivot_root(2).

The following more complicated sequence of steps is described in
Documentation/filesystems/ramfs-rootfs-initramfs.txt:

  - When switching another root device, initrd would pivot_root and then
    umount the ramdisk.  But initramfs is rootfs: you can neither pivot_root
    rootfs, nor unmount it.  Instead delete everything out of rootfs to
    free up the space (find -xdev / -exec rm '{}' ';'), overmount rootfs
    with the new root (cd /newmount; mount --move . /; chroot .), attach
    stdin/stdout/stderr to the new /dev/console, and exec the new init.

    Since this is a remarkably persnickety process (and involves deleting
    commands before you can run them), the klibc package introduced a helper
    program (utils/run_init.c) to do all this for you.  Most other packages
    (such as busybox) have named this command "switch_root".

At least the "cd /newmount; mount --move . /" steps look worthwhile.
The mount namespace should contain only the shared directory and there
must be no way to get back to files outside the shared directory.

> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passt=
hrough_ll.c
> index 5bfd650..f84dcca 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2061,7 +2061,11 @@ static void setup_pivot_root(const char *source)
>  		err(1, "fchdir(newroot)");
>  	}
> =20
> +#ifdef CONFIG_NO_PIVOT
> +	if (chroot(source) < 0){
> +#else
>  	if (syscall(__NR_pivot_root, ".", ".") < 0){
> +#endif

There is no way of knowing if virtiofsd will be deployed on rootfs at
compile-time for virtiofsd binaries shipped by a project like Kata
Containers or as part of a distro package.  If you compile a custom
binary for yourself then it's not an issue but upstream virtio-fs
requires more generic code.

Please change this to a run-time fallback.  The rootfs code should be
execute when pivot_root(2) fails.

Stefan

--+9faIjRurCDpBc7U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2wgEcACgkQnKSrs4Gr
c8g26Qf9GI2dh8IK+2iXBwRsHEJ3H0FhlnAGUf0lPLEYvqAMhInvMDmCN7t933t3
Sg57Cpo6/ZesDHKuxEvlGETlIjz+NJB98BNIUSO83Alwn209ee5u0JlFjKbWhbmP
gOGoGM5e3wEJ3aa2FrMnnMbLPvEGGMUUyXueSzDRKrha/3Sq1AIkmBs6AZ5EiTM5
UYE8kYPNy2XIbp68OJQCU7Spl0qEaExOL73w52DQnIBxCKRIhkSquiBVb3mLB2eL
9KFs4hnmWjCHPA3QgUvWwhN08yBMSKgb6/TXe+/CgPopq2uVoUKqGb+b27Pi3oPA
QtZmTidOz+emC2MxJT15hZaire95cQ==
=U5x/
-----END PGP SIGNATURE-----

--+9faIjRurCDpBc7U--

