Date: Mon, 27 Apr 2020 16:22:22 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200427152222.GA1043329@stefanha-x1.localdomain>
References: <20200424062540.23679-1-chirantan@chromium.org>
	<20200424062540.23679-2-chirantan@chromium.org>
	<20200427151934.GB1042399@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20200427151934.GB1042399@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: virtiofs: Add basic multiqueue
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 27, 2020 at 04:19:34PM +0100, Stefan Hajnoczi wrote:
> On Fri, Apr 24, 2020 at 03:25:40PM +0900, Chirantan Ekbote wrote:
> The C implementation of virtiofsd has request parallelism and there is
> work underway to do it in Rust for cloud-hypervisor too.  Perhaps you
> can try the cloud-hypervisor code, I have CCed Sergio Lopez?

Sergio pointed me to this commit:

https://github.com/cloud-hypervisor/cloud-hypervisor/commit/710520e9a1860c587b4b3ec6aadc466ba1709557

Stefan

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6m+K4ACgkQnKSrs4Gr
c8jQ1Qf/bspMKGE/YgytaeWeBS8mI63yrhYNllexXvVZv7z0CKNbdO4wkt3RsbgB
/Wf5Mir12k7uPduMvC0H94m72oWX7fpd+ABJL0NMarfLtni8fPMqz1RYGGiIrsvU
tfLicwx6dvVxNSoscYaV96OhWqhBdUnLQzl47KzcZkLpYqT8H7qjyxfVll2wWs7i
QPMZtp+1FkBM2did+wOSajypYDc1UqcVbzK8ncbCofyZqyjRPo03Gk8c2isrTM9g
Vjskh4XJAIupD3Sa80rlGbRJ27dGyecuqpnVYyyYlGPnwNymJhwPlWEk3gcYVoAz
ibEGDUlZN11R5T+zin9BXR6nZZPl6w==
=DS17
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--

