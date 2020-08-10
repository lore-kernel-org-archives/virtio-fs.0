Date: Mon, 10 Aug 2020 11:48:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200810154830.GC455528@redhat.com>
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<20200807195526.426056-19-vgoyal@redhat.com>
	<CAJfpegs1CtPMaVmbDc__N0Fc3FkNEe=vQOkrr8RKiiS6NqTyHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs1CtPMaVmbDc__N0Fc3FkNEe=vQOkrr8RKiiS6NqTyHA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 18/20] fuse: Release file in process
	context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-kernel@vger.kernel.org

On Mon, Aug 10, 2020 at 10:29:13AM +0200, Miklos Szeredi wrote:
> On Fri, Aug 7, 2020 at 9:55 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > fuse_file_put(sync) can be called with sync=true/false. If sync=true,
> > it waits for release request response and then calls iput() in the
> > caller's context. If sync=false, it does not wait for release request
> > response, frees the fuse_file struct immediately and req->end function
> > does the iput().
> >
> > iput() can be a problem with DAX if called in req->end context. If this
> > is last reference to inode (VFS has let go its reference already), then
> > iput() will clean DAX mappings as well and send REMOVEMAPPING requests
> > and wait for completion. (All the the worker thread context which is
> > processing fuse replies from daemon on the host).
> >
> > That means it blocks worker thread and it stops processing further
> > replies and system deadlocks.
> 
> Is this reasoning specific to DAX?  Seems to me this is a virtio-fs
> specific issue.

I would think it is virtio-fs + DAX issues. virtio-fs without DAX does
not have this problem.

If making this conditional on DAX an issue, I am wondering, can
we now set args->may_block instead. Now virtiofs will do completion
in a separate worker thread if ->may_block is set. That means, 
worker will block till REMOVEMAPPING completes and then be woken
up.

Do let me know if you like setting args->may_block approach better.
I can give that a try.

Vivek

