Date: Tue, 22 Feb 2022 11:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=QpsewtMuW+sdkalRU0bd+OkoG3x6Vkl1IW8hi/G61Q0=; b=3
	0m/N3T4zFlTtyotaHgh6iaBu9am/LMyXJYJtX4l58wjnP00dxmwHf9UhQblFXAtQ
	3O92o9719aJt0ci57XALoUja7kZqbiwoQ3owUWcVfVahHKDro7mX6tWJzruArwQI
	O64DEPQPXHfdIsEVuG/1nAud+8/frBP1yjbj4TisG5tZpwbDItKeKSKZU2XwVxZi
	DrE9o6g4qxiDPmITKucvvLPyQhEtnOfQksQGbd8Er7w89vOwYSJ9L9uHEo3dCqVm
	qBv0X2RD4IrwkpilW7DrjStA5ScO+ikxlTwjvx7Wx+eev0EPTCM8aCUP9OmLIlPo
	axQES/amfVvGytEOPyakw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=QpsewtMuW+sdkalRU0bd+OkoG3x6V
	kl1IW8hi/G61Q0=; b=Nqfnxnl+8J8J2EgC/ADrgLue554kdEO2DOLhJtMZ4yvYz
	zfx+Mz4cYgpLSUcC17NVV8Bv42NPvYXcOqPPjHGsJKslChmFW4kC+YsJzBD/QjPQ
	5w0aciBYsYNqy5i34h4LXtVU3Ny5PfmUS1h/KJ7pL2x+Y8LEM/VDfTvaxzcvkrjV
	qGd8pHd1i0lLwSqxFPY0xVWPWi+RJLUrwx4Qh5WvFjQd4tes3vsdbb4e4mF8QXGL
	pTPVxY2EEtoJPHXlFvMUhBJhwZWnwBXXbC0OeqskFnNrcYstTJsmvud39cXqGrxi
	C/2ElUkcgQyC1RgE9Yv4H6Bg+ecC0lbuIu73KdIZg==
From: virtiofs-bot@sinrega.org
Message-Id: <31337.122022211165800351@us-mta-20.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Add posix ACLs support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fuse has an option FUSE_POSIX_ACL which needs to be opted in by fuse server to enable posix ACLs. Add virtiofsd option '--posix-acls ' to let users enable posix ACLs support, and the compatibility options '-o posix_acl/no_posix_acl'.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/95

