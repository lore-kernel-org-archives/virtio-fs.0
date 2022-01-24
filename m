Date: Mon, 24 Jan 2022 14:24:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=w1ZalB0n0a+iU821BqCfAe6NYbEPwZhpP3A0TD6dB7I=; b=h
	zWAbCLWn+JnRyoi7jrWBl3rFpv47ezfe4WHD8sbwr94V/VEcH+uH+Fb/9wBXGh7H
	gmxQV0sQ6ltho5rGNXj/2pQYTISz0s3Eps86jiJNu8BsJeAE32TapgbP4OVliIIj
	8zODm/TBHqFcAPNYmCVSXRfQNrphojI8tLhkjt6ssbb/fZHoZHdfDWcUTbM1bXwJ
	IaGvmCNLdD7s1DGrryV58mLjaAGd4XcVwDPIB5xbli+fHWeksANksbSYROKTC+XJ
	Yrca0ZdKhpFkaPC7L2h+rBiV10aeD5Yv0HoBSAxZYuT3Z7MMVsNdKH+cZZfO2jqH
	ESlgh1mtbP3dw/8vScAZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=w1ZalB0n0a+iU821BqCfAe6NYbEPw
	ZhpP3A0TD6dB7I=; b=hpWKGwuqk4ytvKED/LGEZvZR3WOHcYMi+yzAbX8Bobayr
	5+Ykj2VHoDFlEQ9MramrvEnBDihJ/Ff25E9AIklIzkNvLlNxqYJ2nlNj81jSf4TT
	4tkeenzBNS8hKVGliJKv6uOO17xDCPC5Agb9w9Xi9oMdlcLVKeScIYTUDv16knxN
	ux22+Td/6BzCVgR+elZHqzOF0siHoVxBBdcilpxiuYR49eiYMScRwhgncAF4Ha+F
	YNSMGi1MXAZpWsbnIUXfeaeTQKHr4JA68W/lwmmbghKsgYBxVDKAyHrQv5iy4coh
	8GJ1U7pWXKd3SMD1sLkCR2TtgEZZ2uZCZhkK0b0oQ==
From: virtiofs-bot@sinrega.org
Message-Id: <75741.122012414242901923@us-mta-620.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Add examples of how to run
	virtiofsd inside a user namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Expanding the current documentation with some examples of how to run virtiofsd inside a user namespace.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/74

