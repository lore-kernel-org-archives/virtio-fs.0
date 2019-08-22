Date: Thu, 22 Aug 2019 14:55:04 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190822135504.GK20491@stefanha-x1.localdomain>
References: <20190821085659.8448-1-eguan@linux.alibaba.com>
	<20190821150429.GH3309@work-vm>
	<3ca44559-d2ad-f72c-62ae-f44d13c1e0e4@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="M9kwpIYUMbI/2cCx"
Content-Disposition: inline
In-Reply-To: <3ca44559-d2ad-f72c-62ae-f44d13c1e0e4@huawei.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: add support to change log level
 on fly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com


--M9kwpIYUMbI/2cCx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2019 at 01:07:18PM +0800, piaojun wrote:
> On 2019/8/21 23:04, Dr. David Alan Gilbert wrote:
> > * Eryu Guan (eguan@linux.alibaba.com) wrote:
> >> Introduce a file which contains the target log level, and
> >> current_log_level will be reloaded to the target log level on SIGHUP.
> >>
> >> The file is set to "/run/virtiofsd/log_level.<pid>". Due to
> >> sandboxing in virtiofsd, this file can only be read/write via
> >> /proc/<pid>/fd/<fd> for now.
> >>
> >> Example usage:
> >>
> >>   # view current log level
> >>   cat /proc/<pid>/fd/<fd>
> >>   # change log level to debug
> >>   echo debug > /proc/<pid>/fd/<fd>
> >>   kill -HUP <pid>
> >>
> >> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> >=20
> > This looks really complex for something that can only be used for
> > changing log levels.
>=20
> I have the same opinion with Dave, and I wonder if we have some easier
> channel to tell virtiofsd to change log level. And making the channel
> more generic is good for the expansibility of virtiofsd.

There is code for QMP (a JSON RPC-style protocol) in the QEMU codebase
that can be reused.

An option that is more widely used but I have little experience with is
DBus.  It is easy to access from most programming languages, including
the command-line.

Although both of these approaches are somewhat heavyweight, they scale
to much more complex management commands and already have existing
tooling available.

I think we should choose one instead of inventing another RPC system.

Stefan

--M9kwpIYUMbI/2cCx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1enrgACgkQnKSrs4Gr
c8gbnggAjToS1k8OVkpBbiaDvLFPYLAvExTnphC1K4SVD2SlkNL78MZFo7AxPF86
8gs1/dMMOaFvvrl8n0CCxfhfcTVMg0vlqLB4cOyawQdJ0BlV2bUg02GuKoKJnnNp
hs19M2K9MspPFNYKjrDVw1iB1+TjFMUktvrh7THiQzvKskMHVTE/6U2Q0wVAM428
rGJIB9UkN5dairBTjRQzC0q6iGt4P9TfEaR1VZ9y+VdCeyENofdNbKR4Xv0IbPyv
B/Tgkc5a+8BNJu3+oElGC2lN1/Mu2qUPMZ7/3LbeqmphWG5sR0qyy4FbjmdkNk7r
qbbxP6tOHBmBDan3IQGRUfBhi3e8SA==
=fc3E
-----END PGP SIGNATURE-----

--M9kwpIYUMbI/2cCx--

