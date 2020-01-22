Date: Wed, 22 Jan 2020 16:34:57 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200122163457.GC677983@stefanha-x1.localdomain>
References: <20200122024008.28126-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline
In-Reply-To: <20200122024008.28126-1-yangx.jy@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Remove unused enum
 fuse_buf_copy_flags
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: virtio-fs@redhat.com


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2020 at 10:40:08AM +0800, Xiao Yang wrote:
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  tools/virtiofsd/buffer.c         |  7 +++--
>  tools/virtiofsd/fuse_common.h    | 46 +-------------------------------
>  tools/virtiofsd/fuse_lowlevel.c  | 13 ++++-----
>  tools/virtiofsd/fuse_lowlevel.h  | 35 ++----------------------
>  tools/virtiofsd/passthrough_ll.c |  4 +--
>  5 files changed, 13 insertions(+), 92 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4oebEACgkQnKSrs4Gr
c8jLhQgAnUYwJN0OOiWmxBIfeUl2rvdkUv7NyEVlkpHk/QR7gZ9v+P4lE0BxP90h
1Z75YRawzk3SBYik1ynhXw9eu77pjim7iSA2uU2U5vjdwi1twXAEISuv+ckWkBp8
Svf0OcXoTrdluuYoGqlFm/5z6EFiNCIH1NboLJBm33S5IC7tNwW0QfRlZapfsSr/
I/YtDTl6MaP0ogHE6WJxtzwRV5QYTVponTLVKHEzK3iVsOFGBPel+Zq21vXagrlw
frfdPYMzTk6wvGa1DN/N904/4fX9hEA59WMJ6We3l1pgr9CJV6NnkZma4DCCMmg3
LM2UdTg4jG8BNZhw+s+NNsxrKMs6Aw==
=xxDz
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--

