Date: Thu, 11 Jul 2019 20:49:51 +0800
From: Eric Ren <renzhen@linux.alibaba.com>
Message-ID: <20190711124951.GB8976@ali-6c96cfe09cf9.local>
References: <5e2722ade8346b09cbc4a147757a45b527b5a846.1562763758.git.renzhen@linux.alibaba.com>
	<20190711112558.GJ3971@work-vm>
	<20190711122921.GA8976@ali-6c96cfe09cf9.local>
	<20190711123254.GO3971@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711123254.GO3971@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: conditional compile seccomp flag
	support
Reply-To: Eric Ren <renzhen@linux.alibaba.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

Hi,

On Thu, Jul 11, 2019 at 01:32:54PM +0100, Dr. David Alan Gilbert wrote:
> * Eric Ren (renzhen@linux.alibaba.com) wrote:
[...]
> > > Eithe rway, is it actually safe without this define - 
> > Actually I don't know the exact effect of SCMP_FLTATR_CTL_TSYNC attr.
> > What if we gives a warning instead of error if failing to set it?
> > 
> > > or does the thread
> > > which actually runs the work not get the support?
> > 
> > Sorry, I fail to get your point here?
> 
> I don't know seccomp that well (lets ask Stefan!), but my understanding
> of TSYNC is that it causes all threads to get the new seccomp rules
> not just the thread we're running in.  So I'm worried that if we don't
> have TSYNC, some threads will run without the protection they need.

Thanks, I get it. On older kernel host, it has not this support so
I guess a warning message is the best we can do ;-)

Regards,
Eric

