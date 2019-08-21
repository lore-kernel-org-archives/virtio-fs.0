DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=iJAkkTEIs4JoPWZb4eJQZms9eIL92uePApVl/b8FalE=;
	b=ttwc/E3gWA7nkBnkfp7/4VgPjufCFQUaT+g7VV7rlzyDLtKY7T4Hq9qHMo6WfSOz9a
	bgQXb8PF8UK2B3souh3NvO861Ofm1U1Yp0cyPRioK4y0IlVLGkxM9MSJxgyxa7AA3+/r
	1801/lYexOtGQzWspGlexPQu/yq9Uu0RSEINzXrj0pMMs/QaqXlt0GM7Ml7ZAapx5xVm
	kEVn6HWPoIO+Qd8QWu/LlPgwpX1HPeVgJMFkWlXoNIGdLAVrPwtYqa54wuwDfNWp1rpX
	7AUd0DAkT5HtR7lRlLl2esvTh4Pr0PwXNGuku2E58fvuveKUtdTqkPP1J8hTNbPWFNu6
	Z0IA==
Date: Tue, 20 Aug 2019 23:42:26 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20190821034225.kfo46pviyf6edqfc@gabell>
References: <20190813200645.13819-1-msys.mizuma@gmail.com>
	<20190820180322.GH9855@stefanha-x1.localdomain>
	<20190820190520.GR2867@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820190520.GR2867@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

On Tue, Aug 20, 2019 at 08:05:20PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Tue, Aug 13, 2019 at 04:06:45PM -0400, Masayoshi Mizuma wrote:
> > 
> > Two minor comments below.  They can be squashed in when merging this
> > patch.
> > 
> > If users find it problematic that pid files are never deleted we could
> > make this feature optional with --pidfile=PATH.  But I think we can
> > merge this patch for now and see if anyone encounters issues before the
> > next virtio-fs release.
> > 
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > 
> > > +static int fv_socket_lock(struct fuse_session *se)
> > > +{
> > > +        char *dir, *sk_name;
> > > +        Error *local_err = NULL;
> > > +        int ret = -1;
> > > +
> > > +        dir = qemu_get_local_state_pathname("run/virtiofsd");
> > > +
> > > +        if (g_mkdir_with_parents(dir, S_IRWXU) < -1) {
> > > +                fuse_err("%s: Failed to create directory %s: %s",
> > > +                        __func__, dir, strerror(errno));
> > 
> > Missing g_free(dir).
> > 
> > > @@ -876,6 +916,17 @@ static int fv_create_listen_socket(struct fuse_session *se)
> > >                  return -1;
> > >          }
> > >  
> > > +        if (!strlen(se->vu_socket_path)) {
> > > +                fuse_err("Socket path is NULL\n");
> > 
> > s/NULL/empty/
> 
> 
> Thanks; applied with those changes, plus also I found I had
> to move the #include of osdep.h and error.h to the top of the include
> list to avoid glib compilation errors.

Thank you for fixing it and merging the patch!

- Masa

