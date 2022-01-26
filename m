Date: Wed, 26 Jan 2022 04:50:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=0Htea9nMf1rInco7VrRvkMyIZxzBGZ6bFsy1aBFHCTo=; b=v
	xK/vhRu6dmCoOkgOdWo9qXwED5Xr8TeKNd/yL/TUI7FCKR3uIgqdmGwXA0dD87el
	bqFnyjdk3BhmfF0M8pACN1QmOVuWQ58LBSQ9FwjZ/ypGXLhVeuIZpBL+hsNjb7LN
	mTAXB32P1M0AEtqSdxlZMGtei3cCCPiWjWvyHgk2xrqDd+YyFAWQHjyZBWUmBFLj
	72fBbJKo6s5Muqxfp6oqLrqzIxcqaK2F5pNup8aKGPztFxdXIBYa5JYHbwCe3kFf
	m7wRz+MqS+/k00hrDBsfzBdEIyIf13zHytwdKHDtie4dRwcHxHsSzWkVveIoSOEm
	mtRn6bib8N8okfsUfL32w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=0Htea9nMf1rInco7VrRvkMyIZxzBG
	Z6bFsy1aBFHCTo=; b=A0BQ2I+TvlyAzadIgXhiKeLLPWl5LqVP1qx8gdL/itSTC
	8Hyy1Ykk4C9gK+HgWTE6EIjMlEFH/TbGIJ9TCzMGzZpYJf1YQPXTWCXyX5M0wKCz
	fqBAiqgyo9KKUxzQWCbeaQgH4NYH/OZth32rLLLcV2mStE9oQqzf21SlLALuP/pC
	UbC2o4Z5BtkABInc1tcU23mMVnM6Iwg1ehwwd/R1VzdsyYv/uj1MohesCnG0fcCP
	S8/N+aZLotzRmZn3ncDIzeLzAxKR2SIAfkB3mZ08PoSMz1GJWSzgJ0VCQKhnxtxH
	O5tTK7Xu48SVFw9awQjRbDeqGgfO6TwWIAM7rEAWw==
From: virtiofs-bot@sinrega.org
Message-Id: <52672.122012604504800362@us-mta-517.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Drop membership of all
	supplementary groups (CVE-2022-0358)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

At the start, drop membership of all supplementary groups. This is
not required.

If we have membership of "root" supplementary group and when we switch
uid/gid using setresuid/setsgid, we still retain membership of existing
supplemntary groups. And that can allow some operations which are not
normally allowed.

For example, if root in guest creates a dir as follows.

$ mkdir -m 03777 test_dir

This sets SGID on dir as well as allows unprivileged users to write into
this dir.

And now as unprivileged user open file as follows.

$ su test
$ fd = open("test_dir/priviledge_id", O_RDWR|O_CREAT|O_EXCL, 02755);

This will create SGID set executable in test_dir/.

And that's a problem because now an unpriviliged user can execute it,
get egid=0 and get access to resources owned by "root" group. This is
privilege escalation.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=2044863
Fixes: CVE-2022-0358
Reported-by: JIETAO XIAO <shawtao1125@gmail.com>
Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Suggested-by: Vivek Goyal <vgoyal@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/77

