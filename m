Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=kTE/b0i7fvHgSL2qGMMa7PCXGDnnRTxSIYzVVk/q51U=; b=U
 UJQjUUYxu4T8+QflcCuZ6MAgj8V/TQbsZhBQX2XAflBoVfS4zDl1edWv6NVyAqze
 0yD6+QqTaAzq674awx8zrjBPY31Mrv6nox9SSRetLfCHlENw8UKE2vi1aJrC8maQ
 ResE8NbsbcsmgPf8d6uUqryo2p85EAePXmNhMbNM3XhUs/4HAX35qvyichZLY1t3
 jWpAQYzR6D7QQZEEgH3a/g+JUIyRt/4G3cZlhLYtM6gCuXt2faWHfv0pId1JlZ6h
 trNtvfLREbPKM+4fWOSaLJKRLV+ik2W7jEiPb4LYJNBr6neN1VfJ/GeESdieah5k
 vM3P+8bz8LD5XRfETjn9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=kTE/b0i7fvHgSL2qGMMa7PCXGDnnR
 TxSIYzVVk/q51U=; b=SrNhDQJMaqYLea6PrYMzC7Dm8ScQ3XSW+4hirVad0e5kY
 wddIeFa3HiucVRXqqjH2ai0A8rHok5dQavtdLerEtvE41L7XdP0+CJRgg/aiwxay
 wL15fI3kJMd9ZS4a94/kjq1FG7fHafI4w8sIfFRD8cy1K5eRlggI7VbMesKBW0vX
 f5K5QcbA//0YE//1KS9op1/EJNa12sUNbhN6RcKDdHK6hpPsggV/CQvBt9SONzBj
 7vf5+whoTeXBDC3vfuQca8Oy5sMUZtHcHK+4K5/Vx+R2dORc3WGOlHLhXTuvLMsr
 LGO9lGIMsPeL0wbf7fjx2XNjqnThBDumVzF6Z8UJA==
From: virtiofs-bot@sinrega.org
Message-Id: <49832.122040515022000886@us-mta-440.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue,  5 Apr 2022 19:02:23 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Log the FUSE opcode name and
 inode on debug
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, when the debug level is selected, we only log the FUSE
request opcode value. This commit also logs the opcode name, the inode,
the unique, and the pid of each request.

Closes !93
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/108

