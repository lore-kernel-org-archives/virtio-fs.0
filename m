Date: Tue, 17 Aug 2021 08:40:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRuuRo8jEs5dkfw9@redhat.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRuCHvhICtTzMK04@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRuCHvhICtTzMK04@work-vm>
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Miklos Szeredi <miklos@szeredi.hu>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>

On Tue, Aug 17, 2021 at 10:32:14AM +0100, Dr. David Alan Gilbert wrote:
> * Miklos Szeredi (miklos@szeredi.hu) wrote:
> > On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> > >
> > > This patchset adds support of per-file DAX for virtiofs, which is
> > > inspired by Ira Weiny's work on ext4[1] and xfs[2].
> > 
> > Can you please explain the background of this change in detail?
> > 
> > Why would an admin want to enable DAX for a particular virtiofs file
> > and not for others?
> 
> Where we're contending on virtiofs dax cache size it makes a lot of
> sense; it's quite expensive for us to map something into the cache
> (especially if we push something else out), so selectively DAXing files
> that are expected to be hot could help reduce cache churn.

In that case probaly we should just make DAX window larger. I assume
that selecting which files to turn DAX on, will itself will not be
a trivial. Not sure what heuristics are being deployed to determine
that. Will like to know more about it.

Vivek

