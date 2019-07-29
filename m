Date: Mon, 29 Jul 2019 08:51:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190729125142.GB630@redhat.com>
References: <20190725204934.GG15543@redhat.com>
	<20190729101537.GE3369@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729101537.GE3369@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [RFC][PATCH] init: Allow mounting virtio_fs
	instance as rootfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Mon, Jul 29, 2019 at 11:15:37AM +0100, Stefan Hajnoczi wrote:
> On Thu, Jul 25, 2019 at 04:49:34PM -0400, Vivek Goyal wrote:
> > Hi Stefan,
> > 
> > I think following patch might allow you to mount virtio_fs as rootfs
> > with new syntax.
> 
> Thanks, I've sent a similar patch too.  My patch changes mount_root()
> (where the nfs root code also lives) and uses do_mount_root() instead of
> mount_block_root() to avoid block/partition error messages.  But I think
> they are very similar in terms of functionality.

Ok, sounds good. I will squash that patch with one of the existing
patches.

Thanks
Vivek

> 
> > I have only compiled it and not tested it. Plase have a look.
> > 
> > Thanks
> > Vivek
> > 
> > virtio_fs passes root=<fs-instance-name> as identifier of virtio_fs instance
> > to be mounted. None of the existing primitives seems to fit virito_fs needs.
> > 
> > So check rootfstype and if it is "virtio_fs", do not parse root= further
> > and call mount_block_root().
> > 
> > This is similar to carving out special paths for ubifs. Now virtio_fs
> > users should be able to pass "root=myfs rootfstype=virtio_fs" and be
> > able to mount that particular instance of virtio_fs as rootfs.
> >  
> > Yet-To-Be-Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  init/do_mounts.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > Index: rhvgoyal-linux-fuse/init/do_mounts.c
> > ===================================================================
> > --- rhvgoyal-linux-fuse.orig/init/do_mounts.c	2019-04-09 15:42:17.096602971 -0400
> > +++ rhvgoyal-linux-fuse/init/do_mounts.c	2019-07-25 16:40:29.226348627 -0400
> > @@ -595,6 +595,10 @@ void __init prepare_namespace(void)
> >  			mount_block_root(root_device_name, root_mountflags);
> >  			goto out;
> >  		}
> > +		if (root_fs_names && !strncmp(root_fs_names, "virtio_fs", 3)) {
> 
> The entire string, not just the first 3 characters:
> 
>   !strcmp(root_fs_names, "virtio_fs")


