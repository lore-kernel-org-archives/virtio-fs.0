Date: Sat, 29 Jan 2022 06:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=JlC292hx0IjOuYujVBeIlXsid/GxXzFDaZwZOX3b5c4=; b=S
	xwrLdlqhHEMWYMhnfn+vi2Wlfs83T8SSliducZxKy54rRcpWVjr4GMK0ExjjOEsb
	xWtvVsP2tfZa7H3xRga6rbgnbnd4V7TAGH1tAtYrO627qYXngQnEx1LEBOfi1Udc
	stBoLj4WcY/BUY+U8R0vCHXXlzVtC4ZrwqDet6XGATEQIIMLV5AeaPcZzunK+xXh
	wy0GoXUTRx7wQWw3d0imz5xuKleg94xWx0i5mGblT16Lf9LkkXz8fwIGwN3emiTN
	MHeEk7YosykmBvPO2UqvJ+EVgWiufbDFo+0pFwlJpMjTl32jrWvP9RM0JA0hxZ76
	0KENYsco79jiuBFxHUo3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=JlC292hx0IjOuYujVBeIlXsid/GxX
	zFDaZwZOX3b5c4=; b=c0W7etJrghyl6846HxDi35MGnbhrq9oawwqiHkhrF1ezh
	Ztw8BWWuqkE7ug0fETGrW2qfDUCM+5Z4wIfT9EjkCxs/JxWYIv4llaGXS+3+uLEF
	yKm0Tz77I+zvEYr7j68aOKCrhGODBVdVoBb6eP9GDjrMXiEmIj2v97rvbc94qfMI
	ywVugnz+3pA38xOad9dLJgrItm+NCcFmNDSutofo7gLRCBbB4Nb5R1XBeEb/hyIq
	GQcigfJ789vMTgjTY7GbA25sUQaJJuifDu14H3/EcPMtR1tIW1QBVSj7tGYxL9re
	xdTTArISsWL6IA1Cj1/OZioDWWeAWJTvVNwIAOEhA==
From: virtiofs-bot@sinrega.org
Message-Id: <09872.122012906415100111@us-mta-614.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Wrongly implemented InodeData
	refcounting can increase refcount from 0 to 1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The code at https://gitlab.com/virtio-fs/virtiofsd/-/blob/50ffd53962ffe10bc18760d91f21eae79bb7f42c/src/passthrough/mod.rs#L775 can increase the refcount from 0 to 1.
In this case, the consequence is that in `self.do_lookup()` we return an InodeData that is no longer in the `self.inodes` map. It probably doesn't violate any invariant we have, and hence it probably doesn't lead to a panic or the like. But it's nevertheless a behavior that's unexpected (and probably unintended by the programmer of that line).
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/25

