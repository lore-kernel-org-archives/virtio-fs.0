Date: Wed, 16 Feb 2022 12:21:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=sLwWaKjDpVCsk1q2+ePpfneswoPb1qvQEmCAaSARG6c=; b=1
	t48bYDckESkXgmJlBhQ+keady7R4DF0dkzZqGiC3yo5Ux4eTIKd3Ar6f2JyN6Foh
	spOy49ckYYFDE0Mf7DM+DUMsK0IDg0G9eUfMY9yVw3qYxGLqrvVRo/CHHyPVkc/I
	uhMSW39KmOOAjHDEJwjkEwUIoJH5pV/qBNYavRLTCN3AigNacWh1mCn6d4y6QZr0
	+MaKwvNJu6gLMZv1hQFel713frxW/q38LxOtHUREtUdJKBrmQH9DYb8Iv8dfVdsV
	01JAjzMHbL5NLZwNNKysTPyn64Jm8T8V5pOzCJcBOqfBZjAqRO8SEBponAkfFhpB
	s/OUOy83s7GZ5pwteCITA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=sLwWaKjDpVCsk1q2+ePpfneswoPb1
	qvQEmCAaSARG6c=; b=YGqXA/80QnOoUmzGj522+xT/fnPGBK4NQ5RNGcC0NpBXo
	qjTZ5H5r+7l4TfGfKJe5ZVp6qZqNG61tZORuqHBOP1RS12N6OTlJscoT//HzVH3G
	8ny0JJIf5NueQSpWrAj3q4Mv4X85/uQAtIqXQEzZNL+vCnYnnt8JMtRzn2at7R3b
	rO0yvYIVCG/n3kHHv5rbUFJxEHQ/QTAktI3oaKyeoOqH6Pr+RzKccb4R9Xxbn4aY
	+WmpuwvLMqbIyWhB12mI0Lg7HK5pbnAt0hcQAFIfldgE7adgx3P+dhBJC5rV3URV
	8zXPNYnZZxUJt2KCfVT7uDRmW2eUwBAADwoWojhrg==
From: virtiofs-bot@sinrega.org
Message-Id: <59496.122021612210301715@us-mta-42.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Setxattr: get the correct
	structure based on whether SETXATTR_EXT is set in the
	negotiated FSOptions flags
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Store enabled FSOptions as Server field and get the correct structure based on whether SETXATTR_EXT is set in the negotiated FSOptions flags.

Also, pass the 'SetxattrIn::setxattr_flags' as extra flags to 'FileSystem::setxattr', currently this argument is ignored, but will be required to implement posix_acls and selinux support.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/92

