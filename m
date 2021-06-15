DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=bK7I/35VnTAlHtEHWhCuQV+xwWwalH5Gniz7n9zsDQM=;
	b=MZYLAi14vfuRZR5OZFSwg3chsYoDmQ/sEixkpXbur118veNcZ1IICoL4shLDWljbQ4
	R7E8fBJe6yHjJgoREZPxQyLe4Mn+ii8MmwAMbXzy+vWd+UH38XikCXXCNLByQDxdfGWu
	DHPKJRs2z6EwtXVKuQ6YIWxPTlkjYa7uXQW2j6NEMPstxRCxuotk0orGSVImrmN9RieD
	7INbkPux18EtqvZoOFgb94a4aUv3MGspPBLBhMjbxBmDh9sWDyWChwtUNxluyUOChy+v
	u7ZQu6tcXoceS7uEyVd5rAX3Nm9qr86+qD4eji0h7SwDiLovvq3qn6i3mWrv3AXM2OiW
	PkTA==
References: <20210611120427.49736-1-berrange@redhat.com>
	<20210611154222.GA761698@redhat.com> <YMjLZUqZ5nhihJ1X@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <d06eee40-e913-68ea-64a8-4b4592b5546b@gmail.com>
Date: Tue, 15 Jun 2021 12:19:25 -0500
MIME-Version: 1.0
In-Reply-To: <YMjLZUqZ5nhihJ1X@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH] docs: describe the security considerations
 with virtiofsd xattr mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

On 6/15/21 10:46 AM, Daniel P. Berrangé wrote, in part:
>  - Don't use xattrs at all for remapping, instead use
>    hidden files.

As not every host filesystem will have xattrs, or have xattrs enabled: 
Isn't something like the above required of virtiofsd anyway?

Also, for security, you might consider creating a parallel hidden
directory tree 'beside' the shared root (so not exposed to the guest)
then put the xattrs in files there.  So if /var/shared/foo is visible to
the guest, /var/shared/.foo.guest_xattrs/ parallels that.




