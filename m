Date: Mon, 5 Aug 2019 13:26:52 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190805122652.GM13734@work-vm>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190801165409.20121-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801165409.20121-3-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] virtiofsd: prevent
	FUSE_INIT/FUSE_DESTROY races
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> When running with multiple threads it can be tricky to handle
> FUSE_INIT/FUSE_DESTROY in parallel with other request types or in
> parallel with themselves.  Serialize FUSE_INIT and FUSE_DESTROY so that
> malicious clients cannot trigger race conditions.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

(It took me a few minutes getting my head around the different _destroy
functions)

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/fuse_i.h        |  1 +
>  contrib/virtiofsd/fuse_lowlevel.c | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/contrib/virtiofsd/fuse_i.h b/contrib/virtiofsd/fuse_i.h
> index ff6e1b75ba..dcde9feb97 100644
> --- a/contrib/virtiofsd/fuse_i.h
> +++ b/contrib/virtiofsd/fuse_i.h
> @@ -63,6 +63,7 @@ struct fuse_session {
>  	struct fuse_req list;
>  	struct fuse_req interrupts;
>  	pthread_mutex_t lock;
> +	pthread_rwlock_t init_rwlock;
>  	int got_destroy;
>  	int broken_splice_nonblock;
>  	uint64_t notify_ctr;
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> index 6ebf237baa..483a1bc9be 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -2473,6 +2473,18 @@ void fuse_session_process_buf_int(struct fuse_session *se,
>  	req->ctx.pid = in->pid;
>  	req->ch = ch ? fuse_chan_get(ch) : NULL;
>  
> +	/* INIT and DESTROY requests are serialized, all other request types
> +	 * run in parallel.  This prevents races between FUSE_INIT and ordinary
> +	 * requests, FUSE_INIT and FUSE_INIT, FUSE_INIT and FUSE_DESTROY, and
> +	 * FUSE_DESTROY and FUSE_DESTROY.
> +	 */
> +	if (in->opcode == FUSE_INIT || in->opcode == CUSE_INIT ||
> +	    in->opcode == FUSE_DESTROY) {
> +		pthread_rwlock_wrlock(&se->init_rwlock);
> +	} else {
> +		pthread_rwlock_rdlock(&se->init_rwlock);
> +	}
> +
>  	err = EIO;
>  	if (!se->got_init) {
>  		enum fuse_opcode expected;
> @@ -2524,10 +2536,13 @@ void fuse_session_process_buf_int(struct fuse_session *se,
>  		do_write_buf(req, in->nodeid, &iter, bufv);
>  	else
>  		fuse_ll_ops[in->opcode].func(req, in->nodeid, &iter);
> +
> +	pthread_rwlock_unlock(&se->init_rwlock);
>  	return;
>  
>  reply_err:
>  	fuse_reply_err(req, err);
> +	pthread_rwlock_unlock(&se->init_rwlock);
>  }
>  
>  #define LL_OPTION(n,o,v) \
> @@ -2569,6 +2584,7 @@ void fuse_session_destroy(struct fuse_session *se)
>  		if (se->op.destroy)
>  			se->op.destroy(se->userdata, se);
>  	}
> +	pthread_rwlock_destroy(&se->init_rwlock);
>  	pthread_mutex_destroy(&se->lock);
>  	free(se->cuse_data);
>  	if (se->fd != -1)
> @@ -2656,6 +2672,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
>  	list_init_req(&se->list);
>  	list_init_req(&se->interrupts);
>  	fuse_mutex_init(&se->lock);
> +	pthread_rwlock_init(&se->init_rwlock, NULL);
>  
>  	memcpy(&se->op, op, op_size);
>  	se->owner = getuid();
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

