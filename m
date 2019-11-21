References: <20191118022410.21023-1-msys.mizuma@gmail.com>
From: Cao jin <caoj.fnst@cn.fujitsu.com>
Message-ID: <c80528c2-31ee-ccfc-127b-66bc7f93b669@cn.fujitsu.com>
Date: Thu, 21 Nov 2019 13:51:31 +0800
MIME-Version: 1.0
In-Reply-To: <20191118022410.21023-1-msys.mizuma@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] fuse: Fix the return code of
 fuse_direct_IO() to deal with the error for aio
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

On 11/18/19 10:24 AM, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> exit_aio() is sometimes stuck in wait_for_completion() after aio is issued
> with direct IO and the task receives a signal.
> 
> That is because kioctx in mm->ioctx_table is in use by aio_kiocb.
> aio_kiocb->ki_refcnt is 1 at that time. That means iocb_put() isn't
> called correctly.
> 
> fuse_get_req() returns as -EINTR when it's blocked and receives a signal.
> fuse_direct_IO() deals with the -EINTER as -EIOCBQUEUED and returns as
> -EIOCBQUEUED even though the aio isn't queued.
> As the result, aio_rw_done() doesn't handle the error, so iocb_put() isn't
> called via aio_complete_rw(), which is the callback.
> 
> The flow is something like as:
> 
>   io_submit
>     aio_get_req
>       refcount_set(&req->ki_refcnt, 2)
>     __io_submit_one
>       aio_read
>       ...
>         fuse_direct_IO # return as -EIOCBQUEUED
>           __fuse_direct_read
>           ...
>             fuse_get_req # return as -EINTR
>         aio_rw_done
>           # Nothing to do because ret is -EIOCBQUEUED...
>     iocb_put
>       refcount_dec_and_test(&iocb->ki_refcnt) # 2->1
> 
> Return as the error code of fuse_direct_io() or __fuse_direct_read() in
> fuse_direct_IO() so that aio_rw_done() can handle the error and call
> iocb_put().
> 
> This issue is trucked as a virtio-fs issue:
> https://gitlab.com/virtio-fs/qemu/issues/14
> 

I didn't reproduce this issue on kernel v5.4-rc7, but did on 5.4-rc8.
And verified this patch fixed the case in issue 14 on v5.4-rc8 and
virtiofsd (virtio-fs-dev 5f068fa9).

Tested-by: Cao jin <caoj.fnst@cn.fujitsu.com>
-- 
Sincerely,
Cao jin



