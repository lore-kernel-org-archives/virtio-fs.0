MIME-Version: 1.0
References: <20210510155539.998747-1-groug@kaod.org>
	<20210510155539.998747-4-groug@kaod.org>
In-Reply-To: <20210510155539.998747-4-groug@kaod.org>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 11 May 2021 14:31:14 +0200
Message-ID: <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: kvm@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Cornelia Huck <cohuck@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
>
> Honor the expected behavior of syncfs() to synchronously flush all data
> and metadata on linux systems. Simply loop on all known submounts and
> call syncfs() on them.

Why not pass the submount's root to the server, so it can do just one
targeted syncfs?

E.g. somehting like this in fuse_sync_fs():

args.nodeid = get_node_id(sb->s_root->d_inode);

Thanks,
Miklos

