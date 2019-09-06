Date: Fri, 6 Sep 2019 10:17:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20190906101339-mutt-send-email-mst@kernel.org>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<CAJfpegu8POz9gC4MDEcXxDWBD0giUNFgJhMEzntJX_u4+cS9Zw@mail.gmail.com>
	<20190906103613.GH5900@stefanha-x1.localdomain>
	<CAJfpegudNVZitQ5L8gPvA45mRPFDk9fhyboceVW6xShpJ4mLww@mail.gmail.com>
	<20190906120817.GA22083@redhat.com>
	<20190906095428-mutt-send-email-mst@kernel.org>
	<CAJfpeguVvwRCi7+23W2qA+KHeoaYaR7uKsX+JykC3HK00uGSNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguVvwRCi7+23W2qA+KHeoaYaR7uKsX+JykC3HK00uGSNQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 00/18] virtiofs: Fix various races and
	cleanups round 1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Fri, Sep 06, 2019 at 04:11:45PM +0200, Miklos Szeredi wrote:
> This is not a drop in replacement for blk and scsi transports.  More
> for virtio-9p.  Does that have anything similar?

9p seems to supports unplug, yes. It's not great in that it
blocks until we close the channel, but it's there and
it does not crash or leak memory.

