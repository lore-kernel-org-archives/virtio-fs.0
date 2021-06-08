References: <20210604161156.408496-1-groug@kaod.org>
	<20210604161156.408496-3-groug@kaod.org>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <0daa30dc-ea49-dbe3-eac5-4b47dceb54eb@redhat.com>
Date: Tue, 8 Jun 2021 17:08:37 +0200
MIME-Version: 1.0
In-Reply-To: <20210604161156.408496-3-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 2/7] fuse: Fix crash if superblock of
 submount gets killed early
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
> As soon as fuse_dentry_automount() does up_write(&sb->s_umount), the
> superblock can theoretically be killed. If this happens before the
> submount was added to the &fc->mounts list, fuse_mount_remove() later
> crashes in list_del_init() because it assumes the submount to be
> already there.
>
> Add the submount before dropping sb->s_umount to fix the inconsistency.
> It is okay to nest fc->killsb under sb->s_umount, we already do this
> on the ->kill_sb() path.
>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Max Reitz <mreitz@redhat.com>

