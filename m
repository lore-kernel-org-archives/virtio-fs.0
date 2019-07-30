DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
	h=subject : to :
	references : from : message-id : date : mime-version : in-reply-to :
	content-type : content-transfer-encoding; s=corp-2018-07-02;
	bh=TdL8lYAbo8VRfghnHW9UAHDiOlDzL3xO1gRPLcN8n58=;
	b=mdmf6V358bPDUopEO9NVonUYx6XwfPFfoZ1sZEii9FJz6a4k646Pr2iEOlGYopsZQlgQ
	siIzHB10d5GSfAd6wRTVpMbZqPxtM0fyGvSYkTy45e7jBMK67NPCC8Hj1wLX6LkRBMaU
	0I03vTwsLDsMD69eTX0FErFQ30tfinFJLqP3yakya9v9oOtttnkvcflJ3hBwkqGk8Isl
	MBNMbuLVuuxNx3Q0worQmIMv3M4Ctlu482x91Vcem8xNDyth8MFj2MjW0VSDl0aR1LPe
	JkzS/ZIAUqjqJjolYGcDIFmP/6LiQbZyMYb0V5PQzMXHX5dHXibETsik1w1bUAdlc9uS
	kQ== 
References: <5D3F8F04.3030404@huawei.com>
From: Liam Merwick <liam.merwick@oracle.com>
Message-ID: <8748798a-ac4f-4c0a-96fa-190e24dca52b@oracle.com>
Date: Tue, 30 Jul 2019 13:22:56 +0100
MIME-Version: 1.0
In-Reply-To: <5D3F8F04.3030404@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH] virtiofsd: fix compile error
 if 'F_OFD_GETLK' not defined
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>, virtio-fs@redhat.com, qemu-devel@nongnu.org

On 30/07/2019 01:27, piaojun wrote:
> Use F_GETLK for fcntl when F_OFD_GETLK not defined.


Use F_GETLK/F_SETLK for fcntl when F_OFD_GETLK/F_OFD_SETLK not defined.

> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>   contrib/virtiofsd/passthrough_ll.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 9ae1381..757785b 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1619,7 +1619,11 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
>   		return;
>   	}
> 
> +#ifdef F_OFD_GETLK
>   	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
> +#else
> +	ret = fcntl(plock->fd, F_GETLK, lock);
> +#endif
>   	if (ret == -1)
>   		saverr = errno;
>   	pthread_mutex_unlock(&inode->plock_mutex);
> @@ -1668,7 +1672,12 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
> 
>   	/* TODO: Is it alright to modify flock? */
>   	lock->l_pid = 0;
> +
> +#ifdef F_OFD_GETLK


This checks for F_OFD_GETLK but uses F_OFD_SETLK (albeit unlikely one 
being defined without the other)


>   	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
> +#else
> +	ret = fcntl(plock->fd, F_SETLK, lock);
> +#endif
>   	if (ret == -1) {
>   		saverr = errno;
>   	}
>
Might qemu_lock_fd()/qemu_unlock_fd() in util/osdep.c be useful to hide 
this instead?

Regards,
Liam

