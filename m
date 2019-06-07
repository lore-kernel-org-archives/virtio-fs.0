Date: Fri, 7 Jun 2019 13:15:18 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190607121518.GG2631@work-vm>
References: <1559857436-52685-1-git-send-email-bo.liu@linux.alibaba.com>
	<1559857436-52685-3-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559857436-52685-3-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/5] virtiofsd: fix memory leak on
	lo.source
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

* Liu Bo (bo.liu@linux.alibaba.com) wrote:
> valgrind reported that lo.source is leaked on quiting, but it was defined
> as (const char*) as it may point to a const string "/".
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/passthrough_ll.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index b58708f..959d74d 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2269,9 +2269,8 @@ int main(int argc, char *argv[])
>  			err(1, "failed to stat source (\"%s\")", lo.source);
>  		if (!S_ISDIR(stat.st_mode))
>  			errx(1, "source is not a directory");
> -
>  	} else {
> -		lo.source = "/";
> +		lo.source = strdup("/");
>  	}
>  	lo.root.is_symlink = false;
>  	if (!lo.timeout_set) {
> @@ -2333,5 +2332,7 @@ err_out1:
>  	if (lo.root.fd >= 0)
>  		close(lo.root.fd);
>  
> +        free((char *)lo.source);
> +
>  	return ret ? 1 : 0;
>  }
> -- 
> 1.8.3.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

