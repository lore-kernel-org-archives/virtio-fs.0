MIME-Version: 1.0
References: <0f58d156-f2aa-e683-68cc-ed6c829338ba@redhat.com>
In-Reply-To: <0f58d156-f2aa-e683-68cc-ed6c829338ba@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 7 Dec 2020 09:26:31 +0100
Message-ID: <CAOssrKffx7NVtQzkCS+dgtxACSMC02ZAOpqaJ3Dhwcr6HddW7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] when not to forget explicitly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Sun, Dec 6, 2020 at 11:46 AM Laszlo Ersek <lersek@redhat.com> wrote:
>
> Hi Miklos,
>
> what FUSE requests are those after which the client is not supposed to
> ask the server to forget a nodeid?
>
> I'm surprised to see the following comment in
> "tools/virtiofsd/passthrough_ll.c", in "struct lo_inode":
>
>     /*
>      * This counter keeps the inode alive during the FUSE session.
>      * Incremented when the FUSE inode number is sent in a reply
>      * (FUSE_LOOKUP, FUSE_READDIRPLUS, etc).  Decremented when an inode is
>      * released by requests like FUSE_FORGET, FUSE_RMDIR, FUSE_RENAME, etc.
>      *
>      * Note that this value is untrusted because the client can manipulate
>      * it arbitrarily using FUSE_FORGET requests.
>      *
>      * Protected by lo->mutex.
>      */
>     uint64_t nlookup;
>
> I can identify the places in my FUSE client code where I learn of a new
> inode, but I can't tell what requests include an automatic "forget".
>
> The above mentions FUSE_RMDIR, which I didn't expect. I guess it also
> applies to FUSE_UNLINK. Is there anything else?

Nope, the comment is wrong.   It is only decremented on FUSE_FORGET.

Thanks,
Miklos

