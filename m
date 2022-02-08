Date: Tue, 8 Feb 2022 12:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=sLwWaKjDpVCsk1q2+ePpfneswoPb1qvQEmCAaSARG6c=; b=h
	bFOZTkKlG9xPgNEqIdgt5/DqA66zAcF542Uxpex7IWZGawkZu9BKquk3Q4lfd4ds
	UruQt1YZ+4SEBg56ASlSCprXtVrWJ7jVfDthV8wNYUSJRlagaCUu7xIx0TBweAce
	sXIGIWkheZ3BFVwZvsojiJywYTevXB6X/ApVUZwpHATLhg3wtQaxvnwZN+a+ohXX
	9K4JzNPxJBDXSDELU0Z1kI5mFn9RNIVCx9u3s15St8mpBJAGmPdCwWwQ25Njv9nu
	RTb7FS5PHuGEG094gtt6Xn8Db6a1En/tFTQP4gNDxR6VTtneDNmQtS4KKVLXxrun
	jSxbpEcvTJusJXejClaiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=sLwWaKjDpVCsk1q2+ePpfneswoPb1
	qvQEmCAaSARG6c=; b=dX5Na/yGTRINS5Vjx08API3kk3MusS8jt67aXSo3OHFKk
	SsFz9E9NnIO3LQHqNnix6S/rbpSp52YDClleGPIFPd0ZMdBWQPP/CDq315tvK5vt
	5z1ugTRoMNNgo8qtf1ANInX4QM8LD5FAZkxKx2zlRfUukJH7Lb+A+maFiftN90F4
	QAS7cmVQshMYRIY9SZabW99ZI5xx0PtyMwYsBs6RmzhZUgbQR9UANNovhBrNqlD+
	Q2gR0FayA4u4Lq/dvHu3KzGq3EnnyN+Me2ETHHDaiDayWC6AsKOu9NgQikdk7mvS
	WZeESv6C+/7amsBdFfpKL1cZhi8wexPVpkRXtehQw==
From: virtiofs-bot@sinrega.org
Message-Id: <96856.122020812142601561@us-mta-210.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Server: Store enabled FSOptions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Store enabled FSOptions as Server field and get the correct structure based on whether SETXATTR_EXT is set in the negotiated FSOptions flags.

Also, pass the 'SetxattrIn::setxattr_flags' as extra flags to 'FileSystem::setxattr', currently this argument is ignored, but will be required to implement posix_acls and selinux support.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/92

