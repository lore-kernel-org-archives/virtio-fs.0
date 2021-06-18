DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=YDAsEaZIbKIIp8KvyivEadpI521aXNzIrVqbLt8a+6M=;
	b=W3Zwe+ggcNPukjrye6QWgmI1jMrYFTknlvmT0PAsk8U2SmfPWr+w11qxKu60+RqRTj
	KTcKD2lYwNKBYJ2JmvyRtcM4pjyvykHPLUZVs+JvkUxfzP1924LxyG+FJ2jlpZ0jrlNC
	SLdnKkoJ3ODP04kxqwymzcbDjIgGR7hib3bfQ=
MIME-Version: 1.0
References: <20210616160836.590206-1-iangelak@redhat.com>
	<20210616160836.590206-2-iangelak@redhat.com>
In-Reply-To: <20210616160836.590206-2-iangelak@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jun 2021 09:43:36 +0200
Message-ID: <CAJfpeguiZX5zk_JP+h3f_00f5mF0nPqg9QVvmNvQ0TTV__LS-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofs: Add an index to keep track of
	first request queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ioannis Angelakopoulos <iangelak@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, 16 Jun 2021 at 18:09, Ioannis Angelakopoulos
<iangelak@redhat.com> wrote:
>
> From: Vivek Goyal <vgoyal@redhat.com>
>
> We have many virtqueues and first queue which carries fuse normal requests
> (except forget requests) has index pointed to by enum VQ_REQUEST. This
> works fine as long as number of queues are not dynamic.
>
> I am about to introduce one more virtqueue, called notification queue,
> which will be present only if device on host supports it. That means index
> of request queue will change depending on if notification queue is present
> or not.
>
> So, add a variable to keep track of that index and this will help when
> notification queue is added in next patch.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index bcb8a02e2d8b..a545e31cf1ae 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -61,6 +61,7 @@ struct virtio_fs {
>         unsigned int nvqs;               /* number of virtqueues */
>         unsigned int num_request_queues; /* number of request queues */
>         struct dax_device *dax_dev;
> +       unsigned int first_reqq_idx;     /* First request queue idx */
>
>         /* DAX memory window where file contents are mapped */
>         void *window_kaddr;
> @@ -681,7 +682,9 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>         if (fs->num_request_queues == 0)
>                 return -EINVAL;
>
> -       fs->nvqs = VQ_REQUEST + fs->num_request_queues;

Okay, so VQ_REQUEST now completely lost it's meaning as an index into
fs->vqs[] array, but VQ_HIPRIO is still used that way.  This looks
confusing.  Let's just get rid of VQ_REQUEST/VQ_HIPRIO completely, and
add "#define VQ_HIPRIO_IDX 0".

> +       /* One hiprio queue and rest are request queues */
> +       fs->nvqs = 1 + fs->num_request_queues;
> +       fs->first_reqq_idx = 1;
>         fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
>         if (!fs->vqs)
>                 return -ENOMEM;
> @@ -701,10 +704,11 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>         names[VQ_HIPRIO] = fs->vqs[VQ_HIPRIO].name;
>
>         /* Initialize the requests virtqueues */
> -       for (i = VQ_REQUEST; i < fs->nvqs; i++) {
> +       for (i = fs->first_reqq_idx; i < fs->nvqs; i++) {
>                 char vq_name[VQ_NAME_LEN];
>
> -               snprintf(vq_name, VQ_NAME_LEN, "requests.%u", i - VQ_REQUEST);
> +               snprintf(vq_name, VQ_NAME_LEN, "requests.%u",
> +                        i - fs->first_reqq_idx);
>                 virtio_fs_init_vq(&fs->vqs[i], vq_name, VQ_REQUEST);
>                 callbacks[i] = virtio_fs_vq_done;
>                 names[i] = fs->vqs[i].name;
> @@ -1225,7 +1229,7 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
>  static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
>  __releases(fiq->lock)
>  {
> -       unsigned int queue_id = VQ_REQUEST; /* TODO multiqueue */
> +       unsigned int queue_id;
>         struct virtio_fs *fs;
>         struct fuse_req *req;
>         struct virtio_fs_vq *fsvq;
> @@ -1239,6 +1243,7 @@ __releases(fiq->lock)
>         spin_unlock(&fiq->lock);
>
>         fs = fiq->priv;
> +       queue_id = fs->first_reqq_idx;
>
>         pr_debug("%s: opcode %u unique %#llx nodeid %#llx in.len %u out.len %u\n",
>                   __func__, req->in.h.opcode, req->in.h.unique,
> @@ -1316,7 +1321,7 @@ static int virtio_fs_fill_super(struct super_block *sb, struct fs_context *fsc)
>
>         err = -ENOMEM;
>         /* Allocate fuse_dev for hiprio and notification queues */
> -       for (i = 0; i < fs->nvqs; i++) {
> +       for (i = 0; i < fs->first_reqq_idx; i++) {

Previous code didn't seem to do what comment said, while new code
does.  So while the change seems correct, it should go into a separate
patch with explanation.

>                 struct virtio_fs_vq *fsvq = &fs->vqs[i];
>
>                 fsvq->fud = fuse_dev_alloc();
> @@ -1325,7 +1330,7 @@ static int virtio_fs_fill_super(struct super_block *sb, struct fs_context *fsc)
>         }
>
>         /* virtiofs allocates and installs its own fuse devices */
> -       ctx->fudptr = NULL;
> +       ctx->fudptr = (void **)&fs->vqs[fs->first_reqq_idx].fud;

I don't understand this.

>         if (ctx->dax) {
>                 if (!fs->dax_dev) {
>                         err = -EINVAL;
> @@ -1339,9 +1344,14 @@ static int virtio_fs_fill_super(struct super_block *sb, struct fs_context *fsc)
>         if (err < 0)
>                 goto err_free_fuse_devs;
>
> +       fc = fs->vqs[fs->first_reqq_idx].fud->fc;
> +

Nor this.

>         for (i = 0; i < fs->nvqs; i++) {
>                 struct virtio_fs_vq *fsvq = &fs->vqs[i];
>
> +               if (i == fs->first_reqq_idx)
> +                       continue;
> +

Nor this.    There's something subtle going on here, that's not
mentioned in the patch header.

Thanks,
Miklos

