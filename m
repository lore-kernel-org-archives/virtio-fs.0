DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=uc3yyq3YRGZotTCp/cVlRQjlfssJ2HADt/I4MCWeYdw=;
	b=SJA6JlGoAO4ZrZh9zOSneusqd/yIukaD1hhgzyxkNivyJbp4cPM4KvTYA16rXw6JSe
	WII5PoSK+OFv9H6jevDuSmyAze7tZXAFcuLMwev8CFREyJroUGEefXZ/0lIXdht+4vKs
	/yyQ7q8ePaLpAyCj9QL4/hVCiqeXkGf4RFwmvJ4FVHW2Tk/bgpMc//JPhjyT2lF4qNa1
	xc9bvIikU58Pu7H2XIXYeThwWvUJ76D28DBtQReUramqjavJrveZdErGhbBvAlNeE/Rt
	EJrO8zTQJ6jSuELXGJWYxtFDKtNDMjtNMCPWCf+Dq5IH3vSuDVZkP53OPn5QdIDdJex2
	vWRg==
MIME-Version: 1.0
References: <1575536486-24134-1-git-send-email-catherine.hecx@gmail.com>
	<3d26d626-de27-214b-2093-1dd850b632b6@linux.alibaba.com>
In-Reply-To: <3d26d626-de27-214b-2093-1dd850b632b6@linux.alibaba.com>
From: Catherine Ho <catherine.hecx@gmail.com>
Date: Thu, 5 Dec 2019 17:34:42 +0800
Message-ID: <CAEn6zmGOUdukP-VsQ_jNipMdqganz5=-1M=wLZ430qOp2UZxGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix double
	fuse_mbuf_iter_advance when do_removemapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com

Hi Peng

On Thu, 5 Dec 2019 at 17:19, Peng Tao <tao.peng@linux.alibaba.com> wrote:
>
> On 2019/12/5 17:01, Catherine Ho wrote:
> > Commit 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support
> > multiple entries") forgot to remove one fuse_mbuf_iter_advance in
> > do_removemapping.
> No, we do need to advance twice. One for fuse_removemapping_in, another
> for an array of fuse_removemapping_one.
>
But seems it advances for 3 times. What I mean is the 2nd advance of *one*
is pointless.
Please see [1] [2]
[1]https://gitlab.com/virtio-fs/qemu/blob/virtio-fs-dev/contrib/virtiofsd/fuse_lowlevel.c#L1888
[2]https://gitlab.com/virtio-fs/qemu/blob/virtio-fs-dev/contrib/virtiofsd/fuse_lowlevel.c#L1896

Best Regards
Catherine
> >
> > Without this patch, virtiofsd will report:
> > [ID: 00000123] do_removemapping: invalid in, expected 1 * 16, has 60 - 60
> > [ID: 00000123]    unique: 232, error: -22 (Invalid argument), outsize: 16
> >
> What kernel version are you using? It appears that the remove mapping
> request does not container a proper fuse_removemapping_one struct.
>
> > Fixes: 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support multiple entries")
> > Cc: Peng Tao <tao.peng@linux.alibaba.com>
> > Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
> > ---
> >   contrib/virtiofsd/fuse_lowlevel.c | 8 --------
> >   1 file changed, 8 deletions(-)
> >
> > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > index bde66c72c3..752e7d97b9 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > @@ -1894,14 +1894,6 @@ static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
> >               return;
> >       }
> >
> > -     one = fuse_mbuf_iter_advance(iter, sizeof(*one));
> > -     if (!one) {
> > -             fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
> > -                      arg->count, sizeof(*one), iter->size, iter->pos);
> > -             fuse_reply_err(req, EINVAL);
> > -             return;
> > -     }
> > -
> >       if (req->se->op.removemapping)
> >               req->se->op.removemapping(req, req->se, nodeid, arg->count, one);
> The patch is wrong itself, as `one` is not assigned here.
>


