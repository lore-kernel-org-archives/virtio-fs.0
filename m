Date: Thu, 18 Jul 2019 16:39:12 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190718233912.ukfrpykr77nne6e2@US-160370MP2.local>
References: <1562884542-72462-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190718181839.GA30636@redhat.com>
	<20190718185800.yu24umzaajo42aft@US-160370MP2.local>
	<20190718205110.GB30636@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190718205110.GB30636@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] Virtiofs: fix null pointer deference in
 directIO
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

On Thu, Jul 18, 2019 at 04:51:10PM -0400, Vivek Goyal wrote:
> On Thu, Jul 18, 2019 at 11:58:01AM -0700, Liu Bo wrote:
> > On Thu, Jul 18, 2019 at 02:18:39PM -0400, Vivek Goyal wrote:
> > > On Fri, Jul 12, 2019 at 06:35:42AM +0800, Liu Bo wrote:
> > > > Virtiofs has used memremap to create page structs for its managed m=
emory
> > > > and set pagemap's type to MEMORY_DEVICE_FS_DAX.  Thus, the page from
> > > > virtiofs's managed memory is a ZONE_DEVICE page, if %devmap_managed=
_key
> > > > was enabled by pmem drivers, put_page() will run into
> > > > __put_devmap_managed_page().  However, as page_free ops is not defi=
ned, it
> > > > ends up with a NULL pointer dereference.
> > > >=20
> > > > As virtiofs presents its managed memory range as a dax device, this=
 patch
> > > > makes virtiofs mimic how nvdimm/pmem.c setups pagemap fsdax.
> > > >=20
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >=20
> > > > [ 1223.732964] BUG: unable to handle kernel NULL pointer dereferenc=
e at 0000000000000000
> > > > [ 1223.733043] PGD 800000026bd91067 P4D 800000026bd91067 PUD 27631e=
067 PMD 0
> > > > [ 1223.733085] Oops: 0010 [#1] SMP PTI
> > > > [ 1223.733114] CPU: 1 PID: 16505 Comm: build Not tainted 4.19.48-df=
f9509 #1
> > > > [ 1223.733157] RIP: 0010:=A0 =A0 =A0 =A0 =A0 (null)
> > > > [ 1223.733179] Code: Bad RIP value.
> > > > ..
> > > > [ 1223.733671] Call Trace:
> > > > [ 1223.733704]=A0 fuse_release_user_pages+0xad/0xb0
> > > > [ 1223.733751]=A0 fuse_direct_io+0x3ec/0x6a0
> > > > [ 1223.733823]=A0 fuse_dax_direct_write+0x3c/0x70
> > > > [ 1223.733863]=A0 fuse_file_write_iter+0x2ea/0x4c0
> > > > [ 1223.733978]=A0 __vfs_write+0xde/0x160
> > > > [ 1223.734009]=A0 vfs_write+0xab/0x190
> > > > [ 1223.734061]=A0 ksys_write+0x45/0xc0
> > > > [ 1223.734094]=A0 do_syscall_64+0x6b/0x330
> > > > [ 1223.734214]=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > [ 1223.734261] RIP: 0033:0x15536bcddfd0
> > > >=20
> > > > The reproducer could be as simply as,
> > > >=20
> > > > addr =3D mmap(..., fileA, ...);
> > > > fdB =3D open(fileB, O_DIRECT);
> > > > write(fdB, addr);
> > > >=20
> > > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > >=20
> > > I am looking at this now and trying to understand it better. One prob=
lem
> > > I see is with page pinning. If a page is pinned, how do we make sure =
it
> > > is not evicted by reclaim logic. IIUC, right now memory range relciam
> > > logic is not aware about page pinning.
> > >=20
> > > For instance, in above example, write(fdB, addr) will pin pages in fi=
leA.
> > > While write is going on we need to make sure dax memory ranges coveri=
ng
> > > those pages are not reclaimed.
> >=20
> > Good question, it is indeed a problem, i_mmap_sem is not held by page
> > pinning so that dax range reclaim is free to go, nor page pinning in
> > within iomap_begin() and iomap_end() pair.
> >=20
> > While that is a problem, this patch is fixing a different one because
> > of the lack of ->page_free definition.
>=20
> Sure, but in the definition of ->page_free, you are calling
> "wake_up_var(page->_refcount)". This will make sense only if somebody
> is waiting on this.
>

Right, looks like we also need to follow this patch[1], but looks like
the fix for the whole problem is still WIP[2].

> I am checking xfs code and it seems to be waiting for this. We probably
> will have to modify virtio-fs to fix get_user_pages()/DMA races.
>=20
> So give me some time to go through and understand what xfs/dax/mm stack
> is doing for these races and try to fix it properly.=20

Right, I didn't realize the race with dax mapping reclaim.

So there're two things to fix,
a) the race between pinned entries/pages and fs fallocate/truncate.
b) the race between pinned entries/pages and dax ranges background reclaim.

In terms of a), page->_refcount can be used to avoid the race between
dma and dax.

a "dmap->refcnt--" is actually what we need to add for b) at ->page_free.


[1]: "mm, fs, dax: handle layout changes to pinned dax mappings"
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D5fac7408d828719db6d3fdba63e3c3726a6d1ee5

[2]: "mm: introduce put_user_page*(), placeholder versions"
https://patchwork.kernel.org/patch/10637929/

thanks,
-liubo

