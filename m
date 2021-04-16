DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=66IEjZQpaQRtziAI2rhrv
	STpd6AwIoR3UAnnV8nv2KI=; b=lz+G0wPdCN5Y/Q12rPqoQ8q4TYB/o0Rg+4vAV
	760j4DIYS/qge1zjCTRIP4EkwKkK7Qqa9lzrz5hDo205kCTDpzbDJ+qw2tdq8ic+
	3DL/BbZ3y2mgzeMuzGSkm5GgyiJNjmUdRxnvkTqXlVTyr3AeTFO9Mx7gCEGGQ6Qp
	DkaX9qvTUDaVivxFSg8NlYi4RuFdowb/lO0bXdBnQ97xAa6OeVq8V+gUCFVskjwB
	XmSOEQZegntaQJMQppxOO3fCg6Vjqa2uiBN61+Vq2XLMU1ijdaNhBl8UW6UbN1oT
	0Z9y/OJ0zCwYirbgt2WWXYIVkFxr66Uhgzry9Hz1/9q5KsCPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=66IEjZQpaQRtziAI2rhrvSTpd6AwIoR3UAnnV8nv2KI=; b=afBgtnwo
	N8wP66DZMyPeYAH+OgvwiUQjD/1/tkyE2+geFnucdGDLPW+neQnbnrlmBA5rt+lN
	3nrz9sunMzWLZlWWJavquRohB/E2TSl3oH/dolCy8A9GgQhE/eYtHRTxrAqNEdUc
	SmhkYD6lRy/wM8pskvDb20Au5HMn+x3xdnsujnH3qZo7+TKpnm2Px5cWniqsSeqC
	YUs3v/l/3WXc8w44j5MdMUcjjVX7ROJZewihA90uoG0KOcOo76O4MMMz56d5FqGN
	ONMZsqgej6r8zvLhIu/nR88yqkRMGXg77bzJsH9ewcUeMrf4kLdaigty4WOn6Oqe
	Q+k+YNtE2XA6cQ==
Message-Id: <20210416164622.7786F24005B@mailuser.nyi.internal>
Date: Fri, 16 Apr 2021 12:46:22 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Document the xattrmap module
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

For a more pleasant reading experience, I recommend

	$ cargo doc --no-deps --open

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/19

