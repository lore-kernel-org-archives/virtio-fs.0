Date: Mon, 19 Aug 2019 15:34:53 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20190819073453.GN52397@e18g06458.et15sqa>
References: <5D53D882.5090803@huawei.com>
 <5D5A4692.9060006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D5A4692.9060006@huawei.com>
Subject: Re: [Virtio-fs] [PATCH RESEND][RFC] virtiofsd: do not fall back to
 buffer io when cache=auto/always
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

On Mon, Aug 19, 2019 at 02:49:54PM +0800, piaojun wrote:
> When O_DIRECT flags is set by Guest, virtiofsd will open file with
> O_DIRECT, but unset 'fi->direct_io' which makes Guest go buffer io path.
> That causes inconsistency between Guest and Host.
> 
> The cache option in virtiofsd should not affect the file io mode, so
> set 'fi->direct_io' according to 'fi->flags'.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index ca11764..a9c98d0 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1774,8 +1774,10 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>  		fi->fh = fh;
>  		err = lo_do_lookup(req, parent, name, &e);
>  	}
> -	if (lo->cache == CACHE_NONE)
> +	if (fi->flags & O_DIRECT)

Looks like this changes cache=none behavior. Previously, we set
direct_io when cache=none and guest will go to dio path even when the
file is opened for buffer io.

But with this change, guest could do buffer io in cache=none case.

>  		fi->direct_io = 1;
> +	if (lo->cache == CACHE_NONE)
> +		fi->keep_cache = 0;

And this only causes guest to invalidate page cache at open(2) time, but
still go buffer io path on cache=none.

>  	else if (lo->cache == CACHE_ALWAYS)
>  		fi->keep_cache = 1;

I'm thinking about something like (totally untested):

--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1774,7 +1774,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
                fi->fh = fh;
                err = lo_do_lookup(req, parent, name, &e);
        }
-       if (lo->cache == CACHE_NONE)
+       if (lo->cache == CACHE_NONE || fi->flags & O_DIRECT)
                fi->direct_io = 1;
        else if (lo->cache == CACHE_ALWAYS)
                fi->keep_cache = 1;
@@ -1982,7 +1982,7 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
        }

        fi->fh = fh;
-       if (lo->cache == CACHE_NONE)
+       if (lo->cache == CACHE_NONE || fi->flags & O_DIRECT)
                fi->direct_io = 1;
        else if (lo->cache == CACHE_ALWAYS)
                fi->keep_cache = 1;

> 
> @@ -1982,8 +1984,11 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>  	}
> 
>  	fi->fh = fh;
> -	if (lo->cache == CACHE_NONE)
> +
> +	if (fi->flags & O_DIRECT)
>  		fi->direct_io = 1;
> +	if (lo->cache == CACHE_NONE)
> +		fi->keep_cache = 0;
>  	else if (lo->cache == CACHE_ALWAYS)
>  		fi->keep_cache = 1;

And this code snippet duplicates with lo_create(), maybe we could factor
it into a new helper function.

Thanks,
Eryu

