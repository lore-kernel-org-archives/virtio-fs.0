DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=Jlq9FZcvZf1xuE9ojcvY5JlBHqwm16Z+6mIUoj9IPzM=;
	b=DF2FV5kUcyitm5oZPiUc2ykgH0BQy8b0fX7wXHXDgYvAiUuhxxBpi0KJsjt57Tpban
	0hWI8ILTGkrl4whQuwNi/QBoV5mApDPxyiAHGRV1CnkvBToqNfeId622UWt6dp2ps59j
	E8kBZKnkjAvuBxwj3SGQLonltN0a5hUowxJDk/4kIk6n2Wcx+wa7iXMrzK0tOBlT6nZ7
	VzfATyh4BcrKfAYrpvfXudNXU7hM/Xcs/PABv/8ZOgy22VAjyWaxa21oJavO6jLE0b6W
	OXxvJgCU56Sd60esaDUDQPbVRMgyaM0yo2P3CTmUiUwgQSJZEP2yJuVSpnFhSHvI9Hqb
	pkng==
Date: Fri, 18 Oct 2019 11:09:09 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
Message-ID: <20191018100909.GB9360@stefanha-x1.localdomain>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
	<20191017160953.GC1266@stefanha-x1.localdomain>
	<CAOssrKejcfVWXw6Nu1owyEeofTdVp6BNx4bL91ma2g7bg9-nmg@mail.gmail.com>
	<CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2019 at 09:16:36AM +0200, Miklos Szeredi wrote:
> On Thu, Oct 17, 2019 at 6:48 PM Miklos Szeredi <mszeredi@redhat.com> wrot=
e:
>=20
> > Even simpler: allow O_PATH descriptors for f*xattr().
>=20
> Attached patch.  Will post shortly.
>=20
> However, I think it would make sense to fix virtiofsd as well, as this
> will take time to percolate down, even if Al doesn't find anything
> wrong with it.
>=20
> Doing unshare(CLONE_FS) after thread startup seems safe, though must
> be careful to change the working directory to the root of the mount
> *before* starting any threads.

Thank you for extending O_PATH, that's great!  This will be the cleanest
way to perform xattr operations.

If your patch is accepted I will send a man-pages.git patch to update
the open(2) O_PATH documentation (with a minimum kernel version).

I've added the unshare(CLONE_FS) task to my todo list in case no one
else gets to it first.  I may not have time to work on it before
Novemeber though.

Stefan

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2pj0UACgkQnKSrs4Gr
c8ihKAf9HtkKCMKQu3EvE+nGschLd/P5PZJdPs1o2ZmGG6yHO5lSlBMt8eNF5frd
58XBP5jHk/0ii88ZFSXYXcvm+MaMIuEPKTfZSKY91vkjmp45NGqkLeq83F1wMoXE
LDZCgba/h8ZTY6e/g0WrNUyNywUvqhOcvl7Fk9NfIjaMNtNl7U/IewiETe+ekY68
4WMdHFOCjqkmwZZ+VowJTtiofRWAGlqn98IJA08qE3jTTtONVGxNge/CmHqkihEa
oLLleTxItT++w1Vh0gvqQWLUPr/QQEy2ZyMr8zOuAy85mytJZu7XhFx15orpr6Ul
awL/0E+Ek2F1tDbq+PFNcAX4SwEnmQ==
=bw0r
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--

