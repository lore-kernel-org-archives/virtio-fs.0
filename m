DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=RPkgOjtgP3nI+LTyjK4xg2YWRT4LL2DYjNR7eYJgMGM=;
	b=Zjo46vQu4jZi8G7xsroS0mCbebLwFiIQXggd+CqTvEBEAzpyef/pRHSTtrPboEX4Yr
	q4rU7N2uqCV6fjfkF3noJd6q1WeBm/ZyarZUSaMg93B7aVLU/UUrqSVaVb719kB8+L2l
	kxIkggJ1jq4eyMaQmosYuv6AO+Z+6vQD/hd0o=
MIME-Version: 1.0
References: <20210823093107.okqkowakgwwwvvzv@mhamilton>
In-Reply-To: <20210823093107.okqkowakgwwwvvzv@mhamilton>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Tue, 24 Aug 2021 14:04:45 +0900
Message-ID: <CAJFHJroOBS=H+YkYNkvhgS3wz1N5juYRESBPzaJMGYQ1_e0QHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Sergio Lopez <slp@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, David Riley <davidriley@google.com>, Sergey Senozhatsky <senozhatsky@google.com>, Yu Zhao <yuzhao@google.com>

Hi Sergio,

On Mon, Aug 23, 2021 at 6:31 PM Sergio Lopez <slp@redhat.com> wrote:
>
> Hi,
>
> I've noticed that trying to use gdb/lldb on any binary residing on a
> DAX-enabled virtio-fs volume leads to a SIGSEGV in userspace...
>
> Seems like DAX breaks something in the ptrace_access_vm path. On a
> volume without DAX works fine.
>

We've seen this as well and unfortunately it doesn't appear to be
limited to virtio-fs.  Using DAX on a ext4 formatted virtio-pmem disk
image has the same problem.  We've actually disabled DAX everywhere
because of this.

Unfortunately most of the details are in an internal bug report but
I'll try to extract the relevant bits here.  This is well outside my
depth so I've CC'd some of the people who have looked at this.  The
initial bug report was for virtio-pmem+ext4 so some of the details are
specific to pmem but I suspect something similar is happening for
virtio-fs as well.

The issue is that process_vm_readv() corrupts the memory of files that
are mmap()'d when DAX is enabled.

1. A filesystem is mounted with DAX enabled.  pmem_attach_disk() sets
pfn_flags to PFN_DEV|PFN_MAP.  In the fuse case, this appears to
happen here [1].
2. When the (strace/gdb/etc) process does its initial read of the
mmap()'d region, the pfn flags for the page are inherited from the
pmem structure set to PFN_DEV|PFN_MAP in step 1.  During a call to
insert_pfn(), pte_mkdevmap is called to mark the pte as devmap.
3. If you follow the ftrace of the process_vm_readv(), it eventually
reaches do_wp_page(). If the target process had not previously read
the page in, this would not call do_wp_page() and instead just fault
in the page normally through the ext4/dax logic.
4. do_wp_page() calls vm_normal_page() which returns NULL due to the
remote pte being marked special and devmap (from above).  If we just
ignore the devmap check and return the page that has been found and
allow the normal copy to occur, then no problem occurs.  However, that
can't be safely done in normal dax cases.  Due to vm_normal_page()
returning NULL, wp_page_copy() is called (first call site) with a null
vmf->address.  If the mmap()d file is originally from a non-dax
filesystem (eg tmpfs), the second wp_page_copy() ends up being called
with a valid vmf->address.
5. cow_user_page() ends up in this unexpected case since
src==vmf->address is NULL, delimited with the following comment:

        /*
         * If the source page was a PFN mapping, we don't have
         * a "struct page" for it. We do a best-effort copy by
         * just copying from the original user address. If that
         * fails, we just zero-fill it. Live with it.
         */

The end effect of this is that there is the
__copy_from_user_inatomic() call with an invalid uaddr because the
uaddr is from the remote address space.   This results in another page
fault because that remote address isn't valid in the process calling
process_vm_readv().  It seems that there's a few issues here, a) that
it's trying to read from the remote address space as if it were local,
and b) that the failure here is corrupting the remote processes memory
and not just returning an empty page which would be less broken.

In the good case of the mmap()d file being from tmpfs,
src==vmf->address is non-NULL and copy_user_highpage can properly do
the copy of the page.  At that point, the caller is able to copy data
from that page to its own local buffer and return data successfully,
as well as avoid corrupting the remote process.

We've also found that reverting "17839856fd58: gup: document and work
around "COW can break either way" issue" seems to make the problem go
away.

Chirantan

[1]: https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux/+/d5ae8d7f85b7f6f6e60f1af8ff4be52b0926fde1/fs/fuse/virtio_fs.c#741

