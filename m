Date: Mon, 10 Jun 2019 10:04:30 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190610090430.GA22439@work-vm>
References: <1559875098-9347-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190607152147.GI2631@work-vm>
	<20190607181533.r7xkszkdi377o5ha@US-160370MP2.local>
	<20190607183310.GY2631@work-vm>
	<CAOssrKc9Z8SZOJyLv0rBthcDxiUzPhf07p0A4B9zjWQ+iHhm5A@mail.gmail.com>
	<20190607192346.GC2631@work-vm>
	<CAOssrKfvXA0Mb18MW_j+3Gw2pqyvL2=9TTKodmhspfHA5mEpRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKfvXA0Mb18MW_j+3Gw2pqyvL2=9TTKodmhspfHA5mEpRw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: enable PARALLEL_DIROPS during
	INIT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com

* Miklos Szeredi (mszeredi@redhat.com) wrote:
> On Fri, Jun 7, 2019 at 9:23 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Miklos Szeredi (mszeredi@redhat.com) wrote:
> > > On Fri, Jun 7, 2019 at 8:33 PM Dr. David Alan Gilbert
> > > <dgilbert@redhat.com> wrote:
> > > >
> > > > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > > > On Fri, Jun 07, 2019 at 04:21:47PM +0100, Dr. David Alan Gilbert wrote:
> > > > > > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > > > > > lookup is a RO operations, PARALLEL_DIROPS can be enabled.
> > > > > > >
> > > > > > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > > > > >
> > > > > > I'm not too sure what this is doing; and why doesn't upstream libfuse
> > > > > > have this?
> > > > >
> > > > > I'm not sure why libfuse doesn't include the capability, but AFAICT this
> > > > > is needed for practical use.
> > > >
> > > > Miklos: Do you know what the rules are around PARALLEL_DIROPS and why
> > > > the upstream libfuse doesn't have it eanbled?
> > >
> > > Not sure why libfuse3 wouldn't have it enabled by default, probably an
> > > omission.  Having said that, the reason this is opt in is that old
> > > filesystems might rely on the serialized behavior, so back
> > > compatibility requires that we have this turned off by default, so now
> > > libfuse3 has the same problem...
> >
> > So for us (virtio-fs) is it always safe?
> 
> Yes, since no shared data is used between readdir instances.

OK, in that case

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

and added to my tree.


> Thanks,
> Miklos
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

