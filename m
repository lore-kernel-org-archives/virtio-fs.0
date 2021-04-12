Date: Mon, 12 Apr 2021 10:59:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210412145919.GE1184147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] Query about fuse ->sync_fs and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>, virtio-fs-list <virtio-fs@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, Robert Krawitz <rkrawitz@redhat.com>

Hi Miklos,

Robert Krawitz drew attention to the fact that fuse does not seem to
have a ->sync_fs implementation. That probably means that in case of
virtiofs, upon sync()/syncfs(), host cache will not be written back
to disk. And that's not something people expect.

I read somewhere that fuse did not implement ->sync_fs because file
server might not be trusted and it could block sync().

In case of virtiofs, file server is trusted entity (w.r.t guest kernel),
so it probably should be ok to implement ->sync_fs atleast for virtiofs?

Was looking for your thoughts on this before I look into implementing it.

Thanks
Vivek

