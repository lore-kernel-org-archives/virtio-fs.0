Date: Tue, 20 Aug 2019 20:05:20 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190820190520.GR2867@work-vm>
References: <20190813200645.13819-1-msys.mizuma@gmail.com>
	<20190820180322.GH9855@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820180322.GH9855@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: Prevent multiply running with
 same vhost_user_socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Tue, Aug 13, 2019 at 04:06:45PM -0400, Masayoshi Mizuma wrote:
> 
> Two minor comments below.  They can be squashed in when merging this
> patch.
> 
> If users find it problematic that pid files are never deleted we could
> make this feature optional with --pidfile=PATH.  But I think we can
> merge this patch for now and see if anyone encounters issues before the
> next virtio-fs release.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> 
> > +static int fv_socket_lock(struct fuse_session *se)
> > +{
> > +        char *dir, *sk_name;
> > +        Error *local_err = NULL;
> > +        int ret = -1;
> > +
> > +        dir = qemu_get_local_state_pathname("run/virtiofsd");
> > +
> > +        if (g_mkdir_with_parents(dir, S_IRWXU) < -1) {
> > +                fuse_err("%s: Failed to create directory %s: %s",
> > +                        __func__, dir, strerror(errno));
> 
> Missing g_free(dir).
> 
> > @@ -876,6 +916,17 @@ static int fv_create_listen_socket(struct fuse_session *se)
> >                  return -1;
> >          }
> >  
> > +        if (!strlen(se->vu_socket_path)) {
> > +                fuse_err("Socket path is NULL\n");
> 
> s/NULL/empty/


Thanks; applied with those changes, plus also I found I had
to move the #include of osdep.h and error.h to the top of the include
list to avoid glib compilation errors.

Dave

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

