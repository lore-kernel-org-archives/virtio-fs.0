References: <20210604161156.408496-1-groug@kaod.org>
	<20210604161156.408496-6-groug@kaod.org>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <f4161490-f7ed-78f0-bf05-96040cbb31e9@redhat.com>
Date: Tue, 8 Jun 2021 17:40:37 +0200
MIME-Version: 1.0
In-Reply-To: <20210604161156.408496-6-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 5/7] fuse: Call vfs_get_tree() for
	submounts
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
> We recently fixed an infinite loop by setting the SB_BORN flag on
> submounts along with the write barrier needed by super_cache_count().
> This is the job of vfs_get_tree() and FUSE shouldn't have to care
> about the barrier at all.
>
> Split out some code from fuse_dentry_automount() to the dedicated
> fuse_get_tree_submount() handler for submounts and call vfs_get_tree().
>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c   | 53 +++++--------------------------------------------
>   fs/fuse/inode.c | 36 +++++++++++++++++++++++++++++++++
>   2 files changed, 41 insertions(+), 48 deletions(-)

Reviewed-by: Max Reitz <mreitz@redhat.com>

