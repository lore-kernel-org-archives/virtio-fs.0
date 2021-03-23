Date: Tue, 23 Mar 2021 16:19:40 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210323151940.rao4zhik7r57nzcs@mhamilton>
References: <2148A6EA-09CC-4DD2-8E03-8D51633D4137@apple.com>
	<CAOssrKdGOL3Zqmhz4VGEccWw8N0tp1kP7qooB8gN7JOi5+5gew@mail.gmail.com>
	<20210322164704.GD446288@redhat.com>
	<20210323115451.oxe4a4go32brca7z@mhamilton>
	<20210323134733.GA483930@redhat.com>
	<CAAQbG+UxuFYKiNAL0=dUg1oSVs0tqf7vi0C4xVA6h6ft77UcNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="r2n5xwrcwu2pwxfj"
Content-Disposition: inline
In-Reply-To: <CAAQbG+UxuFYKiNAL0=dUg1oSVs0tqf7vi0C4xVA6h6ft77UcNQ@mail.gmail.com>
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
To: Eric Ernst <eric.g.ernst@gmail.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Eric Ernst <eric_ernst@apple.com>, Vivek Goyal <vgoyal@redhat.com>


--r2n5xwrcwu2pwxfj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2021 at 07:52:22AM -0700, Eric Ernst wrote:
> On Tue, Mar 23, 2021 at 6:47 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>=20
> > On Tue, Mar 23, 2021 at 12:55:26PM +0100, Sergio Lopez wrote:
> > > On Mon, Mar 22, 2021 at 12:47:04PM -0400, Vivek Goyal wrote:
> > > > On Mon, Mar 22, 2021 at 05:09:32PM +0100, Miklos Szeredi wrote:
> > > > > On Mon, Mar 22, 2021 at 6:52 AM Eric Ernst <eric_ernst@apple.com>
> > wrote:
> > > > > >
> > > > > > Hey ya=E2=80=99ll,
> > > > > >
> > > > > > One challenge I=E2=80=99ve been looking at is how to setup an a=
ppropriate
> > memory cgroup limit for workloads that are leveraging virtiofs (ie, run=
ning
> > pods with Kata Containers). I noticed that memory usage of the daemon
> > itself can grow considerably depending on the workload; though much more
> > than I=E2=80=99d expect.
> > > > > >
> > > > > > I=E2=80=99m running workload that simply runs a build on kernel=
 sources
> > with -j3. In doing this, the source of the linux kernel are shared via
> > virtiofs (no DAX), so as the build goes on, there are a lot of files
> > opened, closed, as well as created. The rss memory of virtiofsd grows i=
nto
> > several hundreds of MBs.
> > > > > >
> > > > > > When taking a look, I=E2=80=99m suspecting that virtiofsd is ca=
rrying out
> > the opens, but never actually closing fds. In the guest, I=E2=80=99m se=
eing fd=E2=80=99s on
> > the order of 10-40 for all the container processes as it runs, whereas I
> > see the number of fds for virtiofsd continually increasing, reaching ov=
er
> > 80,000 fds. I=E2=80=99m guessing this isn=E2=80=99t expected?
> > > > >
> > > > > The reason could be that guest is keeping a ref on the inodes
> > > > > (dcache->dentry->inode) and current implementation of server keep=
s an
> > > > > O_PATH fd open for each inode referenced by the client.
> > > > >
> > > > > One way to avoid this is to use the "cache=3Dnone" option, which =
forces
> > > > > the client to drop dentries immediately from the cache if not in =
use.
> > > > > This is not desirable if cache is actually in use.
> > > > >
> > > > > The memory use of the server should still be limited by the memory
> > use
> > > > > of the guest:  if there's memory pressure in the guest kernel, th=
en
> > it
> > > > > will clean out caches, which results in the memory use decreasing=
 in
> > > > > the server as well.  If the server memory use looks unbounded, th=
at
> > > > > might be indicative of too much memory used for dcache in the gue=
st
> > > > > (cat /proc/slabinfo | grep ^dentry).     Can you verify?
> > > >
> > > > Hi Miklos,
> > > >
> > > > Apart from above, we identified one more issue on IRC. I asked Eric
> > > > to drop caches manually in guest. (echo 3 > /proc/sys/vm/drop_cache=
s)
> > > > and while it reduced the fds open it did not seem to free up
> > significant
> > > > amount of memory.
> > > >
> > > > So question remains where is that memory. One possibility is that we
> > > > have memory allocated for mapping arrays (inode and fd). These arra=
ys
> > > > only grow and never shrink. So they can lock down some memory.
> > > >
> > > > But still, lot of lo_inode memory should have been freed when
> > > > echo 3 > /proc/sys/vm/drop_caches was done. Why all that did not
> > > > show up in virtiofsd RSS usage, that's kind of little confusing.
> > >
> > > Are you including "RssShmem" in "RSS usage"? If so, that could be
> > > misleading. When virtiofsd[-rs] touches pages that reside in the
> > > memory mapping that's shared with QEMU, those pages are accounted
> > > in the virtiofsd[-rs] process's RssShmem too.
> > >
> > > In other words, the RSS value of the virtiofsd[-rs] process may be
> > > overinflated because it includes pages that are actually shared
> > > (there's no a second copy of them) with the QEMU process.
> > >
> > > This can be observed using a tool like "smem". Here's an example
> > >
> > >  - This virtiofsd-rs process appears to have a RSS of ~633 MiB
> > >
> > > root       13879 46.1  7.9 8467492 649132 pts/1  Sl+  11:33   0:52
> > ./target/debug/virtiofsd-rs
> > > root       13947 69.3 13.4 5638580 1093876 pts/0 Sl+  11:33   1:14
> > qemu-system-x86_64
> > >
> > >  - In /proc/13879/status we can observe most of that memory is
> > >    actually RssShmem:
> > >
> > > RssAnon:          9624 kB
> > > RssFile:          5136 kB
> > > RssShmem:       634372 kB
> >
> > Hi Sergio,
> >
> > Thanks for this observation about RssShmem. I also ran virtiofsd and
> > observed memory usage just now and it indeed looks like that only
> > RssShmem usage is very high.
> >
> > RssAnon:            4884 kB
> > RssFile:            1900 kB
> > RssShmem:        1050244 kB
> >
> > And as you point out that this memory is being shared with QEMU. So
> > looks like from cgroup point of view, we should put virtiofsd and
> > qemu in same cgroup and have a combined memory limit so that this
> > shared memory is accounting looks proper.
> >
> > Eric, does this sound reasonable.
> >
>=20
> Sergio, Vivek --
>=20
> Today QEMU/virtiofsd do live within the same memory cgroup, and are bound
> by that same overhead I need to introduce. Good to know regarding the
> sharing (this restores some sanity to my observations, thank you!), but t=
he
> real crux of the problem is two items:
>  1) the FDs are held long after the application in guest is done with them
> because of dentry cache in the guest (when cache=3Dauto for
> virtiofsd).

Yeah, we're looking into mechanisms that would allow us to avoid
needing to hold an FD for each reference in the dentry cache, but
it'll take a while. :-/

If this becomes a problem, I'm afraid the only short term solution
would be fixing mmap for "cache=3Dnone", and then accepting the
performance hit that may suppose.

>  2) virtiofsd/QEMU is holding on to the memory after the fds are released

The shared memory mapping between virtiofsd[-rs] and QEMU is actually
the same one that's backing the guest's RAM. It's expected that the
guest OS will eventually touch most of the pages available to it,
making QEMU's RSS to grow to a number close to the amount of RAM
configured for the VM. This should happen with or without virtio-fs.

Are you using virtio-balloon's free page reporting or some other
feature to return free pages to the Host?

Sergio.

> --Eric
>=20
>=20
>=20
> >
> > Thanks
> > Vivek
> >
> > >
> > >  - In "smem", we can see a similar amount of RSS, but the PSS is
> > >    roughly half the size because "smem" is splitting it up between
> > >    virtiofsd-rs and QEMU:
> > >
> > > [root@localhost ~]# smem -P virtiofsd-rs -P qemu
> > >   PID User     Command                         Swap      USS      PSS
> >   RSS
> > > 13879 root     ./target/debug/virtiofsd-rs        0    13412   337019
> >  662392
> > > 13947 root     qemu-system-x86_64 -enable-        0   434224   760096
> > 1094392
> > >
> > >  - If we terminate the virtiofsd-rs process, the output of "smem" now
> > >    shows that QEMU's PSS has grown to account for the PSS that was
> > >    previously assigned to virtiofsd-rs too, so we can confirm that was
> > >    memory shared between both processes.
> > >
> > >   PID User     Command                         Swap      USS      PSS
> >   RSS
> > > 13947 root     qemu-system-x86_64 -enable-        0  1082656  1084966
> > 1095692
> > >
> > > Just to be 100% sure, I've also run "heaptrack" on a virtiofsd-rs
> > > instance, and can confirm that the actual heap usage of the process
> > > was around 5-6 MiB.
> > >
> > > Sergio.
> >
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://listman.redhat.com/mailman/listinfo/virtio-fs
> >

--r2n5xwrcwu2pwxfj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmBaBwsACgkQ9GknjS8M
AjVsTw/9E/5A1hdddMLwK15zUnn+iLAKs/xLJdagbTQuT1Q28xWqdaZQrX0AWZhw
KQBx561WxrRROjHuoJfXKsd5hPfwLy8pviTi1CDHdI6b1Nbt1r5QJc6CM9BIH5k9
YTvid8p5Eno5CW7iC/J1OnPiaCG2EQMbJ3NwFl/ZSCVI5XyQL9hZjS6t0P3NKNtj
irVIDxww6WtjHX5jNz7tgSGllPfwl8jCuloMAYaCd9e7bVFa1bexjxN5sB5a3bGm
cfB3CPq1RTl28SdM6mqAfCzqgq6CYK9krWU4PMQFTTDpfIhWEmnYrFxy64F0h50r
sj1/QGoEZDSQaIUtskbEKjmE5Atk2vP3vhcO9pPy8348gSy1hXT+e0LfB2USuazi
T/ai3y3z3sRbX06dY0J2frgxVcF8bo5x5/C2KBDN8mibPE7WAz5t2cSFIMqnvDWm
KdA5irifAyM76cmLE86x00CIb91OlcG41/YgTHcDPfoITTWtEF3nENI+T79HmWhu
icm9KYKdZJlmqkbPBf9O/f27bZLKo443gjo59K41hbfWj4N2c9Zh1Wv8u8P7905U
lpbSNk87dZgLK31vixQExyt7ZsXOTuUX4tcSbl4Xe8fB1mUvC+2dtK5rEXLx9sBL
j/vdjmkdkmj59VX7Fa4HlnCVv4+3G72V59KGgOgxg1H/BexGZf0=
=igUp
-----END PGP SIGNATURE-----

--r2n5xwrcwu2pwxfj--

