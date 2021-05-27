References: <20210525150230.157586-1-groug@kaod.org>
	<20210525150230.157586-2-groug@kaod.org>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <cef80ba1-b0c1-a8bd-387a-9c7d2730a766@redhat.com>
Date: Thu, 27 May 2021 11:51:37 +0200
MIME-Version: 1.0
In-Reply-To: <20210525150230.157586-2-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 1/4] fuse: Fix crash in
 fuse_dentry_automount() error path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On 25.05.21 17:02, Greg Kurz wrote:
> If fuse_fill_super_submount() returns an error, the error path
> triggers a crash:
> 
> [   26.206673] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [...]
> [   26.226362] RIP: 0010:__list_del_entry_valid+0x25/0x90
> [...]
> [   26.247938] Call Trace:
> [   26.248300]  fuse_mount_remove+0x2c/0x70 [fuse]
> [   26.248892]  virtio_kill_sb+0x22/0x160 [virtiofs]
> [   26.249487]  deactivate_locked_super+0x36/0xa0
> [   26.250077]  fuse_dentry_automount+0x178/0x1a0 [fuse]
> 
> The crash happens because fuse_mount_remove() assumes that the FUSE
> mount was already added to list under the FUSE connection, but this
> only done after fuse_fill_super_submount() has returned success.
> 
> This means that until fuse_fill_super_submount() has returned success,
> the FUSE mount isn't actually owned by the superblock. We should thus
> reclaim ownership by clearing sb->s_fs_info, which will skip the call
> to fuse_mount_remove(), and perform rollback, like virtio_fs_get_tree()
> already does for the root sb.
> 
> Fixes: bf109c64040f ("fuse: implement crossmounts")
> Cc: mreitz@redhat.com
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Max Reitz <mreitz@redhat.com>

