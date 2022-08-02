Return-Path: <dgilbert@redhat.com>
Date: Tue, 2 Aug 2022 11:33:21 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <Yuj9ca+1O2xya1mV@work-vm>
References: <YuPd0itNIAz4tQRt@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YuPd0itNIAz4tQRt@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Disable killpriv_v2 by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, Miklos Szeredi <mszeredi@redhat.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> We are having bunch of issues with killpriv_v2 enabled by default. First
> of all it relies on clearing suid/sgid bits as needed by dropping
> capability CAP_FSETID. This does not work for remote filesystems like
> NFS (and possibly others). 
> 
> Secondly, we are noticing other issues related to clearing of SGID
> which leads to failures for xfstests generic/355 and generic/193.
> 
> Thirdly, there are other issues w.r.t caching of metadata (suid/sgid)
> bits in fuse client with killpriv_v2 enabled. Guest can cache that
> data for sometime even if cleared on server.
> 
> Second and Third issue are fixable. Just that it might take a little
> while to get it fixed in kernel. First one will probably not see
> any movement for a long time.
> 
> Given these issues, killpriv_v2 does not seem to be a good candidate
> for enabling by default. We have already disabled it by default in
> rust version of virtiofsd.
> 
> Hence this patch disabled killpriv_v2 by default. User can choose to
> enable it by passing option "-o killpriv_v2".
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

OK, yes I see the corresponding 9b03f65d commit in the Rust version.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>


> ---
>  tools/virtiofsd/passthrough_ll.c |   13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2022-07-29 08:19:05.925119947 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2022-07-29 08:27:08.048049096 -0400
> @@ -767,19 +767,10 @@ static void lo_init(void *userdata, stru
>          fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling killpriv_v2\n");
>          conn->want |= FUSE_CAP_HANDLE_KILLPRIV_V2;
>          lo->killpriv_v2 = 1;
> -    } else if (lo->user_killpriv_v2 == -1 &&
> -               conn->capable & FUSE_CAP_HANDLE_KILLPRIV_V2) {
> -        /*
> -         * User did not specify a value for killpriv_v2. By default enable it
> -         * if connection offers this capability
> -         */
> -        fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling killpriv_v2\n");
> -        conn->want |= FUSE_CAP_HANDLE_KILLPRIV_V2;
> -        lo->killpriv_v2 = 1;
>      } else {
>          /*
> -         * Either user specified to disable killpriv_v2, or connection does
> -         * not offer this capability. Disable killpriv_v2 in both the cases
> +         * Either user specified to disable killpriv_v2, or did not
> +         * specify anything. Disable killpriv_v2 in both the cases.
>           */
>          fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling killpriv_v2\n");
>          conn->want &= ~FUSE_CAP_HANDLE_KILLPRIV_V2;
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

