Date: Tue, 24 Mar 2020 03:12:17 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20200323191217.lh7kl7lhfsedbeya@rsjd01523.et2sqa>
References: <cb5bc383-a669-ebaa-3919-a5f860e10a52@redhat.com>
	<20200323184022.6uzdg2twl3ntwhdg@rsjd01523.et2sqa>
MIME-Version: 1.0
In-Reply-To: <20200323184022.6uzdg2twl3ntwhdg@rsjd01523.et2sqa>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] xfstest generic/503 hangs
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, Mar 24, 2020 at 02:40:23AM +0800, Liu Bo wrote:
> On Mon, Mar 23, 2020 at 07:18:57PM +0100, Max Reitz wrote:
> > Hi,
> > 
> > I have this bug report here:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1813885
> > 
> > And I’m afraid I’m not really making progress on debugging it, so I was
> > wondering whether any of you might have some insights.
> > 
> > The problem is that the generic/503 xfstest hangs on virtio-fs.  Now, I
> > don’t know how the reporter got that test to run in the first place,
> > because for me, it requires fcollapse and fzero, which as far as I can
> > tell are currently not supported for virtio-fs.
> > 
> > So I first had to disable those requirements, and then let the helper
> > program (src/t_mmap_collision.c) not test those operations.
> > 
> > Then, the test hangs.  What I could find out so far is that the hang
> > occurs in src/t_mmap_collision.c’s truncate_down_fn() (run through
> > run_test(&truncate_down_fn), namely in one of the pread()s.  I can also
> > see that some of the pread()s before fail with EFAULT.
> > 
> > A bit more context: t_mmap_collision.c opens a test file twice (I think
> > the idea is that you open it once on an FS with DAX, and once without,
> > but AFAIU it should work either way).  For the relevant test, it mmap()s
> > the DAX FD, truncates it, then fallocates it to increase the size again.
> >  Then it reads from the non-DAX FD.
> > 
> > It does all of that in two threads simultaneously for a second.
> > 
> > The EFAULT seems to come from the guest kernel.  I don’t see virtiofsd
> > returning an error anywhere.  I don’t know where it comes from exactly,
> > only that when I replace all occurrences of “EFAULT” by e.g. “EBADSLT”
> > in mm/, the test crashes instead of hanging, so I take that to mean that
> > the error comes from something in mm/ (which I suppose isn’t too
> > unexpected).
> > 
> > The test passes if running the test function in a single thread instead
> > of two, or if you use a separate TEST_DEV and SCRATCH_DEV – but in the
> > latter case, you really have two separate files, so the test becomes
> > rather moot (AFAIU).
> > 
> > The fact that truncate_down_fn() uses fallocate() seems irrelevant.
> > When you replace it by ftruncate() (i.e. the dax_fd is just first
> > truncated to 0, and then truncated back to @file_size), the test fails
> > in the same way.  So maybe there is some interaction between the
> > ftruncate() and a concurrent pread()?  But where does the EFAULT come from?
> > 
> > Does anyone have any spontaneous ideas? :/
> >
> 
> When it comes to "hang", I guess it's a similar problem of guest dax
> reading while host truncates the file, this can be verify by the hang
> stack, did it hang at dax_iomap_actor() -> dax_copy_to_iter()?
> 
> I think we did use fuse_break_layout() to avoid pinned blocks being
> truncated underneath in this kind of mmap problems, but seems it
> doesn't work as expected.

I spoke too quickly, the stack in bz is not about dax hang I described above.

thanks,
-liubo


