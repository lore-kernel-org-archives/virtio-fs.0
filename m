Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=d9B6Y5jISwFRUaLEmQbtdBXOzjJN/8qRaPVaLRjShNA=; b=m
 2g8qHrFtczT2G+Y8Ik6FEj0jAT6jVYiWUGxvL8A6qr4GhMtCIOFX8l060CfSjGm/
 +CsmUsJo5hIFvAhqsytp5XWrGKJ/Ai5qSC3jmKdPz1ZcFUKZktet9VnY0tqKa6vj
 Vu+6QCFi+l+SdQFmI3Q++VGkKVuEJokuVuoM3Q85t8EgnG5+9K+ZtIHG1Ylz4PQc
 Ya9q9UnluwDOJ3QnlJ3joBmaBzDoXY2O7Ingux92SKiEQOyuJMImUNFtHva73/pC
 BpIPDkg6DhjHS4mYm6mJd3bEfTMjsSviOJQDRQIl5RA3RXS8NZwzsioERpTWy4wb
 B3o57B2m2hivQBwHQvy9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=d9B6Y5jISwFRUaLEmQbtdBXOzjJN/
 8qRaPVaLRjShNA=; b=DtLsYURJJpvOX1bQLOXfSk5ZX7FatpyNSj7rYUcxrO9dZ
 6/FPDpUuBRbnBjy43hQ714a920Qb2yQScmJx1f6gffVTTzDRrr6psV6ewIFB3UsU
 j/XyWqXZzldVYAcNxuvMiJGxaRe4jUxbA1L+CF/DtAWp3k6MUwY8oUW9pvymuvlc
 4U89d1TMGl0TNbroEyWTOwM/s8WeN4lipv83o3XAw8owNMwCRoBKnLABNkzlZ2cD
 8y1Z2/g/09stO1+0IrZ8G5E3fsFDEJ96VxrjPjD8DrZIlbrayAyMH5uRlujnCIB+
 4iJG3rwwLUyDSveohqWIGZQAoeeBbSe8tb3R2tQcA==
From: virtiofs-bot@sinrega.org
Message-Id: <50232.122030813545701235@us-mta-501.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Tue,  8 Mar 2022 18:55:02 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Add statx musl support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This MR adds musl support, adding the missing bit to make statx() available for the musl compilation target.

And removes the unused stat64() function. Currently, MountFds::get() uses statx() without checking its availability. But, even though PassthroughFs::new() checks if statx() is available, stat64() always returns a mount ID 0. This silently breaks '--announce-submounts', and with '--inode-file-handles' virtiofsd fails with a cryptic error, during mount.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/99

