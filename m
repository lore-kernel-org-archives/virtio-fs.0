Date: Thu, 15 Aug 2019 10:45:45 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190815094545.GE2841@work-vm>
References: <20190809082536.56402-1-eguan@linux.alibaba.com>
	<5D4D3E0E.10609@huawei.com> <20190811132042.GB2665@desktop>
	<3d1f5a7e-fd00-2b46-994c-99d07b3c94ce@huawei.com>
	<20190811153517.GF2665@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811153517.GF2665@desktop>
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofsd: print log only when priority
 is high enough
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <guaneryu@gmail.com>
Cc: virtio-fs@redhat.com

* Eryu Guan (guaneryu@gmail.com) wrote:
> On Sun, Aug 11, 2019 at 10:32:16PM +0800, piaojun wrote:
> > 
> > 
> > On 2019/8/11 21:20, Eryu Guan wrote:
> > > On Fri, Aug 09, 2019 at 05:34:06PM +0800, piaojun wrote:
> > >> Hi Eryu,
> > >>
> > >> A very big patch, and I prefer spliting into several ones.
> > > 
> > > Most of the changes are replacing
> > > 
> > > 	if (lo->debug)
> > > 		fuse_debug(...);
> > > 
> > > to
> > > 	fuse_debug(...);
> > > 
> > > But yeah, it's fine to split, one patches introduce current_log_level
> > > related code, one does the replacements.
> > 
> > Sounds reasonable.
> > 
> > > 
> > >>
> > >> On 2019/8/9 16:25, Eryu Guan wrote:
> > >>> Introduce "-o log_level=" command line option to specify current log
> > >>> level (priority), valid values are "debug info warn err", e.g.
> > >>>
> > >>>     ./virtiofsd -o log_level=debug ...
> > >>>
> > >>> So only log priority higher than "debug" will be printed to
> > >>> stderr/syslog. And the default level is info.
> > >>>
> > >>> The "-o debug"/"-d" options are kept, and imply debug log level.
> > >>
> > >> I wonder if this will make user confused when there are two options for
> > >> debug.
> > > 
> > > Forgot to mention, one reason to keep "-o debug/-d" options is try not
> > > to break existing users, e.g. kata-runtime. But I have no strong
> > > preference on this.
> > 
> > Yes, compat is always important, and I have little knowledge about kata,
> > so it would be best to reach an agreement with it.
> > 
> > After looking though all the fuse_log codes, I come up with a new idea
> > to do this.
> > 1. Expand the debug in struct lo_data to *log_level* which represent
> > err, warn, info and debug;
> > 
> > struct lo_data {
> > 	pthread_mutex_t mutex;
> > 	int debug -> *log_level*;
> 
> I thought about this too, but that means that fuse_debug/info/warn/err
> functions should take lo_data or fuse_session as argument as well, and I
> don't think it's worth to introduce such complexity, a global log level
> would be easier. And I think it's possible & easier to add support to
> change the log level (as a global variable) when virtiofsd is running,
> e.g. on SIGHUP.

Yes, lets keep this simple; one debug variable is enough.

Dave

> > 
> > 2. Define a fuse_log_set_level() in fuse_log.c and called by
> > passthrough_ll.c or other files.
> 
> Sounds good.
> 
> > 
> > 3. As for the "-o debug/-d", I prefer to clean it up to make the usage
> > easier. Maybe this won't do harm to the compat as virtiofsd is still in
> > development now. But this change will need a discuss with other developers.
> 
> Thanks,
> Eryu
> 
> > 
> > Jun
> > 
> > > 
> > >>
> > >>>
> > >>> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> > >>> ---
> > >>>  contrib/virtiofsd/fuse_log.c       |   9 ++-
> > >>>  contrib/virtiofsd/fuse_log.h       |   4 +
> > >>>  contrib/virtiofsd/fuse_lowlevel.c  |  77 +++++++-----------
> > >>>  contrib/virtiofsd/fuse_lowlevel.h  |   1 +
> > >>>  contrib/virtiofsd/fuse_virtio.c    | 104 ++++++++++---------------
> > >>>  contrib/virtiofsd/helper.c         |  10 ++-
> > >>>  contrib/virtiofsd/passthrough_ll.c | 156 +++++++++++++++----------------------
> > >>>  7 files changed, 153 insertions(+), 208 deletions(-)
> > >>>
> > >>> diff --git a/contrib/virtiofsd/fuse_log.c b/contrib/virtiofsd/fuse_log.c
> > >>> index 4eb25328721e..d54b64099a2b 100644
> > >>> --- a/contrib/virtiofsd/fuse_log.c
> > >>> +++ b/contrib/virtiofsd/fuse_log.c
> > >>> @@ -9,10 +9,10 @@
> > >>>  #include <stdbool.h>
> > >>>  #include <stdio.h>
> > >>>  #include <stdarg.h>
> > >>> -#include <syslog.h>
> > >>>  #include "fuse_log.h"
> > >>>  
> > >>>  static bool use_syslog;
> > >>> +int current_log_level = LOG_INFO;
> > >>
> > >> Shall we make it static var which won't populate other files?
> > > 
> > > It's used in passthrouth_ll.c (the end of this patch), "-d" sets
> > > current_log_level to LOG_DEBUG.
> > > 
> > >>
> > >> Jun
> > > 
> > > Thanks for the review!
> > > 
> > > Eryu
> > > 
> > >>
> > >>>  
> > >>>  void fuse_log_enable_syslog(void)
> > >>>  {
> > >>> @@ -24,10 +24,13 @@ void fuse_log_enable_syslog(void)
> > >>>      openlog("virtiofsd", LOG_PID, LOG_DAEMON);
> > >>>  }
> > >>>  
> > >>> -static void fuse_vlog(int priority, const char *fmt, va_list ap)
> > >>> +static void fuse_vlog(int target_level, const char *fmt, va_list ap)
> > >>>  {
> > >>> +    if (current_log_level < target_level)
> > >>> +        return;
> > >>> +
> > >>>      if (use_syslog) {
> > >>> -        vsyslog(priority, fmt, ap);
> > >>> +        vsyslog(target_level, fmt, ap);
> > >>>      } else {
> > >>>          vfprintf(stderr, fmt, ap);
> > >>>      }
> > >>> diff --git a/contrib/virtiofsd/fuse_log.h b/contrib/virtiofsd/fuse_log.h
> > >>> index 3c22928d2b1d..c4dfc921b6d8 100644
> > >>> --- a/contrib/virtiofsd/fuse_log.h
> > >>> +++ b/contrib/virtiofsd/fuse_log.h
> > >>> @@ -9,8 +9,12 @@
> > >>>  #ifndef FUSE_LOG_H
> > >>>  #define FUSE_LOG_H
> > >>>  
> > >>> +#include <syslog.h>
> > >>>  #include "qemu/compiler.h"
> > >>>  
> > >>> +/* Current log level */
> > >>> +extern int current_log_level;
> > >>> +
> > >>>  void fuse_log_enable_syslog(void);
> > >>>  void fuse_err(const char *fmt, ...) GCC_FMT_ATTR(1, 2);
> > >>>  void fuse_warning(const char *fmt, ...) GCC_FMT_ATTR(1, 2);
> > >>> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > >>> index 8d3f141d23cf..7eec2680b6de 100644
> > >>> --- a/contrib/virtiofsd/fuse_lowlevel.c
> > >>> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > >>> @@ -155,19 +155,17 @@ static int fuse_send_msg(struct fuse_session *se, struct fuse_chan *ch,
> > >>>  	struct fuse_out_header *out = iov[0].iov_base;
> > >>>  
> > >>>  	out->len = iov_length(iov, count);
> > >>> -	if (se->debug) {
> > >>> -		if (out->unique == 0) {
> > >>> -			fuse_debug("NOTIFY: code=%d length=%u\n",
> > >>> -				   out->error, out->len);
> > >>> -		} else if (out->error) {
> > >>> -			fuse_debug("   unique: %llu, error: %i (%s), outsize: %i\n",
> > >>> -				   (unsigned long long) out->unique,
> > >>> -				   out->error, strerror(-out->error),
> > >>> -				   out->len);
> > >>> -		} else {
> > >>> -			fuse_debug("   unique: %llu, success, outsize: %i\n",
> > >>> -				   (unsigned long long) out->unique, out->len);
> > >>> -		}
> > >>> +	if (out->unique == 0) {
> > >>> +		fuse_debug("NOTIFY: code=%d length=%u\n",
> > >>> +			   out->error, out->len);
> > >>> +	} else if (out->error) {
> > >>> +		fuse_debug("   unique: %llu, error: %i (%s), outsize: %i\n",
> > >>> +			   (unsigned long long) out->unique,
> > >>> +			   out->error, strerror(-out->error),
> > >>> +			   out->len);
> > >>> +	} else {
> > >>> +		fuse_debug("   unique: %llu, success, outsize: %i\n",
> > >>> +			   (unsigned long long) out->unique, out->len);
> > >>>  	}
> > >>>  
> > >>>          if (fuse_lowlevel_is_virtio(se)) {
> > >>> @@ -1668,9 +1666,7 @@ static void do_interrupt(fuse_req_t req, fuse_ino_t nodeid,
> > >>>  		return;
> > >>>  	}
> > >>>  
> > >>> -	if (se->debug)
> > >>> -		fuse_debug("INTERRUPT: %llu\n",
> > >>> -			   (unsigned long long) arg->unique);
> > >>> +	fuse_debug("INTERRUPT: %llu\n", (unsigned long long) arg->unique);
> > >>>  
> > >>>  	req->u.i.unique = arg->unique;
> > >>>  
> > >>> @@ -1952,13 +1948,10 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
> > >>>  		}
> > >>>  	}
> > >>>  
> > >>> -	if (se->debug) {
> > >>> -		fuse_debug("INIT: %u.%u\n", arg->major, arg->minor);
> > >>> -		if (arg->major == 7 && arg->minor >= 6) {
> > >>> -			fuse_debug("flags=0x%08x\n", arg->flags);
> > >>> -			fuse_debug("max_readahead=0x%08x\n",
> > >>> -				   arg->max_readahead);
> > >>> -		}
> > >>> +	fuse_debug("INIT: %u.%u\n", arg->major, arg->minor);
> > >>> +	if (arg->major == 7 && arg->minor >= 6) {
> > >>> +		fuse_debug("flags=0x%08x\n", arg->flags);
> > >>> +		fuse_debug("max_readahead=0x%08x\n", arg->max_readahead);
> > >>>  	}
> > >>>  	se->conn.proto_major = arg->major;
> > >>>  	se->conn.proto_minor = arg->minor;
> > >>> @@ -2135,21 +2128,14 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
> > >>>  		outarg.map_alignment = sysconf(_SC_PAGE_SIZE);
> > >>>  	}
> > >>>  
> > >>> -	if (se->debug) {
> > >>> -		fuse_debug("   INIT: %u.%u\n", outarg.major, outarg.minor);
> > >>> -		fuse_debug("   flags=0x%08x\n", outarg.flags);
> > >>> -		fuse_debug("   max_readahead=0x%08x\n",
> > >>> -			   outarg.max_readahead);
> > >>> -		fuse_debug("   max_write=0x%08x\n", outarg.max_write);
> > >>> -		fuse_debug("   max_background=%i\n",
> > >>> -			   outarg.max_background);
> > >>> -		fuse_debug("   congestion_threshold=%i\n",
> > >>> -			   outarg.congestion_threshold);
> > >>> -		fuse_debug("   time_gran=%u\n",
> > >>> -			   outarg.time_gran);
> > >>> -		fuse_debug("   map_alignment=%u\n",
> > >>> -			   outarg.map_alignment);
> > >>> -	}
> > >>> +	fuse_debug("   INIT: %u.%u\n", outarg.major, outarg.minor);
> > >>> +	fuse_debug("   flags=0x%08x\n", outarg.flags);
> > >>> +	fuse_debug("   max_readahead=0x%08x\n", outarg.max_readahead);
> > >>> +	fuse_debug("   max_write=0x%08x\n", outarg.max_write);
> > >>> +	fuse_debug("   max_background=%i\n", outarg.max_background);
> > >>> +	fuse_debug("   congestion_threshold=%i\n", outarg.congestion_threshold);
> > >>> +	fuse_debug("   time_gran=%u\n", outarg.time_gran);
> > >>> +	fuse_debug("   map_alignment=%u\n", outarg.map_alignment);
> > >>>  	if (arg->minor < 5)
> > >>>  		outargsize = FUSE_COMPAT_INIT_OUT_SIZE;
> > >>>  	else if (arg->minor < 23)
> > >>> @@ -2440,13 +2426,11 @@ void fuse_session_process_buf_int(struct fuse_session *se,
> > >>>  	in = fuse_mbuf_iter_advance(&iter, sizeof(*in));
> > >>>  	assert(in); /* caller guarantees the input buffer is large enough */
> > >>>  
> > >>> -	if (se->debug) {
> > >>> -		fuse_debug("unique: %llu, opcode: %s (%i), nodeid: %llu, insize: %zu, pid: %u\n",
> > >>> -			   (unsigned long long) in->unique,
> > >>> -			   opname((enum fuse_opcode) in->opcode), in->opcode,
> > >>> -			   (unsigned long long) in->nodeid, buf->size,
> > >>> -			   in->pid);
> > >>> -	}
> > >>> +	fuse_debug("unique: %llu, opcode: %s (%i), nodeid: %llu, insize: %zu, pid: %u\n",
> > >>> +		   (unsigned long long) in->unique,
> > >>> +		   opname((enum fuse_opcode) in->opcode), in->opcode,
> > >>> +		   (unsigned long long) in->nodeid, buf->size,
> > >>> +		   in->pid);
> > >>>  
> > >>>  	req = fuse_ll_alloc_req(se);
> > >>>  	if (req == NULL) {
> > >>> @@ -2493,8 +2477,7 @@ void fuse_session_process_buf_int(struct fuse_session *se,
> > >>>  			// TODO: This is after a hard reboot typically, we need to do
> > >>>  			// a destroy, but we can't reply to this request yet so
> > >>>  			// we can't use do_destroy
> > >>> -	                if (se->debug)
> > >>> -				fuse_debug("%s: reinit\n", __func__);
> > >>> +			fuse_debug("%s: reinit\n", __func__);
> > >>>  			se->got_destroy = 1;
> > >>>  			se->got_init = 0;
> > >>>                          if (se->op.destroy)
> > >>> diff --git a/contrib/virtiofsd/fuse_lowlevel.h b/contrib/virtiofsd/fuse_lowlevel.h
> > >>> index e761d8d0e5ec..b441d3dfedeb 100644
> > >>> --- a/contrib/virtiofsd/fuse_lowlevel.h
> > >>> +++ b/contrib/virtiofsd/fuse_lowlevel.h
> > >>> @@ -1798,6 +1798,7 @@ struct fuse_cmdline_opts {
> > >>>  	int show_help;
> > >>>  	int clone_fd;
> > >>>  	int syslog;
> > >>> +	int log_level;
> > >>>  	unsigned int max_idle_threads;
> > >>>  };
> > >>>  
> > >>> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> > >>> index 72ddf703c9d4..5b3174e4c74c 100644
> > >>> --- a/contrib/virtiofsd/fuse_virtio.c
> > >>> +++ b/contrib/virtiofsd/fuse_virtio.c
> > >>> @@ -223,9 +223,8 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
> > >>>          unsigned int in_num = elem->in_num;
> > >>>          struct iovec *in_sg = elem->in_sg;
> > >>>          size_t in_len = iov_length(in_sg, in_num);
> > >>> -        if (se->debug)
> > >>> -                fuse_debug("%s: elem %d: with %d in desc of length %zd\n",
> > >>> -                           __func__, elem->index, in_num,  in_len);
> > >>> +	fuse_debug("%s: elem %d: with %d in desc of length %zd\n",
> > >>> +		   __func__, elem->index, in_num,  in_len);
> > >>>  
> > >>>          /* The elem should have room for a 'fuse_out_header' (out from fuse)
> > >>>           * plus the data based on the len in the header.
> > >>> @@ -286,9 +285,8 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> > >>>  
> > >>>          out->len = tosend_len;
> > >>>  
> > >>> -        if (se->debug)
> > >>> -                fuse_debug("%s: count=%d len=%zd iov_len=%zd \n",
> > >>> -                           __func__, count, len, iov_len);
> > >>> +	fuse_debug("%s: count=%d len=%zd iov_len=%zd \n",
> > >>> +		   __func__, count, len, iov_len);
> > >>>  
> > >>>          /* unique == 0 is notification which we don't support */
> > >>>          assert (out->unique);
> > >>> @@ -301,9 +299,8 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> > >>>          struct iovec *in_sg = elem->in_sg;
> > >>>          size_t in_len = iov_length(in_sg, in_num);
> > >>>          size_t in_len_writeable = iov_length(in_sg, in_num - bad_in_num);
> > >>> -        if (se->debug)
> > >>> -                fuse_debug("%s: elem %d: with %d in desc of length %zd\n",
> > >>> -                           __func__, elem->index, in_num,  in_len);
> > >>> +	fuse_debug("%s: elem %d: with %d in desc of length %zd\n",
> > >>> +		   __func__, elem->index, in_num,  in_len);
> > >>>  
> > >>>          /* The elem should have room for a 'fuse_out_header' (out from fuse)
> > >>>           * plus the data based on the len in the header.
> > >>> @@ -356,23 +353,19 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> > >>>                  for (i = 0, in_sg_left = 0; i < in_sg_cpy_count; i++) {
> > >>>                          in_sg_left += in_sg_ptr[i].iov_len;
> > >>>                  }
> > >>> -                if (se->debug)
> > >>> -                        fuse_debug("%s: after skip skip_size=%zd in_sg_cpy_count=%d in_sg_left=%zd\n",
> > >>> -				   __func__, skip_size, in_sg_cpy_count,
> > >>> -				   in_sg_left);
> > >>> +		fuse_debug("%s: after skip skip_size=%zd in_sg_cpy_count=%d in_sg_left=%zd\n",
> > >>> +			   __func__, skip_size, in_sg_cpy_count, in_sg_left);
> > >>>                  ret = preadv(buf->buf[0].fd, in_sg_ptr, in_sg_cpy_count, buf->buf[0].pos);
> > >>>  
> > >>> -                if (se->debug)
> > >>> -                        fuse_debug("%s: preadv_res=%d(%s) len=%zd\n",
> > >>> -                                   __func__, ret, strerror(errno), len);
> > >>> +		fuse_debug("%s: preadv_res=%d(%s) len=%zd\n",
> > >>> +			   __func__, ret, strerror(errno), len);
> > >>>                  if (ret == -1) {
> > >>>                          ret = errno;
> > >>>                          free(in_sg_cpy);
> > >>>                          goto err;
> > >>>                  }
> > >>>                  if (ret < len && ret) {
> > >>> -                        if (se->debug)
> > >>> -                                fuse_debug("%s: ret < len\n", __func__);
> > >>> +                        fuse_debug("%s: ret < len\n", __func__);
> > >>>                          /* Skip over this much next time around */
> > >>>                          skip_size = ret;
> > >>>                          buf->buf[0].pos += ret;
> > >>> @@ -383,14 +376,12 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> > >>>                  }
> > >>>                  if (!ret) {
> > >>>                          /* EOF case? */
> > >>> -                        if (se->debug)
> > >>> -                                fuse_debug("%s: !ret in_sg_left=%zd\n",
> > >>> -                                           __func__, in_sg_left);
> > >>> +			fuse_debug("%s: !ret in_sg_left=%zd\n",
> > >>> +				   __func__, in_sg_left);
> > >>>                          break;
> > >>>                  }
> > >>>                  if (ret != len) {
> > >>> -                        if (se->debug)
> > >>> -                                fuse_debug("%s: ret!=len\n", __func__);
> > >>> +			fuse_debug("%s: ret!=len\n", __func__);
> > >>>                          ret = EIO;
> > >>>                          free(in_sg_cpy);
> > >>>                          goto err;
> > >>> @@ -410,11 +401,10 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> > >>>                                  msg.len[0] = len;
> > >>>                          }
> > >>>                          int64_t req_res =fuse_virtio_io(se, &msg, buf->buf[0].fd);
> > >>> -                        if (se->debug)
> > >>> -                                fuse_debug("%s: bad loop; len=%zd bad_in_num=%d fd_offset=%zd c_offset=%p req_res=%ld\n",
> > >>> -					   __func__, len, bad_in_num,
> > >>> -					   buf->buf[0].pos,
> > >>> -					   in_sg_ptr[0].iov_base, req_res);
> > >>> +			fuse_debug("%s: bad loop; len=%zd bad_in_num=%d fd_offset=%zd c_offset=%p req_res=%ld\n",
> > >>> +				   __func__, len, bad_in_num,
> > >>> +				   buf->buf[0].pos,
> > >>> +				   in_sg_ptr[0].iov_base, req_res);
> > >>>                          if (req_res > 0) {
> > >>>                                  len -= msg.len[0];
> > >>>                                  buf->buf[0].pos += msg.len[0];
> > >>> @@ -488,11 +478,10 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> > >>>          struct iovec *out_sg = elem->out_sg;
> > >>>          size_t out_len = iov_length(out_sg, out_num);
> > >>>          size_t out_len_readable = iov_length(out_sg, out_num_readable);
> > >>> -        if (se->debug)
> > >>> -                fuse_debug("%s: elem %d: with %d out desc of length %zd"
> > >>> -                           " bad_in_num=%u bad_out_num=%u\n",
> > >>> -                           __func__, elem->index, out_num,
> > >>> -                           out_len, req->bad_in_num, req->bad_out_num);
> > >>> +	fuse_debug("%s: elem %d: with %d out desc of length %zd"
> > >>> +		   " bad_in_num=%u bad_out_num=%u\n",
> > >>> +		   __func__, elem->index, out_num,
> > >>> +		   out_len, req->bad_in_num, req->bad_out_num);
> > >>>  
> > >>>          /* The elem should contain a 'fuse_in_header' (in to fuse)
> > >>>           * plus the data based on the len in the header.
> > >>> @@ -555,11 +544,9 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> > >>>                                  ((struct fuse_in_header *)fbuf.mem)->opcode ==
> > >>>                                  FUSE_READ &&
> > >>>                                  out_sg[1].iov_len == sizeof(struct fuse_read_in)) {
> > >>> -                        if (se->debug) {
> > >>> -                                fuse_debug("Unmappable read case "
> > >>> -                                           "in_num=%d bad_in_num=%d\n",
> > >>> -                                           elem->in_num, req->bad_in_num);
> > >>> -                        }
> > >>> +			fuse_debug("Unmappable read case "
> > >>> +				   "in_num=%d bad_in_num=%d\n",
> > >>> +				   elem->in_num, req->bad_in_num);
> > >>>                          handled_unmappable = true;
> > >>>                  }
> > >>>  
> > >>> @@ -581,8 +568,7 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> > >>>                          // data, we can just do it straight out of guest memory
> > >>>                          // but we must sitll copy the headers in case the guest
> > >>>                          // was nasty and changed them while we were using them.
> > >>> -                        if (se->debug)
> > >>> -                                fuse_debug("%s: Write special case\n", __func__);
> > >>> +			fuse_debug("%s: Write special case\n", __func__);
> > >>>  
> > >>>                          // copy the fuse_write_in header afte rthe fuse_in_header
> > >>>                          fbuf.mem += out_sg->iov_len;
> > >>> @@ -636,10 +622,8 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> > >>>          if (!req->reply_sent) {
> > >>>                  struct VuVirtq *q = vu_get_queue(dev, qi->qidx);
> > >>>  
> > >>> -                if (se->debug) {
> > >>> -                        fuse_debug("%s: elem %d no reply sent\n",
> > >>> -                                   __func__, elem->index);
> > >>> -                }
> > >>> +		fuse_debug("%s: elem %d no reply sent\n",
> > >>> +			   __func__, elem->index);
> > >>>  
> > >>>                  pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
> > >>>                  pthread_mutex_lock(&qi->vq_lock);
> > >>> @@ -683,8 +667,7 @@ static void *fv_queue_thread(void *opaque)
> > >>>                 pf[1].events = POLLIN;
> > >>>                 pf[1].revents = 0;
> > >>>  
> > >>> -               if (qi->virtio_dev->se->debug)
> > >>> -                       fuse_debug("%s: Waiting for Queue %d event\n", __func__, qi->qidx);
> > >>> +	       fuse_debug("%s: Waiting for Queue %d event\n", __func__, qi->qidx);
> > >>>                 int poll_res = ppoll(pf, 2, NULL, NULL);
> > >>>  
> > >>>                 if (poll_res == -1) {
> > >>> @@ -712,9 +695,8 @@ static void *fv_queue_thread(void *opaque)
> > >>>                         break;
> > >>>                 }
> > >>>                 assert(pf[0].revents & POLLIN);
> > >>> -               if (qi->virtio_dev->se->debug)
> > >>> -                       fuse_debug("%s: Got queue event on Queue %d\n",
> > >>> -				  __func__, qi->qidx);
> > >>> +	       fuse_debug("%s: Got queue event on Queue %d\n",
> > >>> +			  __func__, qi->qidx);
> > >>>  
> > >>>                 eventfd_t evalue;
> > >>>                 if (eventfd_read(qi->kick_fd, &evalue)) {
> > >>> @@ -728,15 +710,13 @@ static void *fv_queue_thread(void *opaque)
> > >>>  
> > >>>                 pthread_mutex_lock(&qi->vq_lock);
> > >>>  
> > >>> -               if (se->debug) {
> > >>> -                       /* out is from guest, in is too guest */
> > >>> -                       unsigned int in_bytes, out_bytes;
> > >>> -                       vu_queue_get_avail_bytes(dev, q, &in_bytes, &out_bytes, ~0, ~0);
> > >>> +	       /* out is from guest, in is too guest */
> > >>> +	       unsigned int in_bytes, out_bytes;
> > >>> +	       vu_queue_get_avail_bytes(dev, q, &in_bytes, &out_bytes, ~0, ~0);
> > >>>  
> > >>> -                       fuse_debug("%s: Queue %d gave evalue: %zx available: in: %u out: %u\n",
> > >>> -				  __func__, qi->qidx, (size_t)evalue, in_bytes,
> > >>> -				  out_bytes);
> > >>> -               }
> > >>> +	       fuse_debug("%s: Queue %d gave evalue: %zx available: in: %u out: %u\n",
> > >>> +			  __func__, qi->qidx, (size_t)evalue, in_bytes,
> > >>> +			  out_bytes);
> > >>>  
> > >>>                 while (1) {
> > >>>                         unsigned int bad_in_num = 0, bad_out_num = 0;
> > >>> @@ -871,8 +851,7 @@ int virtio_loop(struct fuse_session *se)
> > >>>                 pf[0].events = POLLIN;
> > >>>                 pf[0].revents = 0;
> > >>>  
> > >>> -               if (se->debug)
> > >>> -                       fuse_debug("%s: Waiting for VU event\n", __func__);
> > >>> +	       fuse_debug("%s: Waiting for VU event\n", __func__);
> > >>>                 int poll_res = ppoll(pf, 1, NULL, NULL);
> > >>>  
> > >>>                 if (poll_res == -1) {
> > >>> @@ -890,8 +869,7 @@ int virtio_loop(struct fuse_session *se)
> > >>>                         break;
> > >>>                 }
> > >>>                 assert(pf[0].revents & POLLIN);
> > >>> -               if (se->debug)
> > >>> -                       fuse_debug("%s: Got VU event\n", __func__);
> > >>> +	       fuse_debug("%s: Got VU event\n", __func__);
> > >>>  
> > >>>                 /* Mutual exclusion with fv_queue_thread() */
> > >>>                 ret = pthread_rwlock_wrlock(&se->virtio_dev->vu_dispatch_rwlock);
> > >>> @@ -1058,9 +1036,7 @@ ssize_t fuse_virtio_write(fuse_req_t req,
> > >>>  	msg.flags[0] = VHOST_USER_FS_FLAG_MAP_W;
> > >>>  
> > >>>  	int64_t result = fuse_virtio_io(req->se, &msg, dst->fd);
> > >>> -        if (req->se->debug) {
> > >>> -                fuse_debug("%s: result=%ld\n", __func__, result);
> > >>> -        }
> > >>> +	fuse_debug("%s: result=%ld\n", __func__, result);
> > >>>  	return result;
> > >>>  }
> > >>>  
> > >>> diff --git a/contrib/virtiofsd/helper.c b/contrib/virtiofsd/helper.c
> > >>> index 5eae1f530aae..dc80100e8594 100644
> > >>> --- a/contrib/virtiofsd/helper.c
> > >>> +++ b/contrib/virtiofsd/helper.c
> > >>> @@ -27,6 +27,8 @@
> > >>>  
> > >>>  #define FUSE_HELPER_OPT(t, p) \
> > >>>  	{ t, offsetof(struct fuse_cmdline_opts, p), 1 }
> > >>> +#define FUSE_HELPER_OPT_VALUE(t, p, v) \
> > >>> +	{ t, offsetof(struct fuse_cmdline_opts, p), v }
> > >>>  
> > >>>  static const struct fuse_opt fuse_helper_opts[] = {
> > >>>  	FUSE_HELPER_OPT("-h",		show_help),
> > >>> @@ -50,6 +52,10 @@ static const struct fuse_opt fuse_helper_opts[] = {
> > >>>  	FUSE_HELPER_OPT("clone_fd",	clone_fd),
> > >>>  	FUSE_HELPER_OPT("max_idle_threads=%u", max_idle_threads),
> > >>>  	FUSE_HELPER_OPT("--syslog",	syslog),
> > >>> +	FUSE_HELPER_OPT_VALUE("log_level=debug", log_level, LOG_DEBUG),
> > >>> +	FUSE_HELPER_OPT_VALUE("log_level=info", log_level, LOG_INFO),
> > >>> +	FUSE_HELPER_OPT_VALUE("log_level=warn", log_level, LOG_WARNING),
> > >>> +	FUSE_HELPER_OPT_VALUE("log_level=err", log_level, LOG_ERR),
> > >>>  	FUSE_OPT_END
> > >>>  };
> > >>>  
> > >>> @@ -137,7 +143,9 @@ void fuse_cmdline_help(void)
> > >>>  	       "    -o clone_fd                use separate fuse device fd for each thread\n"
> > >>>  	       "                               (may improve performance)\n"
> > >>>  	       "    -o max_idle_threads        the maximum number of idle worker threads\n"
> > >>> -	       "                               allowed (default: 10)\n");
> > >>> +	       "                               allowed (default: 10)\n"
> > >>> +	       "    -o log_level=<level>       log level, default to \"info\"\n"
> > >>> +	       "                               level could be one of \"debug, info, warn, err\"\n");
> > >>>  }
> > >>>  
> > >>>  static int fuse_helper_opt_proc(void *data, const char *arg, int key,
> > >>> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > >>> index 321bbb20be65..583e9685161f 100644
> > >>> --- a/contrib/virtiofsd/passthrough_ll.c
> > >>> +++ b/contrib/virtiofsd/passthrough_ll.c
> > >>> @@ -36,6 +36,7 @@
> > >>>  
> > >>>  #include "fuse_virtio.h"
> > >>>  #include "fuse_lowlevel.h"
> > >>> +#include "fuse_log.h"
> > >>>  #include <unistd.h>
> > >>>  #include <stdlib.h>
> > >>>  #include <stdio.h>
> > >>> @@ -421,11 +422,6 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino)
> > >>>  	return fd;
> > >>>  }
> > >>>  
> > >>> -static bool lo_debug(fuse_req_t req)
> > >>> -{
> > >>> -	return lo_data(req)->debug != 0;
> > >>> -}
> > >>> -
> > >>>  static void lo_init(void *userdata,
> > >>>  		    struct fuse_conn_info *conn)
> > >>>  {
> > >>> @@ -436,18 +432,15 @@ static void lo_init(void *userdata,
> > >>>  
> > >>>  	if (lo->writeback &&
> > >>>  	    conn->capable & FUSE_CAP_WRITEBACK_CACHE) {
> > >>> -		if (lo->debug)
> > >>> -			fuse_debug("lo_init: activating writeback\n");
> > >>> +		fuse_debug("lo_init: activating writeback\n");
> > >>>  		conn->want |= FUSE_CAP_WRITEBACK_CACHE;
> > >>>  	}
> > >>>  	if (conn->capable & FUSE_CAP_FLOCK_LOCKS) {
> > >>>  		if (lo->flock) {
> > >>> -			if (lo->debug)
> > >>> -				fuse_debug("lo_init: activating flock locks\n");
> > >>> +			fuse_debug("lo_init: activating flock locks\n");
> > >>>  			conn->want |= FUSE_CAP_FLOCK_LOCKS;
> > >>>  		} else {
> > >>> -			if (lo->debug)
> > >>> -				fuse_debug("lo_init: disabling flock locks\n");
> > >>> +			fuse_debug("lo_init: disabling flock locks\n");
> > >>>  			conn->want &= ~FUSE_CAP_FLOCK_LOCKS;
> > >>>  		}
> > >>>  	}
> > >>> @@ -455,20 +448,17 @@ static void lo_init(void *userdata,
> > >>>  
> > >>>  	if (conn->capable & FUSE_CAP_POSIX_LOCKS) {
> > >>>  		if (lo->posix_lock) {
> > >>> -			if (lo->debug)
> > >>> -				fuse_debug("lo_init: activating posix locks\n");
> > >>> +			fuse_debug("lo_init: activating posix locks\n");
> > >>>  			conn->want |= FUSE_CAP_POSIX_LOCKS;
> > >>>  		} else {
> > >>> -			if (lo->debug)
> > >>> -				fuse_debug("lo_init: disabling posix locks\n");
> > >>> +			fuse_debug("lo_init: disabling posix locks\n");
> > >>>  			conn->want &= ~FUSE_CAP_POSIX_LOCKS;
> > >>>  		}
> > >>>  	}
> > >>>  
> > >>>  	if ((lo->cache == CACHE_NONE && !lo->readdirplus_set) ||
> > >>>  	    lo->readdirplus_clear || lo->shared) {
> > >>> -		if (lo->debug)
> > >>> -			fuse_debug("lo_init: disabling readdirplus\n");
> > >>> +		fuse_debug("lo_init: disabling readdirplus\n");
> > >>>  		conn->want &= ~FUSE_CAP_READDIRPLUS;
> > >>>  	}
> > >>>  }
> > >>> @@ -909,12 +899,11 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > >>>  	lo_inode_put(lo, &inode);
> > >>>  	lo_inode_put(lo, &dir);
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("  %lli/%s -> %lli (version_table[%lli]=%lli)\n",
> > >>> -			   (unsigned long long) parent, name,
> > >>> -			   (unsigned long long) e->ino,
> > >>> -			   (unsigned long long) e->version_offset,
> > >>> -			   (unsigned long long) e->initial_version);
> > >>> +	fuse_debug("  %lli/%s -> %lli (version_table[%lli]=%lli)\n",
> > >>> +		   (unsigned long long) parent, name,
> > >>> +		   (unsigned long long) e->ino,
> > >>> +		   (unsigned long long) e->version_offset,
> > >>> +		   (unsigned long long) e->initial_version);
> > >>>  
> > >>>  	return 0;
> > >>>  
> > >>> @@ -932,9 +921,7 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
> > >>>  	struct fuse_entry_param e;
> > >>>  	int err;
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_lookup(parent=%" PRIu64 ", name=%s)\n",
> > >>> -			   parent, name);
> > >>> +	fuse_debug("lo_lookup(parent=%" PRIu64 ", name=%s)\n", parent, name);
> > >>>  
> > >>>  	/* Don't use is_safe_path_component(), allow "." and ".." for NFS export
> > >>>  	 * support.
> > >>> @@ -1040,10 +1027,9 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
> > >>>  	if (saverr)
> > >>>  		goto out;
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("  %lli/%s -> %lli\n",
> > >>> -			   (unsigned long long) parent, name,
> > >>> -			   (unsigned long long) e.ino);
> > >>> +	fuse_debug("  %lli/%s -> %lli\n",
> > >>> +		   (unsigned long long) parent, name,
> > >>> +		   (unsigned long long) e.ino);
> > >>>  
> > >>>  	fuse_reply_entry(req, &e, lo->shared);
> > >>>  	lo_inode_put(lo, &dir);
> > >>> @@ -1149,10 +1135,9 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
> > >>>  	update_version(lo, inode);
> > >>>  	update_version(lo, parent_inode);
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("  %lli/%s -> %lli\n",
> > >>> -			   (unsigned long long) parent, name,
> > >>> -			   (unsigned long long) e.ino);
> > >>> +	fuse_debug("  %lli/%s -> %lli\n",
> > >>> +		   (unsigned long long) parent, name,
> > >>> +		   (unsigned long long) e.ino);
> > >>>  
> > >>>  	fuse_reply_entry(req, &e, lo->shared);
> > >>>  	lo_inode_put(lo, &parent_inode);
> > >>> @@ -1355,12 +1340,10 @@ static void lo_forget_one(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
> > >>>  	if (!inode)
> > >>>  		return;
> > >>>  
> > >>> -	if (lo_debug(req)) {
> > >>> -		fuse_debug("  forget %lli %lli -%lli\n",
> > >>> -			   (unsigned long long) ino,
> > >>> -			   (unsigned long long) inode->nlookup,
> > >>> -			   (unsigned long long) nlookup);
> > >>> -	}
> > >>> +	fuse_debug("  forget %lli %lli -%lli\n",
> > >>> +		   (unsigned long long) ino,
> > >>> +		   (unsigned long long) inode->nlookup,
> > >>> +		   (unsigned long long) nlookup);
> > >>>  
> > >>>  	unref_inode(lo, inode, nlookup);
> > >>>  	lo_inode_put(lo, &inode);
> > >>> @@ -1642,9 +1625,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> > >>>  	int err;
> > >>>  	struct lo_cred old = {};
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_create(parent=%" PRIu64 ", name=%s)\n",
> > >>> -			   parent, name);
> > >>> +	fuse_debug("lo_create(parent=%" PRIu64 ", name=%s)\n", parent, name);
> > >>>  
> > >>>  	if (!is_safe_path_component(name)) {
> > >>>  		fuse_reply_err(req, EINVAL);
> > >>> @@ -1744,11 +1725,10 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
> > >>>  	struct lo_inode_plock *plock;
> > >>>  	int ret, saverr = 0;
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_getlk(ino=%" PRIu64 ", flags=%d)"
> > >>> -			   " owner=0x%lx, l_type=%d l_start=0x%lx"
> > >>> -			   " l_len=0x%lx\n", ino, fi->flags, fi->lock_owner,
> > >>> -			   lock->l_type, lock->l_start, lock->l_len);
> > >>> +	fuse_debug("lo_getlk(ino=%" PRIu64 ", flags=%d)"
> > >>> +		   " owner=0x%lx, l_type=%d l_start=0x%lx"
> > >>> +		   " l_len=0x%lx\n", ino, fi->flags, fi->lock_owner,
> > >>> +		   lock->l_type, lock->l_start, lock->l_len);
> > >>>  
> > >>>  	inode = lo_inode(req, ino);
> > >>>  	if (!inode) {
> > >>> @@ -1786,12 +1766,11 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
> > >>>  	struct lo_inode_plock *plock;
> > >>>  	int ret, saverr = 0;
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_setlk(ino=%" PRIu64 ", flags=%d)"
> > >>> -			   " cmd=%d pid=%d owner=0x%lx sleep=%d l_whence=%d"
> > >>> -		           " l_start=0x%lx l_len=0x%lx\n", ino, fi->flags,
> > >>> -			   lock->l_type, lock->l_pid, fi->lock_owner, sleep,
> > >>> -			   lock->l_whence, lock->l_start, lock->l_len);
> > >>> +	fuse_debug("lo_setlk(ino=%" PRIu64 ", flags=%d)"
> > >>> +		   " cmd=%d pid=%d owner=0x%lx sleep=%d l_whence=%d"
> > >>> +		   " l_start=0x%lx l_len=0x%lx\n", ino, fi->flags,
> > >>> +		   lock->l_type, lock->l_pid, fi->lock_owner, sleep,
> > >>> +		   lock->l_whence, lock->l_start, lock->l_len);
> > >>>  
> > >>>  	if (sleep) {
> > >>>  		fuse_reply_err(req, EOPNOTSUPP);
> > >>> @@ -1860,9 +1839,7 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
> > >>>  	char buf[64];
> > >>>  	struct lo_data *lo = lo_data(req);
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_open(ino=%" PRIu64 ", flags=%d)\n",
> > >>> -			   ino, fi->flags);
> > >>> +	fuse_debug("lo_open(ino=%" PRIu64 ", flags=%d)\n", ino, fi->flags);
> > >>>  
> > >>>  	/* With writeback cache, kernel may send read requests even
> > >>>  	   when userspace opened write-only */
> > >>> @@ -1965,9 +1942,7 @@ static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
> > >>>  	int fd;
> > >>>  	char *buf;
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_fsync(ino=%" PRIu64 ", fi=0x%p)\n", ino,
> > >>> -			   (void *)fi);
> > >>> +	fuse_debug("lo_fsync(ino=%" PRIu64 ", fi=0x%p)\n", ino, (void *)fi);
> > >>>  
> > >>>  	if (!fi) {
> > >>>  		res = asprintf(&buf, "%i", lo_fd(req, ino));
> > >>> @@ -1995,9 +1970,8 @@ static void lo_read(fuse_req_t req, fuse_ino_t ino, size_t size,
> > >>>  {
> > >>>  	struct fuse_bufvec buf = FUSE_BUFVEC_INIT(size);
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_read(ino=%" PRIu64 ", size=%zd, "
> > >>> -			   "off=%lu)\n", ino, size, (unsigned long) offset);
> > >>> +	fuse_debug("lo_read(ino=%" PRIu64 ", size=%zd, "
> > >>> +		   "off=%lu)\n", ino, size, (unsigned long) offset);
> > >>>  
> > >>>  	buf.buf[0].flags = FUSE_BUF_IS_FD | FUSE_BUF_FD_SEEK;
> > >>>  	buf.buf[0].fd = lo_fi_fd(req, fi);
> > >>> @@ -2019,9 +1993,8 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
> > >>>  	out_buf.buf[0].fd = lo_fi_fd(req, fi);
> > >>>  	out_buf.buf[0].pos = off;
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n",
> > >>> -			   ino, out_buf.buf[0].size, (unsigned long) off);
> > >>> +	fuse_debug("lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n",
> > >>> +		   ino, out_buf.buf[0].size, (unsigned long) off);
> > >>>  
> > >>>  	res = fuse_buf_copy(req, &out_buf, in_buf, 0);
> > >>>  	if(res < 0) {
> > >>> @@ -2105,10 +2078,8 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
> > >>>  	if (!lo_data(req)->xattr)
> > >>>  		goto out;
> > >>>  
> > >>> -	if (lo_debug(req)) {
> > >>> -		fuse_debug("lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
> > >>> -			   ino, name, size);
> > >>> -	}
> > >>> +	fuse_debug("lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
> > >>> +		   ino, name, size);
> > >>>  
> > >>>  	if (inode->is_symlink) {
> > >>>  		/* Sorry, no race free way to getxattr on symlink. */
> > >>> @@ -2180,10 +2151,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
> > >>>  	if (!lo_data(req)->xattr)
> > >>>  		goto out;
> > >>>  
> > >>> -	if (lo_debug(req)) {
> > >>> -		fuse_debug("lo_listxattr(ino=%" PRIu64 ", size=%zd)\n",
> > >>> -			   ino, size);
> > >>> -	}
> > >>> +	fuse_debug("lo_listxattr(ino=%" PRIu64 ", size=%zd)\n", ino, size);
> > >>>  
> > >>>  	if (inode->is_symlink) {
> > >>>  		/* Sorry, no race free way to listxattr on symlink. */
> > >>> @@ -2255,10 +2223,8 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
> > >>>  	if (!lo_data(req)->xattr)
> > >>>  		goto out;
> > >>>  
> > >>> -	if (lo_debug(req)) {
> > >>> -		fuse_debug("lo_setxattr(ino=%" PRIu64 ", name=%s value=%s size=%zd)\n",
> > >>> -			   ino, name, value, size);
> > >>> -	}
> > >>> +	fuse_debug("lo_setxattr(ino=%" PRIu64 ", name=%s value=%s size=%zd)\n",
> > >>> +		   ino, name, value, size);
> > >>>  
> > >>>  	if (inode->is_symlink) {
> > >>>  		/* Sorry, no race free way to removexattr on symlink. */
> > >>> @@ -2306,10 +2272,7 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
> > >>>  	if (!lo_data(req)->xattr)
> > >>>  		goto out;
> > >>>  
> > >>> -	if (lo_debug(req)) {
> > >>> -		fuse_debug("lo_removexattr(ino=%" PRIu64 ", name=%s)\n",
> > >>> -			   ino, name);
> > >>> -	}
> > >>> +	fuse_debug("lo_removexattr(ino=%" PRIu64 ", name=%s)\n", ino, name);
> > >>>  
> > >>>  	if (inode->is_symlink) {
> > >>>  		/* Sorry, no race free way to setxattr on symlink. */
> > >>> @@ -2351,12 +2314,11 @@ static void lo_copy_file_range(fuse_req_t req, fuse_ino_t ino_in, off_t off_in,
> > >>>  	in_fd = lo_fi_fd(req, fi_in);
> > >>>  	out_fd = lo_fi_fd(req, fi_out);
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_copy_file_range(ino=%" PRIu64 "/fd=%d, "
> > >>> -				"off=%lu, ino=%" PRIu64 "/fd=%d, "
> > >>> -				"off=%lu, size=%zd, flags=0x%x)\n",
> > >>> -			   ino_in, in_fd, off_in, ino_out, out_fd, off_out, len,
> > >>> -			   flags);
> > >>> +	fuse_debug("lo_copy_file_range(ino=%" PRIu64 "/fd=%d, "
> > >>> +	           "off=%lu, ino=%" PRIu64 "/fd=%d, "
> > >>> +		   "off=%lu, size=%zd, flags=0x%x)\n",
> > >>> +		   ino_in, in_fd, off_in, ino_out, out_fd, off_out, len,
> > >>> +		   flags);
> > >>>  
> > >>>  	res = copy_file_range(in_fd, &off_in, out_fd, &off_out, len, flags);
> > >>>  	if (res < 0)
> > >>> @@ -2377,11 +2339,10 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
> > >>>  	char *buf;
> > >>>          bool writable = flags & O_RDWR;
> > >>>  
> > >>> -	if (lo_debug(req))
> > >>> -		fuse_debug("lo_setupmapping(ino=%" PRIu64 ", fi=0x%p,"
> > >>> -			   " foffset=%" PRIu64 ", len=%" PRIu64
> > >>> -			   ", moffset=%" PRIu64 ", flags=%" PRIu64 ")\n", ino,
> > >>> -			   (void *)fi, foffset, len, moffset, flags);
> > >>> +	fuse_debug("lo_setupmapping(ino=%" PRIu64 ", fi=0x%p,"
> > >>> +		   " foffset=%" PRIu64 ", len=%" PRIu64
> > >>> +		   ", moffset=%" PRIu64 ", flags=%" PRIu64 ")\n", ino,
> > >>> +		   (void *)fi, foffset, len, moffset, flags);
> > >>>   
> > >>>          vhu_flags = VHOST_USER_FS_FLAG_MAP_R;
> > >>>          if (writable)
> > >>> @@ -2878,7 +2839,16 @@ int main(int argc, char *argv[])
> > >>>  	if (fuse_opt_parse(&args, &lo, lo_opts, NULL)== -1)
> > >>>  		goto err_out1;
> > >>>  
> > >>> +	/*
> > >>> +	 * log_level is 0 if not configured via cmd options (0 is LOG_EMERG,
> > >>> +	 * and we don't use this log level).
> > >>> +	 */
> > >>> +	if (opts.log_level != 0)
> > >>> +		current_log_level = opts.log_level;
> > >>>  	lo.debug = opts.debug;
> > >>> +	if (lo.debug)
> > >>> +		current_log_level = LOG_DEBUG;
> > >>> +
> > >>>  	if (lo.source) {
> > >>>  		struct stat stat;
> > >>>  		int res;
> > >>>
> > >>
> > >> _______________________________________________
> > >> Virtio-fs mailing list
> > >> Virtio-fs@redhat.com
> > >> https://www.redhat.com/mailman/listinfo/virtio-fs
> > > .
> > > 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

