DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=8avZLR3s54zDwGJ9orB8SAXdL8ZA2fUor9iX46FNVUU=;
	b=HV05F0mXKEeO9eeLhfwxRaBkiUirgkYTgZjMFwZ8tjx723Nrbz1C14l8uh7ARpf1Xs
	lVQsyfVXeJmvtNM0pzBWmYV1yfkFE6xPEYhO0e65DVsQxq47W5dhfPZ521FVaP9MScS3
	mcgF8M2mNq2d4tEDA8DmGY/cmHPKmSPT95DaR9hLq5pvPxUlIrCh1jlSOGlZXCgCMD7r
	Bka+Xzy7H7sABVIsUARjrDXf8vSsuYOmXrlb96JyQ/JkRLeCKsf8aoiQpujqsECNhRIy
	rfXO2yoQiY26QNCnVMb5aD3VGOHjy7HfdDUZ5ToYia+tyu+8PRHJMqGbGzBOmcA/ElkF
	agTA==
Date: Fri, 2 Aug 2019 12:22:41 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20190802162239.c2vpm2mip54wjvj6@gabell>
References: <20190801151348.14947-1-msys.mizuma@gmail.com>
	<20190802153930.GB22284@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802153930.GB22284@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Prevent multiply running with
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

Hi Stefan,

On Fri, Aug 02, 2019 at 04:39:30PM +0100, Stefan Hajnoczi wrote:
> On Thu, Aug 01, 2019 at 11:13:48AM -0400, Masayoshi Mizuma wrote:
> > From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > 
> > virtiofsd can run multiply even if the vhost_user_socket is
> > same path.
> > 
> >   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
> >   [1] 244965
> >   virtio_session_mount: Waiting for vhost-user socket connection...
> >   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
> >   [2] 244966
> >   virtio_session_mount: Waiting for vhost-user socket connection...
> >   ]#
> > 
> > The file access from the guest works because the second virtiofsd
> > handles that, however, the user will get confused the situation
> > and may be the cause of unexpected problem. So it's better to
> > prevent the multiple running.
> > 
> > Change unlink() of the socket to the exit of virtiofsd so that the
> > latter virtiofsd can fail on bind() as EADDRINUSE.
> > 
> > Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > ---
> >  contrib/virtiofsd/fuse_lowlevel.c | 1 +
> >  contrib/virtiofsd/fuse_virtio.c   | 1 -
> >  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> This patch makes the UNIX domain socket act similar to a pidfile or
> lockfile.  Does the user need to clean up the UNIX domain socket
> manually before virtiofsd can restart again after a crash?
> 
> This can be a robustness/reliability problem because we must assume that
> crashes happen and recovery should not require human intervention.
> 
> On the other hand, there are plenty of daemons that have long-lived UNIX
> domain socket paths.  How do they handle crash recovery?

It's good point, thanks.
I think if the socket ramains due to the former crash, then the socket
should be unlinked by virtiofsd, not manualy.

virtiofsd should detect whether the socket is in use by the other
virtiofsd or just remains by crash.
I'll try to implement that...

Thanks!
Masa

