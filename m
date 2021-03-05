DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=OCjB31jRrF5NsAhYCmtmSA4VIvxUrAeSy4dF2aX7weE=;
	b=sLqe1Pbih/jz/xyAuBvBPoFBsX
	Lqub8NbECl/fgrEO6t0p8MGw4E3LjqSvZr9JAECvlajv5y/Uo2kMqiwkQMD9wMqoUm5LdAL2/0+9W
	YAIvLJgUjywZYz8PZWHay/zlxE1hE78v82QKGq/6VbrIDwq/0Rvd6QgkjiG8wf86dbwR6/2lGnWsk
	ZNgu2d3QvoKVByDO9AODxqmXULSOnSD4t9XT5Fl65AClkz2JUzYurx86WwpGwpwrikgRar/swPShS
	A39YnSYDuiGwWrV5WHBIbEEylC9mV+KwbWlnYxxKRzGBJz+zVwZnJ4/IhLebDiHG3N4gaV/OSkHhS
	iuTL5m1jDcdUUOOc23ZV4myulZ8ZpYdD1nsYL/P2pGDkRw5/t2A6Lg4b6mcJIsbXVqsHVa37Ka1uG
	ksFQQH/IzYjpKrFWycZ1XViULV3wifpJ+gftrEeNrn4UlNmqjXHKh/593oAhcp1+gEKny7tLtqIbn
	4FG66iZLGLUYu2V0yOMDeGkm9lY9R0qwQuBQpEdz2Y+bK5syOlCFmdnj4Ix88flGk/WN4Wd7rwN6X
	v6vx9zkwB+37l8LEnByiWzwFEW0aijr1Uzc250bspwl7JG8q3630cucZQZ/c7J2XjgvD0j3RkwFKc
	YeUIo62xMLePakdih9RxwtNQbQzqhGiEQ44BEdmA8=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Fri, 05 Mar 2021 15:57:17 +0100
Message-ID: <32960057.KqypvAduHN@silver>
In-Reply-To: <YD+iPTKnOlF/HwlV@codewreck.org>
References: <20200918213436.GA3520@redhat.com> <1805660.C9YIKG4Ep7@silver>
	<YD+iPTKnOlF/HwlV@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] Can not set high msize with virtio-9p (Was: Re:
	virtiofs vs 9p performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Dominique Martinet <asmadeus@codewreck.org>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, v9fs-developer@lists.sourceforge.net, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Mittwoch, 3. M=E4rz 2021 15:50:37 CET Dominique Martinet wrote:
> Christian Schoenebeck wrote on Wed, Mar 03, 2021 at 03:04:21PM +0100:
> > > We can definitely increase the default, for all transports in my
> > > opinion.
> > > As a first step, 64 or 128k?
> >=20
> > Just to throw some numbers first; when linearly reading a 12 GB file on
> > guest (i.e. "time cat test.dat > /dev/null") on a test machine, these a=
re
> > the results that I get (cache=3Dmmap):
> >=20
> > msize=3D16k: 2min7s (95 MB/s)
> > msize=3D64k: 17s (706 MB/s)
> > msize=3D128k: 12s (1000 MB/s)
> > msize=3D256k: 8s (1500 MB/s)
> > msize=3D512k: 6.5s (1846 MB/s)
> >=20
> > Personally I would raise the default msize value at least to 128k.
>=20
> Thanks for the numbers.
> I'm still a bit worried about too large chunks, let's go with 128k for
> now -- I'll send a couple of patches increasing the tcp max/default as
> well next week-ish.

Ok, sounds good!

> > Personally I don't find raw I/O the worst performance issue right now. =
As
> > you can see from the numbers above, if 'msize' is raised and I/O being
> > performed with large chunk sizes (e.g. 'cat' automatically uses a chunk
> > size according to the iounit advertised by stat) then the I/O results a=
re
> > okay.
> >=20
> > What hurts IMO the most in practice is the sluggish behaviour regarding
> > dentries ATM. The following is with cache=3Dmmap (on guest side):
> >=20
> > $ time ls /etc/ > /dev/null
> > real    0m0.091s
> > user    0m0.000s
> > sys     0m0.044s
> > $ time ls -l /etc/ > /dev/null
> > real    0m0.259s
> > user    0m0.008s
> > sys     0m0.016s
> > $ ls -l /etc/ | wc -l
> > 113
> > $
>=20
> Yes, that is slow indeed.. Unfortunately cache=3Dnone/mmap means only open
> dentries are pinned, so that means a load of requests everytime.
>=20
> I was going to suggest something like readdirplus or prefetching
> directory entries attributes in parallel/background, but since we're not
> keeping any entries around we can't even do that in that mode.
>=20
> > With cache=3Dloose there is some improvement; on the first "ls" run (wh=
en
> > its
> > not in the dentry cache I assume) the results are similar. The subseque=
nt
> > runs then improve to around 50ms for "ls" and around 70ms for "ls -l".
> > But that's still far from numbers I would expect.
>=20
> I'm surprised cached mode is that slow though, that is worth
> investigating.
> With that time range we are definitely sending more requests to the
> server than I would expect for cache=3Dloose, some stat revalidation
> perhaps? I thought there wasn't any.

Yes, it looks like more 9p requests are sent than actually required for=20
readdir. But I haven't checked yet what's going on there in detail. That's =

definitely on my todo list, because this readdir/stat/direntry issue ATM=20
really hurts the most IMO.

> I don't like cache=3Dloose/fscache right now as the reclaim mechanism
> doesn't work well as far as I'm aware (I've heard reports of 9p memory
> usage growing ad nauseam in these modes), so while it's fine for
> short-lived VMs it can't really be used for long periods of time as
> is... That's been on my todo for a while too, but unfortunately no time
> for that.

Ok, that's new to me. But I fear the opposite is currently worse; with=20
cache=3Dmmap and running a VM for a longer time: 9p requests get slower and=
=20
slower, e.g. at a certain point you're waiting like 20s for one request. I =

haven't investigated the cause here either yet. It may very well be an issu=
e=20
on QEMU side: I have some doubts in the fid reclaim algorithm on 9p server =

side which is using just a linked list. Maybe that list is growing to=20
ridiculous sizes and searching the list with O(n) starts to hurt after a=20
while.

With cache=3Dloose I don't see such tremendous slowdowns even on long runs,=
=20
which might indicate that this symptom might indeed be due to a problem on =

QEMU side.

> Ideally if that gets fixed, it really should be the default with some
> sort of cache revalidation like NFS does (if that hasn't changed, inode
> stats have a lifetime after which they get revalidated on access, and
> directory ctime changes lead to a fresh readdir) ; but we can't really
> do that right now if it "leaks".
>=20
> Some cap to the number of open fids could be appreciable as well
> perhaps, to spare server resources and keep internal lists short.

I just reviewed the fid reclaim code on 9p servers side to some extent beca=
use=20
of a security issue on 9p server side in this area recently, but I haven't =

really thought through nor captured the authors' original ideas behind it=20
entirely yet. I still have some question marks here. Maybe Greg feels the=20
same.

Probably when support for macOS is added (also on my todo list), then the=20
amount of open fids needs to be limited anyway. Because macOS is much more =

conservative and does not allow a large number of open files by default.

> Anyway, there definitely is room for improvement; if you need ideas I
> have plenty but my time is more than limited right now and for the
> forseeable future... 9p work is purely on my freetime and there isn't
> much at the moment :(
>=20
> I'll make time as necessary for reviews & tests but that's about as much
> as I can promise, sorry and good luck!

I fear that applies to all developers right now. To my knowledge there is n=
ot=20
a single developer either paid and/or able to spend reasonable large time=20
slices on 9p issues.

>From my side: my plans are to hunt down the worst 9p performance issues in=
=20
order of their impact, but like anybody else, when I find some free time=20
slices for that.

#patience #optimistic

Best regards,
Christian Schoenebeck



