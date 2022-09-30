Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1664568193; x=1664654593; bh=H/8SmxuDbeh61Z+xOdW/o
 jwH5Ghr/kWlMhG4e7lEZzA=; b=An7oxtuf4yXNea08uTpvxXgbDk9qCITWSOpTT
 2GVw8DIHx5zBOq9SuAQMLNy2BKAJArsHy92997czxqne0nPhXuQ+oRuh5aB3Fx8J
 UZyQk6Lx0i7Mu1E+wehbHqz1xK26gA0fJFU1AlDx5UHtIc0zcF5rwMlkUfsY4/um
 jwrX3EuafRmPWqyzrx5Xm81Q+Mx6G5jgLtF5LwSdpARcZxzkWs7S2t+AMEahIou6
 HN9XgIJLhBHWumeydqNKTvUUJlbiFr8G25rJm0qTBoTfbd/GmR88TgZ4hPzAeD60
 wJ9wz2FLGxjJguE3jgLKJC11e00iEMbz0Brbu2X4vHlORHInQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1664568193; x=1664654593; bh=H/8SmxuDbeh61Z+xOdW/ojwH5Ghr/kWlMhG
 4e7lEZzA=; b=qLVDUR2l8iuk9KQ3UaE7jQjXM8mN1aVV5zO6CLytMGaftIscA3U
 sSGgKVlRsKOfaHc2dFpFu8HcGwEt7N8oCX3FEfkYJu6iWS7nvLv7t9fAdzZFhAPm
 AvF94p8w0Kg9iApREm5wTAFBNtl5V5xSGGIvQNX30bYKBWSjZ+lLDac0NMCohddY
 SDWqlNPJThsh3j8KAXUAdWusTvf5rGBhLT8jEZhq8o4KkNK4yPZuStDEBkacZvTG
 M9r7tM+jOXDYhNPQLCRSZQ/9SQFkF2hfRtAHw8oCSXEwpCuHLOVvVuFOAad8ie1Y
 rIL3HKOY2Tkel87Q5uBALVgUJf9I8kLKIYg==
From: virtiofs-bot@sinrega.org
Message-Id: <98682.122093016031502073@us-mta-104.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 30 Sep 2022 20:03:18 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: supplementary group support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

C version of virtiofsd has an issue open where client expects supplementary group info will be used to allow file creation in parent dir but virtiofsd/fuse can't handle that. I think rust virtiofsd has same issue. So opening this report.

Here is the qemu issue.

https://gitlab.com/qemu-project/qemu/-/issues/368

Here is a email thread to a discussion about this issue.

https://listman.redhat.com/archives/virtio-fs/2021-June/msg00001.html

Recently a JIRA issue has been opened by KATA folks who are trying to run mysqldb inside kata container with virtiofs as storage.

https://issues.redhat.com/browse/KATA-1776

I guess it will be nice if we can figure a way out to fix this.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/59

