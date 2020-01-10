Date: Fri, 10 Jan 2020 15:00:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200110200043.GE28043@redhat.com>
References: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
	<20200110161334.GD28043@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110161334.GD28043@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix xattr operations
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

On Fri, Jan 10, 2020 at 11:13:34AM -0500, Vivek Goyal wrote:

[..]
> >      if (size) {
> > @@ -2378,7 +2385,11 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
> >              goto out_err;
> >          }
> >  
> > -        ret = fgetxattr(fd, name, value, size);
> > +        if (inode->is_regular) {
> > +            ret = fgetxattr(fd, name, value, size);
> > +        } else {
> > +            ret = getxattr(procname, name, value, size);
> > +        }
> 
> Do we need "lgetxattr()" instead of "getxattr()" for symlinks?

Well, lgetxattr() will not work as that will try to work on
/proc/pid/fd/<fdN>" and that's just a /proc file.

> 
> Say I have following setup.
> 
> foo-symlink -> foo.txt
> 
> Now lo_lookup(foo-symlink.txt, O_PATH | O_NOFOLLOW), will get fd on
> symlink, say 3. And proc should show something similar.
> 
> And /proc/self/fd/3 -> /foo-symlink.txt
> 
> Now if we do getxattr(3), will it not resolve symlinks and get xattr value
> from "foo.txt" instead?

That does not happen. We had opened 3, with O_PATH and O_NOFOLLOW. So
looks like all the operations now happen on actual symbolic file and
if this is path to a symlink file, it does not get resolved further.
Is it because of O_NOFOLLOW flag?

Vivek

