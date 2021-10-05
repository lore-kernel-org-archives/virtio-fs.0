Date: Tue, 5 Oct 2021 16:09:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVyw/wCkjn1JBtDJ@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-11-vgoyal@redhat.com>
	<YVsVp4rPILhz+/Eh@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVsVp4rPILhz+/Eh@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 10/13] virtiofsd: Custom threadpool for
 remote blocking posix locks requests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com

On Mon, Oct 04, 2021 at 03:54:31PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 30, 2021 at 11:30:34AM -0400, Vivek Goyal wrote:
> > Add a new custom threadpool using posix threads that specifically
> > service locking requests.
> > 
> > In the case of a fcntl(SETLKW) request, if the guest is waiting
> > for a lock or locks and issues a hard-reboot through SYSRQ then virtiofsd
> > unblocks the blocked threads by sending a signal to them and waking
> > them up.
> > 
> > The current threadpool (GThreadPool) is not adequate to service the
> > locking requests that result in a thread blocking. That is because
> > GLib does not provide an API to cancel the request while it is
> > serviced by a thread. In addition, a user might be running virtiofsd
> > without a threadpool (--thread-pool-size=0), thus a locking request
> > that blocks, will block the main virtqueue thread that services requests
> > from servicing any other requests.
> > 
> > The only exception occurs when the lock is of type F_UNLCK. In this case
> > the request is serviced by the main virtqueue thread or a GThreadPool
> > thread to avoid a deadlock, when all the threads in the custom threadpool
> > are blocked.
> > 
> > Then virtiofsd proceeds to cleanup the state of the threads, release
> > them back to the system and re-initialize.
> 
> Is there another way to cancel SETLKW without resorting to a new thread
> pool? Since this only matters when shutting down or restarting, can we
> close all plock->fd file descriptors to kick the GThreadPool workers out
> of fnctl()?

Ok, I tested this. If a thread is blocked on OFD lock and another
thread closes associated "fd", it does not unblock the thread
which is blocked on lock. So closing OFD can't be used for unblocking
a thread.

Even if it could be, it can't be a replacement for a thread pool
in general as we can't block main thread otherwise it can deadlock.
But we could have used another glib thread pool (instead of a
custom thread pool which can handle signals to unblock threads).

If you are curious, here is my test program.

https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/ofd-lock.c

Comments in there explain how to use it. It can block on an OFD
lock and one can send SIGUSR1 which will close fd.

Thanks
Vivek

