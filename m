DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=VUwVHY5EhmwuA95hzffZxCTvruckO8XQ5+Y16pohq98=;
	b=WRwTzPMYdidKpIkTgala3f2TZ6QHYRkBxEQXIIqWKC5sWn7F/MD6okYSIJVeQOkFId
	IKS5IXdWHcYvgozJOjcV206Vj6RKCLqxcOH2s3rl/1gD5QdY7hvYziN1fQJWdkCQ76At
	I6qOmM4PG8cSuIq3IgS/x244Fv04Bu9qAyges=
MIME-Version: 1.0
References: <20200901204045.1250822-1-vgoyal@redhat.com>
	<20200901204045.1250822-2-vgoyal@redhat.com>
In-Reply-To: <20200901204045.1250822-2-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 2 Sep 2020 08:57:07 +0200
Message-ID: <CAJfpegtUMJqUDhFTePpFP=oQ=XGFj2tfvx+unV94sN3fFZbZHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: Add a flag FUSE_NONSHARED_FS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Tue, Sep 1, 2020 at 10:41 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> FUSE_NONSHARED_FS will signify that filesystem is not shared. That is
> all fuse modifications are going thourgh this single fuse connection. It
> should not happen that file's data/metadata changed without the knowledge
> of fuse. Automatic file time stamp changes will probably be an exception
> to this rule.
>
> If filesystem is shared between different clients, then this flag should
> not be set.

I'm thinking maybe this flag should force some other parameters as well:

^FUSE_POSIX_LOCK
^FUSE_FLOCK_LOCKS
^FUSE_AUTO_INVAL_DATA
FUSE_EXPLICIT_INVAL_DATA
FUSE_CACHE_SYMLINKS
attr_valid=inf
entry_valid=inf
FOPEN_KEEP_CACHE
FOPEN_CACHE_DIR

This would make sure that it's really only used in the non-shared case.

Thanks,
Miklos

