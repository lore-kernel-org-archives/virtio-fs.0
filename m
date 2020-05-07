MIME-Version: 1.0
References: <20200506153529.239939-1-mreitz@redhat.com>
	<20200506153637.240191-3-mreitz@redhat.com>
In-Reply-To: <20200506153637.240191-3-mreitz@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 7 May 2020 11:56:07 +0200
Message-ID: <CAOssrKerr_KvfuXqTNjJ4936SXiN3AZ6rZ6oo8Mv+9bvDrFAWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC 3/5] fuse: Split fuse_mount off of fuse_conn
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <xanclic@xanclic.moe>

On Wed, May 6, 2020 at 5:37 PM Max Reitz <mreitz@redhat.com> wrote:
>
> From: Max Reitz <xanclic@xanclic.moe>
>
> We want to allow submounts for the same fuse_conn, but with different
> superblocks so that each of the submounts has its own device ID.  To do
> so, we need to split all mount-specific information off of fuse_conn
> into a new fuse_mount structure, so that multiple mounts can share a
> single fuse_conn.

I have the following high level comments:

Control filesystem: each fuse_mount gets a new entry, but they are all
aliases.   I think we should just stick with just one entry for the
connection (and perhaps a symlink for each additional mount, but this
is of secondary importance).

BDI:  we need to call set_bdi_congested/clear_bdi_congested for *all*
mounts of a connection.  Might make sense to look into getting rid of
bdi congestion handling completely, but this is not something I have a
good insight into right now.

Notification: please create a fuse_ilookup() that takes fc and returns
(sb, inode) pair and call this instead ilookup5().   This way the loop
is moved to the place where it's actually necessary.

Thanks,
Miklos


