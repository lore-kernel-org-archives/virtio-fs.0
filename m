Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=LlD53OdPJj/B9UxjponE4ASLGJ6LsvX0fsw4icQz/G8=; b=G
 3z/0x7OXGSwj1K6ThtXqQkNeO/yYgYuupOCw4YrT2ZuKdsx1rgZd3+qrlgnr1dEs
 jrgJ9UupPy+oldQgd4gXNJcNVrCQyTA6JfS2k7I/2J2c4vhiYyWnDzV9BOdcMYxj
 KWnrSXG/QcmIKLBASqUyfV5LUejayYqbtkWN0y+QEf/Q1OX3+78kdmkwnaQB+Rd4
 Q/e5+qtOeQzqBFDj3+RRlS9++if+TuD5C/QyD8cYoZbYvIM4LBiqRWUisUQL8KFo
 lRMrmSp8OxqtH9b5i81g5uS91SwlcuYBqbJJHbgCnshe98KrN06C7AY32nzO48gn
 Q529ACijO8Lj73hxKks7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=LlD53OdPJj/B9UxjponE4ASLGJ6Ls
 vX0fsw4icQz/G8=; b=noy9uolynXNUjAnRgBAnPBrOKsELbQXoZUfiqE0B+XoQ/
 PZpk8oubDAv4lrGBQhHTVhpc+S9ih3WI31PUqmY7f3B//GqLqSO7qbpKEDdZW2H4
 9lFsf0JbTW0hqE6lbXKOwxVQ45f+yneiEVKIgFnvvQSCqtSMNex1A2c0gdAUJX4A
 75RMI7WihxL973eyVBxcE4f3u4YPY02zSHT7zJ1F8OiEAh9j81XPZB5kJfvJmmt6
 YqwF1nPToriPKyfmDww+hzJ9rGQ1b5LK9z/gvt1h7gDwuPnarfxMy0g1n3k6U2cf
 wPnMB0hV84dTPWWWnoJMCoba4bftP9MjuDTqjcYoA==
From: virtiofs-bot@sinrega.org
Message-Id: <70522.122031006113800165@us-mta-135.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Thu, 10 Mar 2022 11:11:40 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Set the number of written bytes
 for used descs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

As the Linux driver ignores the "len" field of used descriptors, we
didn't bother to set it properly when return those descriptors to the
queue.

The problem is that other implementations (at least, the Windows one),
do care about it, so let's do the right thing and set it properly.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/101

