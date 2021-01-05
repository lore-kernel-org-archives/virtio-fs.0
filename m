DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rath.org; h=from
	:to:cc:subject:references:date:in-reply-to:message-id
	:mime-version:content-type:content-transfer-encoding; s=fm1; bh=
	b/JaRXMnZdfCEeurWxv6+1jf9b9QjVrYUPb5jlRij+Y=; b=jS5+US0YEGH/d3rd
	HPUI8MgXhiV5sv8VRNwcj0yBzx7nis3PeSNLPB5cDR49c2MuneWisQ+DYgCnOZIH
	dbQq8WncYEfZffXBDx3VDUcuW/91tx59g/V5xQl6hLffc8C1xipsqUKzLuzUm4mK
	DEPfzFiy8AlyskdEEygtJFb/6aNH3WD/4NEglbrGyGPcWqSyN3doKfAgAwBz394w
	Z28FIf+AFlbRjmtPsqVekN7+4CclCKtbfVSvvKhazOxegvhih7Ftsh1n2xhppSV5
	TL1+O+R3NAa1y9papXnBjxI72t3zgwSX8L3uG0oB2FP4GRR7tzuxF7wixFY72RXq
	4bBHDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; bh=b/JaRXMnZdfCEeurWxv6+1jf9b9QjVrYUPb5jlRij
	+Y=; b=dFoEAXdnkYDNnzUGsDqNRDge+aL6YAHw8NgIZPUn6kDVmnJPO2O9xaRRz
	FPsZQqUfNVFfG8UTtK0RrZUYw+Fb+J0IeXI46dQKMrdz9SedF9dvuq25GA/ljHJY
	5yEm5hR5bZICNKE+/2MYyybgmqC4cp5/cvcmjlvaOZxOW2n40VU4HTScwUItiUHw
	gMyeCi4vRFPMrwY1ILWf0PWBqjcRg9FA1/KCHpvecKsHI78a9L2sozqvCuBXW5v8
	L0HejnrMGBaCISlOMBvsFwewqJZ4DsklIfiFrUD5TzyiFzDS5lGsKagyoe3WipXW
	1WZoQPGAYR1pH6K/o02IsDYKoNHuw==
From: Nikolaus Rath <Nikolaus@rath.org>
References: <20210104160013.GG2972@work-vm>
Date: Tue, 05 Jan 2021 10:11:41 +0000
In-Reply-To: <20210104160013.GG2972@work-vm> (David Alan Gilbert's message of
	"Mon, 4 Jan 2021 16:00:13 +0000")
Message-ID: <87turvsnfm.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [fuse-devel] 'FORGET' ordering semantics (vs unlink
	& NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: fuse-devel@lists.sourceforge.net, virtio-fs@redhat.com, vgoyal@redhat.com

On Jan 04 2021, "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> Hi,
>   On virtio-fs we're hitting a problem with NFS, where
> unlinking a file in a directory and then rmdir'ing that
> directory fails complaining about the directory not being empty.
>
> The problem here is that if a file has an open fd, NFS doesn't
> actually delete the file on unlink, it just renames it to
> a hidden file (e.g. .nfs*******).  That open file is there because
> the 'FORGET' hasn't completed yet by the time the rmdir is issued.


Are you really talking about FORGET and file descriptors here? I always
assumed that the kernel will only drop dentries (aka emit FORGET) when
all fds are closed and never saw otherwise in practice.

Do you mean RELEASE rather than FORGET, or dentry rather than file descriptor?

Best,
-Nikolaus

-- 
GPG Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«


