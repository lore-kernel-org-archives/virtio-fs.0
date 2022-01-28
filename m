Date: Fri, 28 Jan 2022 07:55:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=s7XyMleQYR84oHmPlgOcg8JFk6dUXr+0UUiYmk9gu7g=; b=n
	lGxP8QNw6ieEyKFcK9BbQ8O0fLR8SMe8CG3QrEa0g/j8XDOyaxuIf8Jpe5KNYHQi
	XS8zvw/Ot08obbpaiJLIOmc+PSwAv67WyNjs5TSzmenOxh+xFjAmWs/nEcqUDa1S
	XLceMT1s5FXSe8+LKPByzis1xS2P8Kvq2XazcAmYMjRuVOmi3sVd3iCK3bUviMmK
	C6wNwyUorGEkwrT4rhH/CbDVF1/stOooHhi5fq7+tY3pUdYBGUjS4i0nUaSFqaqn
	AZ/ln/RlHf6srQSYcKpuAy+FdZ/xtc5uBCaG+OwABfhDdEFOpr0aKkLi3L6tjVuC
	edjogBFXrfEqblOOr0GvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=s7XyMleQYR84oHmPlgOcg8JFk6dUX
	r+0UUiYmk9gu7g=; b=ZPHA1KBNHRD9S2E1zGYuDQS4WzzhCSOPAapqBwLzmUGjq
	UJSf8tisOF4t/RME0Wj0IvsMIgeP+3r6nOJ/lgn781QKJoKjOF3Vn8II/tesq+mF
	KxuCY6tYNZm3qpqmoV4XOxsBeoVE5izSAAc+C32ydcR38Y6tS3p5bVnvmyvCSzlU
	12Fx3yPZTiqLoomg83KMFDZb1UB2hahOz586zKRd4D8MnB5yVNAxztWz7G59Ndye
	Rk4J6AizJd+HzmlBDr3+PhYfABpFFEE56P9Fg3V3TuzSAfZh+V4DkM4/4JXLV4G0
	I216KaU64gPLMthCbs/LiKhUE61gJ3ib/d9n5u1xg==
From: virtiofs-bot@sinrega.org
Message-Id: <41213.122012807552800198@us-mta-394.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Adds 'posix_acl' option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Adds options to enable/disable FUSE_POSIX_ACL by specifying <br>
option --posxi_acl or -o posix_acl/no_posix_acl

The C version had this option too.
So this is a step to make the Rust version once again a bit closer to be a drop in replacement.

Signed-off-by: Jan Braun <jan-kai@braun-bs.de>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/81

