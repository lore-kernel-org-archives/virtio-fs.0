DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=mVJjtMrNCMh7zbljwOObjkhRwtgTHC3GfaBo0w1N3S8=;
	b=CIIZl0eW+J8lcwiAUBoLKWsiwvWYdqZ5Ncpg+tuJN+CG3IBYgT+cGD9cO8k3lt8a7h
	QYg2hni19Xj0g4xWT1R9pmhMNF5GZ6eP/B+1tP1InbN/3q5EdD2Eqk2Ap5f/+xLwmZ/r
	qrvnkPinSg3SWlgoKiUlbS0tJCHSYH8PralXU=
MIME-Version: 1.0
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRuCHvhICtTzMK04@work-vm>
	<CAJfpegvM+S5Xru3Yfc88C64mecvco=f99y-TajQBDfkLD-S8zQ@mail.gmail.com>
	<0896b1f6-c8c4-6071-c05b-a333c6cccacd@linux.alibaba.com>
In-Reply-To: <0896b1f6-c8c4-6071-c05b-a333c6cccacd@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Aug 2021 16:11:14 +0200
Message-ID: <CAJfpeguA3zeJq-HJUVZHv4nNybqFezkzPNhcWmj0n5+i7YpW4Q@mail.gmail.com>
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
To: JeffleXu <jefflexu@linux.alibaba.com>
Cc: virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Tue, 17 Aug 2021 at 15:08, JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
>
>
> On 8/17/21 6:09 PM, Miklos Szeredi wrote:
> > On Tue, 17 Aug 2021 at 11:32, Dr. David Alan Gilbert
> > <dgilbert@redhat.com> wrote:
> >>
> >> * Miklos Szeredi (miklos@szeredi.hu) wrote:
> >>> On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> >>>>
> >>>> This patchset adds support of per-file DAX for virtiofs, which is
> >>>> inspired by Ira Weiny's work on ext4[1] and xfs[2].
> >>>
> >>> Can you please explain the background of this change in detail?
> >>>
> >>> Why would an admin want to enable DAX for a particular virtiofs file
> >>> and not for others?
> >>
> >> Where we're contending on virtiofs dax cache size it makes a lot of
> >> sense; it's quite expensive for us to map something into the cache
> >> (especially if we push something else out), so selectively DAXing files
> >> that are expected to be hot could help reduce cache churn.
> >
> > If this is a performance issue, it should be fixed in a way that
> > doesn't require hand tuning like you suggest, I think.
> >
> > I'm not sure what the  ext4/xfs case for per-file DAX is.  Maybe that
> > can help understand the virtiofs case as well.
> >
>
> Some hints why ext4/xfs support per-file DAX can be found [1] and [2].
>
> "Boaz Harrosh wondered why someone might want to turn DAX off for a
> persistent memory device. Hellwig said that the performance "could
> suck"; Williams noted that the page cache could be useful for some
> applications as well. Jan Kara pointed out that reads from persistent
> memory are close to DRAM speed, but that writes are not; the page cache
> could be helpful for frequent writes. Applications need to change to
> fully take advantage of DAX, Williams said; part of the promise of
> adding a flag is that users can do DAX on smaller granularities than a
> full filesystem."
>
> In summary, page cache is preferable in some cases, and thus more fine
> grained way of DAX control is needed.

Hmm, okay, very frequent overwrites could be problematic for directly
mapped nvram.

>
> As for virtiofs, Dr. David Alan Gilbert has mentioned that various files
> may compete for limited DAX window resource.
>
> Besides, supporting DAX for small files can be expensive. Small files
> can consume DAX window resource rapidly, and if small files are accessed
> only once, the cost of mmap/munmap on host can not be ignored.

That's a good point.   Maybe we should disable DAX for file sizes much
smaller than the chunk size?

Thanks,
Miklos

