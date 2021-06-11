Date: Fri, 11 Jun 2021 11:00:47 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <37409.121061111004101131@us-mta-55.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=89Brdk9eSoX8u35s1
	X033fekUbVaJzkL+C4r4ubrAR0=; b=l2NOtTstHuO0hE5AfWSpb53HbC2GHUVLJ
	scAHoJpGlWE1axJ/1gwJ3yvWV9Dw9HYwNoLZxJpAiAeyhfA9PiEfyl8ewW//aUaw
	IfmKCuDCHwOpD5Db64RerK/IvyEJM+F5ZaJdYioTDRc3oTi9i0K5jX9JdTbqzZeC
	wZnmVTJZpsLrCLsKhz6jllPCsH/gJUsRx33xGzXoT1XtcaYuw4p6W3WckP0F0Xby
	Ji0ZlXfDQhpbGRXh6pj4STVpmLcHTEB+rFmnVUJv2MlVROck0Chthu9zQ9+7umXe
	qGyNAGv5GYyQGN4aSNxs2jA0ZvXKEp47r2CA8Og3jebX6MG7aDvCA==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Fix xattr for non-regular,
	non-directory files
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We can only use f{set,get,remove,list}xattr functions on regular and
directory files. For other types of files, use fchdir and the ...xattr
version of the syscall, instead of the f...xattr alternative.

This is a port of virtiofsd commit bdfd6678834 (virtiofsd: Fix xattr
operations) by Misono Tomohiro.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/32

