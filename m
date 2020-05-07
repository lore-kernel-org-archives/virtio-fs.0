DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=H8Cu6HxLa77jfVaZq3CgdIap4XuJaTdN0YbC0ZBDI6M=;
	b=HHTWe/aw3WAO0yhwglTuWvnXtft80GNiSghWxIrZ8pm3zAl6YWCPBliDTGEgkmScPn
	GRXl7egcPPz7vscL5sn1MgH+ZlgS20+7153v5mN3c8Sv5/SOt/jdmqkdfKiaabkOmQmY
	JkkTTl0/M/DXPC/fmTCboG4vGxTAISZ/GlWe0=
MIME-Version: 1.0
References: <20200424062540.23679-1-chirantan@chromium.org>
	<20200424062540.23679-2-chirantan@chromium.org>
	<20200427151934.GB1042399@stefanha-x1.localdomain>
	<CAJFHJrr2DAgQC9ZWx78OudX1x6A57_vpLf4rJu80ceR6bnpbaQ@mail.gmail.com>
	<20200501154752.GA222606@stefanha-x1.localdomain>
In-Reply-To: <20200501154752.GA222606@stefanha-x1.localdomain>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Thu, 7 May 2020 17:10:15 +0900
Message-ID: <CAJFHJrpdbVKWyGuJJCBATVaYZsPLeg6JzpZmGFDsUcF_a4gcMA@mail.gmail.com>
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
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

On Sat, May 2, 2020 at 12:48 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Fri, May 01, 2020 at 04:14:38PM +0900, Chirantan Ekbote wrote:
> > On Tue, Apr 28, 2020 at 12:20 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > Instead of modifying the guest driver, please implement request
> > > parallelism in your device implementation.
> >
> > Yes, we have tried this already [1][2].  As I mentioned above, having
> > additional threads in the server actually made performance worse.  My
> > theory is that when the device only has 2 cpus, having additional
> > threads on the host that need cpu time ends up taking time away from
> > the guest vcpu.  We're now looking at switching to io_uring so that we
> > can submit multiple requests from a single thread.
>
> The host has 2 CPUs?  How many vCPUs does the guest have?  What is the
> physical storage device?  What is the host file system?

The host has 2 cpus.  The guest has 1 vcpu.  The physical storage
device is an internal ssd.  The file system is ext4 with directory
encryption.


>
> io_uring's vocabulary is expanding.  It can now do openat2(2), close(2),
> statx(2), but not mkdir(2), unlink(2), rename(2), etc.
>
> I guess there are two options:
> 1. Fall back to threads for FUSE operations that cannot yet be done via
>    io_uring.
> 2. Process FUSE operations that cannot be done via io_uring
>    synchronously.
>

I'm hoping that using io_uring for just the reads and writes should
give us a big enough improvement that we can do the rest of the
operations synchronously.

Chirantan


