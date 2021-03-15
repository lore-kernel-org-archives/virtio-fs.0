Date: Mon, 15 Mar 2021 14:57:17 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YE91zZZu6PlE4zhz@work-vm>
References: <20210312092212.782255-1-groug@kaod.org>
	<20210312092212.782255-8-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312092212.782255-8-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2 7/7] virtiofsd: Release vu_dispatch_lock
 when stopping queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

* Greg Kurz (groug@kaod.org) wrote:
> QEMU can stop a virtqueue by sending a VHOST_USER_GET_VRING_BASE request
> to virtiofsd. As with all other vhost-user protocol messages, the thread
> that runs the main event loop in virtiofsd takes the vu_dispatch lock in
> write mode. This ensures that no other thread can access virtqueues or
> memory tables at the same time.
> 
> In the case of VHOST_USER_GET_VRING_BASE, the main thread basically
> notifies the queue thread that it should terminate and waits for its
> termination:
> 
> main()
>  virtio_loop()
>   vu_dispatch_wrlock()
>   vu_dispatch()
>    vu_process_message()
>     vu_get_vring_base_exec()
>      fv_queue_cleanup_thread()
>       pthread_join()
> 
> Unfortunately, the queue thread ends up calling virtio_send_msg()
> at some point, which itself needs to grab the lock:
> 
> fv_queue_thread()
>  g_list_foreach()
>   fv_queue_worker()
>    fuse_session_process_buf_int()
>     do_release()
>      lo_release()
>       fuse_reply_err()
>        send_reply()
>         send_reply_iov()
>          fuse_send_reply_iov_nofree()
>           fuse_send_msg()
>            virtio_send_msg()
>             vu_dispatch_rdlock() <-- Deadlock !
> 
> Simply have the main thread to release the lock before going to
> sleep and take it back afterwards. A very similar patch was already
> sent by Vivek Goyal sometime back:
> 
> https://listman.redhat.com/archives/virtio-fs/2021-January/msg00073.html
> 
> The only difference here is that this done in fv_queue_set_started()
> because fv_queue_cleanup_thread() can also be called from virtio_loop()
> without the lock being held.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

I've queued just this 7/7 in the virtiofsd pull I'm just making at the
moment.  I'll leave the rest to ride the vhost-user train.

Dave

> ---
>  tools/virtiofsd/fuse_virtio.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 523ee64fb7ae..3e13997406bf 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -792,7 +792,13 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
>              assert(0);
>          }
>      } else {
> +        /*
> +         * Temporarily drop write-lock taken in virtio_loop() so that
> +         * the queue thread doesn't block in virtio_send_msg().
> +         */
> +        vu_dispatch_unlock(vud);
>          fv_queue_cleanup_thread(vud, qidx);
> +        vu_dispatch_wrlock(vud);
>      }
>  }
>  
> -- 
> 2.26.2
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

