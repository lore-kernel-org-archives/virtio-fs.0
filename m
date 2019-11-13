Date: Wed, 13 Nov 2019 14:40:02 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191113144002.GB554680@stefanha-x1.localdomain>
References: <20191030150719.29048-1-vgoyal@redhat.com>
	<20191030150719.29048-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20191030150719.29048-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtiofs: Use completions while waiting
 for queue to be drained
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 30, 2019 at 11:07:19AM -0400, Vivek Goyal wrote:
> While we wait for queue to finish draining, use completions instead of
> uslee_range(). This is better way of waiting for event.

s/uslee_range()/usleep_range()/

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3MFcIACgkQnKSrs4Gr
c8iVMQgAlnZ9d6GvnmORD+LRCvqgvHMMUlFoZS9nF/QBnEG7N4Pqr8BPRJw7Gi0D
uBdcZjReMZY2fG9ZNXoMA0ivvPUPa3eDEBeuXlQrp8Qw4yx32ciL9VYvKly8vvV2
2SMpOnsiuxDhldW2norjAP2piC7VCt+ni8x0yMTECQbaIfvrMhAxR/be/NWOj3pa
RIFzuyeB4yqi73m0yRXtuN4AwL8Fzq/R0NFAfZDlGSiDmhWJ+xIJpPiL4ZfwVBaK
hwzVPIkrA6TmDNNLtI7aCmVrQiA8lpnMH5FbKLmobmXjhedf4PwtiUEMSa3ESC6Y
lBzMsJ4gnruQmDefdEdC1G7ohBHzSg==
=47Ie
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--

