Date: Thu, 24 Oct 2019 11:02:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191024150225.GB6903@redhat.com>
References: <20191023122523.1816-1-misono.tomohiro@jp.fujitsu.com>
	<20191023200752.GB6942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023200752.GB6942@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix data corruption with
 O_APPEND wirte in writeback mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Oct 23, 2019 at 04:07:52PM -0400, Vivek Goyal wrote:
> On Wed, Oct 23, 2019 at 09:25:23PM +0900, Misono Tomohiro wrote:
> > When writeback mode is enabled (-o writeback), O_APPEND handling is
> > done in kernel. Therefore virtiofsd clears O_APPEND flag when open.
> > Otherwise O_APPEND flag takes precedence over pwrite() and write
> > data may corrupt.
> > 
> > Currently clearing O_APPEND flag is done in lo_open(), but we also
> > need the same operation in lo_create().
> 
> > So, factor out the flag
> > update operation in lo_open() to update_open_flags() and call it
> > in both lo_open() and lo_create().
> > 
> > This fixes the failure of xfstest generic/069 in writeback mode
> > (which tests O_APPEND write data integrity).
> > 

Hi Misono,

Have you tried running pjdfstests. Looks like with the patch applied I
see following tests failing which were passing without the patch. Can
you please have a look. I ran daemon with options "-o cache=always -o
writeback"

/root/git/pjdfstest/tests/chmod/00.t          (Wstat: 0 Tests: 119 Failed: 1)
  Failed test:  64
/root/git/pjdfstest/tests/chown/00.t          (Wstat: 0 Tests: 1323 Failed: 1)
  Failed test:  946
  TODO passed:   1107, 1112, 1116, 1122, 1127, 1131, 1137
                1142, 1146, 1152, 1157, 1161, 1167, 1172
                1176, 1182, 1187
/root/git/pjdfstest/tests/link/00.t           (Wstat: 0 Tests: 202 Failed: 1)
  Failed test:  134
/root/git/pjdfstest/tests/utimensat/01.t      (Wstat: 0 Tests: 7 Failed: 1)
  Failed test:  4
Files=232, Tests=8789, 375 wallclock secs ( 4.00 usr  2.65 sys + 51.48 cusr 262.19 csys = 320.32 CPU)
Thanks
Vivek

> 
> Hi,
> 
> Consolidating updation of flags both for lo_create() and lo_open() makes
> sense to me. I will test it tomorrow.
> 
> Thanks
> Vivek
> 
> > Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 56 +++++++++++++++---------------
> >  1 file changed, 28 insertions(+), 28 deletions(-)
> > 
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index e8892c3c32..79fb78ecce 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1733,6 +1733,32 @@ static void lo_releasedir(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info
> >  	fuse_reply_err(req, 0);
> >  }
> >  
> > +static void update_open_flags(int writeback, struct fuse_file_info *fi)
> > +{
> > +	/* With writeback cache, kernel may send read requests even
> > +	   when userspace opened write-only */
> > +	if (writeback && (fi->flags & O_ACCMODE) == O_WRONLY) {
> > +		fi->flags &= ~O_ACCMODE;
> > +		fi->flags |= O_RDWR;
> > +	}
> > +
> > +	/* With writeback cache, O_APPEND is handled by the kernel.
> > +	   This breaks atomicity (since the file may change in the
> > +	   underlying filesystem, so that the kernel's idea of the
> > +	   end of the file isn't accurate anymore). In this example,
> > +	   we just accept that. A more rigorous filesystem may want
> > +	   to return an error here */
> > +	if (writeback && (fi->flags & O_APPEND))
> > +		fi->flags &= ~O_APPEND;
> > +
> > +	/*
> > +	 * O_DIRECT in guest should not necessarily mean bypassing page
> > +	 * cache on host as well. If somebody needs that behavior, it
> > +	 * probably should be a configuration knob in daemon.
> > +	 */
> > +	fi->flags &= ~O_DIRECT;
> > +}
> > +
> >  static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> >  		      mode_t mode, struct fuse_file_info *fi)
> >  {
> > @@ -1760,12 +1786,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> >  	if (err)
> >  		goto out;
> >  
> > -	/*
> > -	 * O_DIRECT in guest should not necessarily mean bypassing page
> > -	 * cache on host as well. If somebody needs that behavior, it
> > -	 * probably should be a configuration knob in daemon.
> > -	 */
> > -	fi->flags &= ~O_DIRECT;
> > +	update_open_flags(lo->writeback, fi);
> >  
> >  	fd = openat(parent_inode->fd, name,
> >  		    (fi->flags | O_CREAT) & ~O_NOFOLLOW, mode);
> > @@ -1966,28 +1987,7 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
> >  
> >  	fuse_log(FUSE_LOG_DEBUG, "lo_open(ino=%" PRIu64 ", flags=%d)\n", ino, fi->flags);
> >  
> > -	/* With writeback cache, kernel may send read requests even
> > -	   when userspace opened write-only */
> > -	if (lo->writeback && (fi->flags & O_ACCMODE) == O_WRONLY) {
> > -		fi->flags &= ~O_ACCMODE;
> > -		fi->flags |= O_RDWR;
> > -	}
> > -
> > -	/* With writeback cache, O_APPEND is handled by the kernel.
> > -	   This breaks atomicity (since the file may change in the
> > -	   underlying filesystem, so that the kernel's idea of the
> > -	   end of the file isn't accurate anymore). In this example,
> > -	   we just accept that. A more rigorous filesystem may want
> > -	   to return an error here */
> > -	if (lo->writeback && (fi->flags & O_APPEND))
> > -		fi->flags &= ~O_APPEND;
> > -
> > -	/*
> > -	 * O_DIRECT in guest should not necessarily mean bypassing page
> > -	 * cache on host as well. If somebody needs that behavior, it
> > -	 * probably should be a configuration knob in daemon.
> > -	 */
> > -	fi->flags &= ~O_DIRECT;
> > +	update_open_flags(lo->writeback, fi);
> >  
> >  	sprintf(buf, "%i", lo_fd(req, ino));
> >  	fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
> > -- 
> > 2.21.0
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

