Date: Thu, 18 Jul 2019 10:52:40 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190718095240.GB2865@work-vm>
References: <690c7f0afc449d8e843cc3b271035966628df450.1563159705.git.renzhen@linux.alibaba.com>
	<20190716153009.GC21625@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716153009.GC21625@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: remove SCMP_FLTATTR_CTL_TSYNC
 flag
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Mon, Jul 15, 2019 at 11:09:51AM +0800, Eric Ren wrote:
> > SCMP_FLTATTR_CTL_TSYNC flag is only available on
> > Linux Kernel 3.17 or greater. Older host kernel
> > fails virtiofsd, limiting virtiofsd use.
> > 
> > And, confirmed from Stefan Hajnoczi:
> > """
> > There are no threads when setup_seccomp() is invoked so the TSYNC
> > attribute is not required.
> > 
> > Please remove the TSYNC call.  Then we don't need to worry about version
> > or feature checks.
> > """
> > 
> > Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
> > ---
> >  contrib/virtiofsd/seccomp.c | 4 ----
> >  1 file changed, 4 deletions(-)
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks, merged.

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

