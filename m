DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=L5HiMY324/mbIiHBmv8ouk9uhF1dk69cnwR9QB4zoKM=;
	b=KpRR7+8nUUVsoxbdOgYQucb4dRqGY/Ztix1ugMqRzceQBu4muJt6dC7z66GwPBj84e
	V3Am9kEWnBv01osYvcdUtdn2dTZ36LI/wWYbIjsYs7ZuZcoNzyGaIN6chtnCdAjldYFY
	wINqi1LA8R72QTsmD5zTtwaSWYMXBjNt8IDBM=
MIME-Version: 1.0
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRuCHvhICtTzMK04@work-vm>
In-Reply-To: <YRuCHvhICtTzMK04@work-vm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Aug 2021 12:09:40 +0200
Message-ID: <CAJfpegvM+S5Xru3Yfc88C64mecvco=f99y-TajQBDfkLD-S8zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, 17 Aug 2021 at 11:32, Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Miklos Szeredi (miklos@szeredi.hu) wrote:
> > On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> > >
> > > This patchset adds support of per-file DAX for virtiofs, which is
> > > inspired by Ira Weiny's work on ext4[1] and xfs[2].
> >
> > Can you please explain the background of this change in detail?
> >
> > Why would an admin want to enable DAX for a particular virtiofs file
> > and not for others?
>
> Where we're contending on virtiofs dax cache size it makes a lot of
> sense; it's quite expensive for us to map something into the cache
> (especially if we push something else out), so selectively DAXing files
> that are expected to be hot could help reduce cache churn.

If this is a performance issue, it should be fixed in a way that
doesn't require hand tuning like you suggest, I think.

I'm not sure what the  ext4/xfs case for per-file DAX is.  Maybe that
can help understand the virtiofs case as well.

Thanks,
Miklos

