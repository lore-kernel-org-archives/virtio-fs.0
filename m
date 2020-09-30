DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=T1aa/+Iyk5V9x9EGc/B3ToDnogl7jgNiyHzotNGV3ew=;
	b=ZdSDHne7Q0M8HvyMu6+o4cguPWzzhen9CQx4Guc14IMEkK142ZpIJEgIW8QgBeyLBp
	zZvPO4elsyEIKzvbjNzyxhyhR1qCm+0dWk4mcZoeltAz1wzgJ5x+dt7sqxWNjJ4Qf/Fk
	MMAErv0wsdw07SY/+C6vh87cS7rd8wpxxpwGONeOYfDz8biri3Jqq5dWhMyIblqvHnfJ
	QDZZLM3JFYrTzBjqlgB8+NFfy664wbn4f2E6ODW2vdh8rcq0lYNiEmZJS+o+OZFNlLTv
	ASS4nVZFb8HLtzufl7dMopwHYS1lg0YAU+fmQ1fa6CCo0LZvIomv2Dsp8I/BqHEUEeJW
	QOEQ==
MIME-Version: 1.0
References: <20200929185015.GG220516@redhat.com>
In-Reply-To: <20200929185015.GG220516@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Sep 2020 07:35:57 +0300
Message-ID: <CAOQ4uxgMeWF_vitenBY6_N3Eu-ix92q8AO5ckDAF+SVxHTBXXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC PATCH] fuse: update attributes on read() only
	on timeout
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Brian Foster <bfoster@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Sep 29, 2020 at 9:52 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Following commit added a flag to invalidate guest page cache automatically.
>
> 72d0d248ca823 fuse: add FUSE_AUTO_INVAL_DATA init flag
>
> Idea seemed to be that for network file systmes if client A modifies
> the file, then client B should be able to detect that mtime of file
> change and invalidate its own cache and fetch new data from server.
>
> There are few questions/issues with this method.
>
> How soon client B able to detect that file has changed. Should it
> first GETATTR from server for every READ and compare mtime. That
> will be much stronger cache coherency but very slow because every
> READ will first be preceeded by a GETATTR.
>
> Or should this be driven by inode timeout. That is if inode cached attrs
> (including mtime) have timed out, we fetch new mtime from server and
> invalidate cache based on that.
>
> Current logic calls fuse_update_attr() on every READ. But that method
> will result in GETATTR only if either attrs have timedout or if cached
> attrs have been invalidated.
>
> If client B is only doing READs (and not WRITEs), then attrs should be
> valid for inode timeout interval. And that means client B will detect
> mtime change only after timeout interval.
>
> But if client B is also doing WRITE, then once WRITE completes, we
> invalidate cached attrs. That means next READ will force GETATTR()
> and invalidate page cache. In this case client B will detect the
> change by client A much sooner but it can't differentiate between
> its own WRITEs and by another client WRITE. So every WRITE followed
> by READ will result in GETATTR, followed by page cache invalidation
> and performance suffers in mixed read/write workloads.
>
> I am assuming that intent of auto_inval_data is to detect changes
> by another client but it can take up to "inode timeout" seconds
> to detect that change. (And it does not guarantee an immidiate change
> detection).
>
> If above assumption is acceptable, then I am proposing this patch
> which will update attrs on READ only if attrs have timed out. This
> means every second we will do a GETATTR and invalidate page cache.
>
> This is also suboptimal because only if client B is writing, our
> cache is still valid but we will still invalidate it after 1 second.
> But we don't have a good mechanism to differentiate between our own
> changes and another client's changes. So this is probably second
> best method to reduce the extent of issue.
>

I was under the impression that virtiofs in now in the stage of stabilizing the
"all changes are from this client and no local changes on server" use case.
Is that the case? I remember you also had an idea to communicate that this
is the use case on connection setup time for SB_NOSEC which did not happen.

If that is the case, why use auto_inval_data at all for virtiofs and not
explicit_inval_data?
Is that because you do want to allow local changes on the server?

I wonder out loud if this change of behavior you proposed is a good opportunity
to introduce some of the verbs from SMB oplocks / NFS delegations into the
FUSE protocol in order to allow finer grained control over per-file
(and later also
per-directory) caching behavior.

Thanks,
Amir.

