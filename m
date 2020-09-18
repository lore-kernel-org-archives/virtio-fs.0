Date: Fri, 18 Sep 2020 19:55:48 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200918185548.GS2816@work-vm>
References: <a14cfa52-f1bc-b31e-5f85-ab207c1689a0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a14cfa52-f1bc-b31e-5f85-ab207c1689a0@gmail.com>
Subject: Re: [Virtio-fs] Can libvirt parse virtiofsd -o writeback?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

* Harry G. Coin (hgcoin@gmail.com) wrote:
> Is there any libvirt xml parser rev that knows about how to set
> virtiofsd -o writeback?

I don't think so ; the docs say:
https://libvirt.org/formatdomain.html#filesystems
says:

 binary

    The optional binary element can tune the options for virtiofsd. All
    of the following attributes and elements are optional. The attribute
    path can be used to override the path to the daemon. Attribute xattr
    enables the use of filesystem extended attributes. Caching can be
    tuned via the cache element, possible mode values being none and
    always. Locking can be controlled via the lock element - attributes
    posix and flock both accepting values on or off. ( Since 6.2.0 )


Hmm, I've never tried the -o writeback; have you found it beneficial?

Dave


> Thanks
> 
> Harry Coin
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

