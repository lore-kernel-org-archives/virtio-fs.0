DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=Lm3ENkXazy8jzMXdepffx
	oAWFHIIjn7lK7TfBDb4A9A=; b=ZdYOfw9d6QGb1KZBJ0cS15G5LSGnoekvY7NHU
	EDQIUgainT+05k7f89AXs1Aep013kWU7BMsEJNv1IOmrfVKUMgW7gaV7tKlaK3Hl
	+5bassSkw+Qp0qUFLaNJgCkQcAwTRbZ2rG1fFkdciOUCOvZ7bm5fh2JRAEBldjGI
	YnMqy2JlS+Q792LErvPxHWhr3QPrunktYzzdT/+FbcT3Ll4JkZcoZUOncMV+Zh8P
	ChnyohT36uBfPJQVvfp5/maGro1tVXbvZD5z/NPkC29t/aFYvdmgtS6eC+TWwTgV
	k54LzJ2gUrK6vmq0mYBxfIGyETOHeE7/MVNLmqlyN+8KZLqHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=Lm3ENkXazy8jzMXdepffxoAWFHIIjn7lK7TfBDb4A9A=; b=cSOpNsF0
	SLcZlmPyCXcTu3MWk7dif7MB7Sub4ZhN/FQOw2u5IffjaPA1Jd8xB7sAX8AwPrvb
	fsEmWiSk/xRslMfBBgEWksarqP3r0lVA7PYf4dAgBpAikGroPDnHA+UTuqRcxk0e
	Pdw/oBwal8TEVn1MNCrG2PF5Esy9wSzBd8b698o1V9Kvsz84om7Y4HFfTuu7I99u
	cYMlcQll6wFlned+grkVdC63tn4N5EnkYqbRWSYYU0Jk3vx0tg5aHRFQBczFPaJN
	o0WVL5nVhTM2oFT2NOqA7kPyeKM03728DAqKjZOiwr5DU/tPEkDI5PR40KlFJbKu
	zjEsXL17jRgivw==
Message-Id: <20210421150132.8211824005E@mailuser.nyi.internal>
Date: Wed, 21 Apr 2021 11:01:32 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Drop security.capability in
	setattr() branches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If the security.capability xattr is mapped to something else for the
guest, drop it when executing the uid/gid/trunc branches for setattr.

It must be dropped on all writes and the host kernel won't know to look
for the mapped attribute; only the server knows what the mapped attribute
name is.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/21

