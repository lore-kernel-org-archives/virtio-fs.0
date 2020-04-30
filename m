Date: Thu, 30 Apr 2020 09:35:43 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200430083543.GB160930@stefanha-x1.localdomain>
References: <1586585997-24446-1-git-send-email-catherine.hecx@gmail.com>
	<1586594144-24605-1-git-send-email-catherine.hecx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <1586594144-24605-1-git-send-email-catherine.hecx@gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd/passthrough_ll: don't remove
 O_DIRECT when cache=none
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Catherine Ho <catherine.hecx@gmail.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 11, 2020 at 04:35:44AM -0400, Catherine Ho wrote:
> @@ -1702,10 +1703,11 @@ static void update_open_flags(int writeback, stru=
ct fuse_file_info *fi)
> =20
>      /*
>       * O_DIRECT in guest should not necessarily mean bypassing page
> -     * cache on host as well. If somebody needs that behavior, it
> -     * probably should be a configuration knob in daemon.
> +     * cache on host as well. If cache=3Dnone, keep the flag unchanged
>       */
> -    fi->flags &=3D ~O_DIRECT;
> +    if (cache_mode !=3D CACHE_NONE) {
> +        fi->flags &=3D ~O_DIRECT;
> +    }
>  }
> =20

Thanks for the patch!  I have CCed the virtio-fs mailing list so more
people see it.

Please add a new command-line option to control O_DIRECT behavior.

There are two cases:

1. O_DIRECT bypasses the guest page cache but not the host page cache.
   This makes sense when the DAX feature is enabled.

2. O_DIRECT bypasses both the guest and host page cache.  This make
   sense for non-DAX and for I/O performance benchmarking.

Today only #1 is supported.

Your patch makes the behavior dependent on the cache mode option, but
the cache mode doesn't necessarily determine how O_DIRECT should be
handled.  For example, in the DAX case the guest page cache is bypassed
and cache=3Dnone can be used, but we do want to use the host page cache.

You can add a new option so that O_DIRECT handling is configurable for
all cases.

Stefan

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6qjd8ACgkQnKSrs4Gr
c8i7Nwf+MMH9Ye5CS+QppXcXKW3UqQpB3DUj2lrsJk0j2qZ31AVSnEXw2MSrXwvr
6ApcGNGTQS6g5t8plZFruCbKnQvS19xsbW7J4uHGviTLqQ4X0L+vks/Z9meGmBPr
3C1FZRdIy68dXhxrK8xeqNxqIPoK8N8aB6fQjMoiue/wXnoNl9euLvnDBrV0pjs0
DdS6O0mc6A3ZlNeUBExtbzrxwwdti6NxUa4FdIZFZVHthKVpUP8XFGUbqlFjNkwl
eZeK7kZWycQWjm5TIbDNchyegs1mxtQayQF38gpIkMOxTlJQFdmRknnGVCgPJ6qz
I3s8kGoGy7kWrE/YPKYlnp2jkw+5Wg==
=h2l4
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--

