Date: Wed, 14 Aug 2019 09:54:52 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190814085452.GA2920@work-vm>
References: <20190813192944.26009-1-vgoyal@redhat.com>
	<20190813192944.26009-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813192944.26009-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/4] virtiofsd: Fix number of padding bits
 in fuse_file_info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Currently we have 27 padding bits while there are 6 bit fields. I suspect
> this is wrong. We probably are trying to aling to 32 bits and hence padding
> bits should be 26 instead.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Yeh, I reckon this was broken upstream by 19accdf ~6 years ago; whether
it's fixable upstream I don't know because they have API requierments
since it's a library.

Still, it's definitely wrong so:

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/fuse_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/contrib/virtiofsd/fuse_common.h b/contrib/virtiofsd/fuse_common.h
> index 6419f66470..4d95f6f28b 100644
> --- a/contrib/virtiofsd/fuse_common.h
> +++ b/contrib/virtiofsd/fuse_common.h
> @@ -65,7 +65,7 @@ struct fuse_file_info {
>  	unsigned int flock_release : 1;
>  
>  	/** Padding.  Do not use*/
> -	unsigned int padding : 27;
> +	unsigned int padding : 26;
>  
>  	/** File handle.  May be filled in by filesystem in open().
>  	    Available in all other file operations */
> -- 
> 2.17.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

