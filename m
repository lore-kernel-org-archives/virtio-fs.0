Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1650463400; x=1650549800; bh=kTE/b0i7fvHgSL2qGMMa7
 PCXGDnnRTxSIYzVVk/q51U=; b=XCZlIxt7SFGGmGZu3fJwfuYUaULpzDH5qtSIi
 dLo3Q2qHInit11RasogatFdbqZj+fYtkzZE4sOnaxWMyBQFU7GwDuRuV+L7pEvvi
 XRTNu6zCvzEsnxOB3AwCYfudWEuYc1VE883jUaOYBjQ8jTBNoezEq/hrrlYJ0uHi
 +Jg/1e0TYD6Y7e7vrY6et6XEyhWGAR5mUr6fOHLaOf54GBKN/T2M8xdALLgmvlWw
 yiinvi5qkfiZZDRtjdysBOWdiD9eMXq0E2ckBmkOA/D++YJB8BhYuIhYcrztj+NZ
 wj3k9u4yuPMfP0Y2ZWswFz3b7Z0fckg50OGRylRSP69jY/h4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1650463400; x=1650549800; bh=k
 TE/b0i7fvHgSL2qGMMa7PCXGDnnRTxSIYzVVk/q51U=; b=eEa9CUvl0XdJ3RTs6
 cGsXiqWjFbXW0jp6npGOKxYejt9obSqQsz8Czg2HDLrkEE2zSRXBXRuqTjuTg5AQ
 3R/mZZ2oZXRh1GVQK5PyIIgd8YZ+y6ZH0Fh3N0/mq0QCSIgZ2OmSk+TmOVpYe3or
 SUXwRavygESlH4PHdyNsauXkLb8Kg9T3bFTxylzP3UHYtTGSgmiX8AK7LrJ3Brsi
 0zEs43OnNr8M9O8zAhKeyN5l1zuIhJtd0HmkE5TBeRcp8ZTmgRkhUVyWoTF6wjr/
 VznLb1KxsWTEbFdh9TEnxu3Pxo/fOg/drO6sCJisBnhzKtEd7oQENmWYySeE1ERu
 Ir2pA==
From: virtiofs-bot@sinrega.org
Message-Id: <63293.122042010032200715@us-mta-173.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 20 Apr 2022 14:03:25 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Log the FUSE opcode name and
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

