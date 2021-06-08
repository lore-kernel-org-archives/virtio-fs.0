References: <20210604161156.408496-1-groug@kaod.org>
	<20210604161156.408496-5-groug@kaod.org>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <233b722a-4794-6905-f9d9-c0445ae24812@redhat.com>
Date: Tue, 8 Jun 2021 17:25:29 +0200
MIME-Version: 1.0
In-Reply-To: <20210604161156.408496-5-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 4/7] fuse: Add dedicated filesystem
 context ops for submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On 04.06.21 18:11, Greg Kurz wrote:
> The creation of a submount is open-coded in fuse_dentry_automount().
> This brings a lot of complexity and we recently had to fix bugs
> because we weren't setting SB_BORN or because we were unlocking
> sb->s_umount before sb was fully configured. Most of these could
> have been avoided by using the mount API instead of open-coding.
>
> Basically, this means coming up with a proper ->get_tree()
> implementation for submounts and call vfs_get_tree(), or better
> fc_mount().
>
> The creation of the superblock for submounts is quite different from
> the root mount. Especially, it doesn't require to allocate a FUSE
> filesystem context, nor to parse parameters.
>
> Introduce a dedicated context ops for submounts to make this clear.
> This is just a placeholder for now, fuse_get_tree_submount() will
> be populated in a subsequent patch.
>
> Only visible change is that we stop allocating/freeing a useless FUSE
> filesystem context with submounts.
>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/fuse_i.h    |  5 +++++
>   fs/fuse/inode.c     | 16 ++++++++++++++++
>   fs/fuse/virtio_fs.c |  3 +++
>   3 files changed, 24 insertions(+)

Reviewed-by: Max Reitz <mreitz@redhat.com>

