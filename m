Date: Tue, 26 Jan 2021 11:19:47 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210126111947.GD250425@stefanha-x1.localdomain>
References: <CAAQbG+U9m91sxsm9swLB7gYNh3NT47Z0kb9LbgEZXUMV65StLQ@mail.gmail.com>
	<CAOssrKd6JkEKt98F7XhHeUhcCYP+gwnrHLE8VKTg0K-ABUxDEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Content-Disposition: inline
In-Reply-To: <CAOssrKd6JkEKt98F7XhHeUhcCYP+gwnrHLE8VKTg0K-ABUxDEA@mail.gmail.com>
Subject: Re: [Virtio-fs] Lack of inotify for virtio-fs backed
 files/directories
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 25, 2021 at 08:22:32PM +0100, Miklos Szeredi wrote:
> On Fri, Jan 22, 2021 at 5:58 PM Eric Ernst <eric.g.ernst@gmail.com> wrote:
> >
> > Hey ya'll,
> >
> > As highlighted nicely at [1], a common pattern in Kubernetes is to watc=
h for changes to files/directories passed in as Configmaps or secrets. Side=
cars typically use inotify to watch for changes and then signal the primary=
 container or perform other changes based on the reconfiguration.
> >
> > In the context of Kata, these files/dirs are passed in utilizing virtio=
-fs. Since FUSE itself doesn't support inotify, this pattern will fail. I'm=
 looking at ways to work-around this gap, including:
> >
> > 1) documenting this as a compatibility limitation ("don't do this!").
> > 2) suggesting end-users modify their sidecars and utilize poll
> > 3) doing an inotify on the host, and when changes are identified, notif=
y the guest agent who can then modify the files on disk to trigger an inoti=
fy
> > 4) Working on contributing to libfuse in order to add inotify support.
> >
> > (4) is the right thing, but will take quite a bit of time before it can=
 be used. I'm curious if other folks have suggestions for workarounds (I do=
n't like any of the ones I suggested), and if anyone has taken a look at (4=
)?
>=20
> Here's a thread on enabling inotify in remote fs:
>=20
> https://lore.kernel.org/linux-fsdevel/20190507085707.GD30899@veci.piliscs=
aba.redhat.com/
>=20
> The discussion didn't get too far, it seems there's not a very big
> interest in this, but conceptually it doesn't seem too difficult.

Vivek Goyal previously experimented with adding a notification virtqueue
to the virtio-fs device so that FUSE_NOTIFY_* messages can be supported.
That code can be brought back and merged.

However, due to the number of flags in inotify(7) I think this is a
non-trivial project. Whoever wants to tackle this feature should be
aware that it may take a few months (3?) to fully implement and test.

Stefan

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAP+tMACgkQnKSrs4Gr
c8iBVgf/WWBFy8/lEMNWjvyDbAAZtEqafynSCEpXeW9Yi6ZALtEiocfcyicsk4Op
2nbD/51ZKo+WfcM+VubWh9+G+BC64lTCxUhWChjX4yAwIhY0ZJ2TRzL0A2hWYkmA
eIKgIfBUBtj8whdUwa6UuqQQ8W+ZU2XWspl32+FndwSLe7mGi0Ypu+oW2QbU0rx2
9dPiUGT2oMoPbbDJKxfcf0AEX7RnpQc3nqj7xfWOJw7CXAWd7NyY72i3vbpAAFGt
CTOdjzJ5DBePvNKn9Q7dmO18TnDUS6CBoJSehVXRGaGT8mOqNLibp8pm0isOYf5g
orN/NfC0ayyNlp69X2qnyHhrKl7B6A==
=slgL
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--

