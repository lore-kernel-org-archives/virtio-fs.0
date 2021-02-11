Date: Thu, 11 Feb 2021 10:32:03 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211103203.GH247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-8-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-8-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 07/24] DAX: virtio-fs: Add vhost-user slave
 commands for mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:07PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index d6085f7045..1deedd3407 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -1432,6 +1432,26 @@ Slave message types
> =20
>    The state.num field is currently reserved and must be set to 0.
> =20
> +``VHOST_USER_SLAVE_FS_MAP``
> +  :id: 6
> +  :equivalent ioctl: N/A
> +  :slave payload: fd + n * (offset + address + len)

I'm not sure I understand this notation. '+' means field concatenation?
Is 'fd' a field or does it indicate file descriptor passing?

I suggest using a struct name instead of informal notation so that the
payload size and representation is clear.

The same applies for VHOST_USER_SLAVE_FS_UNMAP.

> +  :master payload: N/A
> +
> +  Requests that the QEMU mmap the given fd into the virtio-fs cache;

s/QEMU mmap the given fd/given fd be mmapped/

Please avoid mentioning QEMU specifically. Any VMM should be able to
implement this spec.

The same applies for VHOST_USER_SLAVE_FS_UNMAP.

> +  multiple chunks can be mapped in one command.
> +  A reply is generated indicating whether mapping succeeded.
> +
> +``VHOST_USER_SLAVE_FS_UNMAP``
> +  :id: 7
> +  :equivalent ioctl: N/A
> +  :slave payload: n * (address + len)
> +  :master payload: N/A
> +
> +  Requests that the QEMU un-mmap the given range in the virtio-fs cache;
> +  multiple chunks can be unmapped in one command.
> +  A reply is generated indicating whether unmapping succeeded.

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlB6MACgkQnKSrs4Gr
c8jcowf9HLRW3wAQ6DWqqDUQI5gIbsSaQpT2V3uW5lE7BmR/l/AstkBdWbl+QNrF
vuRLB/7cqST/vpzdtcJkaLt9AU6p4uN6U0lfa9qAtkdtD3sSDlCxqMYxdpUPznvs
clWkKB7XPn/a0gRh8cOZp6UQ0mlJtaOCs/RWHV+X/YFFwGxmrFSH5ymjWGIZOFzI
o9PjInIInB2gCCciadHoHEpGxlQtJkCTpDnt3/6cFs4Kp3UTCh8AhKIfqh0x/oh8
uqXEgfbJbfrcXMBDdOIopzX5QMMaiphPXipENKnYmn12hhP25uJTlc48ghnE2EZJ
i95UpNCqyZoEPrDN4pyJctSg7mnW4Q==
=DNUJ
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--

