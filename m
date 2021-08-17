Date: Tue, 17 Aug 2021 08:39:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRut5sioYfc2M1p7@redhat.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
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
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>

On Tue, Aug 17, 2021 at 10:06:53AM +0200, Miklos Szeredi wrote:
> On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> >
> > This patchset adds support of per-file DAX for virtiofs, which is
> > inspired by Ira Weiny's work on ext4[1] and xfs[2].
> 
> Can you please explain the background of this change in detail?
> 
> Why would an admin want to enable DAX for a particular virtiofs file
> and not for others?

Initially I thought that they needed it because they are downloading
files on the fly from server. So they don't want to enable dax on the file
till file is completely downloaded. But later I realized that they should
be able to block in FUSE_SETUPMAPPING call and make sure associated
file section has been downloaded before returning and solve the problem.
So that can't be the primary reason.

Other reason mentioned I think was that only certain files benefit
from DAX. But not much details are there after that. It will be nice
to hear a more concrete use case and more details about this usage.

Thanks
Vivek

