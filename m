Date: Thu, 3 Feb 2022 04:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=4J/JOhu8zdIGXd/0DzVMihmTh9qoc2drU2HmgfNbLk4=; b=0
	pAFae0Y/n8eErh8qkg3xWYjq0MF4lfvfvpuqStN7pBAZA7wWLr7mqIcCaj3DA1PO
	oHfdjiQnDyInN4DtKSwwGXiy+1TtU2Te9j1XsAI+SaUb7Dfd5bnHK8uBhHdxYVDJ
	nRd+zEyTa1y036EXwvmKSzS8/wMCnwxzKpYVKSH9fObb0cCXzLdSlFJYpb+tOiz4
	p7drIR2B7sdmitFVSY0LRI838adzpGhnMFi6DZnVd+w3O9qOzi83iPsid44as3Ev
	uzJPzJrnnHawnu+b2xtfqaPadHJ1G7vXi+rOXp0WcwvinXt7VP5jMNl0QZNpe0hd
	ShnWcfyaXc/vK1XJ+CN+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=4J/JOhu8zdIGXd/0DzVMihmTh9qoc
	2drU2HmgfNbLk4=; b=fZdrLWMgJF3M8U1O6gqstTFSRz5kb9OzkBegyqXDg2D5z
	Du4O6mHZjIV5qXkqKpw/v/EpF/whoDVbvPbr2fQLmqu1c/wc6xs2RhZQjolSgIIu
	32CROEVFkPAB1k+WNkVdeudmNdKQMxvA/Mh+Nv8mPu/m8YfLoSYbgaVM90dv7jTA
	bjsPUM86ybTSNar+poXrzeli/oPW5Z9l/TFqXqlgiI8l0hIfAUZbqX/uG3fQnulC
	m8/wfsmQBhsIlDpUjANgJfByNAKllaSlm5Bk4H5TOtUHpHZ3JLO/UEbSb6LDhD5E
	5w+DKpji/oTgfOTtj2L3vFkAIou57tWFcsnOaOskg==
From: virtiofs-bot@sinrega.org
Message-Id: <84664.122020304572300129@us-mta-372.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: mount_fd: Use Arc for MountFd
	reference counting
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This commit moves `MountFd` and `MountFds` into a separate module
and uses `Arc<MountFd>` for refcounting instead of rolling
our own refcounting.

Supersedes !70
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/73

