Date: Wed, 28 Apr 2021 09:15:02 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YIkZhqKaLat6Q9YH@work-vm>
References: <6b2e27a4-8bee-3649-95a4-a2cea45a18e4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b2e27a4-8bee-3649-95a4-a2cea45a18e4@gmail.com>
Subject: Re: [Virtio-fs] Min host / vm kernel rev for basic DAX ops?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

* Harry G. Coin (hgcoin@gmail.com) wrote:
> Kindly answer a couple 'basic' virtiofs questions:
> 
> 1) Which mainline kernel version is necessary for the host, and for the
> vm to enable reliable DAX operations -- supposing no shared host
> activity on the underlying fs.

I don't think there's any host kernel dependency for DAX
currently.
(You do need a guest with the DAX support)

> 2) Which host file system(s) have the best DAX performance while
> offering xattr and related abilities?

I'm not aware of any comparison between host filesystems.

Dave

> Thanks
> 
> 
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

