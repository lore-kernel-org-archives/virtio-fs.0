Return-Path: <hi@alyssa.is>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
 :cc:content-type:content-type:date:date:from:from:in-reply-to
 :in-reply-to:message-id:mime-version:references:reply-to:sender
 :subject:subject:to:to; s=fm2; t=1697904625; x=1697991025; bh=oR
 x/3T3+anRPR+hsEa7pcHpZMcaj2WraCFrupzwjhb0=; b=tDYwxDNYRMD71FIlP7
 /AWEHQlN7BviJoaZNvIULfyA2TxphEzVLS0aGf1AEV97LmOccQ2ISIdpJjC2mC+s
 YBHIIfIbr23hll3vGlBozQB003encXe/ocTstt0zAqeKmUOZ62MnOIeclvfDZ8EI
 QvyFNONck2izueEFvKjFTP89by8uo/Jpsr3x31Mo7Zqdt+Nepi1ZPv2yy3wP+wVH
 s6Fz6L0qCKHVuqtg1lLOiOKDNVtu6/S3qlyB510KE5rA6Fs5pMdR86oPCnM73X3l
 IIFQlPiZ340Qi+Bv3aaBmA/NPibLtgr1E4y9LwgdV7A/yulbmUVdoepr0d7HHMFb
 1FLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm3; t=1697904625; x=1697991025; bh=oRx/3T3+anRPR
 +hsEa7pcHpZMcaj2WraCFrupzwjhb0=; b=btOztuzLfrpe41FReDm64vM5+Gh4U
 0u6zxP6d1Zew8I9BBoeaDoDmIXna4Sh1hw145FWrGDbM4ri28SJue3E1EIogGUJw
 ckzvJmzfBYX+i+Niv502e53V8HxEGlE2Xk37+EvJztJ0Cg7IhlvzYL+UJ1rYjAoT
 z0Wyb7Vy5g8iBO6ePhMaaCf6Ajfqn5FSdife3TAAGXuin+wmNOA4jDjv+NlFe0PU
 0bdqId3P+brvI/uTv73tD1A8MafXMPgr6y6S5piNaD2gLxa8TL0raf9PinMwvSz1
 Tnti839O0YyDYr8x9X5dmGU6iIN5ZqEHTjojFav6Il8ifHYHmid50ZBuQ==
Date: Sat, 21 Oct 2023 16:10:21 +0000
From: Alyssa Ross <hi@alyssa.is>
Message-ID: <zdor636rec2ni6oxuic3x55khtr4bkcpqazu3xjdhvlbemsylr@pwjyz2qfa4mm>
References: <20231005203030.223489-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="4hrx2uig745c5dti"
Content-Disposition: inline
In-Reply-To: <20231005203030.223489-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Export filesystem tags through
 sysfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com, mzxreary@0pointer.de, gmaglione@redhat.com


--4hrx2uig745c5dti
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05, 2023 at 04:30:30PM -0400, Vivek Goyal wrote:
> virtiofs filesystem is mounted using a "tag" which is exported by the
> virtiofs device. virtiofs driver knows about all the available tags but
> these are not exported to user space.
>
> People have asked these tags to be exported to user space. Most recently
> Lennart Poettering has asked for it as he wants to scan the tags and mount
> virtiofs automatically in certain cases.
>
> https://gitlab.com/virtio-fs/virtiofsd/-/issues/128

Hi, I was one of those people. :)

> This patch exports tags through sysfs. One tag is associated with each
> virtiofs device. A new "tag" file appears under virtiofs device dir.
> Actual filesystem tag can be obtained by reading this "tag" file.
>
> For example, if a virtiofs device exports tag "myfs", a new file "tag"
> will show up here.
>
> /sys/bus/virtio/devices/virtio<N>/tag
>
> # cat /sys/bus/virtio/devices/virtio<N>/tag
> myfs
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Are you still thinking about exposing this in the uevent as well?
That would be much more convenient for me, because with this approach
by the time the "remove" uevent arrives, it's no longer possible to
check what tag was associated with the device =E2=80=94 you have to store it
somewhere when the device appears, so you can look it up again when the
device is removed.  (Not everybody uses udev.)

Regardless,

Tested-by: Alyssa Ross <hi@alyssa.is>

=E2=80=A6 and a review comment below.

> ---
>  fs/fuse/virtio_fs.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 5f1be1da92ce..a5b11e18f331 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -107,6 +107,21 @@ static const struct fs_parameter_spec virtio_fs_para=
meters[] =3D {
>  	{}
>  };
>
> +/* Forward Declarations */
> +static void virtio_fs_stop_all_queues(struct virtio_fs *fs);
> +
> +/* sysfs related */
> +static ssize_t tag_show(struct device *dev, struct device_attribute *att=
r,
> +			char *buf)
> +{
> +	struct virtio_device *vdev =3D container_of(dev, struct virtio_device,
> +						  dev);
> +	struct virtio_fs *fs =3D vdev->priv;
> +
> +	return sysfs_emit(buf, "%s", fs->tag);

All of the other files in the device directory end with trailing
newlines.  Should this one be an exception?

> +}
> +static DEVICE_ATTR_RO(tag);

--4hrx2uig745c5dti
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmUz99oACgkQ+dvtSFmy
ccACZg//SZNxNUCxHZmFo775x0ukdlk7V21OpOnQxIZbmyz3lFU/cy41MCQnTLDZ
sOCud1CXqlDNDrqxQsVRVaq40bQTAsEukNCVo4EVqtHMRyPFa3iWayzvy+wMDMvg
K9t39TAQIn/xSgKhpV/xJlnIEiKl5XY1TTfQyCyOvntXAsYWhDfz5d0hHnsVzXgO
+vMioJdLT+rJLy1abtZth125NOhsieKkUmwjLnGm4jUhyzUQabjTfYPsUKZBssP7
eRkTSoTnzL/zqVOYXhdNO4xpSq+/wg/4STBG7rFgLVsaI1zvZicbmHhjcHy4Nk07
kQxnLTeciYNbU+D0cVOwelmOCXFkaxOYB5/oOtpCC5DKELo7sVFoOX3Zq5InXQtC
CvptihrJr+XJKBjsd6C0FMCIU6ki40i0mzdXNS6wsqM0Q/KL+EfZxCqlYw7Mh/BR
FEmxLYlj7GFWQQy7KpWfrDVMuSaN7MsTGsW8F2/6F2zF57JE65aqnJh9kVDriynX
+U1eUhaW59QSreq6pr7ssmAB/zIoE0RGu/zqlnDB7If2BAe4jNZgE0jjZgYfzL/5
uiSfUMZlDGEmPM+kZNYjVdvScwmz05bXSH0IMET42IgbVgQSGsCrMlbhvkQr1f/f
cHmiynIdAISNUMVF4jjljBp5DVsejqfnQbr9pATqqG3Ik+UyjRs=
=VAq9
-----END PGP SIGNATURE-----

--4hrx2uig745c5dti--

