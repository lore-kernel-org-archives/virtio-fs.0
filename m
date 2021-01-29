Date: Fri, 29 Jan 2021 10:04:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210129150415.GC3146@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
	<20210125180115.22936-2-vgoyal@redhat.com>
	<20210126165600.7bbe369d@bahia.lan>
	<20210126183336.GB3239@redhat.com>
	<20210129130309.1e769bdc@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129130309.1e769bdc@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH 1/6] virtiofsd: Drop ->vu_dispatch_rwlock
 while waiting for thread to exit
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: mst@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, marcandre.lureau@redhat.com

On Fri, Jan 29, 2021 at 01:03:09PM +0100, Greg Kurz wrote:
> On Tue, 26 Jan 2021 13:33:36 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> [...]
>  
> > > 
> > > Also, since pthread_rwlock_wrlock() can fail, I think we should
> > > always check it's return value, at least with an assert() like
> > > already done elsewhere.
> > 
> > Will check return code of pthread_rwlock_wrlock() and probably use
> > assert().
> > 
> 
> It turns out that pthread_rwlock_rdlock() and pthread_rwlock_unlock() can
> also fail for various reasons that would likely indicate a programming
> error, but their return values are never checked anywhere.
> 
> I have a patch to address this globally in this file. Should I post it
> now or you prefer this series goes first ?

Please go ahead and post your patch. Your patch can go first and I can
rebase my patches on top of yours.

Vivek

