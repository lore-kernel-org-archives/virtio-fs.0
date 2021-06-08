References: <20210604161156.408496-1-groug@kaod.org>
	<20210604161156.408496-4-groug@kaod.org>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <1fc488d8-91b8-9613-8127-a8b34ddb4744@redhat.com>
Date: Tue, 8 Jun 2021 17:12:15 +0200
MIME-Version: 1.0
In-Reply-To: <20210604161156.408496-4-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 3/7] fuse: Fix infinite loop in sget_fc()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On 04.06.21 18:11, Greg Kurz wrote:
> We don't set the SB_BORN flag on submounts. This is wrong as these
> superblocks are then considered as partially constructed or dying
> in the rest of the code and can break some assumptions.
>
> One such case is when you have a virtiofs filesystem with submounts
> and you try to mount it again : virtio_fs_get_tree() tries to obtain
> a superblock with sget_fc(). The logic in sget_fc() is to loop until
> it has either found an existing matching superblock with SB_BORN set
> or to create a brand new one. It is assumed that a superblock without
> SB_BORN is transient and the loop is restarted. Forgetting to set
> SB_BORN on submounts hence causes sget_fc() to retry forever.
>
> Setting SB_BORN requires special care, i.e. a write barrier for
> super_cache_count() which can check SB_BORN without taking any lock.
> We should call vfs_get_tree() to deal with that but this requires
> to have a proper ->get_tree() implementation for submounts, which
> is a bigger piece of work. Go for a simple bug fix in the meatime.
>
> Fixes: bf109c64040f ("fuse: implement crossmounts")
> Cc: mreitz@redhat.com
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)

Reviewed-by: Max Reitz <mreitz@redhat.com>

