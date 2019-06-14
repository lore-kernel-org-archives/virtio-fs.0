Date: Fri, 14 Jun 2019 18:24:15 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190614172414.GJ2785@work-vm>
References: <20190610160955.GA19995@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610160955.GA19995@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] Adding notifications vq to the virtio-fs device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> Hi Vivek,
> There is discussion of adding the notifications vq to the virtio-fs
> device so that FUSE Notification messages are possible.  This was
> previously discussed on the VIRTIO mailing lists here:
> https://lists.oasis-open.org/archives/virtio-dev/201902/msg00074.html
> 
> The main issue is how to handle the case where the device wishes to
> raise notifications but the driver has not supplied enough buffers.
> 
> FUSE requires reliable notification delivery.  We cannot drop
> notifications.
> 
> The mechanism will have to support reliable delivery.  For example, the
> device may need to pause further operation until the driver makes
> buffers available again.  But this could lead to DoS or deadlocks, so
> care is needed!
> 
> I hope this link is useful in restarting the discussion about the
> notifications vq.

In the case we were recently discussing, notification of lock
availability, that's not necessarily a problem; if there's no
space on the notification queue then we stop notifying about
locks until there is some space.

Dave

> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

