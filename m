Date: Tue, 5 Oct 2021 09:19:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVxQ1qIERJVSC+yV@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-12-vgoyal@redhat.com>
	<YVsXLhZOUOI0Ubha@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVsXLhZOUOI0Ubha@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 11/13] virtiofsd: Shutdown notification
	queue in the end
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

On Mon, Oct 04, 2021 at 04:01:02PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 30, 2021 at 11:30:35AM -0400, Vivek Goyal wrote:
> > So far we did not have the notion of cross queue traffic. That is, we
> > get request on a queue and send back response on same queue. So if a
> > request be being processed and at the same time a stop queue request
> > comes in, we wait for all pending requests to finish and then queue
> > is stopped and associated data structure cleaned.
> > 
> > But with notification queue, now it is possible that we get a locking
> > request on request queue and send the notification back on a different
> > queue (notificaiton queue). This means, we need to make sure that
> 
> s/notificaiton/notification/
> 
> > notifiation queue has not already been shutdown or is not being
> 
> s/notifiation/notification/

Will fix both.

[..]
> >  /* Callback from libvhost-user on start or stop of a queue */
> > @@ -934,7 +950,16 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
> >           * the queue thread doesn't block in virtio_send_msg().
> >           */
> >          vu_dispatch_unlock(vud);
> > -        fv_queue_cleanup_thread(vud, qidx);
> > +
> > +        /*
> > +         * If queue 0 is being shutdown, treat it as if device is being
> > +         * shutdown and stop all queues.
> > +         */
> 
> Please expand this comment so it's clear why we do this.

Ok, will do. I put the justification in commit message but it is a good
idea to put it here as well.

Vivek

