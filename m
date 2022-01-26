Date: Wed, 26 Jan 2022 11:27:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=0Htea9nMf1rInco7VrRvkMyIZxzBGZ6bFsy1aBFHCTo=; b=R
	jDdI2x3X/y/WzKG8tGdFcoKRmcRrXFaOJHdsr7VXp2zMWwV1S9MYKEuE9FZdQISR
	PEzXJTQOmy1Ct1GqePGuY1YAmUemM8rVAeZTK46yB6NeU0bUcCNMTvtWHoHGcRU6
	BG7gtm7cj7L5YcV9jSSORbyDtdtf+x6/s/XO3ThXktfbTjYGLFWp27So+/Las5Mr
	XgyU5X5ny6ve8NYWNKOv9mTGMoHRMTqh+/PIMhJIkVkzlDZY7jF5GYhv8AkfhMNm
	d3KLbqTpClY8x3GwJ1+ZYB8/04S9CQByLWIN3rvioIyKpzBRW54E8+yS6vcjKgxU
	vA6Z4mZ7LpWqTRP4SPQ5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=0Htea9nMf1rInco7VrRvkMyIZxzBG
	Z6bFsy1aBFHCTo=; b=jcqkgVZ17qbZ8X3HpeQjU9fqpLRBoyAmVT3MOmQv+UrKF
	059URM8GhsahfIOi+HIfPPydrIY1B1tuyZ38u1CcvN6vVV4j7pWZBGbJmM3qrLzV
	ElQq1WCy++ISu2h9CfujZczWk4i/oIR8/WQDX0GWAtelK2l6ki0V443NK9jsClZe
	jqiXTIQ2EEpA1sd9YFZpQm5ngZbSKd/5Z2s5dwCHFNsgrCJfXrHVCC3o8gM2bHJd
	DUWjmGkxDK9dRQESr67kz//JGy9JFWqg7uRgDa+vmUU+SKukrB2vRDVmLA/PH8B0
	sqXE7c17Kkn/vbkD0u6sApQ0/wfwhMxBvXtqOEb+w==
From: virtiofs-bot@sinrega.org
Message-Id: <18694.122012611272500373@us-mta-427.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Drop membership of all
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

