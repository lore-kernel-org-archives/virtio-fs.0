Date: Mon, 19 Aug 2019 17:04:26 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190819160426.GB2625@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
Subject: [Virtio-fs] [ANNOUNCE] virtio-fs v0.3 release
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, kata-dev@lists.katacontainers.io


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I am delighted to announce the release of virtio-fs v0.3, a shared file
system that lets virtual machines access a directory tree on the host.
This release is based on QEMU 4.1.0 and Linux 5.3-rc3.

For more information about virtio-fs: https://virtio-fs.gitlab.io/

This is a development release aimed at early adopters of virtio-fs.  Work is
being done to upstream the code into Linux and QEMU.  We expect to stop
publishing virtio-fs releases once the code has been merged by these upstream
projects.

Where to get it:

  https://gitlab.com/virtio-fs/linux/-/tags/virtio-fs-v0.3
  https://gitlab.com/virtio-fs/qemu/-/tags/virtio-fs-v0.3

Changes:

 * Please note that the mount syntax has changed to:

     # mount -t virtio_fs myfs /mnt -o ...

   The old syntax was "mount -t virtio_fs none /mnt -o tag=myfs,...".

 * virtiofsd --fd=FDNUM takes a listen socket file descriptor number.  File
   descriptor passing is an alternative way to manage the vhost-user UNIX
   domain socket.  The parent process no longer needs to wait for virtiofsd to
   create the listen socket before spawning the VM.

 * virtiofsd --syslog logs to syslog(2) instead of stderr.  Useful for unifying
   logging and when the virtiofsd process is not being supervised.

 * virtiofsd --thread-pool-size=NUM sets the maximum number of worker threads
   for FUSE request processing.  This can be used to control the host queue
   depth.  The default is 64.

 * Performance improvements and bug fixes.

Note for Kata Containers: the new kernel is not compatible with existing
Kata Containers releases due to the mount syntax change.  To try it out,
please apply the following kata-runtime patch:

  https://gitlab.com/virtio-fs/runtime/commit/a2e44de817e438c02a495cf258039774527e3178

Kata Containers patches for virtio-fs v0.3 are under development and will be
submitted to Kata soon.

Thanks to the following people for contributing code and to many more
for helping the virtio-fs effort:

Dr. David Alan Gilbert <dgilbert@redhat.com>
Eric Ren <renzhen@linux.alibaba.com>
Eryu Guan <eguan@linux.alibaba.com>
Ganesh Maharaj Mahalingam <ganesh.mahalingam@intel.com>
Jiufei Xue <jiufei.xue@linux.alibaba.com>
Liu Bo <bo.liu@linux.alibaba.com>
Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Miklos Szeredi <mszeredi@redhat.com>
Peng Tao <tao.peng@linux.alibaba.com>
piaojun <piaojun@huawei.com>
Sebastien Boeuf <sebastien.boeuf@intel.com>
Stefan Hajnoczi <stefanha@redhat.com>
Vivek Goyal <vgoyal@redhat.com>
Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1ayIkACgkQnKSrs4Gr
c8hAzQf9E4PbRDszsY7PdMkSP1YTi+I3Nv+dejPOnv98yeUdhv+vJFrrmsi4ZT0c
403/aP5zUg6+iIPUu8kjF1yCBeLNK5a6mNKtZT5k0o3uyUlHk1cNKAZaJimOm1UD
MYzgKTwvHkPd8ZLKwo1Ion1L597neZnF3SqhJE7pMbkKBNJvRPduY531zl2NwdJ8
+gH3MxPqyIlu0lwCdE1kdYe9gFP+CvWK9g0PMvkD+XhjdO21JxBNFaTu4jjzc+WV
MRndGHtT0fbqj75bS6coe8CMnaWUDoRbH03ByK048YjTidlYL2z5SVOLFKIidSmo
cA6OS1FyZs8XDU+GwvoHPvpCff8iJw==
=zbZx
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--

