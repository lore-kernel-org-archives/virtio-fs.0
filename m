Date: Wed, 7 Aug 2019 19:03:55 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190807180355.GA22758@stefanha-x1.localdomain>
References: <20190801165409.20121-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20190801165409.20121-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
	part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2019 at 05:54:05PM +0100, Stefan Hajnoczi wrote:
> Performance
> -----------
> Please try these patches out and share your results.

Here are the performance numbers:

  Threadpool | iodepth | iodepth
     size    |    1    |   64
  -----------+---------+--------
  None       |   4451  |  4876
  1          |   4360  |  4858
  64         |   4359  | 33,266

A graph is available here:
https://vmsplice.net/~stefan/virtiofsd-threadpool-performance.png

Summary:

 * iodepth=64 performance is increased by 6.8 times.
 * iodepth=1 performance degrades by 2%.
 * DAX is bottlenecked by QEMU's single-threaded
   VHOST_USER_SLAVE_FS_MAP/UNMAP handler.

Threadpool size "none" is virtiofsd commit 813a824b707 ("virtiofsd: use
fuse_lowlevel_is_virtio() in fuse_session_destroy()") without any of the
multithreading preparation patches.  I benchmarked this to check whether
the patches introduce a regression for iodepth=1.  They do, but it's
only around 2%.

I also ran with DAX but found there was not much difference between
iodepth=1 and iodepth=64.  This might be because the host mmap(2)
syscall becomes the bottleneck and a serialization point.  QEMU only
processes one VHOST_USER_SLAVE_FS_MAP/UNMAP at a time.  If we want to
accelerate DAX it may be necessary to parallelize mmap, assuming the
host kernel can do them in parallel on a single file.  This performance
optimization is future work and not directly related to this patch
series.

The following fio job was run with cache=none and no DAX:

  [global]
  runtime=60
  ramp_time=30
  filename=/var/tmp/fio.dat
  direct=1
  rw=randread
  bs=4k
  size=4G
  ioengine=libaio
  iodepth=1

  [read]

Guest configuration:
1 vCPU
4 GB RAM
Linux 5.1 (vivek-aug-06-2019)

Host configuration:
Intel(R) Core(TM) i7-5600U CPU @ 2.60GHz (2 cores x 2 threads)
8 GB RAM
Linux 5.1.20-300.fc30.x86_64
XFS + dm-thin + dm-crypt
Toshiba THNSFJ256GDNU (256 GB SATA SSD)

Stefan

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1LEmwACgkQnKSrs4Gr
c8gLjQf/UBAHjyJ/mHomkCbE3SaeaZIwfXNA9Zm278DVu9a2vAOhjZ1shtV5b21g
yDlesefwzFb9u/McYTwf1hbUiYweSy2bNqaRFb9ZsI4EWxqDJRirpTGlioWESzjy
kdQ3Gh9PRwgdgfXZMBUN01ut07dQKEDSTzlBISHkS5GT56to9NbzprHZh+bwy8NG
9UenaGzcvEwTxGxEjSekF/UkGwXVnsBOE4Do1MsBK5WJf+T919kUW5043yz1HUyB
7YfoTtKMo+cyUJaQcyGOOXCs2vhoAVqY/KUYM92RH31shnwbBZK5nAa9wVACGcu2
fslfzmFxRovmbI6U+QjZrfs+lgQGCg==
=swFN
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--

