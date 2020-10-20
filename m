DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=QNX6vawmxeW1fAbRAA5ngvhksjFJTlORwG0F7fk9LSw=;
	b=mXgtxn5H20doMXCJZe2YGsH/flIr+T6EfSsNvIa1LzgW7xz5VJ5v0h2QhoedxcBUyF
	mbcMOJpuqZVZyrvFf61ph0pABnr0JkB40sscjjjum8APkY0U9LqCeAxxWniCL2tWVZXJ
	H7X0cWg6WWZ5ughaKembxJc29cTwoyVqudhWo=
MIME-Version: 1.0
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-3-mreitz@redhat.com>
	<20200911102459.GC94280@stefanha-x1.localdomain>
	<CAJfpegvxmx995QihR+=bOcyWy0pGmxFtAJhzvw7O2k9rq9r5zA@mail.gmail.com>
	<a75efdcf-834c-8515-b3b7-87d4f63c888c@redhat.com>
In-Reply-To: <a75efdcf-834c-8515-b3b7-87d4f63c888c@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Oct 2020 14:19:34 +0200
Message-ID: <CAJfpegueOhs0PwtTdF7dRU3zpH0mZqp2kT3xNu-3DrdptAcTiw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [fuse-devel] [PATCH 2/9] fuse: Add
	FUSE_ATTR_SUBMOUNT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, fuse-devel <fuse-devel@lists.sourceforge.net>

On Mon, Sep 14, 2020 at 2:29 PM Max Reitz <mreitz@redhat.com> wrote:
>
> On 11.09.20 13:07, Miklos Szeredi wrote:
> > On Fri, Sep 11, 2020 at 12:25 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >>
> >> On Wed, Sep 09, 2020 at 08:45:56PM +0200, Max Reitz wrote:
> >>> This is a flag for fuse_attr.flags that indicates that the given entry
> >>> resides on a different filesystem than the parent, and as such should
> >>> have a different st_dev.
> >>>
> >>> Signed-off-by: Max Reitz <mreitz@redhat.com>
> >>> ---
> >>>  include/uapi/linux/fuse.h | 7 +++++++
> >>>  1 file changed, 7 insertions(+)
> >>>
> >>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> >>> index de94c11cfc3b..c034cdf8f5f4 100644
> >>> --- a/include/uapi/linux/fuse.h
> >>> +++ b/include/uapi/linux/fuse.h
> >>> @@ -417,6 +417,13 @@ struct fuse_file_lock {
> >>>   */
> >>>  #define FUSE_FSYNC_FDATASYNC (1 << 0)
> >>>
> >>> +/**
> >>> + * fuse_attr flags
> >>> + *
> >>> + * FUSE_ATTR_SUBMOUNT: File/directory is a submount point
> >>> + */
> >>> +#define FUSE_ATTR_SUBMOUNT      (1 << 0)
> >>
> >> If you respin, please add a little more detail here. How should clients
> >
> > I'm just reviewing/queuing this, so no need to respin.
> >
> >> act when this flag is detected (which FUSE messages should they send to
> >> deal with submounts)?
> >
> > Actually, no new messages, since the reply containing
> > FUSE_ATTR_SUBMOUNT already refers to the submount root.  I'll fix the
> > description.
>
> Perhaps it’s still useful to note how this flag is supposed to be
> handled; i.e. that it’s a hint to the kernel to create an auto-mounted
> submount.
>
> > And since there's no separate information for the actual mount point
> > (userspace can't obtain it) AT_NO_AUTOMOUNT users become confused due
> > to the dummy mountpoint becoming visible with all the wrong data.
> > Maybe the fix is to force automount even with AT_NO_AUTOMOUNT.  Will
> > look into that.
>
> If that’s possible...  Though Dave did mention that it seems intentional
> that auto-mounts aren’t mounted on stat, so as not to overwhelm the
> system on a plain ls call.

Oh, this is subtle.   Big automount maps (like a automounted home
directory on a muti-user server) definitely don't want automounts on
an ls.  Static mounts being exported to virtiofs probably won't result
in an automount storm, but would benefit from find being less broken.

If on the other hand virtiofs is re-exporting a big automount map,
then it would make sense to inherit this behavior.  But at this stage
that's just overdesign.

For now let's just see how the current no-automount behavior works in real life.

Thanks,
Miklos


