Date: Fri, 17 Dec 2021 05:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=6h7ijwDmqb/hP10GvCn6stzttCUWhoPi5g8FI
	BoW2hM=; b=XweyfWZ4Co7wf8s7tvCC7t9TocdLZYVm3rntJFoRQMBrVB7nkZdCH
	7FJVFBAlGXYL4StEdxBzhiAQrvxTYb8/N7hxRXn2V5qL9PAflJxDyQOA+HZqlDL0
	BfXf/DjWZhnEwc6DJTHxYQuwwdAIPeJt+9nJrxesvxXPXMLprhhyDpjTJwTUalXs
	j3OLKUmZF8Fg14uS4lkocct2Ym4L8wal4eIDiJQEzcEbVupB9NZDEG0WPrJYIeb9
	Y7LHep7tSfR7QvKoR2Czn5xFX8gJt90gMj50LyAGBOB0U+s18XjMztuuE1oZrT+L
	jm7Xya6rr0bMDq10to272JeTo9CEa5r+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6h7ijwDmqb/hP10Gv
	Cn6stzttCUWhoPi5g8FIBoW2hM=; b=RJO005Z/cJNk9dmQRxF5SP0pv6IETwNyk
	6YwgA94WCa6mYaSNJmcM1OS0YkuHHXSQiOtcm+7L503mhbGf+q62Mn4e/CBzHbHP
	ub5UZovxJlzeFs5ppd+4VpHSbXDwRZGmNzUV+pEvolajeGt15g6ZnxgAdlQtagFs
	4Rmlp2vrXNaWYTzfbtFan+rdOm03hNjM3oOLYPC0XAkqm9+0m9MZPLdtBl3zLDw5
	rF58yGzWBOxV38OppXZ07I5ItMNEqEXvYrMVzVvORL7QP+lhgQN02z6foulV8Nn1
	PwfOWQ7PyTd/2XT+KTYfX8VGFfMXCGmjl5nU88g54OfSVF2gvqGwg==
From: virtiofs-bot@sinrega.org
Message-Id: <91127.121121705115700485@us-mta-664.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR closed: Set up the stage for v1.0.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This patch series gives the final touches to get the project ready for the v1.0.0 release.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/53

