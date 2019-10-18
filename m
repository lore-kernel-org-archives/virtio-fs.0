DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=WST3IHmB4Yaq0s+j7mfZWbA/H08o+3ozNzjBE/vWdQg=;
	b=vBYTmxPnm1QbaJzCVBCm2zqLKKQMj4NzOSQN617kxPffI4E9ovSG6fNsMm9XIhrnQg
	1+44mCRhEG76+Lc/oljHqo/XDQd7DQoW+Tl45M4Bno0jOE85OiQqH6Z0ljJ9hySvAt9O
	zZEXEB3VzRWNH4KUZxGB3YyXQuFHWVb58OhVH4HumnsH0LWsLFanBqeuJEX6oRRsH4po
	9YHsyRZGatl5+TGIALi8CAIdOV48/azJVwvmxpVD/9Mi/ywHX6R9WyX9NyFYxuzfMtYB
	Qa8XkmSw9Z00CeAKlw365+WWFcaDXNRdySH6Pwb/HYg3QiFkH3QT03/Gbrzpmn2PlRvT
	rs8A==
Date: Fri, 18 Oct 2019 17:15:38 +0800
From: Eryu Guan <guaneryu@gmail.com>
Message-ID: <20191018091533.GM2622@desktop>
References: <20191015083228.13475-1-qi.fuli@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015083228.13475-1-qi.fuli@fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] fstests: Add virtio-fs shared file system
 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: QI Fuli <qi.fuli@fujitsu.com>
Cc: virtio-fs@redhat.com, Misono Tomohiro <misono.tomohiro@fujitsu.com>, fstests@vger.kernel.org

On Tue, Oct 15, 2019 at 05:32:28PM +0900, QI Fuli wrote:
> This patch adds support for virtio-fs shared file system that lets
> virtual machines access a directory tree on the host.
> 
> To run xfstests on it, first, start virtiofsd daemon in host:
>  ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu0 -o source=$DIR0 -o cache=always
>  ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu1 -o source=$DIR1 -o cache=always
> 
> second, launch QEMU with:
>  -chardev socket,id=char0,path=/tmp/vhostqemu0
>  -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs0
>  -chardev socket,id=char1,path=/tmp/vhostqemu1
>  -device vhost-user-fs-pci,queue-size=1024,chardev=char1,tag=myfs1
>  -m 8G
>  -object memory-backend-file,id=mem,size=8G,mem-path=/dev/shm,share=on
>  -numa node,memdev=mem
> 
> then, inside the VM run xfstests with:
>  export TEST_DEV=myfs0
>  export TEST_DIR=$TESTDIR
>  export SCRATCH_DEV=myfs1
>  export SCRATCH_MNT=$SCRATCHMNT
>  export MOUNT_OPTIONS=""
>  export TEST_FS_MOUNT_OPTS=""
> 
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
> Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>

Looks good to me, thanks for the patch!

Eryu

> ---
>  check         |  2 ++
>  common/config |  4 ++--
>  common/rc     | 18 +++++++++++++++---
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/check b/check
> index c7f1dc5e..2e148e57 100755
> --- a/check
> +++ b/check
> @@ -56,6 +56,7 @@ check options
>      -glusterfs		test GlusterFS
>      -cifs		test CIFS
>      -9p			test 9p
> +    -virtiofs		test virtiofs
>      -overlay		test overlay
>      -pvfs2		test PVFS2
>      -tmpfs		test TMPFS
> @@ -268,6 +269,7 @@ while [ $# -gt 0 ]; do
>  	-glusterfs)	FSTYP=glusterfs ;;
>  	-cifs)		FSTYP=cifs ;;
>  	-9p)		FSTYP=9p ;;
> +	-virtiofs)	FSTYP=virtiofs ;;
>  	-overlay)	FSTYP=overlay; export OVERLAY=true ;;
>  	-pvfs2)		FSTYP=pvfs2 ;;
>  	-tmpfs)		FSTYP=tmpfs ;;
> diff --git a/common/config b/common/config
> index a0d58bde..2cb0202a 100644
> --- a/common/config
> +++ b/common/config
> @@ -480,8 +480,8 @@ _check_device()
>  	fi
>  
>  	case "$FSTYP" in
> -	9p|tmpfs)
> -		# 9p mount tags are just plain strings, so anything is allowed
> +	9p|tmpfs|virtiofs)
> +		# 9p and virtiofs mount tags are just plain strings, so anything is allowed
>  		# tmpfs doesn't use mount source, ignore
>  		;;
>  	overlay)
> diff --git a/common/rc b/common/rc
> index cfaabf10..3d5c8b23 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -603,6 +603,9 @@ _test_mkfs()
>      9p)
>  	# do nothing for 9p
>  	;;
> +    virtiofs)
> +	# do nothing for virtiofs
> +	;;
>      ceph)
>  	# do nothing for ceph
>  	;;
> @@ -640,6 +643,9 @@ _mkfs_dev()
>      9p)
>  	# do nothing for 9p
>  	;;
> +    virtiofs)
> +	# do nothing for virtiofs
> +	;;
>      overlay)
>  	# do nothing for overlay
>  	;;
> @@ -704,7 +710,7 @@ _scratch_mkfs()
>  	local mkfs_status
>  
>  	case $FSTYP in
> -	nfs*|cifs|ceph|overlay|glusterfs|pvfs2|9p)
> +	nfs*|cifs|ceph|overlay|glusterfs|pvfs2|9p|virtiofs)
>  		# unable to re-create this fstyp, just remove all files in
>  		# $SCRATCH_MNT to avoid EEXIST caused by the leftover files
>  		# created in previous runs
> @@ -1467,7 +1473,7 @@ _require_scratch_nocheck()
>  			_notrun "this test requires a valid \$SCRATCH_MNT"
>  		fi
>  		;;
> -	9p)
> +	9p|virtiofs)
>  		if [ -z "$SCRATCH_DEV" ]; then
>  			_notrun "this test requires a valid \$SCRATCH_DEV"
>  		fi
> @@ -1591,7 +1597,7 @@ _require_test()
>  			_notrun "this test requires a valid \$TEST_DIR"
>  		fi
>  		;;
> -	9p)
> +	9p|virtiofs)
>  		if [ -z "$TEST_DEV" ]; then
>  			_notrun "this test requires a valid \$TEST_DEV"
>  		fi
> @@ -2686,6 +2692,9 @@ _check_test_fs()
>      9p)
>  	# no way to check consistency for 9p
>  	;;
> +    virtiofs)
> +	# no way to check consistency for virtiofs
> +	;;
>      ceph)
>  	# no way to check consistency for CephFS
>  	;;
> @@ -2744,6 +2753,9 @@ _check_scratch_fs()
>      9p)
>  	# no way to check consistency for 9p
>  	;;
> +    virtiofs)
> +	# no way to check consistency for virtiofs
> +	;;
>      ceph)
>  	# no way to check consistency for CephFS
>  	;;
> -- 
> 2.20.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

