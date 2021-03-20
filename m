Date: Sat, 20 Mar 2021 16:04:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20210320160430-mutt-send-email-mst@kernel.org>
References: <20210318135223.1342795-1-ckuehl@redhat.com>
	<20210318135223.1342795-3-ckuehl@redhat.com>
	<YFNvH8w4l7WyEMyr@miu.piliscsaba.redhat.com>
	<00c5dce8-fc2d-6e68-e3bc-a958ca5d2342@redhat.com>
MIME-Version: 1.0
In-Reply-To: <00c5dce8-fc2d-6e68-e3bc-a958ca5d2342@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofs: split requests that exceed
	virtqueue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jasowang@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

On Thu, Mar 18, 2021 at 10:52:14AM -0500, Connor Kuehl wrote:
> On 3/18/21 10:17 AM, Miklos Szeredi wrote:
> > I removed the conditional compilation and renamed the limit.  Also made
> > virtio_fs_get_tree() bail out if it hit the WARN_ON().  Updated patch below.
> 
> Thanks, Miklos. I think it looks better with those changes.
> 
> > The virtio_ring patch in this series should probably go through the respective
> > subsystem tree.
> 
> Makes sense. I've CC'd everyone that ./scripts/get_maintainers.pl suggested
> for that patch on this entire series as well. Should I resend patch #1
> through just that subsystem to avoid confusion or wait to see if it gets
> picked out of this series?

Yes pls post separately. Thanks!

> Thanks again,
> 
> Connor

