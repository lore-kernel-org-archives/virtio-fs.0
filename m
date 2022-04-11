Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1649688579; x=1649774979; bh=BAgmpcwEt0gfVgvDpeDzY
 s1wRFxGbkB+LV9cEifM9xc=; b=SegjjUMKDXTrhuQVzlPl8o+OscCRYpI/3zIMX
 vf/zlcsBXrzHh9ldLCj4L5BAaCvf1gEuRC900LLG0Yu+VFkv2QRHkn4Y7o3e92+u
 Lloe+CceBvtVu2Msox0UtFT1Z27+a7XwiCw6WBiOGsoJo/vbrxs0GTkBYJUiPFWe
 tR9NuOFGzGvWc0mqUIsyjOlxtyuO90hlIGf73miir/jBFiibI22ACpZk6JSEPZ04
 Syn24giQUaIxi7LDmUglI1KhD8IEqdSY4ODUt/gm83/h9unpCjv7Q/Mt4xhDtjry
 RPUCunQjxD7AkoMJgblGQ7TNA/6EtoqPgeWZ0efRAaI7uL3zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; t=1649688579; x=1649774979; bh=B
 AgmpcwEt0gfVgvDpeDzYs1wRFxGbkB+LV9cEifM9xc=; b=m52eBXeT19w8Yc9Wl
 o8yT2zN0LvWeox4TaeFOxXxPQpxOC0aPpTPsA76TyIlMPyj0lGcnu0JhzjOOyoa2
 tnMLec52tcCVbN4pRdlZxzM69mtqm/ieuE5gbgGvnpd0NzRS7MXI4cDBJtas11hk
 S3i3wWcDtPbjrhCBStMEwj+Birat4DOgAnCxvhwD6D+2EFl8OJC83MhDSO8XJ3pb
 PAGMDdXC4bA0HMkAOhXH8LenxbA55r9Lz6eKcRWig4JAdpEBuPiKYawE2pbJOx0G
 TF55ucOpPA74tHBuSckvK9FkIeLZl+mL/ANox/bdObUSl3wZ+f0HKB+CLeM3i2zz
 YVCHw==
From: virtiofs-bot@sinrega.org
Message-Id: <94891.122041110493903703@us-mta-648.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 11 Apr 2022 14:49:42 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Increment the rlimit_nofile for
 all sandbox modes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, we only increment the rlimit_nofile with the user-supplied
value within sandbox modes 'chroot' and 'namespace'. However, in the
'namespace' mode, we don't honor '--rlimit-nofile=0' and we increase
the value to the maximum, as in the default case.
    
This commit try to increase the rlimit_nofile for all modes,
honoring '--rlimit-nofile=0'. Additionally, it leaves the limit
unchanged if the limit is greater than 1M. Also, if everything fails
the hard limit is used.
    

Closes #37
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/104

