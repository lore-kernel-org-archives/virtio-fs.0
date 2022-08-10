Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1660129293; x=1660215693; bh=IhA9j+4adVgkTV5WZY8pC
 wzo4FX7XRr1TRkZc229L2E=; b=P1k5ELLCzKrPIBiJNAmdnYLufz8AKr2kxkXK4
 SCZM5zQguAURke6j3w2Xvo9hLZt6a5nGHeNgyvZheqZnI7MeOFYh4FtbKJBZvmv3
 BwBrBSKYHRvS3pVBHhvM69WqJ+ES61Vf25Av422vc11X9gGwrUtTR4DpPfN9FH1f
 Io75hqY79b4JW/SYeqtx8zyfIf9CiZADmfy8GdD5KhRiqZdSN/KXJtpST8APy6Cw
 7u81EmHicr5MufKhAJoAOEtKm1F87AWqwvLkLisWzfYN2+VfRUq8nW/TUXStGO+3
 emMNvPXTXo0+Q6vW0Yv3V1mvy3WPQHwT9s4M6Y1sVG3USXgEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1660129293; x=1660215693; bh=IhA9j+4adVgkTV5WZY8pCwzo4FX7XRr1TRk
 Zc229L2E=; b=betmse+0/MVu67p2JQroM1oyM/Npb17PhYh7CppJbYNpk1GRQXU
 85U+/U7kesqA7AjS++8oU6HAZmN81NbThIO+b/V9fU3F/iBdD20H+YECL86vi5nY
 sVksE5+C7BVkDTyl+dzURbb+a8dQEHnOUjS7QN6kUsxXGFhq+2NTXmqosduCtEOK
 4kAcOyYBz1A4qN5o66ENKsmvF5o4CCJ+jWWCq/qFkgJLBTduwOXZGouvrTMJhwMk
 lQwBoj94rdy8XlpJ/feVAP8jxogE04ItFf41ziHw5eXT/CLvdJOQ/t9Ic+kbEji3
 IqP/vm+63VMbRhenYjAgTQCqerwMefZ99wQ==
From: virtiofs-bot@sinrega.org
Message-Id: <01242.122081007013501335@us-mta-52.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 10 Aug 2022 11:01:37 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Add powerpc64 arch support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Running virtiofsd on ppc64le fails due to restricted syscalls. This PR adds support for allowing it.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/130

