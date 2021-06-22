Date: Tue, 22 Jun 2021 03:51:53 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <10633.121062203514800273@us-mta-346.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZZsTBsa8QX2wCNSCh
	2Wy/1b68Wxn/B2YSUqsS3F3O20=; b=F0uov1ObvPe+dmFeb1IwnO/1L7rnXRBt+
	xGlhC4txnPHCa0+6bOm54LS+/C6yH+2Au6aO1Dd08s2rmLLNmigWmwMJefWVrewG
	j7o5pvvt1bhphSqXD9uleYru1qvQlW0wZ8PEzZDGrv6kJvG6VhojECzuaXfUSp6R
	//hkLMyIXC7SpqJGVncwpVNXKYvh2Zkd5n6yTx6TIdvheYoA4EfT0QsKIbnKYHwt
	uRSn3g37s4Qs4R08glI+6rBynla+RioOQFMtbGg5RayG+duOn0IKCHpfV8SuZUQX
	CH0Jqj+Qqy8+eXjwKJ/fbLsQKVeLu5XCiKvJHTQJKpZ4aGOQAVOBQ==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Drop dependency on strum
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We're only using it to avoid manually implementing FromStr for
SandboxMode.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/33

