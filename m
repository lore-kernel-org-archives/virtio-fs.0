Date: Thu, 6 May 2021 16:16:01 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQIMfU00U3ZR3BL@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-19-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="s+/LkN8WXC3Z886s"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-19-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 18/26] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--s+/LkN8WXC3Z886s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 28, 2021 at 12:00:52PM +0100, Dr. David Alan Gilbert (git) wrote:
> +    close(fd);

I looked back at the hw/virtio/vhost-user.c slave channel code and it
closes fds for us. Looks like this close(2) call should be removed, but
please double-check in case I missed something.

Stefan

--s+/LkN8WXC3Z886s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUCDEACgkQnKSrs4Gr
c8j2mgf/T8Y9qq45TavKJizEPOE8iSWeTSoPKzJcQ7BfP3CLbMkubx35MNst6oXz
P2lJkq2+cmwPAOc8/bs7kRZU4s0pVki6bqQORaduoP2oEEsLVGZj89Wj/YbD9Lmf
R9Mdb5NPCK7O+6iws582cAPpTKU9Zb6ctcSKIMQfZqF8HVIra1CCAv8MDWv2CWEH
fQt+rVv6q4MKROijEQ/Ndd3of0hVtQ7LJmlXt2KjSd82ed5o9Jb9oQ3xdaB9pBLH
XAyiHnfWG14n7LCFH9xNLbaGvKOjZiceSgGnoKDT0xIMoAiQSV0Y3mszpXQsHW6s
iHxWG4w8TR9fTLivRTKqcZw96wWuBA==
=d7sN
-----END PGP SIGNATURE-----

--s+/LkN8WXC3Z886s--

