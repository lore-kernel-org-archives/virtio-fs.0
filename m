Date: Tue, 23 Mar 2021 12:55:26 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210323115451.oxe4a4go32brca7z@mhamilton>
References: <2148A6EA-09CC-4DD2-8E03-8D51633D4137@apple.com>
	<CAOssrKdGOL3Zqmhz4VGEccWw8N0tp1kP7qooB8gN7JOi5+5gew@mail.gmail.com>
	<20210322164704.GD446288@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mzckivqqb3dblgvm"
Content-Disposition: inline
In-Reply-To: <20210322164704.GD446288@redhat.com>
Subject: Re: [Virtio-fs] Large memory consumption by virtiofsd,
 suspecting fd's aren't being closed?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Eric Ernst <eric_ernst@apple.com>


--mzckivqqb3dblgvm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2021 at 12:47:04PM -0400, Vivek Goyal wrote:
> On Mon, Mar 22, 2021 at 05:09:32PM +0100, Miklos Szeredi wrote:
> > On Mon, Mar 22, 2021 at 6:52 AM Eric Ernst <eric_ernst@apple.com> wrote:
> > >
> > > Hey ya=E2=80=99ll,
> > >
> > > One challenge I=E2=80=99ve been looking at is how to setup an appropr=
iate memory cgroup limit for workloads that are leveraging virtiofs (ie, ru=
nning pods with Kata Containers). I noticed that memory usage of the daemon=
 itself can grow considerably depending on the workload; though much more t=
han I=E2=80=99d expect.
> > >
> > > I=E2=80=99m running workload that simply runs a build on kernel sourc=
es with -j3. In doing this, the source of the linux kernel are shared via v=
irtiofs (no DAX), so as the build goes on, there are a lot of files opened,=
 closed, as well as created. The rss memory of virtiofsd grows into several=
 hundreds of MBs.
> > >
> > > When taking a look, I=E2=80=99m suspecting that virtiofsd is carrying=
 out the opens, but never actually closing fds. In the guest, I=E2=80=99m s=
eeing fd=E2=80=99s on the order of 10-40 for all the container processes as=
 it runs, whereas I see the number of fds for virtiofsd continually increas=
ing, reaching over 80,000 fds. I=E2=80=99m guessing this isn=E2=80=99t expe=
cted?
> >=20
> > The reason could be that guest is keeping a ref on the inodes
> > (dcache->dentry->inode) and current implementation of server keeps an
> > O_PATH fd open for each inode referenced by the client.
> >=20
> > One way to avoid this is to use the "cache=3Dnone" option, which forces
> > the client to drop dentries immediately from the cache if not in use.
> > This is not desirable if cache is actually in use.
> >=20
> > The memory use of the server should still be limited by the memory use
> > of the guest:  if there's memory pressure in the guest kernel, then it
> > will clean out caches, which results in the memory use decreasing in
> > the server as well.  If the server memory use looks unbounded, that
> > might be indicative of too much memory used for dcache in the guest
> > (cat /proc/slabinfo | grep ^dentry).     Can you verify?
>=20
> Hi Miklos,
>=20
> Apart from above, we identified one more issue on IRC. I asked Eric
> to drop caches manually in guest. (echo 3 > /proc/sys/vm/drop_caches)
> and while it reduced the fds open it did not seem to free up significant
> amount of memory.
>=20
> So question remains where is that memory. One possibility is that we
> have memory allocated for mapping arrays (inode and fd). These arrays
> only grow and never shrink. So they can lock down some memory.
>=20
> But still, lot of lo_inode memory should have been freed when
> echo 3 > /proc/sys/vm/drop_caches was done. Why all that did not
> show up in virtiofsd RSS usage, that's kind of little confusing.

Are you including "RssShmem" in "RSS usage"? If so, that could be
misleading. When virtiofsd[-rs] touches pages that reside in the
memory mapping that's shared with QEMU, those pages are accounted
in the virtiofsd[-rs] process's RssShmem too.

In other words, the RSS value of the virtiofsd[-rs] process may be
overinflated because it includes pages that are actually shared
(there's no a second copy of them) with the QEMU process.

This can be observed using a tool like "smem". Here's an example

 - This virtiofsd-rs process appears to have a RSS of ~633 MiB
=20
root       13879 46.1  7.9 8467492 649132 pts/1  Sl+  11:33   0:52 ./target=
/debug/virtiofsd-rs
root       13947 69.3 13.4 5638580 1093876 pts/0 Sl+  11:33   1:14 qemu-sys=
tem-x86_64

 - In /proc/13879/status we can observe most of that memory is
   actually RssShmem:

RssAnon:	    9624 kB
RssFile:	    5136 kB
RssShmem:	  634372 kB

 - In "smem", we can see a similar amount of RSS, but the PSS is
   roughly half the size because "smem" is splitting it up between
   virtiofsd-rs and QEMU:

[root@localhost ~]# smem -P virtiofsd-rs -P qemu
  PID User     Command                         Swap      USS      PSS      =
RSS=20
13879 root     ./target/debug/virtiofsd-rs        0    13412   337019   662=
392=20
13947 root     qemu-system-x86_64 -enable-        0   434224   760096  1094=
392=20

 - If we terminate the virtiofsd-rs process, the output of "smem" now
   shows that QEMU's PSS has grown to account for the PSS that was
   previously assigned to virtiofsd-rs too, so we can confirm that was
   memory shared between both processes.

  PID User     Command                         Swap      USS      PSS      =
RSS=20
13947 root     qemu-system-x86_64 -enable-        0  1082656  1084966  1095=
692=20

Just to be 100% sure, I've also run "heaptrack" on a virtiofsd-rs
instance, and can confirm that the actual heap usage of the process
was around 5-6 MiB.

Sergio.

--mzckivqqb3dblgvm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmBZ1y0ACgkQ9GknjS8M
AjWnLw/7BfT7xtWTljcc3LoKILGZgskDi17LCVdGSINPX/7qep8DVHtguTGVT8l5
uWW0Y6gMvrcWdnQ8IPmWZJFFk4bxxGnhSmAT1veRadrcCZKP25KVTh6yQXvjVJN/
QPtcjZ6hGlCf2mQrLL64I+RSwgrCZKe+kh8nf487AV419TY2I9qdqRFYOFUOXv3/
FCTPUWyphcZXcog8fnwU0CGKQLFZVIYSmMgvqZ2qJsZGZ/OCrq8rv43Rar0F2dQw
/Tj1c8uq6cGQjPhf8UdIdMWn5Nfg1pVPCHW1IdtKgqhp6uqzP5/ocjyBZhoXNLvN
Assil/+VDGcDWYGIf7u2ndVEvZcOosx60AxECUC0f8ggnzpALUBBTqGW8LlpCw5B
R5of76W8lEekyAK6dpBNTlQR7qfcy+d9Tyy+xHtqxknso5+J2HzNU9BWnWqlbVgi
6+lN84vUzguf234qAdRF48raJUH7/Id73WSP+snKgdOwmMSS10gyRZFwmR6NfoDT
TDBziz78DykXA4eiDeSsJxvzIilXueouihACpUuM2AK6dE9AjgWSmDMsnTyE+3kz
AndOTuD7Xn1u7NwhrK1aKkqvXaP1aMXl16y1o8YajUhJQTBLflAzaXkcYbbUFRCy
pZz6cXDo+31sCslZJchu8ERazKvNVz2X/A2bIkVrwxYX/4wYJ3E=
=4LHI
-----END PGP SIGNATURE-----

--mzckivqqb3dblgvm--

