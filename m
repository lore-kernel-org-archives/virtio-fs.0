Date: Tue, 7 Dec 2021 08:48:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=7U9zImRQzHD2ncl6VvAh3nASHmQxnxFFBiVuE
	6M7bRo=; b=NXW/fjMpBvUvMpFxK1FqhDwsL9vaXReP65HDuPCJuQJjvz3Ngyr+7
	Gh2Bdc/COOtOSBA8Szu5X4t8IOBW6xFFOPoh6m63QZWyLGcE7dYOVu/ijVonhDi1
	f/OTH7AlnA3ZvC8TJ+YznobdThGyACnVSOeI1PrbBgRg7zI4Qajigy9wbAdj12m0
	1MbfTCpOULjm584Tt2EGNsIKn1knYUwXIwNKljT+AFKUzD/xg4Ou4sL37QghFzgd
	XQ7IFCfZgENKUBlh/UassMh2BIdAX2q84WaTI+vJqwu7YVQH5PfFLypk04U1RtAa
	lhG1ZGd8ZKVZC1wZwrU33+qTpiOcIeGIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7U9zImRQzHD2ncl6V
	vAh3nASHmQxnxFFBiVuE6M7bRo=; b=WrNdQQaiGPKQUZH//Z+0Rvefc85jZ0gCg
	S7C0g+G7Crwr/cWWLlUeM8QUKKP6pcxi8TSR1NQnQ2bTG9CfY/P7LCLabw1S3KAu
	Ygp0H7CQzULcexYC01V8WNpi7cb6qxqpJPr8qmMKp3a/LmzZA2Y3MnI6Q7SH8Juv
	s57gCREnJF09rpDYML/AVchTYKeTQj1hwI8VSmxGrV8xy9UQ8dMwg48dHk64EDe/
	EnzpFJ5MIHuhWGmo4OO07Ypju/F7Aj3LlLrSIxKYBdTOTv08aT4jRqxFM0cZP3Qw
	rdxkWz+RjzAV8qoZs4w/WKa25i7uwCbPfbdCdCCGhPB8NK0VUcA1g==
From: virtiofs-bot@sinrega.org
Message-Id: <98583.121120708481300817@us-mta-30.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Set up the stage for v1.0.0
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
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/53

