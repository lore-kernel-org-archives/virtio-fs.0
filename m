DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=72DtlOOXf3iWRVT3ci7J4WRe2OfSvBNjNaeA3yO9uK4=;
	b=Idh2Xx12wurhec+tb51VXcm2gKzhfH4gX3K09ASFpVoRuTmMu/vJGJwK84eLaSP5mW
	5/cVFO3hfKyLchwoi/1kNkpcOn7aBjR79Q3pK7VG6UEy7OUUQf4em+JvE/WfzdO7FmzU
	4neTGcTHopg3pumi7BnaAp/RQq7p8zxcHcbaAK4cO6iy1RABOuyob49V3bwWsLYfP81N
	KjVswMgfMAh56xRz16VPrmK7S/fk9B4qLPnFIuJk1RHViWRfxwtIYiTQbTMjSEWZ0ZVk
	HIbD3O3PcsTWcTLndqXXJMLPkNup3nIRe1z5aQEwLxhBGMWfkGwvVMQp8bRFomcikfuC
	nntA==
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-4-vgoyal@redhat.com>
	<CAJfpegu=ooDmc3hT9cOe2WEUHQN=twX01xbV+YfPQPJUHFMs-g@mail.gmail.com>
	<20201106171843.GA1445528@redhat.com>
	<CAJfpegvvGL=GJX0a+cDUVhX754NibudTvHvtrBrCnk-FEnfQ6A@mail.gmail.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <7fb2e471-cfff-ae73-8716-585c609376b8@gmail.com>
Date: Wed, 11 Nov 2020 08:27:07 -0600
MIME-Version: 1.0
In-Reply-To: <CAJfpegvvGL=GJX0a+cDUVhX754NibudTvHvtrBrCnk-FEnfQ6A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
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
To: virtio-fs@redhat.com

I suggest default settings meet this test:  A Fedora vm booted directly
via virtio FS (with virtiofs as root) running with SE enabled, with
xattr 'on' and the host fs xattr capable like btrfs (Fedora default) --
does not generate SE linux denials or 'attribute not settable'
complaints.  In other words -- 'it just works'.  At least in the default
fedora at this time that is not the case.

HC



On 11/11/20 7:54 AM, Miklos Szeredi wrote:
> On Fri, Nov 6, 2020 at 6:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> I think it does not hurt to start passing FATTR_KILL_PRIV for chown()
>> as well. In that case, server will always clear caps on chown but
>> clear suid/sgid only if FATTR_KILL_PRIV is set. (Which will always
>> be set).
> Okay.
>
> More thoughts for FUSE_HANDLE_KILLPRIV_V2:
>
>  - clear "security.capability" on write, truncate and chown unconditionally
>  - clear suid/sgid if
>     o setattr has FATTR_SIZE and  FATTR_KILL_PRIV
>     o setattr has FATTR_UID or FATTR_GID
>     o open has O_TRUNC and FUSE_OPEN_KILL_PRIV
>     o write has FUSE_WRITE_KILL_PRIV
>
> Kernel has:
> ATTR_KILL_PRIV -> clear "security.capability"
> ATTR_KILL_SUID -> clear S_ISUID
> ATTR_KILL_SGID -> clear S_ISGID if executable
>
> Fuse has:
> FUSE_*KILL_PRIV -> clear S_ISUID and S_ISGID if executable
>
> So the fuse meaning of FUSE_*KILL_PRIV has a complementary meaning to
> that of ATTR_KILL_PRIV, which is somewhat confusing.  Also "PRIV"
> implies all privileges, including "security.capability" but the fuse
> ones relate to suid/sgid only.
>
> How about FUSE_*KILL_SUIDGID (FUSE_WRITE_KILL_SUIDGID being an alias
> for FUSE_WRITE_KILL_PRIV)?
>
> Thanks,
> Miklos
>
>
>
>
>> So anything is fine. We just need to document it well. I think I will
>> write it very clearly in qemu patch depending on what goes in kernel.
>>
>> Thanks
>> Vivek
>>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
>

