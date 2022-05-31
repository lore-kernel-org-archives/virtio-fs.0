Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653995578; x=1654081978; bh=+0siEHBwfdCRukIqXk7vZ
 aPQsMocwlvxGd8/fonvq10=; b=mToQDB8mAaBdu8sxiVBEEKF0uIBoQKNLKg9ek
 LBMjh6fUKRGK0HnI5ImSbJL0RA/A1zEHOS3yjhxKRr+HVN3rBXzHw6pnpfuB8/Ii
 I2dgLCshmrUUI9yxImPhLRbNdWqfGSERyqkixUwlB8eJlQH1LoLHpOiFavPYvM4H
 gQxChkIn+/i3xN+00Pc7YYCHYVpQdzZZGCjDlU6qq5F+2STTbjVrvWPDY+dq2Gwp
 fQrIhR4qOgEQ1pG/sBspAlT+X6Ug37OoZXbIgWsZ0iebaOLan9Q/053p4/4HvzHQ
 DU2Q/4adloRSr5pfcDk/Th7u05TqQb9FiIfVLiQyQh77sYX3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653995578; x=1654081978; bh=+0siEHBwfdCRukIqXk7vZaPQsMocwlvxGd8
 /fonvq10=; b=OdqBEH1U/QqFnkOSDaD3+5aQuYDBvRVOcgHvVhQC4KeoGdUHNMq
 dXavc8WLBL1+pxTCgOfZ6qcFHlbIOVzEuBMwKGnIw3j9VmD7yTV7NNA/oqU7dDxl
 okVZs0Jbm217G9VJuVuDhghlCAv7MD8Z01cXevh6t5MHhCVQzXJkiHBkHH0esRS2
 e+Fo1B9qPo4RSqcUYdO8W/IAF4FnXtljgFiQNEfmZfDjC8qnH6Ph8w1AUorE4O0e
 hmQWzm8yNW9VKHqPwBWVCEpuibsQNpwyfU/jkSIRECLYMBtnosRXEUlj/SyywlXT
 H+H7kbWdHjD20fEIIhRYMijMgnQpwYsBeog==
From: virtiofs-bot@sinrega.org
Message-Id: <96392.122053107130100237@us-mta-530.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 31 May 2022 11:13:03 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Do not create tmpdir and bind
 mount /proc/self/fd on /proc instead
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

virtiofsd needs access to /proc/self/fd but we also want to make
sure that if virtiofsd is hacked, it is not able to traverse up the
directory tree and be able to access /proc/ etc.

Currently virtiofsd creates a tmpdir and bind mounts /proc/self/fd/
there and then opens an O_PATH fd for tmpdir. And then it deletes
the tmpdir.

C version of virtiofsd bind mounts /proc/self/fd on /proc/ and then
opens an O_PATH fd on /proc.

Creating a separate dir needs to find a temporary space and SELinux
policy might not allow for writing to some tmp space directly. Instead
runtime needs to setup some space and label it properly so that virtiofsd
can write to it.

So going away from the need of creating tmpdir will be good as long
as one can not traverse into /proc/self or /proc. I think it is
not possible with bind mounting /proc/self/fd on /proc. So proposing
this patch. 

Closes #49 

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/119

