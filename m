Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=MOXnyf1YwlbSeeWuLBeh11X+2FufbZlo7w2wB12V7kg=;
 b=VsUq4ENYKFkBKvmnOAv4cRmTbI434LO8lpPu9KvnwMm2iyPYJKCScuanX6eUpyOA8k
 MKNnBWW5gouxbhjvVHZh6K2ro+xg1amhF95FIfItTPhhkipToeGnRahbZoiA6IKbW2x1
 tOyu7vD/WnJUW3ldtags90xtJDT1Z3cuzobvxObH97Q+2KAihUVoW6M991u/fiB62EIH
 kPGAPOGRozxEfnicSQK2kqWE+K9ppo60EZ3SFi0mF9aTvnjIGbtd9fA8HDSyHkD2mkit
 m87lCIGABlGQbJh6i+4+xPdbxszoocgnK0oM1m1FDhXPoko06z/ClD8bsOKmPH661CTD
 Z16g==
MIME-Version: 1.0
References: <20220818184618.2205172-1-yokada.996@gmail.com>
 <YwZiyXqPTlSadOOR@fedora> <Yyn/UUVAHwV+bMP7@redhat.com>
In-Reply-To: <Yyn/UUVAHwV+bMP7@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 27 Sep 2022 11:50:00 -0400
Message-ID: <CAJSP0QXUWia+U1uLVVDxputRxEeYJqNapORts4R0UTUiXaL17w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: use g_date_time_get_microsecond
 to get subsecond
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Yusuke Okada <yokada.996@gmail.com>, "open list:virtiofs" <virtio-fs@redhat.com>, Yusuke Okada <okada.yusuke@jp.fujitsu.com>, qemu-devel@nongnu.org, qemu-stable <qemu-stable@nongnu.org>

On Tue, 20 Sept 2022 at 19:08, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Aug 24, 2022 at 01:41:29PM -0400, Stefan Hajnoczi wrote:
> > On Thu, Aug 18, 2022 at 02:46:19PM -0400, Yusuke Okada wrote:
> > > From: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
> > >
> > > The "%f" specifier in g_date_time_format() is only available in glib
> > > 2.65.2 or later. If combined with older glib, the function returns null
> > > and the timestamp displayed as "(null)".
> > >
> > > For backward compatibility, g_date_time_get_microsecond should be used
> > > to retrieve subsecond.
> > >
> > > In this patch the g_date_time_format() leaves subsecond field as "%06d"
> > > and let next snprintf to format with g_date_time_get_microsecond.
> > >
> > > Signed-off-by: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
> > > ---
> > >  tools/virtiofsd/passthrough_ll.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > Thanks, applied to my block tree for QEMU 7.2:
> > https://gitlab.com/stefanha/qemu/commits/block
>
> Hi Stefan,
>
> Wondering when do you plan to send it for merge. This seems like
> a simple fix. Not sure why it does not qualify as a fix for
> 7.1 instead.

The pull request with this patch was merged into qemu.git/master today.

Regarding 7.1, it needs to go through the -stable tree. I have CCed
qemu-stable so this patch can be picked up.

Thanks,
Stefan

