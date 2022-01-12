DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=stuvus.uni-stuttgart.de; s=20200828.smtp01;
	h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dcRu7FojRWTNXtKiFm4Pu19KnNsiQKZkESkvqs4+2kM=;
	b=hsBXdP2QbWeNNPDyIWBmCPUwx
	ujzdcQ/giu/rFaVdFYJd2uqyHusZ9X99KsRAR741j4MM/EORNJF+bWAv2rMSzGP8SzH1d4Hx6XPOh
	+fIWPYZR6bYHgew9n/KNb2cn64jNDsuAF1czj83ps7gw1jUbiJXWWI7cYTmLea1SlXogYVaSYeIkX
	aIHrehC7GWunw8Zi1itVm+0CAwjQ35wqfsTk1RxgNGEwW9/iWuG1J3Z2ti/Ch+aqnXUUaRI4+HErB
	MrrrQrUFlpyXICI1JvPDEZyT174C+xbmevDRlg8mi4HaPanM1zGDxxNF1hflMeaUDT8WNzsiDjzba
	Ivuc/9Brw==
Message-ID: <d2f48cc3-b539-eb4d-bb4d-96f915a51f80@stuvus.uni-stuttgart.de>
Date: Wed, 12 Jan 2022 18:18:08 +0100
MIME-Version: 1.0
References: <20220111181043.435915-1-sebastian.hasler@stuvus.uni-stuttgart.de>
From: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
In-Reply-To: <20220111181043.435915-1-sebastian.hasler@stuvus.uni-stuttgart.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Do not support blocking flock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com


On 11/01/2022 19:10, Sebastian Hasler wrote:
> With the current implementation, blocking flock can lead to
> deadlock. Thus, it's better to return EOPNOTSUPP if a user attempts
> to perform a blocking flock request.
>
> Signed-off-by: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
> ---
>   tools/virtiofsd/passthrough_ll.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 64b5b4fbb1..f3cc307f6d 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2442,6 +2442,12 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>       int res;
>       (void)ino;
>   
> +    if (!(op & LOCK_NB)) {
> +        /* Blocking flock is not supported */
> +        fuse_reply_err(req, EOPNOTSUPP);
> +        return;
> +    }
> +
>       res = flock(lo_fi_fd(req, fi), op);
>   
>       fuse_reply_err(req, res == -1 ? errno : 0);

I tested this patch by cherry-picking it on v6.1.0 and using it with 
Kata Containers 2.3.0. The bash code

     exec 42>/lock/flock
     flock -w 120 42

outputs

     flock: 42: Operation not supported

while the bash code

     exec 42>/lock/flock
     flock --nonblock 42

still works. So it works as intended.

-- 
Sebastian Hasler

stuvus – Studierendenvertretung Universität Stuttgart

