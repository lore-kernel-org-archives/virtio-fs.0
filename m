Date: Tue, 17 Aug 2021 20:14:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRxQ9rClxWux/UHs@redhat.com>
References: <20210730150134.216126-10-mreitz@redhat.com>
	<YRF2xjwSKOiqB/Al@redhat.com>
	<df64553c-c03d-076a-bcef-bec8554977a4@redhat.com>
	<YRKZ415xrDtcYaQR@redhat.com>
	<4a74bbbd-92f6-a7d1-0c8d-fa8b121b9643@redhat.com>
	<YRKh/fbBntF+GfS8@redhat.com>
	<6e943ee0-dcb3-6812-3a0b-eb2b72b503ad@redhat.com>
	<YRrALRGy2cROwsP9@redhat.com>
	<89b416e7-c0ca-7831-da13-683e8a74b7ae@redhat.com>
	<YRwRz8aZGq6QLpx/@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YRwRz8aZGq6QLpx/@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 09/10] virtiofsd: Optionally fill
	lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Reitz <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

On Tue, Aug 17, 2021 at 03:45:19PM -0400, Vivek Goyal wrote:
> On Tue, Aug 17, 2021 at 10:27:16AM +0200, Hanna Reitz wrote:
> > On 16.08.21 21:44, Vivek Goyal wrote:
> > > On Wed, Aug 11, 2021 at 08:41:18AM +0200, Hanna Reitz wrote:
> > > 
> > > [..]
> > > > > > But given the inotify complications, there’s really a good reason we should
> > > > > > use mountinfo.
> > > > > > 
> > > > > > > > It’s a bit tricky because our sandboxing prevents easy access to mountinfo,
> > > > > > > > but if that’s the only way...
> > > > > > > yes. We already have lo->proc_self_fd. Maybe we need to keep
> > > > > > > /proc/self/mountinfo open in lo->proc_self_mountinfo. I am assuming
> > > > > > > that any mount table changes will still be visible despite the fact
> > > > > > > I have fd open (and don't have to open new fd to notice new mount/unmount
> > > > > > > changes).
> > > > > > Well, yes, that was my idea.  Unfortunately, I wasn’t quite successful yet;
> > > > > > when I tried keeping the fd open, reading from it would just return 0
> > > > > > bytes.  Perhaps that’s because we bind-mount /proc/self/fd to /proc so that
> > > > > > nothing else in /proc is visible. Perhaps we need to bind-mount
> > > > > > /proc/self/mountinfo into /proc/self/fd before that...
> > > > > Or perhaps open /proc/self/mountinfo and save fd in lo->proc_mountinfo
> > > > > before /proc/self/fd is bind mounted on /proc?
> > > > Yes, I tried that, and then reading would just return 0 bytes.
> > > Hi Hanna,
> > > 
> > > I tried this simple patch and I can read /proc/self/mountinfo before
> > > bind mounting /proc/self/fd and after bind mounting /proc/self/fd. Am
> > > I missing something.
> > 
> > Yes, but I tried reading it in the main loop (where we’d actually need it). 
> > It looks like the umount2(".", MNT_DETACH) in setup_mounts() breaks it.
> 
> Good point. I modified my code and notice too that after umoutn2() it
> always reads 0 bytes. I can understand that all the other mount points
> could go away but new rootfs mount point of virtiofsd should still be
> visible, IIUC. I don't understand why.
> 
> Anyway, I tried re-opening /proc/self/mountinfo file after umount2(".",
> MNT_DETACH), and that seems to work and it shows root mount point. I 
> created a bind mount and it shows that too.
> 
> So looks like quick fix can be that we re-open /proc/self/mountinfo. But
> that means we can't bind /proc/self/fd on /proc/. We could bind mount
> /proc/self on /proc. Not sure is it safe enough.

Or may be I can do this.

- Open O_PATH fd for /proc/self
  proc_self = open("/proc/self");
- Bind mount /proc/self/fd on /proc
- pivot_root() and umount() stuff
- Openat(proc_self, "mountinfo")
- close(proc_self)

If this works, then we don't have the security issue and we managed
to open mountinfo after pivot_root() and umount(). Will give it a
try and see if it works tomorrow.

Vivek

