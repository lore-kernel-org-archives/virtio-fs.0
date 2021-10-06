References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-12-vgoyal@redhat.com>
From: Christophe de Dinechin <dinechin@redhat.com>
Date: Wed, 06 Oct 2021 17:15:57 +0200
In-reply-to: <20210930153037.1194279-12-vgoyal@redhat.com>
Message-ID: <lytuhui39c.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu


On 2021-09-30 at 11:30 -04, Vivek Goyal <vgoyal@redhat.com> wrote...
> So far we did not have the notion of cross queue traffic. That is, we
> get request on a queue and send back response on same queue. So if a
> request be being processed and at the same time a stop queue request
> comes in, we wait for all pending requests to finish and then queue
> is stopped and associated data structure cleaned.
>
> But with notification queue, now it is possible that we get a locking
> request on request queue and send the notification back on a different
> queue (notificaiton queue). This means, we need to make sure that

typo: notification (I just saw Stefan noticed it too)

> notifiation queue has not already been shutdown or is not being

typo: notification ;-)

> shutdown in parallel while we are trying to send a notification back.
> Otherwise bad things are bound to happen.
>
> One way to solve this problem is that stop notification queue in the
> end. First stop hiprio and all request queues.

I do not understand that sentence. Maybe you meant to write "is to stop
notification queue in the end", but even so I don't understand if you mean
"in the end" (of what) or "last" (relative to other queues)? I guess you
meant last.

> That means by the
> time we are trying to stop notification queue, we know no other
> request can be in progress which can try to send something on
> notification queue.
>
> But problem is that currently we don't have any control on in what
> order queues should be stopped. If there was a notion of whole device
> being stopped, then we could decide in what order queues should be
> stopped.
>
> Stefan mentioned that there is a command to stop whole device
> VHOST_USER_SET_STATUS but it is not implemented in libvhost-user
> yet. Also we probably could not move away from per queue stop
> logic we have as of now.
>
> As an alternative, he said if we stop all queue when qidx 0 is
> being stopped, it should be fine and we can solve the issue of
> notification queue shutdown order.
>
> So in this patch I am shutting down all queues when queue 0
> is being shutdown. And also changed shutdown order in such a
> way that notification queue is shutdown last.

For my education: I assume there is no valid case where there is no queue
and only the notification queue?

>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index c67c2e0e7a..a87e88e286 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -826,6 +826,11 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
>      assert(qidx < vud->nqueues);
>      ourqi = vud->qi[qidx];
>
> +    /* Queue is already stopped */
> +    if (!ourqi) {
> +        return;
> +    }
> +
>      /* qidx == 1 is the notification queue if notifications are enabled */
>      if (!se->notify_enabled || qidx != 1) {
>          /* Kill the thread */
> @@ -847,14 +852,25 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
>
>  static void stop_all_queues(struct fv_VuDev *vud)
>  {
> +    struct fuse_session *se = vud->se;
> +
>      for (int i = 0; i < vud->nqueues; i++) {
>          if (!vud->qi[i]) {
>              continue;
>          }
>
> +        /* Shutdown notification queue in the end */
> +        if (se->notify_enabled && i == 1) {
> +            continue;
> +        }
>          fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func__, i);
>          fv_queue_cleanup_thread(vud, i);
>      }
> +
> +    if (se->notify_enabled) {
> +        fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func__, 1);
> +        fv_queue_cleanup_thread(vud, 1);
> +    }
>  }
>
>  /* Callback from libvhost-user on start or stop of a queue */
> @@ -934,7 +950,16 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
>           * the queue thread doesn't block in virtio_send_msg().
>           */
>          vu_dispatch_unlock(vud);
> -        fv_queue_cleanup_thread(vud, qidx);
> +
> +        /*
> +         * If queue 0 is being shutdown, treat it as if device is being
> +         * shutdown and stop all queues.
> +         */
> +        if (qidx == 0) {
> +            stop_all_queues(vud);
> +        } else {
> +            fv_queue_cleanup_thread(vud, qidx);
> +        }
>          vu_dispatch_wrlock(vud);
>      }
>  }

For my education: given that we dropped the write lock above, what prevents
queue 0 from being shutdown on one thread while another cleans up another
queue. What makes it safe in that case? I think this is worth a comment.

--
Cheers,
Christophe de Dinechin (IRC c3d)

