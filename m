Date: Mon, 1 Jun 2020 16:55:05 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200601155505.GA581007@stefanha-x1.localdomain>
References: <20191025100152.6638-1-stefanha@redhat.com>
	<20191025100152.6638-2-stefanha@redhat.com>
	<20191026174745-mutt-send-email-mst@kernel.org>
	<20191027123623.GO4472@stefanha-x1.localdomain>
	<87zh9n6pwj.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <87zh9n6pwj.fsf@linaro.org>
Subject: Re: [Virtio-fs] [RFC 1/3] WIP virtiofsd: import Linux <fuse.h>
	header file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2020 at 11:28:44AM +0100, Alex Benn=E9e wrote:
>=20
> Stefan Hajnoczi <stefanha@redhat.com> writes:
>=20
> > On Sat, Oct 26, 2019 at 05:49:11PM -0400, Michael S. Tsirkin wrote:
> >> On Fri, Oct 25, 2019 at 12:01:50PM +0200, Stefan Hajnoczi wrote:
> >> > tests/vhost-user-fs-test.c needs fuse.h.  The private copy that
> >> > virtiofsd has can be replaced with a properly imported file using
> >> > update-linux-headers.sh.
> >> >=20
> >> > TODO rerun update-linux-headers.sh with upstream kernel tree!
> >> >=20
> >> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> >>=20
> >> OK I would just add this with the virtiofsd patchset.
> >
> > Yes, I'll talk to David.
>=20
> Catching up after the fact I see this didn't get merged. Was there a
> reason?

This patch series is stalled because I have been busy with other tasks.

The standard-headers fuse.h header will be needed when something outside
virtiofsd uses FUSE definitions for virtio-fs. At the moment nothing
does so there is no need to merge this patch yet.

Stefan

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7VJNgACgkQnKSrs4Gr
c8jDWAf9GfRw0GKIvlbbLhOpjwgs9gY4vpGKmEfTmuiXoJcDzDEchSpA7PNH6sKc
PKY462eeO8VqxfTf23k75SaGdnbzljN1fHnb4kFi6hZKmaQPggrTGTmrYtP2zqnT
xwfhbZ1A9Q2DGZRLXt54i22UZhmpFY03scirsXmU2pj3e4ZFD+h5nMdITljZv8UP
SKIvStf8HpOFBWTwY2D/ifBxOWCwvD7dFSfMhs4V7/LpIb0svFhM+57o7O2Q/a7J
6QKTuEsAhRNFxc90L8BBa4d9n0OUFF+Wb72AbU5mewAh8ckofSM+9dUL4W/sp/y4
MRdZHst4/7bJfIdgH+G3n5xvjy/mRg==
=CWEx
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--

