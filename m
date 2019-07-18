Date: Thu, 18 Jul 2019 16:51:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190718205110.GB30636@redhat.com>
References: <1562884542-72462-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190718181839.GA30636@redhat.com>
	<20190718185800.yu24umzaajo42aft@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190718185800.yu24umzaajo42aft@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH] Virtiofs: fix null pointer deference in
 directIO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Thu, Jul 18, 2019 at 11:58:01AM -0700, Liu Bo wrote:
> On Thu, Jul 18, 2019 at 02:18:39PM -0400, Vivek Goyal wrote:
> > On Fri, Jul 12, 2019 at 06:35:42AM +0800, Liu Bo wrote:
> > > Virtiofs has used memremap to create page structs for its managed mem=
ory
> > > and set pagemap's type to MEMORY_DEVICE_FS_DAX.  Thus, the page from
> > > virtiofs's managed memory is a ZONE_DEVICE page, if %devmap_managed_k=
ey
> > > was enabled by pmem drivers, put_page() will run into
> > > __put_devmap_managed_page().  However, as page_free ops is not define=
d, it
> > > ends up with a NULL pointer dereference.
> > >=20
> > > As virtiofs presents its managed memory range as a dax device, this p=
atch
> > > makes virtiofs mimic how nvdimm/pmem.c setups pagemap fsdax.
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > [ 1223.732964] BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000000
> > > [ 1223.733043] PGD 800000026bd91067 P4D 800000026bd91067 PUD 27631e06=
7 PMD 0
> > > [ 1223.733085] Oops: 0010 [#1] SMP PTI
> > > [ 1223.733114] CPU: 1 PID: 16505 Comm: build Not tainted 4.19.48-dff9=
509 #1
> > > [ 1223.733157] RIP: 0010:=A0 =A0 =A0 =A0 =A0 (null)
> > > [ 1223.733179] Code: Bad RIP value.
> > > ..
> > > [ 1223.733671] Call Trace:
> > > [ 1223.733704]=A0 fuse_release_user_pages+0xad/0xb0
> > > [ 1223.733751]=A0 fuse_direct_io+0x3ec/0x6a0
> > > [ 1223.733823]=A0 fuse_dax_direct_write+0x3c/0x70
> > > [ 1223.733863]=A0 fuse_file_write_iter+0x2ea/0x4c0
> > > [ 1223.733978]=A0 __vfs_write+0xde/0x160
> > > [ 1223.734009]=A0 vfs_write+0xab/0x190
> > > [ 1223.734061]=A0 ksys_write+0x45/0xc0
> > > [ 1223.734094]=A0 do_syscall_64+0x6b/0x330
> > > [ 1223.734214]=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > [ 1223.734261] RIP: 0033:0x15536bcddfd0
> > >=20
> > > The reproducer could be as simply as,
> > >=20
> > > addr =3D mmap(..., fileA, ...);
> > > fdB =3D open(fileB, O_DIRECT);
> > > write(fdB, addr);
> > >=20
> > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> >=20
> > I am looking at this now and trying to understand it better. One problem
> > I see is with page pinning. If a page is pinned, how do we make sure it
> > is not evicted by reclaim logic. IIUC, right now memory range relciam
> > logic is not aware about page pinning.
> >=20
> > For instance, in above example, write(fdB, addr) will pin pages in file=
A.
> > While write is going on we need to make sure dax memory ranges covering
> > those pages are not reclaimed.
>=20
> Good question, it is indeed a problem, i_mmap_sem is not held by page
> pinning so that dax range reclaim is free to go, nor page pinning in
> within iomap_begin() and iomap_end() pair.
>=20
> While that is a problem, this patch is fixing a different one because
> of the lack of ->page_free definition.

Sure, but in the definition of ->page_free, you are calling
"wake_up_var(page->_refcount)". This will make sense only if somebody
is waiting on this.

I am checking xfs code and it seems to be waiting for this. We probably
will have to modify virtio-fs to fix get_user_pages()/DMA races.

So give me some time to go through and understand what xfs/dax/mm stack
is doing for these races and try to fix it properly.=20

Thanks
Vivek

