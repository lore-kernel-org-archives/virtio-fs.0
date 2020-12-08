Date: Tue, 8 Dec 2020 09:16:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201208141608.GA3212@redhat.com>
References: <20201207183021.22752-1-vgoyal@redhat.com>
	<861a96f9-34fa-cd1f-4bbf-4a3506c9afa2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861a96f9-34fa-cd1f-4bbf-4a3506c9afa2@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/3] virtiofsd: Fix lo_flush() and
	inode->posix_lock init
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Tue, Dec 08, 2020 at 05:51:34AM +0100, Laszlo Ersek wrote:
> Hi Vivek,
> 
> On 12/07/20 19:30, Vivek Goyal wrote:
> > Laszlo is writing a virtiofs client for OVMF and noticed that if he
> > sends fuse FLUSH command for directory object, virtiofsd crashes.
> > virtiofsd does not expect a FLUSH arriving for a directory object.
> > 
> > This patch series has one of the patches which fixes that. It also
> > has couple of posix lock fixes as a result of lo_flush() related debugging.
> > 
> > Vivek Goyal (3):
> >   virtiofsd: Set up posix_lock hash table for root inode
> >   virtiofsd: Disable posix_lock hash table if remote locks are not
> >     enabled
> >   virtiofsd: Check file type in lo_flush()
> > 
> >  tools/virtiofsd/passthrough_ll.c | 54 +++++++++++++++++++++++---------
> >  1 file changed, 39 insertions(+), 15 deletions(-)
> > 
> 
> I put back the (wrong) FLUSH for the root dir into my code temporarily, to reproduce the crash (it does, with v5.2.0-rc4).
> 
> Then I applied your series [*], and retested.
> 
> [*] I'm unsure about the email you sent in response to 1/3, namely <https://lists.gnu.org/archive/html/qemu-devel/2020-12/msg01504.html>; I ignored that when applying the patches.

Hi Laszlo,

Thank you for the testing.

I reposed patch 1 to take care of coding style issues. Functionally both
the versions are same.

> 
> Indeed now I get a graceful -EBADF:
> 
> [13316825985314] [ID: 00000004] unique: 60, opcode: FLUSH (25), nodeid: 1, insize: 64, pid: 1
> [13316825993517] [ID: 00000004]    unique: 60, error: -9 (Bad file descriptor), outsize: 16
> 
> For whichever patch in the series my testing is relevant:
> 
> Tested-by: Laszlo Ersek <lersek@redhat.com>
> 
> (I'm having some difficulty figuring out which patch(es) should carry my T-b.
> 
> - I think I didn't really test patch#2 with the above, so that one should likely not get the T-b
> 
> - I think patch#3 is what I really tested.
> 
> - But, if that's the case, doesn't patch#3 make the fix in patch#1 untestable, in my scenario? I believe the code is no longer reached in lo_flush(), due to patch#3, where the change from patch#1 would matter. Patch#1 seems correct, and the last paragraph of its commit message relevant, but I think my testing currently only covered patch#3.
> 
> I'll let you decide where to apply my T-b.)

David Gilbert can add your Tested-by: while applying this patch series.
I think adding it to patch 3 makes most sense.

Thanks
Vivek

