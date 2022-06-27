Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1656314765; x=1656401165; bh=uq2MBwhxNTvM44uB0e2sH
 8srrUwd7CAyI9VpWDuTqSw=; b=igu/qHMJbgmvl6GH4V522gU8Q+uQyRt2qPBys
 8D2n/tVjwMgi+8r7AXW8o5vTcf+Br637i2rz0FhxPkmhAdDNtELz2624p2++akbZ
 lW8LZBIfMgL6a4CuTaVsMNLO0QgUqHUIv8ksPKDeBR5nqp05sX5yfY2lwN+moFHe
 k18gUwjZ3yZhGpr47hbgMaZJOAAaWX/Hdzcnetp0e6yEzObOBxY7kRiQiadcH/6f
 0LlQ4Ihms3WYu0N0z3Gfm/EsiWy7zmtFhcb3MwetXKEU/zzIVTLTFHJM6N/zN7G+
 SJ/el1cBT6WukS3FBwgtOVLxggSVyEDAroQANaxAdxFuDa2CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1656314765; x=1656401165; bh=uq2MBwhxNTvM44uB0e2sH8srrUwd7CAyI9V
 pWDuTqSw=; b=xsyvMS1nSa9DV72yr3pIt7xc/lwZ6jW8sPMoP/RDrFoMgrM8lhK
 Omd9yinFVz60sde2LgmBBXShTLbdPUopxXqgZZUO9rvXqE6/96BiyVHdDy2BACPi
 TwpN7yJWzZOx/9FQ6fVWzIjlFe1caN37oEdjx2UmfULvVz0NkcEaJPEWLZYLZFLC
 g7MdZMZYm3prsHCnpZyMINdNPiz31RVB19CKXqhzCat8LIdD8zTCeR/RXWu8E/Fk
 YXeEZaHaGQg9mTqXB3OPC+YhI1gN9ZZkNvbqTwCcsh+3a5oPMEb+LqRFa3wKBfJQ
 dYFWtiWO/S7v9JYsi5ze/GsWkVIKgT2XPlw==
From: virtiofs-bot@sinrega.org
Message-Id: <63772.122062703260700135@us-mta-501.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 27 Jun 2022 07:26:10 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add capability to create
 security context (SELinux) during file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fuse has capability to send security context of file (SELinux), during file creation if server opted for it (FUSE_SECURITY_CTX). Enable this feature and opt for SECURITY_CTX if user passed option "-o security_label". This should help with support SELinux on top of virtiofs.

As of now file creation and security context setting operation are non-atomic. In some cases these can be made atomic. These additional changes I will follow in separate MR once these changes are merged. Otherwise it becomes too much of code.

Please review.

Vivek
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/102

