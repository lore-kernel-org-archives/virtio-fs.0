Date: Mon, 20 Jan 2020 16:59:13 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200120165913.GQ2827@work-vm>
References: <20200120124307.20020-1-misono.tomohiro@jp.fujitsu.com>
	<20200120124307.20020-3-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120124307.20020-3-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: Remove fuse_loop_mt.c
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com

* Misono Tomohiro (misono.tomohiro@jp.fujitsu.com) wrote:
> Since now there is no user of fuse_loop_mt.c in virtiofs, remove it.
> Also cleanup related code (e.g. clone_fd option).
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

I'll try and squash this into one of the earlier patches in the series.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/Makefile.objs   |  1 -
>  tools/virtiofsd/fuse.h          | 38 ----------------------
>  tools/virtiofsd/fuse_common.h   | 24 --------------
>  tools/virtiofsd/fuse_i.h        | 19 -----------
>  tools/virtiofsd/fuse_loop_mt.c  | 56 ---------------------------------
>  tools/virtiofsd/fuse_lowlevel.h | 20 ------------
>  tools/virtiofsd/helper.c        |  3 --
>  7 files changed, 161 deletions(-)
>  delete mode 100644 tools/virtiofsd/fuse_loop_mt.c
> 
> diff --git a/tools/virtiofsd/Makefile.objs b/tools/virtiofsd/Makefile.objs
> index 941b19f18e..076f667e46 100644
> --- a/tools/virtiofsd/Makefile.objs
> +++ b/tools/virtiofsd/Makefile.objs
> @@ -1,7 +1,6 @@
>  virtiofsd-obj-y = buffer.o \
>                    fuse_opt.o \
>                    fuse_log.o \
> -                  fuse_loop_mt.o \
>                    fuse_lowlevel.o \
>                    fuse_signals.o \
>                    fuse_virtio.o \
> diff --git a/tools/virtiofsd/fuse.h b/tools/virtiofsd/fuse.h
> index 945ebc7a0d..7a4c713559 100644
> --- a/tools/virtiofsd/fuse.h
> +++ b/tools/virtiofsd/fuse.h
> @@ -996,44 +996,6 @@ int fuse_loop(struct fuse *f);
>   */
>  void fuse_exit(struct fuse *f);
>  
> -/**
> - * FUSE event loop with multiple threads
> - *
> - * Requests from the kernel are processed, and the appropriate
> - * operations are called.  Request are processed in parallel by
> - * distributing them between multiple threads.
> - *
> - * For a description of the return value and the conditions when the
> - * event loop exits, refer to the documentation of
> - * fuse_session_loop().
> - *
> - * Note: using fuse_loop() instead of fuse_loop_mt() means you are running in
> - * single-threaded mode, and that you will not have to worry about reentrancy,
> - * though you will have to worry about recursive lookups. In single-threaded
> - * mode, FUSE will wait for one callback to return before calling another.
> - *
> - * Enabling multiple threads, by using fuse_loop_mt(), will cause FUSE to make
> - * multiple simultaneous calls into the various callback functions given by your
> - * fuse_operations record.
> - *
> - * If you are using multiple threads, you can enjoy all the parallel execution
> - * and interactive response benefits of threads, and you get to enjoy all the
> - * benefits of race conditions and locking bugs, too. Ensure that any code used
> - * in the callback function of fuse_operations is also thread-safe.
> - *
> - * @param f the FUSE handle
> - * @param config loop configuration
> - * @return see fuse_session_loop()
> - *
> - * See also: fuse_loop()
> - */
> -#if FUSE_USE_VERSION < 32
> -int fuse_loop_mt_31(struct fuse *f, int clone_fd);
> -#define fuse_loop_mt(f, clone_fd) fuse_loop_mt_31(f, clone_fd)
> -#else
> -int fuse_loop_mt(struct fuse *f, struct fuse_loop_config *config);
> -#endif
> -
>  /**
>   * Get the current context
>   *
> diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
> index 1e8191b7a6..4b2c215fd9 100644
> --- a/tools/virtiofsd/fuse_common.h
> +++ b/tools/virtiofsd/fuse_common.h
> @@ -118,30 +118,6 @@ struct fuse_file_info {
>      uint32_t poll_events;
>  };
>  
> -/**
> - * Configuration parameters passed to fuse_session_loop_mt() and
> - * fuse_loop_mt().
> - */
> -struct fuse_loop_config {
> -    /**
> -     * whether to use separate device fds for each thread
> -     * (may increase performance)
> -     */
> -    int clone_fd;
> -
> -    /**
> -     * The maximum number of available worker threads before they
> -     * start to get deleted when they become idle. If not
> -     * specified, the default is 10.
> -     *
> -     * Adjusting this has performance implications; a very small number
> -     * of threads in the pool will cause a lot of thread creation and
> -     * deletion overhead and performance may suffer. When set to 0, a new
> -     * thread will be created to service every operation.
> -     */
> -    unsigned int max_idle_threads;
> -};
> -
>  /*
>   * Capability bits for 'fuse_conn_info.capable' and 'fuse_conn_info.want'
>   */
> diff --git a/tools/virtiofsd/fuse_i.h b/tools/virtiofsd/fuse_i.h
> index 4da6a242ba..4e47e5880d 100644
> --- a/tools/virtiofsd/fuse_i.h
> +++ b/tools/virtiofsd/fuse_i.h
> @@ -97,25 +97,6 @@ struct fuse_module {
>      int ctr;
>  };
>  
> -/*
> - * Channel interface (when using -o clone_fd)
> - */
> -
> -/**
> - * Obtain counted reference to the channel
> - *
> - * @param ch the channel
> - * @return the channel
> - */
> -struct fuse_chan *fuse_chan_get(struct fuse_chan *ch);
> -
> -/**
> - * Drop counted reference to a channel
> - *
> - * @param ch the channel
> - */
> -void fuse_chan_put(struct fuse_chan *ch);
> -
>  int fuse_send_reply_iov_nofree(fuse_req_t req, int error, struct iovec *iov,
>                                 int count);
>  void fuse_free_req(fuse_req_t req);
> diff --git a/tools/virtiofsd/fuse_loop_mt.c b/tools/virtiofsd/fuse_loop_mt.c
> deleted file mode 100644
> index 5dfaff35fd..0000000000
> --- a/tools/virtiofsd/fuse_loop_mt.c
> +++ /dev/null
> @@ -1,56 +0,0 @@
> -/*
> - * FUSE: Filesystem in Userspace
> - * Copyright (C) 2001-2007  Miklos Szeredi <miklos@szeredi.hu>
> - *
> - * Implementation of the multi-threaded FUSE session loop.
> - *
> - * This program can be distributed under the terms of the GNU LGPLv2.
> - * See the file COPYING.LIB.
> - */
> -
> -#include "fuse_i.h"
> -#include "fuse_lowlevel.h"
> -#include "fuse_misc.h"
> -#include "standard-headers/linux/fuse.h"
> -#include "fuse_virtio.h"
> -
> -#include <assert.h>
> -#include <errno.h>
> -#include <semaphore.h>
> -#include <signal.h>
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <string.h>
> -#include <sys/ioctl.h>
> -#include <sys/time.h>
> -#include <unistd.h>
> -
> -/* Environment var controlling the thread stack size */
> -#define ENVNAME_THREAD_STACK "FUSE_THREAD_STACK"
> -
> -struct fuse_chan *fuse_chan_get(struct fuse_chan *ch)
> -{
> -    assert(ch->ctr > 0);
> -    pthread_mutex_lock(&ch->lock);
> -    ch->ctr++;
> -    pthread_mutex_unlock(&ch->lock);
> -
> -    return ch;
> -}
> -
> -void fuse_chan_put(struct fuse_chan *ch)
> -{
> -    if (ch == NULL) {
> -        return;
> -    }
> -    pthread_mutex_lock(&ch->lock);
> -    ch->ctr--;
> -    if (!ch->ctr) {
> -        pthread_mutex_unlock(&ch->lock);
> -        close(ch->fd);
> -        pthread_mutex_destroy(&ch->lock);
> -        free(ch);
> -    } else {
> -        pthread_mutex_unlock(&ch->lock);
> -    }
> -}
> diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
> index 27f631d9fc..3a7213f42f 100644
> --- a/tools/virtiofsd/fuse_lowlevel.h
> +++ b/tools/virtiofsd/fuse_lowlevel.h
> @@ -1827,7 +1827,6 @@ struct fuse_cmdline_opts {
>      int show_version;
>      int show_help;
>      int print_capabilities;
> -    int clone_fd;
>      int syslog;
>      int log_level;
>      unsigned int max_idle_threads;
> @@ -1918,25 +1917,6 @@ int fuse_session_mount(struct fuse_session *se);
>   */
>  int fuse_session_loop(struct fuse_session *se);
>  
> -/**
> - * Enter a multi-threaded event loop.
> - *
> - * For a description of the return value and the conditions when the
> - * event loop exits, refer to the documentation of
> - * fuse_session_loop().
> - *
> - * @param se the session
> - * @param config session loop configuration
> - * @return see fuse_session_loop()
> - */
> -#if FUSE_USE_VERSION < 32
> -int fuse_session_loop_mt_31(struct fuse_session *se, int clone_fd);
> -#define fuse_session_loop_mt(se, clone_fd) fuse_session_loop_mt_31(se, clone_fd)
> -#else
> -int fuse_session_loop_mt(struct fuse_session *se,
> -                         struct fuse_loop_config *config);
> -#endif
> -
>  /**
>   * Flag a session as terminated.
>   *
> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> index bcb8c05063..2f46f4719a 100644
> --- a/tools/virtiofsd/helper.c
> +++ b/tools/virtiofsd/helper.c
> @@ -52,7 +52,6 @@ static const struct fuse_opt fuse_helper_opts[] = {
>      FUSE_OPT_KEY("fsname=", FUSE_OPT_KEY_KEEP),
>      FUSE_HELPER_OPT("subtype=", nodefault_subtype),
>      FUSE_OPT_KEY("subtype=", FUSE_OPT_KEY_KEEP),
> -    FUSE_HELPER_OPT("clone_fd", clone_fd),
>      FUSE_HELPER_OPT("max_idle_threads=%u", max_idle_threads),
>      FUSE_HELPER_OPT("--syslog", syslog),
>      FUSE_HELPER_OPT_VALUE("log_level=debug", log_level, FUSE_LOG_DEBUG),
> @@ -147,8 +146,6 @@ void fuse_cmdline_help(void)
>             "    -f                         foreground operation\n"
>             "    --daemonize                run in background\n"
>             "    -s                         disable multi-threaded operation\n"
> -           "    -o clone_fd                use separate fuse device fd for "
> -           "each thread\n"
>             "                               (may improve performance)\n"
>             "    -o max_idle_threads        the maximum number of idle worker "
>             "threads\n"
> -- 
> 2.21.1
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

