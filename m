Date: Fri, 9 Oct 2020 14:24:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201009182424.GA44737@redhat.com>
References: <20200916163553.GA39212@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916163553.GA39212@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add support for
 FUSE_HANDLE_KILLPRIV_V2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Sep 16, 2020 at 12:35:53PM -0400, Vivek Goyal wrote:
> This patch adds basic support for FUSE_HANDLE_KILLPRIV_V2. virtiofsd
> can enable/disable this by specifying option "-o killpriv_v2/no_killpriv_v2".
> By default this is enabled as long as client supports it.
> 
> I have posted corresponding kernel patches here.
> 
> https://www.redhat.com/archives/virtio-fs/2020-September/msg00054.html

I have posted of V3 of kernel patches now. This patch remains unchanged.

https://lore.kernel.org/linux-fsdevel/20201009181512.65496-1-vgoyal@redhat.com/T/#m4a6ba7d6bc9defdde0882cf21b89b768ce837663

Thanks
Vivek

> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  include/standard-headers/linux/fuse.h |  10 ++-
>  tools/virtiofsd/fuse_common.h         |  10 +++
>  tools/virtiofsd/fuse_lowlevel.c       |  10 ++-
>  tools/virtiofsd/fuse_lowlevel.h       |   1 +
>  tools/virtiofsd/passthrough_ll.c      | 116 ++++++++++++++++++++++++--
>  5 files changed, 136 insertions(+), 11 deletions(-)
> 
> diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
> index 26e7de1b43..744498bc5a 100644
> --- a/include/standard-headers/linux/fuse.h
> +++ b/include/standard-headers/linux/fuse.h
> @@ -338,6 +338,7 @@ struct fuse_file_lock {
>  #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
>  #define FUSE_EXPLICIT_INVAL_DATA (1 << 25)
>  #define FUSE_MAP_ALIGNMENT	(1 << 26)
> +#define FUSE_HANDLE_KILLPRIV_V2	(1 << 27)
>  
>  /**
>   * CUSE INIT request/reply flags
> @@ -413,6 +414,13 @@ struct fuse_file_lock {
>   */
>  #define FUSE_FSYNC_FDATASYNC	(1 << 0)
>  
> +/**
> + * Open flags
> + * FUSE_OPEN_KILL_PRIV: Kill suid/sgid/security.capability. sgid is cleared
> + *                      only if file has group execute permission.
> + */
> +#define FUSE_OPEN_KILL_PRIV    (1 << 0)
> +
>  enum fuse_opcode {
>  	FUSE_LOOKUP		= 1,
>  	FUSE_FORGET		= 2,  /* no reply */
> @@ -579,7 +587,7 @@ struct fuse_setattr_in {
>  
>  struct fuse_open_in {
>  	uint32_t	flags;
> -	uint32_t	unused;
> +	uint32_t	open_flags;
>  };
>  
>  struct fuse_create_in {
> diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
> index aa7e6ed31a..a8d8217687 100644
> --- a/tools/virtiofsd/fuse_common.h
> +++ b/tools/virtiofsd/fuse_common.h
> @@ -352,6 +352,16 @@ struct fuse_file_info {
>   */
>  #define FUSE_CAP_NO_OPENDIR_SUPPORT (1 << 24)
>  
> +/**
> + * Indicates that the filesystem is responsible for unsetting
> + * setuid and setgid bits when a file is written, truncated, or
> + * its owner is changed. setuid/setgid is cleared on WRITE/truncate
> + * only if caller does not have CAP_FSETID. For WRITE requests
> + * this is communicated through write flag FUSE_WRITE_KILL_PRIV.
> + *
> + */
> +#define FUSE_CAP_HANDLE_KILLPRIV_V2 (1 << 27)
> +
>  /**
>   * Ioctl flags
>   *
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index a34a611a90..90afffd6de 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -881,7 +881,7 @@ static void do_setattr(fuse_req_t req, fuse_ino_t nodeid,
>                        FUSE_SET_ATTR_GID | FUSE_SET_ATTR_SIZE |
>                        FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME |
>                        FUSE_SET_ATTR_ATIME_NOW | FUSE_SET_ATTR_MTIME_NOW |
> -                      FUSE_SET_ATTR_CTIME;
> +                      FUSE_SET_ATTR_CTIME | FUSE_SET_ATTR_KILL_PRIV;
>  
>          req->se->op.setattr(req, nodeid, &stbuf, arg->valid, fi);
>      } else {
> @@ -1118,6 +1118,7 @@ static void do_open(fuse_req_t req, fuse_ino_t nodeid,
>  
>      memset(&fi, 0, sizeof(fi));
>      fi.flags = arg->flags;
> +    fi.kill_priv = arg->open_flags & FUSE_OPEN_KILL_PRIV;
>  
>      if (req->se->op.open) {
>          req->se->op.open(req, nodeid, &fi);
> @@ -2081,6 +2082,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
>              bufsize = max_bufsize;
>          }
>      }
> +    if (arg->flags & FUSE_HANDLE_KILLPRIV_V2) {
> +        se->conn.capable |= FUSE_CAP_HANDLE_KILLPRIV_V2;
> +    }
>  #ifdef HAVE_SPLICE
>  #ifdef HAVE_VMSPLICE
>      se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
> @@ -2218,6 +2222,10 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
>          outarg.map_alignment = ffsl(sysconf(_SC_PAGE_SIZE)) - 1;
>      }
>  
> +    if (se->conn.want & FUSE_CAP_HANDLE_KILLPRIV_V2) {
> +        outarg.flags |= FUSE_HANDLE_KILLPRIV_V2;
> +    }
> +
>      fuse_log(FUSE_LOG_DEBUG, "   INIT: %u.%u\n", outarg.major, outarg.minor);
>      fuse_log(FUSE_LOG_DEBUG, "   flags=0x%08x\n", outarg.flags);
>      fuse_log(FUSE_LOG_DEBUG, "   max_readahead=0x%08x\n", outarg.max_readahead);
> diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
> index d488b88882..fdc256b5ce 100644
> --- a/tools/virtiofsd/fuse_lowlevel.h
> +++ b/tools/virtiofsd/fuse_lowlevel.h
> @@ -145,6 +145,7 @@ struct fuse_forget_data {
>  #define FUSE_SET_ATTR_ATIME_NOW (1 << 7)
>  #define FUSE_SET_ATTR_MTIME_NOW (1 << 8)
>  #define FUSE_SET_ATTR_CTIME (1 << 10)
> +#define FUSE_SET_ATTR_KILL_PRIV (1 << 14)
>  
>  /*
>   * Request methods and replies
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 6514674f04..33f74a1a46 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -170,6 +170,7 @@ struct lo_data {
>  
>      /* An O_PATH file descriptor to /proc/self/fd/ */
>      int proc_self_fd;
> +    int user_killpriv_v2, killpriv_v2;
>  };
>  
>  static const struct fuse_opt lo_opts[] = {
> @@ -192,6 +193,8 @@ static const struct fuse_opt lo_opts[] = {
>      { "no_shared", offsetof(struct lo_data, shared), 0 },
>      { "readdirplus", offsetof(struct lo_data, readdirplus_set), 1 },
>      { "no_readdirplus", offsetof(struct lo_data, readdirplus_clear), 1 },
> +    { "killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 1 },
> +    { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
>      FUSE_OPT_END
>  };
>  static bool use_syslog = false;
> @@ -588,6 +591,30 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
>          fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling readdirplus\n");
>          conn->want &= ~FUSE_CAP_READDIRPLUS;
>      }
> +
> +    if (lo->user_killpriv_v2 == 1) {
> +        /* User explicitly asked for this option. Enable it unconditionally.
> +         * If connection does not have this capability, it should fail
> +         * in fuse_lowlevel.c
> +         */
> +        fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling killpriv_v2\n");
> +        conn->want |= FUSE_CAP_HANDLE_KILLPRIV_V2;
> +	lo->killpriv_v2 = 1;
> +    } else if (lo->user_killpriv_v2 == -1 &&
> +               conn->capable & FUSE_CAP_HANDLE_KILLPRIV_V2) {
> +        /* User did not specify a value for killpriv_v2. By default enable it
> +         * if connection offers this capability */
> +        fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling killpriv_v2\n");
> +        conn->want |= FUSE_CAP_HANDLE_KILLPRIV_V2;
> +        lo->killpriv_v2 = 1;
> +    } else {
> +        /* Either user specified to disable killpriv_v2, or connection does
> +         * not offer this capability. Disable killpriv_v2 in both the cases
> +         */
> +        fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling killpriv_v2\n");
> +        conn->want &= ~FUSE_CAP_HANDLE_KILLPRIV_V2;
> +        lo->killpriv_v2 = 0;
> +    }
>  }
>  
>  static int64_t *version_ptr(struct lo_data *lo, struct lo_inode *inode)
> @@ -686,6 +713,14 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>          uid_t uid = (valid & FUSE_SET_ATTR_UID) ? attr->st_uid : (uid_t)-1;
>          gid_t gid = (valid & FUSE_SET_ATTR_GID) ? attr->st_gid : (gid_t)-1;
>  
> +        /* if fc->killpriv_v2 is set, change of ownership should clear
> +         * suid/sgid/caps.
> +         *
> +         * TODO: On ext4/xfs above works with fchownat() call without
> +         * doing anything extra. If there are filesystem where this
> +         * does not work, virtiofsd needs to take care of this.
> +         */
> +
>          res = fchownat(ifd, "", uid, gid, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
>          if (res == -1) {
>              goto out_err;
> @@ -693,7 +728,18 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>      }
>      if (valid & FUSE_SET_ATTR_SIZE) {
>          int truncfd;
> -
> +        bool kill_priv = lo->killpriv_v2 && (valid & FUSE_SET_ATTR_KILL_PRIV);
> +        bool cap_fsetid_dropped = false;
> +
> +        /* if fc->killpriv_v2 is set, change of size should clear caps
> +         * always. suid should be cleared if FUSE_SETATTR_KILL_PRIV is
> +         * set. And sgid should be cleared if FUSE_SETATTR_KILL_PRIV is
> +         * set as well as group execute permission is on.
> +         *
> +         * TODO: On ext4/xfs above works with truncate() call without
> +         * doing anything extra. If there are filesystem where this
> +         * does not work, virtiofsd needs to take care of this.
> +         */
>          if (fi) {
>              truncfd = fd;
>          } else {
> @@ -704,12 +750,26 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>              }
>          }
>  
> +        if (kill_priv) {
> +            res = drop_effective_cap("FSETID", &cap_fsetid_dropped);
> +            if (res != 0) {
> +                lo_inode_put(lo, &inode);
> +                fuse_reply_err(req, res);
> +            }
> +        }
>          res = ftruncate(truncfd, attr->st_size);
> +        saverr = errno;
> +        if (cap_fsetid_dropped) {
> +            res = gain_effective_cap("FSETID");
> +            if(res) {
> +                fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
> +            }
> +        }
>          if (!fi) {
> -            saverr = errno;
>              close(truncfd);
> -            errno = saverr;
>          }
> +
> +        errno = saverr;
>          if (res == -1) {
>              goto out_err;
>          }
> @@ -1943,20 +2003,45 @@ static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
>  
>  static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>  {
> -    int fd;
> +    int fd, ret, saverr;
>      ssize_t fh;
>      char buf[64];
>      struct lo_data *lo = lo_data(req);
> +    bool cap_fsetid_dropped = false;
>  
> -    fuse_log(FUSE_LOG_DEBUG, "lo_open(ino=%" PRIu64 ", flags=%d)\n", ino,
> -             fi->flags);
> +    fuse_log(FUSE_LOG_DEBUG, "lo_open(ino=%" PRIu64 ", flags=%d, kill_priv=%d)"
> +             "\n", ino, fi->flags, fi->kill_priv);
>  
>      update_open_flags(lo->writeback, fi);
>  
>      sprintf(buf, "%i", lo_fd(req, ino));
> +
> +    /*
> +     * fi->kill_priv is set if file server opted for killpriv_v2 feature
> +     * and client did open(O_TRUNC) and caller did not have CAP_FSETID.
> +     * In that case suid/sgid/security.capability needs to be killed
> +     * according to certain rules. Dropping capability does right thing
> +     * on ext4/xfs already.
> +     */
> +    if (fi->kill_priv) {
> +        ret = drop_effective_cap("FSETID", &cap_fsetid_dropped);
> +        if (ret != 0) {
> +            fuse_reply_err(req, ret);
> +            return;
> +        }
> +    }
> +
>      fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
> +    saverr = errno;
> +    if (cap_fsetid_dropped) {
> +        ret = gain_effective_cap("FSETID");
> +        if (ret) {
> +            fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
> +        }
> +    }
> +
>      if (fd == -1) {
> -        return (void)fuse_reply_err(req, errno);
> +        return (void)fuse_reply_err(req, saverr);
>      }
>  
>      pthread_mutex_lock(&lo->mutex);
> @@ -2091,8 +2176,20 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
>      out_buf.buf[0].pos = off;
>  
>      fuse_log(FUSE_LOG_DEBUG,
> -             "lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n", ino,
> -             out_buf.buf[0].size, (unsigned long)off);
> +             "lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu kill_priv=%d)\n",
> +             ino, out_buf.buf[0].size, (unsigned long)off, fi->kill_priv);
> +
> +    /*
> +     * If lo->killpriv_v2 is set, then we are supposed to kill caps
> +     * and also kill suid/sgid if fi->kill_priv is set. Current
> +     * common filesystem ext4/xfs already drop security.capability
> +     * on WRITE. So we don't have to do anything special.
> +     *
> +     * TODO: If we are running on to of a file system which does not
> +     * remove caps on WRITE, then we will have to remove it ourselves
> +     * explicitly. Same is true for removing SUID/SGID if CAP_FSETID
> +     * is not there.
> +     */
>  
>      /*
>       * If kill_priv is set, drop CAP_FSETID which should lead to kernel
> @@ -3210,6 +3307,7 @@ int main(int argc, char *argv[])
>          .writeback = 0,
>          .posix_lock = 1,
>          .proc_self_fd = -1,
> +        .user_killpriv_v2 = -1,
>      };
>      struct lo_map_elem *root_elem;
>      int ret = -1;
> -- 
> 2.25.4
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

