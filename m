Date: Fri, 17 Dec 2021 05:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=+EvlwYzVSdbDz/qmzcu1hyG+aH/XPTFEiwQt6
	K/UC84=; b=jsOHVykfyW0GtB+AlyI6FshA/lheqDYftTCLrw2QTbywcG8UgZFn5
	Lp+l+Gmv3fNtrl4gNv9qNmRwx4B24BGoaLyCHeeRL47coXQzKJH+0yR8/TzySctm
	C9zNJSQsDxkYrorQudKiqwyo5LxOdEv9vWATEcL1NhHz80eNuhSRKIhKpSlgxmA0
	w0l0tTgzOC/rgM74v+Fdy65f/OeaxHKd7efCwWB9DRy9ipVzFyazCGJ+6Bbxxkgi
	UMUJgPpTybE2vn0GchDhtku7DP0sgioPQ3LpCohJ8JDztexQf1Gh8q+ejm8z6kVm
	h7xValpS+OxbLzCSMzTreZXlkpzLsibvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+EvlwYzVSdbDz/qmz
	cu1hyG+aH/XPTFEiwQt6K/UC84=; b=D2KF502wXKBYLj2JPY5udbBDYX+ZniGDH
	nhku5BfB0Cx3+sxP8BxJke6XuS0XC3Hn5vqkEOy7qVfHQlmi8EMlPpcWFdQPgZfU
	+g+4soGGo8qL6/bNrjrlN9MEqqZTZX9Ywj+9ZTPCKwLsPm7E4agwUEqLXphZUYSo
	R8/91tQdKpKpUJ7NQ1TC0CWCDwFRwJh7FqFZYkEG6C1Kl3y4g5Sf9dw0kAggNzvi
	6L/O0v9vQYKGiZB1vcj+6Xh3Xb1JMsF8NtOU+7lCg5/O9mTEiNx9tTVCpTgdiV4D
	VcX2v+K3ctHgPHiHWWSjOTV/GQ+OEhOG7H3iQETOVjJEAzReHfBxw==
From: virtiofs-bot@sinrega.org
Message-Id: <71237.121121705132700314@us-mta-520.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR closed: Implement support for remote
	locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Locks can either be managed locally by the guest kernel, or remotely
by the virtio-fs daemon. The latter option is more expensive, but
allows those locks to be visible outside the guest, a critical feature
if multiple actors (guests or other applications running on the host)
intend to access the same files using locking semantics.

This commit implements support for remote locks, both POSIX locks and
flock, adding the command line flag "remote-locks" to allow users to
configure the desired behavior from either "disabled" (the default
option), "enabled-safe" and "enabled-unsafe".

The reason for having two different "enabled" options, one "safe" and
another "unsafe", is because some locking operations are blocking,
meaning the thread servicing the request will be kept busy until the
lock is released. Thus, a malicious application running in the guest
may starve the virtio-fs daemon by issuing a number of blocking lock
operations.

The "safe" variant allows all locking operations, except the ones that
may be blocking, returning ENOTSUP for them, while the "unsafe" one
allows all operations with no exceptions.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/4

