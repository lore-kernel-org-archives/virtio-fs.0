From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <0f58d156-f2aa-e683-68cc-ed6c829338ba@redhat.com>
Date: Sun, 6 Dec 2020 11:46:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] when not to forget explicitly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com

Hi Miklos,

what FUSE requests are those after which the client is not supposed to
ask the server to forget a nodeid?

I'm surprised to see the following comment in
"tools/virtiofsd/passthrough_ll.c", in "struct lo_inode":

    /*
     * This counter keeps the inode alive during the FUSE session.
     * Incremented when the FUSE inode number is sent in a reply
     * (FUSE_LOOKUP, FUSE_READDIRPLUS, etc).  Decremented when an inode is
     * released by requests like FUSE_FORGET, FUSE_RMDIR, FUSE_RENAME, etc.
     *
     * Note that this value is untrusted because the client can manipulate
     * it arbitrarily using FUSE_FORGET requests.
     *
     * Protected by lo->mutex.
     */
    uint64_t nlookup;

I can identify the places in my FUSE client code where I learn of a new
inode, but I can't tell what requests include an automatic "forget".

The above mentions FUSE_RMDIR, which I didn't expect. I guess it also
applies to FUSE_UNLINK. Is there anything else?

I'd really appreciate an exhaustive list of request types that
auto-forget :)

Thank you!
Laszlo

