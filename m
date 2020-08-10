DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=8FB9qBlcnnV7tNXkgg0cfLMfuoyQM+za2trKIURDDTQ=;
	b=qiqKtTbV0zFdDhubSofXDpDaKx/M0v422ibki3fNwhZrFXYn9o4oq0vUEgj4rmCF8p
	D2pJKhwNSNR6f8sEyRE5zP9N71FfdAUWNtUtM1+gkdiBblXKV2hE4j7UwqHB/A7OWvJ6
	cCmLzgqcmCG6zy9LOIktVigjXCrGRh8eUBpxw=
MIME-Version: 1.0
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<20200807195526.426056-19-vgoyal@redhat.com>
	<CAJfpegs1CtPMaVmbDc__N0Fc3FkNEe=vQOkrr8RKiiS6NqTyHA@mail.gmail.com>
	<20200810193717.GF455528@redhat.com>
In-Reply-To: <20200810193717.GF455528@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 10 Aug 2020 21:39:46 +0200
Message-ID: <CAJfpegsARKo+az+4Q98ecH3RMQinFT=QeMdte2=aZdvbz2WY1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-kernel@vger.kernel.org

On Mon, Aug 10, 2020 at 9:37 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Aug 10, 2020 at 10:29:13AM +0200, Miklos Szeredi wrote:
> > On Fri, Aug 7, 2020 at 9:55 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > fuse_file_put(sync) can be called with sync=true/false. If sync=true,
> > > it waits for release request response and then calls iput() in the
> > > caller's context. If sync=false, it does not wait for release request
> > > response, frees the fuse_file struct immediately and req->end function
> > > does the iput().
> > >
> > > iput() can be a problem with DAX if called in req->end context. If this
> > > is last reference to inode (VFS has let go its reference already), then
> > > iput() will clean DAX mappings as well and send REMOVEMAPPING requests
> > > and wait for completion. (All the the worker thread context which is
> > > processing fuse replies from daemon on the host).
> > >
> > > That means it blocks worker thread and it stops processing further
> > > replies and system deadlocks.
> >
> > Is this reasoning specific to DAX?  Seems to me this is a virtio-fs
> > specific issue.
>
> Hi Miklos,
>
> I am looking at this patch closely and maybe we don't need it, given
> current code.
>
> Reason being that looks like for virtiofs now we set ctx->destroy=true
> and that sets fc->destroy. And if that's set, we don't schedule async req
> in fuse_release_common();
>
> fuse_release_common() {
>   fuse_file_put(ff, ff->fc->destroy, isdir);
> }
>
> And if we don't schedule async file put, we don't run the risk of
> blocking worker thread in evict_inode() with DAX enabled.
>
> I ran blogbench multiple times with this patch reverted and I can't
> reproduce the deadlock.
>
> So we can drop this patch for now. If need be I will fix it as
> post merge patch.

Okay.  Yeah, I was thinking along the lines of no-async-release-ever
for virtiofs, but apparently that's already done.

Thanks,
Miklos

