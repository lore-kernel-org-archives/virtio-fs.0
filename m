Date: Tue, 26 Jan 2021 10:10:31 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210126101031.GB226981@stefanha-x1.localdomain>
References: <20210121144429.58885-1-stefanha@redhat.com>
	<20210122154054.GA120574@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <20210122154054.GA120574@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: prevent opening of special files
 (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: qemu-devel@nongnu.org, P J P <ppandit@redhat.com>, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 22, 2021 at 10:40:54AM -0500, Vivek Goyal wrote:
> On Thu, Jan 21, 2021 at 02:44:29PM +0000, Stefan Hajnoczi wrote:
> > A well-behaved FUSE client does not attempt to open special files with
> > FUSE_OPEN because they are handled on the client side (e.g. device nodes
> > are handled by client-side device drivers).
> >=20
> > The check to prevent virtiofsd from opening special files is missing in
> > a few cases, most notably FUSE_OPEN. A malicious client can cause
> > virtiofsd to open a device node, potentially allowing the guest to
> > escape. This can be exploited by a modified guest device driver. It is
> > not exploitable from guest userspace since the guest kernel will handle
> > special files inside the guest instead of sending FUSE requests.
> >=20
> > This patch adds the missing checks to virtiofsd. This is a short-term
> > solution because it does not prevent a compromised virtiofsd process
> > from opening device nodes on the host.
> >=20
> > Reported-by: Alex Xu <alex@alxu.ca>
> > Fixes: CVE-2020-35517
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>=20
> It looks good to me. I see there is another openat() instance in
> lo_opendir(). May be we can convert it to use lo_inode_open() as well?

I thought so too, but this one is interesting:

  fd =3D openat(lo_fd(req, ino), ".", O_RDONLY);

Using "." here is basically equivalent to O_DIRECTORY!

Therefore this always fails on special files. That's why I ended up
leaving it unchanged.

  $ cat a.c
  #define _GNU_SOURCE
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <fcntl.h>
  #include <unistd.h>
  #include <stdio.h>
  #include <stdlib.h>

  int main(int argc, char **argv)
  {
      int fd;
      int pfd =3D open(argv[1], O_PATH);

      if (pfd < 0) {
          perror("open");
          return EXIT_FAILURE;
      }

      fd =3D openat(pfd, ".", O_RDONLY);
      if (fd < 0) {
          perror("openat");
          return EXIT_FAILURE;
      }

      close(fd);
      close(pfd);
      return EXIT_SUCCESS;
  }
  $ gcc -o a a.c
  $ ./a /tmp
  <--- no error
  $ ./a /tmp/a.c
  openat: Not a directory
  $ ./a /dev/stdin
  openat: Not a directory

Stefan

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAP6pcACgkQnKSrs4Gr
c8hGdQgAvd//+jyb2QVpI7GGXlaJslHi+Wm15qWqoEff2/LpuqCtmWJ0hgZ202Fi
B70+Y+27Be3D8f6d28UNo1eM1Yq+TMQLc506SREir0dt3ACkT4SxLgSYcZ3LMeyf
SYee6TDe2/Sbfs/s2/amdo7u4Kr0U06ujho5MXgBktbP2Orv1ydj72XFYsAcq2pJ
+j+Irg0F7nwMdRdYc+nPBCCHlaGh/CG+TRJZ1HkqJyk3g+9UHFs9tn7EWYD5jsik
6R5E5XEFu9IWzEcEGUAwuBIy5JkV+7j9wP3k7rXEFB4Dj0zWEYVWodDGE2iXNzxm
2AZwsjVNhjO/bymeEgXL/YzcNq0e+Q==
=VTao
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--

