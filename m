From: JeffleXu <jefflexu@linux.alibaba.com>
References: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
Message-ID: <dd4c7cd8-bbf0-4e15-8ed9-d6babdc40eca@linux.alibaba.com>
Date: Tue, 7 Sep 2021 10:07:19 +0800
MIME-Version: 1.0
In-Reply-To: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofs: miscellaneous fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

ping ...

On 8/12/21 1:46 PM, Jeffle Xu wrote:
> Some fixes or optimization for virtiofs, which are authored by Liu Bo.
> 
> Liu Bo (2):
>   virtio-fs: disable atomic_o_trunc if no_open is enabled
>   virtiofs: reduce lock contention on fpq->lock
> 
>  fs/fuse/file.c      | 11 +++++++++--
>  fs/fuse/virtio_fs.c |  3 ---
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 

-- 
Thanks,
Jeffle

