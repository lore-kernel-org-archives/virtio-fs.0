Date: Thu, 10 Jun 2021 08:59:13 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <90269.121061008590800141@us-mta-250.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Pulw44miDH2wbc4hA
	tFNDlSSnXbRl3VdtKeQdBfkMdk=; b=OFSCRhiXwUk/8RG1uM9Nwon26FNkhGGrJ
	DPuzRL7tzXR2Ub5q3KoExC+cCdgwbTwlwTD3qPRTpdsWrTIDjXkkehOcRJAf1luM
	LDe0eqof9eJtQ+hKdEqva0Sdzo1y8vvYq9Wbz2VWsy4g45b6tSyXwDIAGgreqF4S
	q9Z2EheqRpwhf4OBdJcmEcK4iZuJudCm0rZWIrYzGO2W+KP48AY46HOpcJLRlv1H
	9f4Xu3dKGYwoMrmTe2srsnn/1123dP18ivvZSoUotomkH58XqlSyVvOXpN0IDZhf
	7Gcaj9+f/mO058UJPkatDWXLcnRMRbz17D2S8SWk75y51xFUyG8Qg==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Fix file type check for
	submount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The current check (`mode & IFDIR != 0`) only kind of works accidentally.
It should be `mode & IFMT == IFDIR`.

Judging from my bits/stat.h, block devices and sockets would also pass
the `mode & IFDIR != 0` condition.  That is not exactly catastrophic, we
just never tested what happens what happens if we were to mark something
that is not a directory a submount, and so we only allow directories to
be submount points until someone needs guest submounts for mount points
that are not directories.

Note that the kernel also has a guard to only allow submounts on
directory nodes, so in practice this patch should not change any
user-visible behavior.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/30

