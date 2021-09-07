DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=gSsmXQdog+XhRKFrtC061ebmew6mLTJ95fTRhHi5xkA=;
	b=T9OmG0t/v7+e7ikKzrY0GBccn59UJoYuOtW9D+yB97t32goBea8gIyAqD6b3wlT8v9
	9UuibUNeApxg7PuPqC89FwlInDPXDjW/b+4gkEzSOSTofwfIOucChFesw0tFHV0lu7+s
	5RDCtA1S6/EqCR1O/IvOeB0dtqJt+hftv5M7E=
MIME-Version: 1.0
References: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
	<20210812054618.26057-3-jefflexu@linux.alibaba.com>
In-Reply-To: <20210812054618.26057-3-jefflexu@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 7 Sep 2021 10:57:07 +0200
Message-ID: <CAJfpegt48RM_y7mOj5EBcohF0zEmE4D6D7sHNgYgKNgGqDgTsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofs: reduce lock contention on
	fpq->lock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Thu, 12 Aug 2021 at 07:46, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>
> From: Liu Bo <bo.liu@linux.alibaba.com>
>
> Since %req has been removed from fpq->processing_list, no one except
> request_wait_answer() is looking at this %req and request_wait_answer()
> waits only on FINISH flag, it's OK to remove fpq->lock after %req is
> dropped from the list.

I'll accept a patch to remove FR_SENT completely from virtiofs.

This flag is used for queuing interrupts but interrupts are not yet
implemented in virtiofs.    When blocking lock support is added the
interrupt handling needs to be properly designed.

Thanks,
Miklos

