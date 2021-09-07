Date: Tue, 7 Sep 2021 14:10:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YTerJ1bvGSfOYjBY@redhat.com>
References: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
	<20210812054618.26057-3-jefflexu@linux.alibaba.com>
	<CAJfpegt48RM_y7mOj5EBcohF0zEmE4D6D7sHNgYgKNgGqDgTsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt48RM_y7mOj5EBcohF0zEmE4D6D7sHNgYgKNgGqDgTsA@mail.gmail.com>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>

On Tue, Sep 07, 2021 at 10:57:07AM +0200, Miklos Szeredi wrote:
> On Thu, 12 Aug 2021 at 07:46, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> >
> > From: Liu Bo <bo.liu@linux.alibaba.com>
> >
> > Since %req has been removed from fpq->processing_list, no one except
> > request_wait_answer() is looking at this %req and request_wait_answer()
> > waits only on FINISH flag, it's OK to remove fpq->lock after %req is
> > dropped from the list.
> 
> I'll accept a patch to remove FR_SENT completely from virtiofs.
> 

Recently I was also looking at FR_SENT flag and was wondering if it
is atomic bit flag, then why do we need to take spin lock around it.
Probably we need just some barrier if code needs it but not necessarily
any lock.

But I agree that FR_SENT seems not usable from virtiofs point of view
as we don't have support for interrupt request.

> This flag is used for queuing interrupts but interrupts are not yet
> implemented in virtiofs.    When blocking lock support is added the
> interrupt handling needs to be properly designed.

Hmm.., I did not think about this. I was getting ready to post patches
for blocking posix locks but it does not have any support for interrupting
the locking request (either blocked or queued).

Is implementing interrupt support a requirement for getting blocking
posix lock patches in?

Thanks
Vivek

