DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=YTSoKdzG15IclUaVeclY6UnOmRKJnRQSxaUgUe43OGE=;
	b=WamyOoBPhQl4aR/I2S9hb2dSFH0TZDMKGZsasN0a+KYduV8hbPM1rI5GHYAFFZvwUz
	NyovioVmgsvPHyUQPe4X/eSjitoJGtybboIHRvg9AE08nEt41jparSDYjE42OcQu12mL
	3eQ01QP/sSh/OvM2hQye68ergBsyClFuGNjTGO5TQp+QHpOpH2fOV6vUUkCYd57KWOe1
	j4I6I2iWnjupQ5ayC4MKiYNNZh+P97KHx9ItMzSb5ps+bo/p6nLTFl6x1+eBT5ZviKIj
	lShBjfOKmDamowFFA+kCZ1pPYPKlaJtkBH90t3w4ep0y4vueRc/pc8hk77EvHfHziULr
	4L8Q==
Date: Tue, 13 Aug 2019 14:33:09 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20190813183307.uxpimpmxau3nhwgb@gabell>
References: <20190811225534.9040-1-msys.mizuma@gmail.com>
	<20190813155153.GD32090@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813155153.GD32090@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

On Tue, Aug 13, 2019 at 04:51:53PM +0100, Stefan Hajnoczi wrote:
> On Sun, Aug 11, 2019 at 06:55:34PM -0400, Masayoshi Mizuma wrote:
> > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > index 8adc4b1ab8..ab18b86435 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > @@ -2587,6 +2587,9 @@ void fuse_session_destroy(struct fuse_session *se)
> >  	free(se->vu_socket_path);
> >  	se->vu_socket_path = NULL;
> >  
> > +	unlink(se->vu_socket_lock_file);
> 
> Are you sure this works?  We should be inside the chroot here, so this
> is probably not the same file that we created!

Ah, thank you for pointing it out. You're right.
The namespace is changed into the sandbox after the vhost-user
socket connection is established.
I'll remove the unlink().

> 
> > +        socket_name = malloc(strlen(se->vu_socket_path) + 1);
> > +        memset(socket_name, 0, strlen(se->vu_socket_path) + 1);
> > +        memcpy(socket_name, se->vu_socket_path, strlen(se->vu_socket_path));
> 
> These lines can be replaced with:
> 
>   socket_name = g_strdup(se->vu_socket_path);
>   ...
>   g_free(socket_name);

Thanks.

> 
> > +        strreplace(socket_name, '/', '.');
> > +
> > +        se->vu_socket_lock_file = malloc(NAME_MAX);
> > +        memset(se->vu_socket_lock_file, 0, NAME_MAX);
> > +        snprintf(se->vu_socket_lock_file, NAME_MAX, "%s/%s.pid",
> > +			dir, socket_name);
> 
> These lines can be replaced with:
> 
>   se->vu_socket_lock_file = g_strdup_printf("%s/%s.pid", dir, socket_name);
> 
> The difference here is that it won't silently truncate to NAME_MAX.
> This is probably a good thing since an ENAMETOOLONG error should be
> reported instead of silently truncating the path.

Got it. I'll fix this.

Thanks!
Masa

