Date: Wed, 14 Aug 2019 08:43:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190814124339.GA32294@redhat.com>
References: <20190813192944.26009-1-vgoyal@redhat.com>
	<20190813192944.26009-5-vgoyal@redhat.com>
	<20190814095216.GD2920@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814095216.GD2920@work-vm>
Subject: Re: [Virtio-fs] [PATCH 4/4] virtiofsd: Drop CAP_FSETID if client
	asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On Wed, Aug 14, 2019 at 10:52:16AM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > If client requested killing setuid/setgid bits on file being written, drop
> > CAP_FSETID capability so that setuid/setgid bits are cleared upon write
> > automatically.
> > 
> > pjdfstest chown/12.t needs this.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Some high level questions:
>   a) This is going to be *really* expensive isn't it - that's a lot of
> syscalls for each write
> 
>   b) and isn't this the normal case, i.e. a non-root guest writing to a
> normal file?

Hi David,

FUSE_WRITE_KILL_PRIV flag will not be set frequently. It is set only
if a write happens to a file which has setuid/setgid bit set. Very
few files in filesystem typically have this bit set and for those
also it will be set only for first write and not subsequent writes.

So I will not be worried about performance impact of it.

> 
>   c) I guess an unpriv virtiofsd still works OK because the cap is
> already gone.
> 
>   d) How is this thread safe?  My reading is cap_set_proc is process
> wide; you'd have other writesin other threads doing non-kill-priv
> writes; also you'd have multiple threads doing   (clear) write (set) -
> that feels like they'd interact badly.

man page of capabilities says that its a per thread property.

**************************
       Starting with kernel 2.2, Linux divides  the  privileges  traditionally
       associated  with  superuser into distinct units, known as capabilities,
       which can be independently enabled and disabled.   Capabilities  are  a
       per-thread attribute.
**************************

So dropping capability per thread and enabling it back should be fine.

> 
>   e) I think you could share some stuff between the drop and the
> restore;  for example you only ever need to do cap_from_name once
> in the entire run.   You can probably also do teh cap_get_proc when
> you drop it, keep that 'caps' around and then set it again.

Given its not a very frequent operation, I am not too worried about
it. It will just make code structure little more complicated. 

But if you have strong opinion about it, I am open to change it.

Thanks
Vivek

> 
> 
> Dave
> 
> > ---
> >  contrib/virtiofsd/Makefile.objs    |   2 +
> >  contrib/virtiofsd/passthrough_ll.c | 127 +++++++++++++++++++++++++++++
> >  contrib/virtiofsd/seccomp.c        |   2 +
> >  3 files changed, 131 insertions(+)
> > 
> > diff --git a/contrib/virtiofsd/Makefile.objs b/contrib/virtiofsd/Makefile.objs
> > index 941b19f18e..25f1e8dd73 100644
> > --- a/contrib/virtiofsd/Makefile.objs
> > +++ b/contrib/virtiofsd/Makefile.objs
> > @@ -11,3 +11,5 @@ virtiofsd-obj-y = buffer.o \
> >  
> >  seccomp.o-cflags := $(SECCOMP_CFLAGS)
> >  seccomp.o-libs := $(SECCOMP_LIBS)
> > +
> > +passthrough_ll.o-libs += -lcap
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index 321bbb20be..412663653a 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -56,6 +56,7 @@
> >  #include <sys/mman.h>
> >  #include <sys/socket.h>
> >  #include <sys/un.h>
> > +#include <sys/capability.h>
> >  
> >  #include "ireg.h"
> >  #include <sys/mount.h>
> > @@ -230,6 +231,115 @@ static struct lo_data *lo_data(fuse_req_t req)
> >  	return (struct lo_data *) fuse_req_userdata(req);
> >  }
> >  
> > +/* Helpers for dropping and regaining effective capabilities. Returns 0
> > + * on success, error otherwise  */
> > +static int drop_effective_cap(const char *cap_name, bool *cap_dropped)
> > +{
> > +	cap_t caps;
> > +	cap_value_t cap;
> > +	cap_flag_value_t cap_value;
> > +	int ret = 0;
> > +
> > +	ret = cap_from_name(cap_name, &cap);
> > +	if (ret == -1) {
> > +		ret = errno;
> > +		fuse_err("cap_from_name(%s) failed:%s\n", cap_name,
> > +			 strerror(errno));
> > +		goto out;
> > +	}
> > +
> > +	if (!CAP_IS_SUPPORTED(cap)) {
> > +		fuse_err("capability(%s) is not supported\n", cap_name);
> > +		return EINVAL;
> > +	}
> > +
> > +	caps = cap_get_proc();
> > +	if (caps == NULL) {
> > +		ret = errno;
> > +		fuse_err("cap_get_proc() failed\n");
> > +		goto out;
> > +	}
> > +
> > +	if (cap_get_flag(caps, cap, CAP_EFFECTIVE, &cap_value) == -1) {
> > +		ret = errno;
> > +		fuse_err("cap_get_flag() failed\n");
> > +		goto out_cap_free;
> > +	}
> > +
> > +	/* We dont have this capability in effective set already. */
> > +	if (cap_value == CAP_CLEAR) {
> > +		ret = 0;
> > +		goto out_cap_free;
> > +	}
> > +
> > +	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap, CAP_CLEAR) == -1) {
> > +		ret = errno;
> > +		fuse_err("cap_set_flag() failed\n");
> > +		goto out_cap_free;
> > +	}
> > +
> > +	if (cap_set_proc(caps) == -1) {
> > +		ret = errno;
> > +		fuse_err("cap_set_procs() failed\n");
> > +		goto out_cap_free;
> > +	}
> > +
> > +	ret = 0;
> > +	if (cap_dropped)
> > +		*cap_dropped = true;
> > +
> > +out_cap_free:
> > +	cap_free(caps);
> > +out:
> > +	return ret;
> > +}
> > +
> > +static int gain_effective_cap(const char *cap_name)
> > +{
> > +	cap_t caps;
> > +	cap_value_t cap;
> > +	int ret = 0;
> > +
> > +	ret = cap_from_name(cap_name, &cap);
> > +	if (ret == -1) {
> > +		ret = errno;
> > +		fuse_err("cap_from_name(%s) failed:%s\n", cap_name,
> > +			 strerror(errno));
> > +		goto out;
> > +	}
> > +
> > +	if (!CAP_IS_SUPPORTED(cap)) {
> > +		fuse_err("capability(%s) is not supported\n", cap_name);
> > +		return EINVAL;
> > +	}
> > +
> > +	caps = cap_get_proc();
> > +	if (caps == NULL) {
> > +		ret = errno;
> > +		fuse_err("cap_get_proc() failed\n");
> > +		goto out;
> > +	}
> > +
> > +
> > +	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap, CAP_SET) == -1) {
> > +		ret = errno;
> > +		fuse_err("cap_set_flag() failed\n");
> > +		goto out_cap_free;
> > +	}
> > +
> > +	if (cap_set_proc(caps) == -1) {
> > +		ret = errno;
> > +		fuse_err("cap_set_procs() failed\n");
> > +		goto out_cap_free;
> > +	}
> > +	ret = 0;
> > +
> > +out_cap_free:
> > +	cap_free(caps);
> > +out:
> > +	return ret;
> > +}
> > +
> >  static void lo_map_init(struct lo_map *map)
> >  {
> >  	map->elems = NULL;
> > @@ -2014,6 +2124,7 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
> >  	ssize_t res;
> >  	struct fuse_bufvec out_buf = FUSE_BUFVEC_INIT(fuse_buf_size(in_buf));
> >  	struct lo_data *lo = lo_data(req);
> > +	bool cap_fsetid_dropped = false;
> >  
> >  	out_buf.buf[0].flags = FUSE_BUF_IS_FD | FUSE_BUF_FD_SEEK;
> >  	out_buf.buf[0].fd = lo_fi_fd(req, fi);
> > @@ -2023,6 +2134,16 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
> >  		fuse_debug("lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n",
> >  			   ino, out_buf.buf[0].size, (unsigned long) off);
> >  
> > +	/*
> > +	 * If kill_priv is set, drop CAP_FSETID which should lead to kernel
> > +	 * clearing setuid/setgid on file.
> > +	 */
> > +	if (fi->kill_priv) {
> > +		res = drop_effective_cap("cap_fsetid", &cap_fsetid_dropped);
> > +		if (res != 0)
> > +			fuse_reply_err(req, res);
> > +	}
> > +
> >  	res = fuse_buf_copy(req, &out_buf, in_buf, 0);
> >  	if(res < 0) {
> >  		fuse_reply_err(req, -res);
> > @@ -2037,6 +2158,12 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
> >  
> >  		fuse_reply_write(req, (size_t) res);
> >  	}
> > +
> > +	if (cap_fsetid_dropped) {
> > +		res = gain_effective_cap("cap_fsetid");
> > +		if (res)
> > +			fuse_err("Failed to gain CAP_FSETID\n");
> > +	}
> >  }
> >  
> >  static void lo_statfs(fuse_req_t req, fuse_ino_t ino)
> > diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
> > index 5f1c873b82..7384ebee0a 100644
> > --- a/contrib/virtiofsd/seccomp.c
> > +++ b/contrib/virtiofsd/seccomp.c
> > @@ -78,6 +78,8 @@ static const int syscall_whitelist[] = {
> >  	SCMP_SYS(unlinkat),
> >  	SCMP_SYS(utimensat),
> >  	SCMP_SYS(write),
> > +	SCMP_SYS(capget),
> > +	SCMP_SYS(capset),
> >  };
> >  
> >  /* Syscalls used when --syslog is enabled */
> > -- 
> > 2.17.2
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

