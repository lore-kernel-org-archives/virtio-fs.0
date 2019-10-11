DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=fN1blR9PvaqWfAFCzj6In05/t5IgcWX4Rb7GxzkwKNs=;
	b=KblU4kGszNseRmxqDWDB20v3T2mMXZQwAz/yZMVMSm4+yapuzs4ZvI6H/SGGmknsX2
	3ZBTcVFHfJi11fdx/8DyNG6d/d6XIpACnN6zdcvWdoWOCSZ+c7kLWDpprRXXjOndiKXF
	+enHI0KCNjbwZotozMG15IXvbGS4LN7XimWt8=
MIME-Version: 1.0
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191007143444.GA174343@work-vm> <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
In-Reply-To: <27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Sat, 12 Oct 2019 03:45:01 +0900
Message-ID: <CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>

On Thu, Oct 10, 2019 at 7:00 PM qi.fuli@fujitsu.com <qi.fuli@fujitsu.com> wrote
>
>
> [ 7740.126845] INFO: task aio-last-ref-he:3361 blocked for more than 122
> seconds.
> [ 7740.128884]       Not tainted 5.4.0-rc1-aarch64-5.4-rc1 #1
> [ 7740.130364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 7740.132472] aio-last-ref-he D    0  3361   3143 0x00000220
> [ 7740.133954] Call trace:
> [ 7740.134627]  __switch_to+0x98/0x1e0
> [ 7740.135579]  __schedule+0x29c/0x688
> [ 7740.136527]  schedule+0x38/0xb8
> [ 7740.137615]  schedule_timeout+0x258/0x358
> [ 7740.139160]  wait_for_completion+0x174/0x400
> [ 7740.140322]  exit_aio+0x118/0x6c0
> [ 7740.141226]  mmput+0x6c/0x1c0
> [ 7740.142036]  do_exit+0x29c/0xa58
> [ 7740.142915]  do_group_exit+0x48/0xb0
> [ 7740.143888]  get_signal+0x168/0x8b0
> [ 7740.144836]  do_notify_resume+0x174/0x3d8
> [ 7740.145925]  work_pending+0x8/0x10
> [ 7863.006847] INFO: task aio-last-ref-he:3361 blocked for more than 245
> seconds.
> [ 7863.008876]       Not tainted 5.4.0-rc1-aarch64-5.4-rc1 #1
>

I have also seen this hang while writing the virtio-fs device for
crosvm.  The issue is with the retry logic when the virtqueue is full,
which happens very easily when the device doesn't support DAX.

virtio_fs_wake_pending_and_unlock has code like this:

retry:
    ret = virtio_fs_enqueue_req(&fs->vqs[queue_id], req);
    if (ret < 0) {
        if (ret == -ENOMEM || ret == -ENOSPC) {
            /* Virtqueue full. Retry submission */
            /* TODO use completion instead of timeout */
            usleep_range(20, 30);
            goto retry;
        }


Spinning here is completely unsafe as this method may be called while
the fc->bg_lock is held.  The call chain is
`fuse_request_queue_background (acquire fc->bg_lock) -> flush_bg_queue
-> queue_request_and_unlock -> virtio_fs_wake_pending_and_unlock (spin
until virtqueue is not full)`.  This lock is also acquired when
finishing requests if there was a background request:
`virtio_fs_requests_done_work (pull completed requests out of
virtqueue) -> fuse_request_end (acquire fc->bg_lock when the
FR_BACKGROUND bit is set in req->flags)`.  This is a deadlock where
one thread keeps spinning waiting for the virtqueue to empty but the
thread that can actually empty the virtqueue is blocked on acquiring a
spin lock held by the original thread.

I have a local patch that tries to fix this by putting requests in
fpq->io before queueing them.  Then if the virtqueue is full, they are
removed from fpq->io and put on fpq->processing and
virtio_fs_requests_done has code to queue requests from
fpq->processing after it empties the virtqueue.  I don't know if
that's the proper way to fix it but it does make the hang go away.


This is unrelated but there's also a nullptr dereference in the driver
if the device advertises more than request queue.  This is problematic
code:

/* Allocate fuse_dev for hiprio and notification queues */
for (i = 0; i < VQ_REQUEST; i++) {
    struct virtio_fs_vq *fsvq = &fs->vqs[i];

    fsvq->fud = fuse_dev_alloc();
    if (!fsvq->fud)
        goto err_free_fuse_devs;
}

ctx.fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
err = fuse_fill_super_common(sb, &ctx);
if (err < 0)
    goto err_free_fuse_devs;

fc = fs->vqs[VQ_REQUEST].fud->fc;

for (i = 0; i < fs->nvqs; i++) {
    struct virtio_fs_vq *fsvq = &fs->vqs[i];

    if (i == VQ_REQUEST)
        continue; /* already initialized */
    fuse_dev_install(fsvq->fud, fc);
}

The first loop only initializes fsvq->fud for queues up to VQ_REQUEST
but then the second loop calls fuse_dev_install with fsvq->fud for all
queues up to fs->nvqs.  When fs->nvqs is greater than VQ_REQUEST this
will end up dereferencing an uninitialized pointer.  I think the fix
is to skip calling fuse_dev_alloc for the VQ_REQUEST queue but then
call it for all the other queues up to fs->nvqs.


Chirantan

