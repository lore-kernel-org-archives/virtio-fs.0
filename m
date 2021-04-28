Date: Wed, 28 Apr 2021 17:52:32 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YImS0CTG5OgqLgFe@work-vm>
References: <20210428144813.417170-1-philmd@redhat.com>
	<CAFEAcA9_5C4sLwb-MXwg-yCgN+Esb0mop=baCv5kgoW58UPQzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAFEAcA9_5C4sLwb-MXwg-yCgN+Esb0mop=baCv5kgoW58UPQzA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Meson build fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>, Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Wed, 28 Apr 2021 at 15:53, Philippe Mathieu-Daud=E9 <philmd@redhat.com=
> wrote:
> >
> > A pair of fixes to allow building virtiofsd without sysemu/tools.
> >
> > Should this configuration be tested in CI?
>=20
> Does the configuration make sense to support? I thought
> virtiofsd was only of use with system emulation ?

It probably is; although arguably it makes sense to build
virtiofsd by itself without either emulation.

Dave

> thanks
> -- PMM
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

