References: <20190820134545.GA4233@redhat.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <d6fe5b15-5ca4-c189-3319-2b90150704d2@huawei.com>
Date: Tue, 20 Aug 2019 22:33:29 +0800
MIME-Version: 1.0
In-Reply-To: <20190820134545.GA4233@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Reset O_DIRECT flag during file
 open
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: aneesh.kumar@linux.vnet.ibm.com

Hi Vivek & Aneesh,

On 2019/8/20 21:45, Vivek Goyal wrote:
> If an application wants to do direct IO and opens a file with O_DIRECT
> in guest, that does not necessarily mean that we need to bypass page
> cache on host as well. So reset this flag on host.

I have a different understanding about this. The I/O mode should be kept
same both in Guest and Host. When doing direct io in Guest, the user may
want the data go to disk rather than kept in Host page cache which means
volatile. So it seems more reasonable that Guest and Host have the same
file I/0 semantics.

> 
> If somebody needs to bypass page cache on host as well (and it is safe to
> do so), we can add a knob in daemon later to control this behavior.

This discussion has some relationship with my RFC PATCH "virtiofsd: do
not fall back to buffer io when cache=auto/always", and we could involve
the issue mentioned in that email if you do not mind.

> 
> I check virtio-9p and they do reset O_DIRECT flag.

I just checked the virtio-9p code and found some strange comments which
seemed to say the server could not support direct I/O temporary. With
all these questions, I will CC the author of the code, and discuss them
together.

static int get_dotl_openflags(V9fsState *s, int oflags)
{
    int flags;
    /*
     * Filter the client open flags
     */
    flags = dotl_to_open_flags(oflags);
    flags &= ~(O_NOCTTY | O_ASYNC | O_CREAT);
    /*
     * Ignore direct disk access hint until the server supports it.
     */
    flags &= ~O_DIRECT;
    return flags;
}

> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: qemu/contrib/virtiofsd/passthrough_ll.c
> ===================================================================
> --- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2019-08-20 09:33:07.900975145 -0400
> +++ qemu/contrib/virtiofsd/passthrough_ll.c	2019-08-20 09:35:45.829414412 -0400
> @@ -1967,6 +1967,13 @@ static void lo_open(fuse_req_t req, fuse
>  	if (lo->writeback && (fi->flags & O_APPEND))
>  		fi->flags &= ~O_APPEND;
>  
> +	/*
> +	 * O_DIRECT in guest should not necessarily mean bypassing page
> +	 * cache on host as well. If somebody needs that behavior, it
> +	 * probably should be a configuration knob in daemon.
> +	 */
> +	fi->flags &= ~O_DIRECT;
> +

We need do the same thing for lo_create().

Thanks,
Jun

>  	sprintf(buf, "%i", lo_fd(req, ino));
>  	fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
>  	if (fd == -1)
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
> 

