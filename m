Date: Wed, 26 May 2021 11:16:09 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <13915.121052611160001147@us-mta-512.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6qmdMFSZkSt36G+vR
	uk+BLBw0kuuNk8c6Idd1uhpMww=; b=Wq+6AXuRSFA5AxkffFi0DTEj6IM/Cq1Uc
	afjS887meTV0TxrDLZtX/QCRrlR7kbNQB4U+veNjfneAwzgDlqSJ/ctOIIXQbGtT
	DLAj3ga19UAncMRHkDkb/3v7J2FOZ9i2TqLhjEP8oZtZM2TL/yBd5Bod/bbf+2vy
	nVoJeCg8dEiag8k2e6dYMMsvJO9ccoLQ7Nz6uL7ajVItiaE6cJ0JbCoFvgw46ICj
	seMiSxwEg7aAiwpGGL7XdLEL7IHj64faQJbhKY2lRr0L3IsABlLQbemcqWTv2Yeg
	6RW5xUWfKCle3eM3gmvP0QAOrNt1U0oLi3ryBPm87K86jEeD9oBLA==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Infer type to fix build on
	Aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fixes #13 

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/28

