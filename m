Date: Tue, 11 May 2021 11:23:12 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJpbEMePhQ88EWWR@stefanha-x1.localdomain>
References: <20210507221527.699516-1-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="A7V9ozvfxmSnLtjw"
Content-Disposition: inline
In-Reply-To: <20210507221527.699516-1-ckuehl@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Enable multiple request queues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>


--A7V9ozvfxmSnLtjw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 07, 2021 at 05:15:27PM -0500, Connor Kuehl wrote:
> @@ -1245,7 +1262,8 @@ __releases(fiq->lock)
>  		 req->in.h.nodeid, req->in.h.len,
>  		 fuse_len_args(req->args->out_numargs, req->args->out_args));
> =20
> -	fsvq =3D &fs->vqs[queue_id];
> +	fsvq =3D this_cpu_read(this_cpu_fsvq);

Please check how CPU hotplug affects this patch. If the current CPU
doesn't have a vq because it was hotplugged, then it may be necessary to
pick another vq.

Stefan

--A7V9ozvfxmSnLtjw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCaWxAACgkQnKSrs4Gr
c8gaYQf/ZbGTh/PBCw1PB2OJDsg9sJ/qLNSeJAXsrq1soajsgMZNL5qaCxFxca96
7Ct1XtEelrvOEivymGbnjYFnL3kDuTeYhPzlyPBwG9heVxBReVxmKaC18hm5GwKk
Qd481XSuaAF2gVk1B55pgfK4NwX/smvCgHpWvkP8vakZttXFUgMYcXM7Mi7V9XcJ
4f3EWA0m0iaWAkVJY2R+luPJtvc403igrv4QpUrw0kgn7iYw424W9O819g+Na4dO
8QdFtUmFHQsgwNVy6hKMnbhc7V0m3Hdwr2JVNXb2cd+yXqwVX+8xP3KeZOvBb5gX
hUibZHl+yf0GfluxoJUfjT8JXVtBDg==
=VnK4
-----END PGP SIGNATURE-----

--A7V9ozvfxmSnLtjw--

