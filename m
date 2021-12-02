Date: Thu, 2 Dec 2021 04:51:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=r31xEKYz8u6/3iV9m/ePJJzcf/qdmqPa6nYXF
	MF+Bs8=; b=Cw9Sktko5e7b7P8krU89BiwPsC8R/JXIN7lQSFVLA4NyCiC8j5q3N
	7g4pVtJ9E1tWbgrc7CjwDtj4V3ogI69tU+qaU7zVLlP4zddB3keP5SUwLFtTiE5B
	FWhaBucfFxg56riEx77NqAI2a0LBBHhIaiN5igqHMUtQKUkOYBvThNzn5rOlo01w
	njTncPfRhewTzc/UoIpr4G/bbrbY7o9b3RY6PrC4JqDfCWjLT4zRLfUCSWsq9TdS
	FKAMZqlPn6riFvy6VNX3oCuET6kgV8DS5mzhBfOQs89RCsjT5ckAe9G7AxmUhJmX
	4Q7/amWCEwcX7xJlaFqUKqKp5EmnURMNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=r31xEKYz8u6/3iV9m
	/ePJJzcf/qdmqPa6nYXFMF+Bs8=; b=X6/UK6zmPJ0/ocoxOGpYpMloYlDrvbtgl
	ymGtTATYYu0qHgb0qUNpB4TYLGUe67gazfYEBAzGsNbsKWibNRyF7YOeHDxMSs0i
	rhO1z0j+13FifmllRSaHeiJWhFq6kHKZzrcgmFItkDep+BRpGHGhsoDpqxqmgPuN
	//jThge0LjTO11BYFyod79JTJmdIg3KXVEtTEACIHc81MaTEPpDE1qpRYpxAMnDr
	nZCBIwTrMIebbGdlaJqVoQjdC9e0hS/IyF3afWCi8iF9s96HxarJ7p/FivscKKs4
	6rk3J3GOt5U7UXUXURqx8EwX0vwe4PGAt/I4BuPCs857P7PiZAHvA==
From: virtiofs-bot@sinrega.org
Message-Id: <05023.121120204510000539@us-mta-29.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Correctly open mountinfo with
	sandbox=none
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We need to open `/proc/self/mountinfo` with `O_RDONLY`, because we want to read from it.  Instead, we open it with `O_PATH` (when using sandbox=none), though, which is wrong and will later prevent us from creating openable file handles.

Fix it.

(Reported by German)
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/52

