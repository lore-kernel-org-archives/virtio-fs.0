Date: Tue, 8 Feb 2022 10:48:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=w1ZalB0n0a+iU821BqCfAe6NYbEPwZhpP3A0TD6dB7I=; b=A
	9IWjV5zb8pxuN2yrkn3qWBruvZNkneiBOUmNYSmQnZuYrFK+9ME+f6eIQ5oDpAWC
	zn7TX7g9ZQp5sCO3m4nV+zJ9+STm4jRsFGipN5uKTJPz+0hY3KIUy4IVFKSYg67L
	0EfkNOumbSJMusPYraOrdZL55hUz0DW0hY+87kwar9jK2fadmLbJknSW2gN0BDCq
	CJgKNcUop6JQPbivCdSanJyDk1s9trd4qPPvIQybyVDF4cbtQXIkw6qRVA09u1wf
	N6B2kHHwcQKOKJXkn/4HRPvse6CCswqehCyPGhLsr+V/qxyH1b5kxyOsRE56H8la
	QaZZoinjRwb/m8yl4E2Mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=w1ZalB0n0a+iU821BqCfAe6NYbEPw
	ZhpP3A0TD6dB7I=; b=g51PlU3XxfyQqiAL2krzZ4kr1XwGAFc1yrrJOf/EB8MJH
	e6Gmpo85AnZyZ0hVEv2fiPvm4HXT4hdZeoxZD+o7WW93h2/YODeLrQcoCmeYaOJc
	WkP85zE+aB+5f17/Gz/HgKmI7NOifOpoQzTO4i7jf93/7pbZ2ljN9CnK/CV0AIRU
	KR2MOVFSXPtkktdkh9fnKYdE5HmP8J64REImBMHy0JxBwWiyT73RazwpWx6jB376
	k5OAKGD9l2FSZK/XlHYORVir4EnkNbSaffgPgUQ8D5mUuvp5JEZl3098It0PHCLS
	WOM5OuzwSmB4sVDE9gW54w8h4//pbtB5kJbnutBHA==
From: virtiofs-bot@sinrega.org
Message-Id: <38208.122020810484100785@us-mta-190.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Add examples of how to run
	virtiofsd inside a user namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Expanding the current documentation with some examples of how to run virtiofsd inside a user namespace.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/74

