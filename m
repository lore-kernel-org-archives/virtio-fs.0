Date: Fri, 29 Jan 2021 09:16:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210129141600.GA3146@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
	<20210125180115.22936-5-vgoyal@redhat.com>
	<20210128165234.GC20377@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128165234.GC20377@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 4/6] qemu,
 vhost-user: Extend protocol to start/stop/flush slave channel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com, qemu-devel@nongnu.org

On Thu, Jan 28, 2021 at 04:52:34PM +0000, Stefan Hajnoczi wrote:
> On Mon, Jan 25, 2021 at 01:01:13PM -0500, Vivek Goyal wrote:
> > Currently we don't have a mechanism to flush slave channel while shutting
> > down vhost-user device and that can result a deadlock. Consider following
> > scenario.
> > 
> > 1. Slave gets a request from guest on virtqueue (say index 1, vq1), to map
> >    a portion of file in qemu address space.
> > 
> > 2. Thread serving vq1 receives this request and sends a message to qemu on
> >    slave channel/fd and gets blocked in waiting for a response from qemu.
> > 
> > 3. In the mean time, user does "echo b > /proc/sysrq-trigger" in guest. This
> >    leads to qemu reset and ultimately in main thread we end up in
> >    vhost_dev_stop() which is trying to shutdown virtqueues for the device.
> > 
> > 4. Slave gets VHOST_USER_GET_VRING_BASE message to shutdown a virtqueue on
> >    unix socket being used for communication.
> > 
> > 5. Slave tries to shutdown the thread serving vq1 and waits for it to
> >    terminate. But vq1 thread can't terminate because it is waiting for
> >    a response from qemu on slave_fd. And qemu is not processing slave_fd
> >    anymore as qemu is ressing (and not running main event loop anymore)
> >    and is waiting for a response to VHOST_USER_GET_VRING_BASE.
> > 
> > So we have a deadlock. Qemu is waiting on slave to response to
> > VHOST_USER_GET_VRING_BASE message and slave is waiting on qemu to
> > respond to request it sent on slave_fd.
> > 
> > I can reliably reproduce this race with virtio-fs.
> > 
> > Hence here is the proposal to solve this problem. Enhance vhost-user
> > protocol to properly shutdown slave_fd channel. And if there are pending
> > requests, flush the channel completely before sending the request to
> > shutdown virtqueues.
> > 
> > New workflow to shutdown slave channel is.
> > 
> > - Qemu sends VHOST_USER_STOP_SLAVE_CHANNEL request to slave. It waits
> >   for an reply from guest.
> > 
> > - Then qemu sits in a tight loop waiting for
> >   VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE message from slave on slave_fd.
> >   And while waiting for this message, qemu continues to process requests
> >   on slave_fd to flush any pending requests. This will unblock threads
> >   in slave and allow slave to shutdown slave channel.
> > 
> > - Once qemu gets VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE message, it knows
> >   no more requests will come on slave_fd and it can continue to shutdown
> >   virtqueues now.
> > 
> > - Once device starts again, qemu will send VHOST_USER_START_SLAVE_CHANNEL
> >   message to slave to open the slave channel and receive requests.
> > 
> > IOW, this allows for proper shutdown of slave channel, making sure
> > no threads in slave are blocked on sending/receiving message. And
> > this in-turn allows for shutting down of virtqueues, hence resolving
> > the deadlock.
> 
> Is the new message necessary?

Hi Stefan,

It probably is not necessary but it feels like a cleaner and simpler
solution.

There slave is a separate channel from virtqueues. And if device is
stopping, we want to make sure there are no pending requests in
slave channel. It is possible that virtqueue shutodwn is successful
but other entity could still be sending messages on slave channel. In
that case, shall we say device shutdown complete and stop polling
slave channel?

IOW, the way we have explicit protocol messages to shutdown each
vring, it makes sense to have explicit protocol message to shutdown
slave channel as well. Right now there is no mechanism to do that.

IMHO, introducing an explicit mechanism in protocol to shutdown
slave channel feels better as compared to say keep on serving
slave channel in parallel while waiting for virtuqueues to shutdown
and stop serving slave as soon as last virtuqueue is stopped (there
could still be pending slave message right after last virtuqueue
got shutdown).


> How about letting QEMU handle slave fd
> activity while waiting for virtqueues to stop instead?
> 
> In other words, QEMU should monitor both the UNIX domain socket and the
> slave fd after it has sent VHOST_USER_GET_VRING_BASE and is awaiting the
> response.

I can give it a try. If there is a strong preference for this solution.
I guess I can patch vhost_user_get_vring_base() to poll and serve both
unix domain socket and slave fd.

But at this point of time I do think that adding a mechanism to shutodwn
slave channel (the way we have mechanism to shutdown vring), sounds
better from design point of view.

Vivek

