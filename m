Date: Mon, 7 Feb 2022 08:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=85dKdpMUxPf/QX1W/GWmWeIy/Z9TqddNEjmQ0mcIWaE=; b=u
	QD/C78oFlPo/IgDl/j+ZDOYWdXIBlH15YYRxtcQjYC2Bn2R+RU6GcIV4tr/IS9x6
	lq31TmXgCil2aogC99qaeQH+dsdHO5gPbUya24pgV61w32j8ZvtxGpXK9euj1pkk
	vni8RIFSG4Rx3dEeSGYFFhf7ivfWr0K3wGSdXdDlkzLN/RktmzH2bCrr4fKVFocT
	382L4Cf2JnOO1d9PtcDlxl3xgLgydRPi19EmXYAoOX+vAzwodzyx9fOYfB+A0v0Y
	Jiex/Ghpfh2EqBV2cjq2C7/KguiALe02xtTPjx9tdtm/qmU97tLTGxyzPOm6pUEt
	xJvgrBltBp41X0KDqszvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=85dKdpMUxPf/QX1W/GWmWeIy/Z9Tq
	ddNEjmQ0mcIWaE=; b=m7NLhcuiHGXskdn+bjEWZ+pItPzwET2C0+OZYBhT32OBp
	2ZXddulrxtu1XPxMlIzL6PUXUZ3SHPy+vwNzf+1+9r23AI13be0iHSkpqdlYZJC6
	+3vQfYrizH5DB/+rGq/XjKl0fWGK8S4/m4ETwsiyBS56dU6ei+6wyKZOYrJ7M1TN
	BEOj+gZGdeOsf61vwTsGTy+Xz4ashxHZYEQaTGp5VrFFD/QmSSe2JYOapyW7CVZb
	xTSq871U64jv/HATxdELaezAllWzLo+bbHCLUt24FpMYUdL/MMxaF/rxWrjjucqH
	oLkHINh6qtQ+e+5hvHlE6ZIYkKg88Vfp33+2jRZBg==
From: virtiofs-bot@sinrega.org
Message-Id: <46213.122020708555200359@us-mta-591.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Set signal handlers,
	required to be an "init" process in a PID namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The first process created in a new PID namespace (pid_namespaces(7))
is the "init" process, for that namespace. Only signals for which the
"init" process has established a  signal handler can be sent to it.
To run  virtiofsd with '--sandbox namespace', we need to set handlers
to end the child process if the parent dies. Also, in case the
PID namespace is set by an external tool. Fixes #23
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/75

