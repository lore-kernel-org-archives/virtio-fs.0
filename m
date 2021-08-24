Date: Tue, 24 Aug 2021 19:27:59 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
Message-ID: <YSWAfxlvYtaSy7X/@redhat.com>
References: <20210823093107.okqkowakgwwwvvzv@mhamilton>
	<CAJFHJroOBS=H+YkYNkvhgS3wz1N5juYRESBPzaJMGYQ1_e0QHg@mail.gmail.com>
	<20210824132223.7ujg7joxq2pwu5jo@mhamilton>
	<CAOUHufaD+AC+L0j9PZnTM_SJMd_4KSzKq4hJfthK6M861QnCBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOUHufaD+AC+L0j9PZnTM_SJMd_4KSzKq4hJfthK6M861QnCBQ@mail.gmail.com>
Subject: Re: [Virtio-fs] Problem using gdb/lldb on a binary residing on a
 DAX-enabled volume
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Yu Zhao <yuzhao@google.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, David Riley <davidriley@google.com>, Sergey Senozhatsky <senozhatsky@google.com>

Hello everyone,

On Tue, Aug 24, 2021 at 12:09:37PM -0600, Yu Zhao wrote:
> On Tue, Aug 24, 2021 at 7:22 AM Sergio Lopez <slp@redhat.com> wrote:
> >
> > On Tue, Aug 24, 2021 at 02:04:45PM +0900, Chirantan Ekbote wrote:
> > > Hi Sergio,
> > >
> > > On Mon, Aug 23, 2021 at 6:31 PM Sergio Lopez <slp@redhat.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > I've noticed that trying to use gdb/lldb on any binary residing on a
> > > > DAX-enabled virtio-fs volume leads to a SIGSEGV in userspace...
> > > >
> > > > Seems like DAX breaks something in the ptrace_access_vm path. On a
> > > > volume without DAX works fine.
> > > >
> > >
> > > We've seen this as well and unfortunately it doesn't appear to be
> > > limited to virtio-fs.  Using DAX on a ext4 formatted virtio-pmem disk
> > > image has the same problem.  We've actually disabled DAX everywhere
> > > because of this.
> > >
> > > Unfortunately most of the details are in an internal bug report but
> > > I'll try to extract the relevant bits here.  This is well outside my
> > > depth so I've CC'd some of the people who have looked at this.  The
> > > initial bug report was for virtio-pmem+ext4 so some of the details are
> > > specific to pmem but I suspect something similar is happening for
> > > virtio-fs as well.
> > >
> > > The issue is that process_vm_readv() corrupts the memory of files that
> > > are mmap()'d when DAX is enabled.
> > >
> > > 1. A filesystem is mounted with DAX enabled.  pmem_attach_disk() sets
> > > pfn_flags to PFN_DEV|PFN_MAP.  In the fuse case, this appears to
> > > happen here [1].
> > > 2. When the (strace/gdb/etc) process does its initial read of the
> > > mmap()'d region, the pfn flags for the page are inherited from the
> > > pmem structure set to PFN_DEV|PFN_MAP in step 1.  During a call to
> > > insert_pfn(), pte_mkdevmap is called to mark the pte as devmap.
> > > 3. If you follow the ftrace of the process_vm_readv(), it eventually
> > > reaches do_wp_page(). If the target process had not previously read
> > > the page in, this would not call do_wp_page() and instead just fault
> > > in the page normally through the ext4/dax logic.
> > > 4. do_wp_page() calls vm_normal_page() which returns NULL due to the
> > > remote pte being marked special and devmap (from above).  If we just
> > > ignore the devmap check and return the page that has been found and
> > > allow the normal copy to occur, then no problem occurs.  However, that
> > > can't be safely done in normal dax cases.  Due to vm_normal_page()
> > > returning NULL, wp_page_copy() is called (first call site) with a null
> > > vmf->address.  If the mmap()d file is originally from a non-dax
> > > filesystem (eg tmpfs), the second wp_page_copy() ends up being called
> > > with a valid vmf->address.
> > > 5. cow_user_page() ends up in this unexpected case since
> > > src==vmf->address is NULL, delimited with the following comment:
> > >
> > >         /*
> > >          * If the source page was a PFN mapping, we don't have
> > >          * a "struct page" for it. We do a best-effort copy by
> > >          * just copying from the original user address. If that
> > >          * fails, we just zero-fill it. Live with it.
> > >          */
> > >
> > > The end effect of this is that there is the
> > > __copy_from_user_inatomic() call with an invalid uaddr because the
> > > uaddr is from the remote address space.   This results in another page
> > > fault because that remote address isn't valid in the process calling
> > > process_vm_readv().  It seems that there's a few issues here, a) that
> > > it's trying to read from the remote address space as if it were local,
> > > and b) that the failure here is corrupting the remote processes memory
> > > and not just returning an empty page which would be less broken.
> > >
> > > In the good case of the mmap()d file being from tmpfs,
> > > src==vmf->address is non-NULL and copy_user_highpage can properly do
> > > the copy of the page.  At that point, the caller is able to copy data
> > > from that page to its own local buffer and return data successfully,
> > > as well as avoid corrupting the remote process.
> > >
> > > We've also found that reverting "17839856fd58: gup: document and work
> > > around "COW can break either way" issue" seems to make the problem go
> > > away.
> >
> > Thanks a lot for the super-detailed write-up. Do you know if someone
> > is already working on a fix that can be upstreamed?

Hmm, it appears you're not actually using latest upstream, if you were, you
couldn't backout 178 clean.

If you were to use latest upstream, I suppose your problem would be
already solved, however upstream cannot be backported to production
because upstream reopened CVE-2020-29374 with a slightly modified
reproducer:

https://github.com/aagit/kernel-testcases-for-v5.11/blob/main/vmsplice-v5.11.c

Upstream if backported would also cause all kind of ABI breaks to
clear_refs (obvious ones like RDMA being disabled from clear_refs
tracking, see 9348b73c2e1bfea74ccd4a44fb4ccc7276ab9623) but also some
that won't require any RDMA device like this ABI regression:

https://github.com/aagit/kernel-testcases-for-v5.11/blob/main/page_count_do_wp_page.c

Upstream also triggers false positive COWs after a swapin followed by
a memory write, if there's still a swapcache pin on the anon memory as
an example of how inaccurate it become.

So production has to stick to 178 since breaking ptrace on pmem is
preferable than dealing with the above fallout.

Note that 178 has other defect not just ptrace on pmem, it breaks KSM
density and it also broke uffd-wp (which I have to assume isn't
included yet in your current kernel version, so that shouldn't be a
concern).

> Hi Sergio,
> 
> I cc'ed Andrea from RH -- he might have a fix queued in his tree.

That's right thanks for the CC.

17839856fd58 was in the right direction because the only bug there
was, was in GUP and so it's correct to fix it in GUP itself.

To resolve the defect of 17839856fd58, whenever a GUP pin is being
taken for reading on a shared page with mapcount elevated, the
mapcount unshare logic triggers a new fault called COR fault, which
copies the page. Once done it leaves the pagetables like if a read
fault happened. That resolves all defects caused by 17839856fd58 which
instead acted as a write fault despite it was a GUP "read" access.

The patchset continues and leverages the COR fault to add full MM
coherency by the POSIX specs to FOLL_LONGTERM GUP pins no matter which
vma type. It's now as coherent as the long term pin was under the MMU
notifier it was impossible to achieve without the COR fault.

https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/commit/?h=mapcount_deshare&id=9f2f36029b5c8d4b3390c93e90a3b9254b7ec730

If you're curious to test it, this is the latest version:

https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/log/?h=mapcount_deshare

I notice the branch is already super old, I didn't rebase it since mid
Jun sorry... There's also a v5.10-LTS -stable version. I'll rebase it
again soon as time permits.

Thanks,
Andrea

