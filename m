Date: Tue, 17 Aug 2021 11:37:20 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YRuRYJ2+hOa704sS@work-vm>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRuCHvhICtTzMK04@work-vm>
	<CAJfpegvM+S5Xru3Yfc88C64mecvco=f99y-TajQBDfkLD-S8zQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvM+S5Xru3Yfc88C64mecvco=f99y-TajQBDfkLD-S8zQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

* Miklos Szeredi (miklos@szeredi.hu) wrote:
> On Tue, 17 Aug 2021 at 11:32, Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Miklos Szeredi (miklos@szeredi.hu) wrote:
> > > On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> > > >
> > > > This patchset adds support of per-file DAX for virtiofs, which is
> > > > inspired by Ira Weiny's work on ext4[1] and xfs[2].
> > >
> > > Can you please explain the background of this change in detail?
> > >
> > > Why would an admin want to enable DAX for a particular virtiofs file
> > > and not for others?
> >
> > Where we're contending on virtiofs dax cache size it makes a lot of
> > sense; it's quite expensive for us to map something into the cache
> > (especially if we push something else out), so selectively DAXing files
> > that are expected to be hot could help reduce cache churn.
> 
> If this is a performance issue, it should be fixed in a way that
> doesn't require hand tuning like you suggest, I think.

I'd agree that would be nice; however:
  a) It looks like other filesystems already gave something admin
selectable
  b) Trying to write clever heuristics is only going to work in some
cases; being able to say 'DAX this directory' might work better in
practice.

> I'm not sure what the  ext4/xfs case for per-file DAX is.  Maybe that
> can help understand the virtiofs case as well.

Yep, I don't understand the case with real nvdimm hardware.

Dave

> Thanks,
> Miklos
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

