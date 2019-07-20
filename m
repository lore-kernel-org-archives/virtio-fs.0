Date: Fri, 19 Jul 2019 19:34:55 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190720023455.vw3ptwrma45l72jq@US-160370MP2.local>
References: <1562884542-72462-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190718181839.GA30636@redhat.com>
	<20190718185800.yu24umzaajo42aft@US-160370MP2.local>
	<20190718205110.GB30636@redhat.com>
	<20190718233912.ukfrpykr77nne6e2@US-160370MP2.local>
	<20190719195130.GC13636@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190719195130.GC13636@redhat.com>
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

On Fri, Jul 19, 2019 at 03:51:30PM -0400, Vivek Goyal wrote:
> On Thu, Jul 18, 2019 at 04:39:12PM -0700, Liu Bo wrote:
> > On Thu, Jul 18, 2019 at 04:51:10PM -0400, Vivek Goyal wrote:
> > > On Thu, Jul 18, 2019 at 11:58:01AM -0700, Liu Bo wrote:
> > > > On Thu, Jul 18, 2019 at 02:18:39PM -0400, Vivek Goyal wrote:
> > > > > On Fri, Jul 12, 2019 at 06:35:42AM +0800, Liu Bo wrote:
> > > > > > Virtiofs has used memremap to create page structs for its manag=
ed memory
> > > > > > and set pagemap's type to MEMORY_DEVICE_FS_DAX.  Thus, the page=
 from
> > > > > > virtiofs's managed memory is a ZONE_DEVICE page, if %devmap_man=
aged_key
> > > > > > was enabled by pmem drivers, put_page() will run into
> > > > > > __put_devmap_managed_page().  However, as page_free ops is not =
defined, it
> > > > > > ends up with a NULL pointer dereference.
> > > > > >=20
> > > > > > As virtiofs presents its managed memory range as a dax device, =
this patch
> > > > > > makes virtiofs mimic how nvdimm/pmem.c setups pagemap fsdax.
> > > > > >=20
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > >=20
> > > > > > [ 1223.732964] BUG: unable to handle kernel NULL pointer derefe=
rence at 0000000000000000
> > > > > > [ 1223.733043] PGD 800000026bd91067 P4D 800000026bd91067 PUD 27=
631e067 PMD 0
> > > > > > [ 1223.733085] Oops: 0010 [#1] SMP PTI
> > > > > > [ 1223.733114] CPU: 1 PID: 16505 Comm: build Not tainted 4.19.4=
8-dff9509 #1
> > > > > > [ 1223.733157] RIP: 0010:=A0 =A0 =A0 =A0 =A0 (null)
> > > > > > [ 1223.733179] Code: Bad RIP value.
> > > > > > ..
> > > > > > [ 1223.733671] Call Trace:
> > > > > > [ 1223.733704]=A0 fuse_release_user_pages+0xad/0xb0
> > > > > > [ 1223.733751]=A0 fuse_direct_io+0x3ec/0x6a0
> > > > > > [ 1223.733823]=A0 fuse_dax_direct_write+0x3c/0x70
> > > > > > [ 1223.733863]=A0 fuse_file_write_iter+0x2ea/0x4c0
> > > > > > [ 1223.733978]=A0 __vfs_write+0xde/0x160
> > > > > > [ 1223.734009]=A0 vfs_write+0xab/0x190
> > > > > > [ 1223.734061]=A0 ksys_write+0x45/0xc0
> > > > > > [ 1223.734094]=A0 do_syscall_64+0x6b/0x330
> > > > > > [ 1223.734214]=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > > [ 1223.734261] RIP: 0033:0x15536bcddfd0
> > > > > >=20
> > > > > > The reproducer could be as simply as,
> > > > > >=20
> > > > > > addr =3D mmap(..., fileA, ...);
> > > > > > fdB =3D open(fileB, O_DIRECT);
> > > > > > write(fdB, addr);
> > > > > >=20
> > > > > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > > > >=20
> > > > > I am looking at this now and trying to understand it better. One =
problem
> > > > > I see is with page pinning. If a page is pinned, how do we make s=
ure it
> > > > > is not evicted by reclaim logic. IIUC, right now memory range rel=
ciam
> > > > > logic is not aware about page pinning.
> > > > >=20
> > > > > For instance, in above example, write(fdB, addr) will pin pages i=
n fileA.
> > > > > While write is going on we need to make sure dax memory ranges co=
vering
> > > > > those pages are not reclaimed.
> > > >=20
> > > > Good question, it is indeed a problem, i_mmap_sem is not held by pa=
ge
> > > > pinning so that dax range reclaim is free to go, nor page pinning in
> > > > within iomap_begin() and iomap_end() pair.
> > > >=20
> > > > While that is a problem, this patch is fixing a different one becau=
se
> > > > of the lack of ->page_free definition.
> > >=20
> > > Sure, but in the definition of ->page_free, you are calling
> > > "wake_up_var(page->_refcount)". This will make sense only if somebody
> > > is waiting on this.
> > >
> >=20
> > Right, looks like we also need to follow this patch[1], but looks like
> > the fix for the whole problem is still WIP[2].
> >=20
> > > I am checking xfs code and it seems to be waiting for this. We probab=
ly
> > > will have to modify virtio-fs to fix get_user_pages()/DMA races.
> > >=20
> > > So give me some time to go through and understand what xfs/dax/mm sta=
ck
> > > is doing for these races and try to fix it properly.=20
> >=20
> > Right, I didn't realize the race with dax mapping reclaim.
> >=20
> > So there're two things to fix,
> > a) the race between pinned entries/pages and fs fallocate/truncate.
> > b) the race between pinned entries/pages and dax ranges background recl=
aim.
>=20
> Right.
>=20
> I think we can take care of both the races by calling
> dax_layout_busy_page() in path a) and path b)?
>

I think so, that's what we have for now.

> >=20
> > In terms of a), page->_refcount can be used to avoid the race between
> > dma and dax.
> >=20
> > a "dmap->refcnt--" is actually what we need to add for b) at ->page_fre=
e.
>=20
> I am not seeing any callback where we can increment dmap->refcnt. That
> probably means we will have to reply on calling dax_layout_busy_page()
> in reclaim path. This is expected to be called with inode lock held.
>=20
> I am thinking of following sequence.
>=20
> 1. inode_trylock(inode)
> 2. Take i_mmap_sem
> 3. call dax_layout_busy_page() to make sure no pages on this inode are id=
le.
> 4. Take i_dmap_sem
> 5. Reclaim range

I realized that callers of dax_layout_busy_page() only need to block
any new mapping creation, which means a down_read(&i_mmap_sem) is
enough for the protection.

If dax_layout_busy_page() returns any pinned entry, we can skip the
reclaim.

Although dax_layout_busy_page() does unmap_mapping_range() to
disassociate the dax pfn and its mapped pte, next time when the pte is
walked by mmu, it will refault in the dax pfn.

The whole assumption of using dax_layout_busy_page() is that pinned memory
will be released very soon, I think it's also matching our virtiofs case,
e.g. a direct IO.

thanks,
-liubo
>=20
> This means that we can't drop inode lock in range reclaim path as your
> dmap refcount patches are currently doing.
>=20
> This probably means that range reclaim might get enen more slower. I=20
> am thinking that once we get hold of a inode lock and have been
> able to do dax_layout_busy_page(), we should reclaim multiple ranges
> from same inode (using one FUSE_REMOVEMAPPING()) command, instead
> of freeing one range at a time.
>=20
> And that might provide some speed up with range reclaim.
>=20
> /me is not 100% sure yet if we need to keep inode lock held when we=20
> call dax_layout_busy_page(). As of now truncate/punch_hole seems
> to hold it. Also we are waiting for pages to become idle, so it
> kind of makes sense to not start more read/writes while we are
> waiting for pages to become idle.
>=20
> Thanks
> Vivek
>=20
> >=20
> >=20
> > [1]: "mm, fs, dax: handle layout changes to pinned dax mappings"
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D5fac7408d828719db6d3fdba63e3c3726a6d1ee5
> >=20
> > [2]: "mm: introduce put_user_page*(), placeholder versions"
> > https://patchwork.kernel.org/patch/10637929/
> >=20
> > thanks,
> > -liubo

