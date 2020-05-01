DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=MV/Q7EwkQ764+aYA9y8KigZ49kNY6VR5runzo9HRXAI=;
	b=YEsJ68kG67HFUSEVoa4ShQkuTQXVsgWgNJnujwjFmqlO4tae8gECHz+YXcWwCiDBC+
	YLqHC3qQXaRzDO7F3ICHjwSHE14kYBfZ1yL4lBRLcTwFpx4R/vsXaPPcE8w0a9/dcrYN
	PETEIzETn8rgkDpHd4NyRr3SEAw3Hm8bv7aNw=
MIME-Version: 1.0
References: <20200424062540.23679-1-chirantan@chromium.org>
	<20200424062540.23679-2-chirantan@chromium.org>
	<20200427151934.GB1042399@stefanha-x1.localdomain>
In-Reply-To: <20200427151934.GB1042399@stefanha-x1.localdomain>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Fri, 1 May 2020 16:14:38 +0900
Message-ID: <CAJFHJrr2DAgQC9ZWx78OudX1x6A57_vpLf4rJu80ceR6bnpbaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: virtiofs: Add basic multiqueue
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

Hi Stefan,

On Tue, Apr 28, 2020 at 12:20 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Fri, Apr 24, 2020 at 03:25:40PM +0900, Chirantan Ekbote wrote:
> > Use simple round-robin scheduling based on the `unique` field of the
> > fuse request to spread requests across multiple queues, if supported by
> > the device.
>
> Multiqueue is not intended to be used this way and this patch will
> reduce performance*.  I don't think it should be merged.
>
> * I know it increases performance for you :) but hear me out:
>

It actually doesn't increase performance for me :-(.  It did increase
performance when I tested it on my 96-core workstation but on our
actual target devices, which only have 2 cores, using multiqueue or
having additional threads in the server actually made performance
worse.

> The purpose of multiqueue is for SMP scalability.  It allows queues to
> be processed with CPU/NUMA affinity to the vCPU that submitted the
> request (i.e. the virtqueue processing thread runs on a sibling physical
> CPU core).  Each queue has its own MSI-X interrupt so that completion
> interrupts can be processed on the same vCPU that submitted the request.
>
> Spreading requests across queues defeats all this.  Virtqueue processing
> threads that are located in the wrong place will now process the
> requests.  Completion interrupts will wake up a vCPU that did not submit
> the request and IPIs are necessary to notify the vCPU that originally
> submitted the request.
>

Thanks for the explanation.  I wasn't aware of this aspect of using
multiple queues but it makes sense now why we wouldn't want to spread
the requests across different queues.

> Even if you don't care about SMP performance, using multiqueue as a
> workaround for missing request parallelism still won't yield the best
> results.  The guest should be able to submit up to the maximum queue
> depth of the physical storage device.  Many Linux block drivers have max
> queue depths of 64.  This would require 64 virtqueues (plus the queue
> selection algorithm would have to utilize each one) and shows how
> wasteful this approach is.
>

I understand this but in practice unlike the virtio-blk workload,
which is nothing but reads and writes to a single file, the virtio-fs
workload tends to mix a bunch of metadata operations with data
transfers.  The metadata operations should be mostly handled out of
the host's file cache so it's unlikely virtio-fs would really be able
to fully utilize the underlying storage short of reading or writing a
really huge file.

> Instead of modifying the guest driver, please implement request
> parallelism in your device implementation.

Yes, we have tried this already [1][2].  As I mentioned above, having
additional threads in the server actually made performance worse.  My
theory is that when the device only has 2 cpus, having additional
threads on the host that need cpu time ends up taking time away from
the guest vcpu.  We're now looking at switching to io_uring so that we
can submit multiple requests from a single thread.

The multiqueue change was small and I wasn't aware of the SMP
implications, which is why I sent this patch.

Thanks,
Chirantan

[1] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2103602
[2] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2103603


