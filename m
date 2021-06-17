DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wzZhieUCTydu3GyeTVG9mMeeZV6Pcd3sEaD/7vJ14DE=;
	b=WFK4gPH3RMnGJEiPQBkbbzCReG
	e6lx/HO4t41Z/sImtffnNLojRPbVSDUBztDOF5Cj5mCbDlO5K1py0Ud8f5E1fpuh465GetCfEDH+K
	qUSDIj3GnT0ffxm5aRgzlCLxkDltYLm24JlVyPoV+9isVWbYcKOSb24kI6w57KhH0PP5dUXBHH40N
	dhSfTHusBDvoxmftQBwHDyipEB6Vv9i1O1NRsvNqcWSJuODlqo20Fb/hM+6pUK1Yhuyp39iE7BIxE
	tnoNhMHHttdV2lU3m8lLJRKpEjgyUbPTMyGLd/GsKeCMZNUlbMs3/a1umEUg42qsM3RGKPi5hiOXc
	6m3bw7wg==
Date: Thu, 17 Jun 2021 15:25:00 +0100
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <YMtbPDW+T5Z1uBZt@infradead.org>
References: <20210614174454.903555-1-vgoyal@redhat.com>
	<YMsgaPS90iKIqSvi@infradead.org>
	<20210617133052.GA1142820@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210617133052.GA1142820@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v2 0/2] Add support to boot virtiofs and
	9pfs as rootfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, dhowells@redhat.com, miklos@szeredi.hu, richard.weinberger@gmail.com, asmadeus@codewreck.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

On Thu, Jun 17, 2021 at 09:30:52AM -0400, Vivek Goyal wrote:
> > +static int __init mount_nodev_root(void)
> > +{
> > +	struct file_system_type *fs = get_fs_type(root_fs_names);
> 
> get_fs_type() assumes root_fs_names is not null. So if I pass
> "root=myfs rw", it crashes with null pointer dereference.

Ok, I'll need to fix that.

> > +	int err = -ENODEV;
> > +
> > +	if (!fs)
> > +		goto out;
> > +	if (fs->fs_flags & FS_REQUIRES_DEV)
> > +		goto out_put_filesystem;
> > +
> > +	fs_names = (void *)__get_free_page(GFP_KERNEL);
> > +	if (!fs_names)
> > +		goto out_put_filesystem;
> > +	get_fs_names(fs_names);
> 
> I am wondering what use case we are trying to address by calling
> get_fs_names() and trying do_mount_root() on all filesystems
> returned by get_fs_names(). I am assuming following use cases
> you have in mind.
> 
> A. User passes a single filesystem in rootfstype.
>    
>    root=myfs rootfstype=virtiofs rw
> 
> B. User passes multiple filesystems in rootfstype and kernel tries all
>    of them one after the other
> 
>    root=myfs, rootfstype=9p,virtiofs rw
> 
> C. User does not pass a filesystem type at all. And kernel will get a
>    list of in-built filesystems and will try these one after the other.
> 
>    root=myfs rw
> 
> If that's the thought, will it make sense to call get_fs_names() first
> and then inside the for loop call get_fs_type() and try mounting
> only if FS_REQUIRES_DEV is not set, otherwise skip and move onto th
> next filesystem in the list (fs_names).

I thought of A and B.  I did not think at all of C and think it is
a rather bad idea.  I'll revisit the patch to avoid C and will resend it
as a formal patch.

