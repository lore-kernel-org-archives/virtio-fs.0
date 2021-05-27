References: <20210525150230.157586-1-groug@kaod.org>
	<20210525150230.157586-5-groug@kaod.org>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <db587ac1-f06b-6e6f-92fe-c94bd4849a51@redhat.com>
Date: Thu, 27 May 2021 15:28:04 +0200
MIME-Version: 1.0
In-Reply-To: <20210525150230.157586-5-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 4/4] fuse: Make fuse_fill_super_submount()
 static
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

On 25.05.21 17:02, Greg Kurz wrote:
> This function used to be called from fuse_dentry_automount(). This code
> was moved to fuse_get_tree_submount() in the same file since then. It
> is unlikely there will ever be another user. No need to be extern in
> this case.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/fuse_i.h | 9 ---------
>   fs/fuse/inode.c  | 4 ++--
>   2 files changed, 2 insertions(+), 11 deletions(-)

Reviewed-by: Max Reitz <mreitz@redhat.com>

