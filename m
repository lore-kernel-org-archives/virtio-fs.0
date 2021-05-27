Date: Thu, 27 May 2021 18:31:51 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YK/Xh3rIL9gPEGjn@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-19-dgilbert@redhat.com>
	<YJQIMfU00U3ZR3BL@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJQIMfU00U3ZR3BL@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 18/26] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 28, 2021 at 12:00:52PM +0100, Dr. David Alan Gilbert (git) wrote:
> > +    close(fd);
> 
> I looked back at the hw/virtio/vhost-user.c slave channel code and it
> closes fds for us. Looks like this close(2) call should be removed, but
> please double-check in case I missed something.

Nice, I think you're right; I've deleted that close(fd)


> Stefan


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

