Date: Thu, 17 Feb 2022 09:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=8HlVnWd+DjWZ7m61Duy6tCit9RwYviggufZWSAQO198=; b=x
	yiy4bm9Rz2tbNxKLDMIVOIOwU6kyasZhJAumlqTePpbCHrPHypaNI61UDuHV6ET2
	40FVRj2JFxsKRx1BQ+eOPVttUz+3O2X23ImlDzlyyjitW8uvScY5wct2RRTNAGAe
	vwGIm22sAetkm/yJFY6B9EJsaqukwLrhgb6GzIqkxiuAPaRNX/BACutSn8aRjRoA
	tUlMaz2NGrOjDXLWgTjHZwaNYOcddNNCLMNOp34R9L5NobRjIkDcoNoUyCqpDpJ5
	ZP0s/YaCwL9pUnoj3vYJf5qoXtAzz1Iz4ySI0yQO4NJhJ79Wkk6gmOAGhRjzP7Wf
	rOsM6EB9lPSTCL5rEsbrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=8HlVnWd+DjWZ7m61Duy6tCit9RwYv
	iggufZWSAQO198=; b=KkZjlqAY5QXLmM8jNqgYwzi9HZFANcNqO7zkY03Nkgygu
	heZ8MPQfIbkjY5xo6m7dMhgYoLXYHL8+7uFO7kc6iQghSu/F9w9y9Nzzi0IaBJwe
	Wp4X69uSK86eZon1Z2BWUAuenPwNJFHnzQ7g04o3pTIEteIrR5UBAjx9LCzx/4Kb
	OWySJwJnXHy/2ZGoXt7yKeWzpDV1gOQj9Ijl+OsZrr+k1N+OY9K52wjsUKyLG/pf
	5LnaT5cRJLK6vIpBk+yO1ZWEZ1Lk0jrJhpJjWavp80WDOr6OB+EfCG9HFQMFuRRv
	a54XWHcM9olyLdv0GRobzHzUdCwQ68G9H5HoZf5qQ==
From: virtiofs-bot@sinrega.org
Message-Id: <95853.122021709094001652@us-mta-384.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: vhost_user_backend: Remove
	nested RwLock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Implement `VhostUserBackend` instead of `VhostUserBackendMut`, in
order to avoid having a nested `RwLock`.  When using
`VhostUserBackendMut`, it needs to be wrapped in an `RwLock` (or
`Mutex`) which doesn't make sense, because our implementation uses
its own `Mutex` for synchronization.

This MR contains a 2nd commit that replaces the internal `Mutex` by an `RwLock`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/91

