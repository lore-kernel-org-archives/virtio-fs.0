DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=3OwoprurdfjCI69Sb0SLu5vwDZ5zDww0nnsXZt9JzSo=;
	b=qbKwC/TPm7zICPaZDHAAL+1BPFdv5DY+p59+a9c37+VmbTF/BktdFoWonN8sJxajaz
	XT9u5rQPVJhiYhkjILmMUWVNfDtgMRCP3qPo2c9ZCbCAwxiJIefCpcYdbSatEQ1eeLZd
	XhUOYTpwOUUL33up2NzfpgDERSeLcmKy1+zas=
MIME-Version: 1.0
References: <20210316160147.289193-1-vgoyal@redhat.com>
	<20210316160147.289193-2-vgoyal@redhat.com>
In-Reply-To: <20210316160147.289193-2-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 17 Mar 2021 16:43:35 +0100
Message-ID: <CAJfpegtD-6Xt3JDtoOtqJLXeDzVgjfaVJhHU8OQ8Lpw9tu2FzA@mail.gmail.com>
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

On Tue, Mar 16, 2021 at 5:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> If ACL changes, it is possible that file mode permission bits change. As of
> now fuse client relies on file server to make those changes. But it does
> not send enough information to server so that it can decide where SGID
> bit should be cleared or not. Server does not know if caller has CAP_FSETID
> or not. It also does not know what are caller's group memberships and if any
> of the groups match file owner group.

Right.  So what about performing the capability and group membership
check in the client and sending the result of this check to the
server?

Yes, need to extend fuse_setxattr_in.

There's still a race with uid and gid changing on the underlying
filesystem, so the attributes need to be refreshed, but I don't think
that's a big worry.

Thanks,
Miklos

