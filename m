Date: Tue, 3 Sep 2019 10:18:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190903141851.GC10983@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegvPTxkaNhXWhiQSprSJqyW1cLXeZEz6x_f0PxCd-yzHQg@mail.gmail.com>
	<20190903041507-mutt-send-email-mst@kernel.org>
	<20190903140752.GA10983@redhat.com>
	<20190903101001-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903101001-mutt-send-email-mst@kernel.org>
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
 virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Tue, Sep 03, 2019 at 10:12:16AM -0400, Michael S. Tsirkin wrote:
> On Tue, Sep 03, 2019 at 10:07:52AM -0400, Vivek Goyal wrote:
> > On Tue, Sep 03, 2019 at 04:31:38AM -0400, Michael S. Tsirkin wrote:
> > 
> > [..]
> > > +	/* TODO lock */
> > > give me pause.
> > > 
> > > Cleanup generally seems broken to me - what pauses the FS
> > 
> > I am looking into device removal aspect of it now. Thinking of adding
> > a reference count to virtiofs device and possibly also a bit flag to
> > indicate if device is still alive. That way, we should be able to cleanup
> > device more gracefully.
> 
> Generally, the way to cleanup things is to first disconnect device from
> linux so linux won't send new requests, wait for old ones to finish.

I was thinking of following.

- Set a flag on device to indicate device is dead and not queue new
  requests. Device removal call can set this flag.

- Return errors when fs code tries to queue new request.

- Drop device creation reference in device removal path. If device is
  mounted at the time of removal, that reference will still be active
  and device state will not be cleaned up in kernel yet.

- User unmounts the fs, and that will drop last reference to device and
  will lead to cleanup of in kernel state of the device.

Does that sound reasonable.

Vivek

