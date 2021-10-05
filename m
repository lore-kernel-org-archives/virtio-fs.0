Date: Tue, 5 Oct 2021 09:06:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVxN21sNt4U8cO64@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-11-vgoyal@redhat.com>
	<YVsVp4rPILhz+/Eh@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

I don't think that closing plock->fd will unblock fcntl().  

SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
{
        struct fd f = fdget_raw(fd);
}

IIUC, fdget_raw() will take a reference on associated "struct file" and
after that rest of the code will work with that "struct file".

static int do_lock_file_wait(struct file *filp, unsigned int cmd,
                             struct file_lock *fl)
{
..
..
                error = wait_event_interruptible(fl->fl_wait,
                                        list_empty(&fl->fl_blocked_member));

..
..
}

And this shoudl break upon receiving signal. And man page says the
same thing.

       F_OFD_SETLKW (struct flock *)
              As for F_OFD_SETLK, but if a conflicting lock  is  held  on  the
              file,  then  wait  for that lock to be released.  If a signal is
              caught while waiting, then the call is  interrupted  and  (after
              the  signal  handler has returned) returns immediately (with re‐
              turn value -1 and errno set to EINTR; see signal(7)).

It would be nice if we don't have to implement our own custom threadpool
just for locking. Would have been better if glib thread pool provided
some facility for this.

[..]
> > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> > index 3b720c5d4a..c67c2e0e7a 100644
> > --- a/tools/virtiofsd/fuse_virtio.c
> > +++ b/tools/virtiofsd/fuse_virtio.c
> > @@ -20,6 +20,7 @@
> >  #include "fuse_misc.h"
> >  #include "fuse_opt.h"
> >  #include "fuse_virtio.h"
> > +#include "tpool.h"
> >  
> >  #include <sys/eventfd.h>
> >  #include <sys/socket.h>
> > @@ -612,6 +613,60 @@ out:
> >      free(req);
> >  }
> >  
> > +/*
> > + * If the request is a locking request, use a custom locking thread pool.
> > + */
> > +static bool use_lock_tpool(gpointer data, gpointer user_data)
> > +{
> > +    struct fv_QueueInfo *qi = user_data;
> > +    struct fuse_session *se = qi->virtio_dev->se;
> > +    FVRequest *req = data;
> > +    VuVirtqElement *elem = &req->elem;
> > +    struct fuse_buf fbuf = {};
> > +    struct fuse_in_header *inhp;
> > +    struct fuse_lk_in *lkinp;
> > +    size_t lk_req_len;
> > +    /* The 'out' part of the elem is from qemu */
> > +    unsigned int out_num = elem->out_num;
> > +    struct iovec *out_sg = elem->out_sg;
> > +    size_t out_len = iov_size(out_sg, out_num);
> > +    bool use_custom_tpool = false;
> > +
> > +    /*
> > +     * If notifications are not enabled, no point in using cusotm lock
> > +     * thread pool.
> > +     */
> > +    if (!se->notify_enabled) {
> > +        return false;
> > +    }
> > +
> > +    assert(se->bufsize > sizeof(struct fuse_in_header));
> > +    lk_req_len = sizeof(struct fuse_in_header) + sizeof(struct fuse_lk_in);
> > +
> > +    if (out_len < lk_req_len) {
> > +        return false;
> > +    }
> > +
> > +    fbuf.mem = g_malloc(se->bufsize);
> > +    copy_from_iov(&fbuf, out_num, out_sg, lk_req_len);
> 
> This looks inefficient: for every FUSE request we now malloc se->bufsize
> and then copy lk_req_len bytes, only to free the memory again.
> 
> Is it possible to keep lk_req_len bytes on the stack instead?

I guess it should be possible. se->bufsize is variable but lk_req_len
is known at compile time.

lk_req_len = sizeof(struct fuse_in_header) + sizeof(struct fuse_lk_in);

So we should be able to allocate this much space on stack and point
fbuf.mem to it.

char buf[sizeof(struct fuse_in_header) + sizeof(struct fuse_lk_in)];
fbuf.mem = buf;

Will give it a try.

Vivek

