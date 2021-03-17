DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=AlA+jYln5RzDTCm9btKJym2tsVjc3VyPFKEv+xmMJFM=;
	b=H8odzmq1dNXM+w1tKOc1T3J2Y8jJOiLwVfPMoR11yBlAU2B6Vj2CwtJ1lkg1FYinxu
	DTQQsYLIOG2Cixb87RGUxhtOgGM+NytvEh+ZM9pFAyW+ivpjfsFaCOl86Zc6F0c+iXQo
	lJY6VGWv5jkB6WX/leh0J+VLzolNWC521jCQE=
MIME-Version: 1.0
References: <20210316160147.289193-1-vgoyal@redhat.com>
	<20210316160147.289193-2-vgoyal@redhat.com>
	<CAJfpegtD-6Xt3JDtoOtqJLXeDzVgjfaVJhHU8OQ8Lpw9tu2FzA@mail.gmail.com>
	<20210317170119.GE324911@redhat.com>
In-Reply-To: <20210317170119.GE324911@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 17 Mar 2021 20:25:51 +0100
Message-ID: <CAJfpegvtYtfwsMCi38VjMGanarTStQNEnqveRUFhU1xCJ5EbUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 1/1] fuse: send file mode updates using
	SETATTR
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Seth Forshee <seth.forshee@canonical.com>

On Wed, Mar 17, 2021 at 6:01 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Mar 17, 2021 at 04:43:35PM +0100, Miklos Szeredi wrote:
> > On Tue, Mar 16, 2021 at 5:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > If ACL changes, it is possible that file mode permission bits change. As of
> > > now fuse client relies on file server to make those changes. But it does
> > > not send enough information to server so that it can decide where SGID
> > > bit should be cleared or not. Server does not know if caller has CAP_FSETID
> > > or not. It also does not know what are caller's group memberships and if any
> > > of the groups match file owner group.
> >
> > Right.  So what about performing the capability and group membership
> > check in the client and sending the result of this check to the
> > server?
>
> Hi Miklos,
>
> But that will still be non-atomic, right? I mean server probably will
> do setxattr first, then check if SGID was cleared or not, and if it
> has not been cleared, then it needs to set the mode.
>
> IOW, we still have two operations (setxattr followed by mode setting).
>
> I had thought about that option. But could not understand what does
> it buy us as opposed to guest sending a SETATTR.

If the non-atomic SETXATTR + SETATTR is done in the client, then the
server has no chance of ever operating correctly.

If the responsibility for clearing sgid is in the server, then it's up
to the server to decide how to best deal with this.  That may be the
racy way, but at least it's not the only possibility.

Not sure if virtiofsd can do this atomically or not.
setgid()/setgroups() require CAP_SETGID, but that's relative to the
user namespace of the daemon, so this might be possible to do, I
haven't put a lot of thought into this.

Thanks,
Miklos

