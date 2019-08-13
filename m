DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=q5QdM2eXLDC8gGTpLrnSqMZDyOQGB6UIAQoxCGHhExU=;
	b=TldaMYDTYnJ4l+CEAet/mwTqlYksQ8ONrdkKi+3ZX5Kwi2P7FLmCaPqAINtCrWbwH8
	948tN50GIUhaHMqXpprGjM/ys5HlC78kMjDIKSDfN6aKpWFzWa4ZwwoII+fAvumJQMlG
	59xLe3o7EJDFgDYBTwMHiGQgJsOZ/ulxkfT6N9lNjGd9tlhkNr/B5axEEEFtLLOTINzO
	ORcsqrgmApqm2Nnx1wyWBw4mMrRRxRClss1P/zWJ3ZANCBihLpeyJAj4YoqJ5gPUXyaw
	plE1KfgmoshcVkOWuqsHZ8VMmqasKxd3YaovWy4gOmdkRCPnYGpIemPdToX6Ulkft4li
	L2Vw==
Date: Tue, 13 Aug 2019 09:48:09 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20190813134808.vqzrqt2mcz45ma5a@gabell>
References: <20190811225534.9040-1-msys.mizuma@gmail.com>
	<5D50D934.3010908@huawei.com>
	<20190812190250.7ghmdxpnvz3u7ec6@gabell>
	<5D520812.8000300@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D520812.8000300@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: Prevent multiply running with
 same vhost_user_socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

On Tue, Aug 13, 2019 at 08:45:06AM +0800, piaojun wrote:
> 
> 
> On 2019/8/13 3:02, Masayoshi Mizuma wrote:
> > Hi Jun,
> > 
> > On Mon, Aug 12, 2019 at 11:12:52AM +0800, piaojun wrote:
> >> Hi Masayoshi,
> >>
> >> On 2019/8/12 6:55, Masayoshi Mizuma wrote:
> >>> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> >>>
> >>> virtiofsd can run multiply even if the vhost_user_socket is
> >>> same path.
> >>>
> >>>   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
> >>>   [1] 244965
> >>>   virtio_session_mount: Waiting for vhost-user socket connection...
> >>>   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
> >>>   [2] 244966
> >>>   virtio_session_mount: Waiting for vhost-user socket connection...
> >>>   ]#
> >>>
> >>> The user will get confused about the situation and maybe the cause of the
> >>> unexpected problem. So it's better to prevent the multiple running.
> >>>
> >>> Create a regular file under localstatedir directory to exclude the
> >>> vhost_user_socket. To create and lock the file, use qemu_write_pidfile()
> >>> because the API has some sanity checks and file lock.
> >>>
> >>> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> >>> ---
> >>>  contrib/virtiofsd/fuse_i.h        |  1 +
> >>>  contrib/virtiofsd/fuse_lowlevel.c |  3 ++
> >>>  contrib/virtiofsd/fuse_virtio.c   | 50 +++++++++++++++++++++++++++++++
> >>>  3 files changed, 54 insertions(+)
> >>>
> >>> diff --git a/contrib/virtiofsd/fuse_i.h b/contrib/virtiofsd/fuse_i.h
> >>> index ff6e1b75ba..d31c675469 100644
> >>> --- a/contrib/virtiofsd/fuse_i.h
> >>> +++ b/contrib/virtiofsd/fuse_i.h
> >>> @@ -72,6 +72,7 @@ struct fuse_session {
> >>>          char *vu_socket_path;
> >>>          int   vu_listen_fd;
> >>>          int   vu_socketfd;
> >>> +        char *vu_socket_lock_file;
> >>
> >> I prefer char *vu_socket_lock which is just a personal habit.
> >>
> >>>          struct fv_VuDev *virtio_dev;
> >>>  };
> >>>  
> >>> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> >>> index 8adc4b1ab8..ab18b86435 100644
> >>> --- a/contrib/virtiofsd/fuse_lowlevel.c
> >>> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> >>> @@ -2587,6 +2587,9 @@ void fuse_session_destroy(struct fuse_session *se)
> >>>  	free(se->vu_socket_path);
> >>>  	se->vu_socket_path = NULL;
> >>>  
> >>> +	unlink(se->vu_socket_lock_file);
> >>> +	free(se->vu_socket_lock_file);
> >>> +
> >>>  	free(se);
> >>>  }
> >>>  
> >>> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> >>> index 083e4fc317..4999f95b63 100644
> >>> --- a/contrib/virtiofsd/fuse_virtio.c
> >>> +++ b/contrib/virtiofsd/fuse_virtio.c
> >>> @@ -32,6 +32,9 @@
> >>>  
> >>>  #include "contrib/libvhost-user/libvhost-user.h"
> >>>  
> >>> +#include "qemu/osdep.h"
> >>> +#include "qapi/error.h"
> >>> +
> >>>  struct fv_VuDev;
> >>>  struct fv_QueueInfo {
> >>>          pthread_t thread;
> >>> @@ -862,6 +865,47 @@ int virtio_loop(struct fuse_session *se)
> >>>         return 0;
> >>>  }
> >>>  
> >>> +static void strreplace(char *s, char old, char new)
> >>> +{
> >>> +        for (; *s; ++s)
> >>> +                if (*s == old)
> >>> +                        *s = new;
> >>> +}
> >>> +
> >>> +static int fv_create_socket_lock_file(struct fuse_session *se)
> >>> +{
> >>> +        char *dir, *socket_name;
> >>> +        Error *local_err = NULL;
> >>> +
> >>> +        dir = qemu_get_local_state_pathname("run/virtiofsd");
> >>> +
> >>> +        if (g_mkdir_with_parents(dir, S_IRWXU) < -1) {
> >>> +                fuse_err("%s: Failed to create directory %s: %s",
> >>> +                        __func__, dir, strerror(errno));
> >>> +                return -1;
> >>> +        }
> >>> +
> >>> +        socket_name = malloc(strlen(se->vu_socket_path) + 1);
> 
> Sorry for not pointing this in the last email, and it's better adding a
> NULL checker here, moreover, checking NULL before *unlink* in
> fuse_session_destroy() becomes necessary.

Good point, thanks.

> 
> >>> +        memset(socket_name, 0, strlen(se->vu_socket_path) + 1);
> >>> +        memcpy(socket_name, se->vu_socket_path, strlen(se->vu_socket_path));
> >>> +        strreplace(socket_name, '/', '.');
> >>
> >> Shall we use a local var to replace the long *se->vu_socket_path*? And
> > 
> > I'll add a local var to replace strlen(se->vu_socket_path).
> > 
> >> I wonder if we could just place the lock file in the same dir level of
> >> socket file which could save some code work?
> > 
> > Thank you for the suggestion but I prefer the lock file is in
> > localstatedir, for example /var/run/virtiofsd, because if the
> > lock file in the same dir and the dir is used in common, for example
> > /tmp, users may delete the lock file...
> 
> It's also good for me. And if you agree with all my comments, feel free
> to add:
> 
> Reviewed-by: Jun Piao <piaojun@huawei.com>

Thanks!

- Masa

> 
> Jun
> 
> > 
> >>
> >>> +
> >>> +        se->vu_socket_lock_file = malloc(NAME_MAX);
> >>> +        memset(se->vu_socket_lock_file, 0, NAME_MAX);
> >>> +        snprintf(se->vu_socket_lock_file, NAME_MAX, "%s/%s.pid",
> >>> +			dir, socket_name);
> >>> +
> >>> +        if (!qemu_write_pidfile(se->vu_socket_lock_file, &local_err)) {
> >>> +                error_report_err(local_err);
> >>
> >> Memory leak here.
> > 
> > I'll fix this.
> > 
> > Thanks!
> > Masa
> > 
> >>
> >>> +                return -1;
> >>> +        }
> >>> +
> >>> +        free(socket_name);
> >>> +        g_free(dir);
> >>> +
> >>> +        return 0;
> >>> +}
> >>> +
> >>>  static int fv_create_listen_socket(struct fuse_session *se)
> >>>  {
> >>>          struct sockaddr_un un;
> >>> @@ -876,6 +920,12 @@ static int fv_create_listen_socket(struct fuse_session *se)
> >>>                  return -1;
> >>>          }
> >>>  
> >>> +        /* Check the vu_socket_path is already used */
> >>> +        if (fv_create_socket_lock_file(se) == -1) {
> >>> +                fuse_err("%s: Socket lock file creation failed\n", __func__);
> >>> +                return -1;
> >>> +        }
> >>> +
> >>>          /* Create the Unix socket to communicate with qemu
> >>>           * based on QEMU's vhost-user-bridge
> >>>           */
> >>>
> > .
> > 

