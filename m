Date: Fri, 11 Feb 2022 12:08:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=YpGe8o+X+ot5SfAsrLAgpQwllLhHhLpxygo/hJ10Fws=; b=u
	OBr7vHwuxBXuHCXgMO1hzmcK//mzEfhOWrIT5aXcmpUy2f8N8Jbu6a6BWyAsvcxm
	gfTmziZ3EMaQhzkzGrCM01x+ZkyyhGQ+Q0dUylo8e/g6XfmDz5k8r+5bdFogTrd4
	r7NP9yJ3sAUy6wuUSgCS+6TAfIV/QSaRcHP1AAcIdoBr0QepPhMXyaEPdqljXLGQ
	NTbzTCbCxS9ViYjGaKVRZHkVSspyIQnGyWYj+VeZSpwW2LuxCOr3Yse78/G4yQqq
	8l9rkWGcXDhzW4+7E66jf7OcjwGV0BU9zLktQjdXa5F+NnZG8wzYhGQLbTe7ROA8
	8AK/sNkd6OrLQKxB38/8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=YpGe8o+X+ot5SfAsrLAgpQwllLhHh
	Lpxygo/hJ10Fws=; b=oos/QlAJ1WCcfbRO1XT7YsXJtKdDqOgJyH4lK63iZUfNe
	XMvLsZEcCR1P0H3JLJYn/aDrbuFCYhrraElF9ICQC+kvicqyLjseZNWZLO59y+aF
	KGhInGzj+oykRqHJjKBpynmERsZbHtUCO396Ho/CKwAHHkrg8LahF8BMOdjzl2Fe
	pZ4QP7gDx78Haf3c4UK22vmwazZGL7e4f8HdQCbdq4cZ4D5mUZGyLhtpQ0gK+flw
	h8i7QAHKDl+IIPXMyqf5jV4ZLmgo7quFlvU1uz8g9K7W7SNzc9xV09Ky64yW7TK6
	c06X/5hyYmijn4UAkGVS3TOA0vT2vlyuBy3QOauFg==
From: virtiofs-bot@sinrega.org
Message-Id: <33237.122021112085101677@us-mta-595.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: fuse: Debug-log opcode name and
	inode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When log-level is debug, log the opcode name (instead of just the
number) and the inode for each request.  Example:

```
[2022-02-11T17:04:34Z INFO  virtiofsd] Waiting for vhost-user socket connection...
[2022-02-11T17:04:37Z INFO  virtiofsd] Client connected, servicing requests
[2022-02-11T17:04:41Z DEBUG virtiofsd] HIPRIO_QUEUE_EVENT
[2022-02-11T17:04:41Z DEBUG virtiofsd] QUEUE_EVENT
[2022-02-11T17:06:39Z DEBUG virtiofsd] QUEUE_EVENT
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Received request: opcode=Init, inode=0
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Replying OK, header: OutHeader { len: 80, error: 0, unique: 2 }
[2022-02-11T17:06:39Z DEBUG virtiofsd] QUEUE_EVENT
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Received request: opcode=Getxattr, inode=1
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Replying ERROR, header: OutHeader { len: 16, error: -38, unique: 4 }
```
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/93

