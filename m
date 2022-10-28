Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666934408; x=1667020808; bh=T7U6qOqTezmexaUNWR4q1
 Y3Wn9g9Pro9yVrh8WWa66c=; b=kL6QqMCaWVZS4CqJSzQ7NVLfG4b+q9BoEwDgH
 chmILwPX3uRAOyx43Roj9dh0u43v9NfMeExpAt/7Jn3xV1+4W7vzrplw82kwCvof
 qyaR+LLrfpUl7zckbxTvYwpFjnIP4RpW+w6jbSXz1zL7moTsroTyUOp0w99zL0Ky
 v6ii1W0t5TvGthjdxO5hQuzJwC+2u80Ttk6NgHQpvB9hiAox6KvPOygWpD1872h6
 VQcR90npS+XxNE+jae8Bh75kc/Zlbam/8k2DoXQNbx9QFD+F/3inPL6KRKYzFk1B
 8S434NdncqJEdACBSNt0jwfGfsnYqrmOjjemt7E+cK1CMkjkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666934408; x=1667020808; bh=T7U6qOqTezmexaUNWR4q1Y3Wn9g9Pro9yVr
 h8WWa66c=; b=hYkEdf6tsj6npUYtUBdb1KFivxLWLmxElQwRAFbGoJQ8LQpQN2Z
 kEButbj7/phLTO3JHNXcbA9IhOWvyPz3uaBYUY/0iSN4JUBSueZn3uRxMEbNOV+/
 pif8Ect2VzL6ndjyyR/9D6HpUT2hPIrOcXtd9mz1Q324P0U9+Cte+t8+HnWNworU
 ILIKJuRxchxOM0Obq+t/M3Va+Qcvs7eEB9cT569l7VNm+tbWYv9fuEuj77UeidT/
 Bv0RlKQN5U+ljCwEBf9mPBwhaYyGWAc3uLzcr8uXtRzCoTAUsdNW0XzXMHh3pACC
 jwXsSYSSrQ7dY52akXUSBeUdrfEQmBjrzcw==
From: virtiofs-bot@sinrega.org
Message-Id: <72428.122102801200800276@us-mta-374.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 28 Oct 2022 05:20:11 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: performance gap between
 virtio-fs and virtio-blk in --cache=always mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi team,
I've done some tests to virtio-fs and virtio-blk. The conditions are:
 1. same buffered read workload.
 2. --cache=always for virtiofs
The result is virtio-blk costs only half time to finish the job than virtio-fs, why is that in terms of they are both just memory access?(I do one extra test first to load the workload to memory)
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/66

