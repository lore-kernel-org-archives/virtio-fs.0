DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=IppUYQ8GF/7LuBlILBgrSqpEAXjuA5Ok93a1QoZUdgs=;
	b=ZQL1SDTMWchSpBu6572KAIf9vY6HqcyfOBt08vmb/plT8QnQEeE82ipV5agcqGarSb
	De7BcSwnUKKIXbUKL+CH8DrsMIcof9QDryXiVGIOCq0Hl/gZ0w68liLomJiZrBoTQfQq
	ZwDg/T5sQ75ew9je9uIK/q5OMNyn1TPDcQPx0=
MIME-Version: 1.0
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-4-vgoyal@redhat.com>
	<CAJfpegu=ooDmc3hT9cOe2WEUHQN=twX01xbV+YfPQPJUHFMs-g@mail.gmail.com>
	<20201106171843.GA1445528@redhat.com>
In-Reply-To: <20201106171843.GA1445528@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Nov 2020 14:54:43 +0100
Message-ID: <CAJfpegvvGL=GJX0a+cDUVhX754NibudTvHvtrBrCnk-FEnfQ6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 3/6] fuse: setattr should set
	FATTR_KILL_PRIV upon size change
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

On Fri, Nov 6, 2020 at 6:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> I think it does not hurt to start passing FATTR_KILL_PRIV for chown()
> as well. In that case, server will always clear caps on chown but
> clear suid/sgid only if FATTR_KILL_PRIV is set. (Which will always
> be set).

Okay.

More thoughts for FUSE_HANDLE_KILLPRIV_V2:

 - clear "security.capability" on write, truncate and chown unconditionally
 - clear suid/sgid if
    o setattr has FATTR_SIZE and  FATTR_KILL_PRIV
    o setattr has FATTR_UID or FATTR_GID
    o open has O_TRUNC and FUSE_OPEN_KILL_PRIV
    o write has FUSE_WRITE_KILL_PRIV

Kernel has:
ATTR_KILL_PRIV -> clear "security.capability"
ATTR_KILL_SUID -> clear S_ISUID
ATTR_KILL_SGID -> clear S_ISGID if executable

Fuse has:
FUSE_*KILL_PRIV -> clear S_ISUID and S_ISGID if executable

So the fuse meaning of FUSE_*KILL_PRIV has a complementary meaning to
that of ATTR_KILL_PRIV, which is somewhat confusing.  Also "PRIV"
implies all privileges, including "security.capability" but the fuse
ones relate to suid/sgid only.

How about FUSE_*KILL_SUIDGID (FUSE_WRITE_KILL_SUIDGID being an alias
for FUSE_WRITE_KILL_PRIV)?

Thanks,
Miklos




>
> So anything is fine. We just need to document it well. I think I will
> write it very clearly in qemu patch depending on what goes in kernel.
>
> Thanks
> Vivek
>

