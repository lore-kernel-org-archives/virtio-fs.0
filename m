Date: Thu, 13 May 2021 16:17:03 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJ1C752kyBYW9ltm@stefanha-x1.localdomain>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<CAFQAk7gH7DUi0-wDANQQBHTPgdtQxv34k+6tr9vzftPLqJt6KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QoZnNghw2jTIKK7p"
Content-Disposition: inline
In-Reply-To: <CAFQAk7gH7DUi0-wDANQQBHTPgdtQxv34k+6tr9vzftPLqJt6KQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC PATCH 0/9] Support for Virtio-fs daemon crash
	reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: QEMU <qemu-devel@nongnu.org>, Xie Yongji <xieyongji@bytedance.com>, virtio-fs-list <virtio-fs@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>


--QoZnNghw2jTIKK7p
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 10, 2021 at 10:38:05PM +0800, Jiachen Zhang wrote:
> Hi all,
>=20
>=20
> We are going to develop the v2 patch for virtio-fs crash reconnection. As
> suggested by Marc-Andr=E9 and Stefan, except for the inflight I/O tracking
> log area, all the other internal statuses of virtiofsd will be saved to
> some places other than QEMU. Specifically, the three lo_maps (ino_map,
> dirp_map, and fd_map) could be saved to several mmapped files, and the
> opened fds could be saved to systemd. I'd like to get some feedback on our
> further thoughts before we work on the revision.
>=20
>=20
> 1. What about by default save the opened fds as file handles to host
> kernel, instead of saving them to systemd. After some internal discussion,
> we think introducing systemd may introduce more uncertainness to the
> system, as we need to create one service for each daemon, and all the
> daemons may suffer the single-point failure of the systemd process.

I don't think saving file handles works 100%. The difference between an
open fd and a file handle is what happens when the inode is deleted. If
an external process deletes the inode during restart and then the fd
keeps it alive while a file handle becomes stale and the inode is gone.

Regarding systemd, it's pid 1 and cannot die - otherwise the system is
broken.

But in any case I think there are multiple options here. Whether you
choose to systemd, implement the sd_notify(3) protocol in your own
parent process, or take a different approach like a parent process with
clone(2) CLONE_FILES to avoid the communication overhead for saving
every fd, I think all of those approaches would be reasonable.

> 2. Like the btree map implementation (multikey.rs) of virtiofsd-rs, what
> about splitting the flatten lo_map implementation, which supports to be
> persisted to files, from passhtrough_ll.c to a new separated source file.
> This way, maybe we can more easily wrap it with some Rust compatible
> interfaces, and enable crash recovery for virtiofsd-rs based on it.

In the past two months I've noticed the number of virtiofsd-rs merge
requests has increased and I think the trend is that new development is
focussing on virtiofsd-rs.

If it fits into your plans then focussing on virtiofsd-rs would be fine
and then there is no need to worry about Rust compatible interfaces for
C virtiofsd.

> 3. What about dropping the dirp_map, and integrate the opened directory f=
ds
> to fd_map. The virtiofsd-rs implementation only has two maps (inodes and
> handles). In the C version, dirp_map may also unnecessary.

Maybe, but carefully:

The purpose of the maps is to safely isolate the client from the
virtiofsd's internal objects. The way I remember it is that C virtiofsd
has a separate dirp map to prevent type confusion between regular open
files and directories. The client must not trick the server into calling
readdir(3) on something that's not a struct dirent because that could be
a security issue.

However, it's possible that virtiofsd-rs is able to combine the two
because it uses syscall APIs on file descriptors instead of libc
opendir(3) so there is no possibility of type confusion. The syscall
would simply fail if the file descriptor is not O_DIRECTORY.

Stefan

--QoZnNghw2jTIKK7p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCdQu8ACgkQnKSrs4Gr
c8gE1ggAx/DMD6vK7M03AhlZWlcNvheewGIcaYwtqHR0HV4fznYMD1n9TBClC2lc
uv6XzzWvWP9NYr6fryuS/lug2Zd30NrRfEOEAxY3LXlWl3u80Dp2hN+UaMk0hSbS
SpIFXyPPQVBFyO0c/yIqjteqyLBN6/2PS6ZU9fXZM5o1sP4bAdXLl0P7YhoNHvze
T4NED1LEpI+sKAyY+7SijWS6/1W5G5t6mNK8WB6A2JAwc8lNCjvvXBeg7Nc5l7uh
2kTIRRdnXvP7doqcZpNn0cXbvZmbbngppjDl2OrY6surIWRRfJkZhRxbGEP9vl2m
jP2WFcOzAEoobqa4LbeP4wGfYRXkLg==
=D/xq
-----END PGP SIGNATURE-----

--QoZnNghw2jTIKK7p--

