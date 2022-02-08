Date: Tue, 8 Feb 2022 11:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=TB2L56E5cur1pT8pjL8JjPJDIndaWSMgTWL4uCF5sEc=; b=N
	d3GFh4vsfVs3USRNNe+3D4+jwFsi8wo7XOMmNvLIknsE9n7cWpkj3pM9/A220lqP
	x4tjrSKu87OzZzUMenmxQVeM4oflKgQcUoCmf3D5I3qHlpEx4cFVK5HrMGDYPv5D
	dYwwaFg5Ld8Ph4i8w11jNqDv6HApIIUgnj66HrxXXqSvXi4DSd7oUDvTPt5xyCG8
	ehzVAYe5ioLk8bv4OzPniwkIzUeRraVQ/Fmiae0rjqpom1OOCwdgaEUwjFBF0g06
	RSIoeX1TRIdBTpro46/ThZUmV15/VkiMGztlCDywUApJnSqQAK/GsV6r2NAiOqBm
	Q6gXolzcC8cs7dKn2Whfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=TB2L56E5cur1pT8pjL8JjPJDIndaW
	SMgTWL4uCF5sEc=; b=WdWATJ8ohwosmQInUha0VjBD6Qtu8q7CXyFiMtfrgG0n+
	s8DhiF1XXAunLpWcU3l4s1hW7VO6w5/ryjzV0FRnfjXjvAmpdZoFUP2T5Lmwzrr8
	k9WGB+j9bGyWR/T+IHutr6icbQGX9B8tp8AnuJzqvn5z9wv4Vq5wt0k0Q60fpvlg
	ziDtxhttRy4B/WztKBLbljZxHWhyjRI004HUTUQcT983ym2ARGdFz6COVj33Hszm
	OWOkc52ktOa5Hc+ZzLk3u1Hh7ix/L27f76G95V/mg/1xs4endj6cEpD1dILORwCp
	WDBuCSQFyr4FSUIhjoAZFl6S9OioYz2n7ufFN5cYA==
From: virtiofs-bot@sinrega.org
Message-Id: <82965.122020811152901986@us-mta-645.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: vhost_user_backend: Remove
	unnecessary Mutex
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The `VhostUserFsThread<F>` doesn't need to be wrapped in a `Mutex`,
because every write operation has an exclusive reference, anyway.

Supersedes: !83

Closes: !83
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/89

