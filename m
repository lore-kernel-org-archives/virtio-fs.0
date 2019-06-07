Date: Fri, 7 Jun 2019 12:29:37 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190607192936.ffzpccykdb2czxvt@US-160370MP2.local>
References: <1559875098-9347-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190607152147.GI2631@work-vm>
	<20190607181533.r7xkszkdi377o5ha@US-160370MP2.local>
	<20190607183310.GY2631@work-vm>
	<CAOssrKc9Z8SZOJyLv0rBthcDxiUzPhf07p0A4B9zjWQ+iHhm5A@mail.gmail.com>
	<20190607192346.GC2631@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607192346.GC2631@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: enable PARALLEL_DIROPS during
	INIT
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>

On Fri, Jun 07, 2019 at 08:23:46PM +0100, Dr. David Alan Gilbert wrote:
> * Miklos Szeredi (mszeredi@redhat.com) wrote:
> > On Fri, Jun 7, 2019 at 8:33 PM Dr. David Alan Gilbert
> > <dgilbert@redhat.com> wrote:
> > >
> > > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > > On Fri, Jun 07, 2019 at 04:21:47PM +0100, Dr. David Alan Gilbert wrote:
> > > > > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > > > > lookup is a RO operations, PARALLEL_DIROPS can be enabled.
> > > > > >
> > > > > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > > > >
> > > > > I'm not too sure what this is doing; and why doesn't upstream libfuse
> > > > > have this?
> > > >
> > > > I'm not sure why libfuse doesn't include the capability, but AFAICT this
> > > > is needed for practical use.
> > >
> > > Miklos: Do you know what the rules are around PARALLEL_DIROPS and why
> > > the upstream libfuse doesn't have it eanbled?
> > 
> > Not sure why libfuse3 wouldn't have it enabled by default, probably an
> > omission.  Having said that, the reason this is opt in is that old
> > filesystems might rely on the serialized behavior, so back
> > compatibility requires that we have this turned off by default, so now
> > libfuse3 has the same problem...
> 
> So for us (virtio-fs) is it always safe?
>

FYI, my first round of limited testing (dbench4, fsmark, fstests) didn't say no.

thanks,
-liubo

