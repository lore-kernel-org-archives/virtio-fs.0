Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1667923264; x=1668009664; bh=iOGxzJMkoElZjdPhiKHx3
 8InVVPdoOydOU7Ma0CQ5ls=; b=7sN+qUNbHl/1SXHthpDgcGM6STPBp8qM3FUHN
 6wu6D4tVRFew67VXTepoVbsXXpYSUBfQcM+mqakOMNsNvyJs93+xA5NaiSsz2Y8v
 GAZ90/Zt7YyGTcDu9cUKaeo2gCMMvY4PEMGdjUS8flY4Ha0ZS+iX5PKSPqW+FWs3
 P6OngUlMODUruNwpEupbaW1peedTs2eba5m9uJy387e4HD9LIgvD4s0G4MZTfUU6
 xGrl3yF9qLCTY4O7IFDqbUCOOjvVOOLChs5auCsjFt4gs1Xa34IZV4LoD1Qa+yGE
 hcMrlr5L/I9EMBlmIQX6WKj2dNdKZCMsehYBgDTraA0JeXgkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1667923264; x=1668009664; bh=iOGxzJMkoElZjdPhiKHx38InVVPdoOydOU7
 Ma0CQ5ls=; b=HG9OOXFKF+/lOlqJm4dSO1ZzktJ22uqcqxlSmyBaPbj2iBZ0qHY
 Gwx7joYcJIjCqmtwhX2AKMatbtG7PDtV3GjtwpdIHlBWAZMw3MbXC6fx/FaqPJoD
 /+1gmv7EARE4mIkuWjBZIEB9X8JWC2VUHF/TyYr07ravIhUSdU/YtGE283zx3rI4
 AEpnBdNxCQGDk5NY4wpoLUILmW+4DZWBguctMJglyYplHJTdqX3BzkddO3F1lkkm
 JYJGTdFdhOG5Lhuu1zFKV7phIle5/vexkaB8Hf1t9bn/lKGJ+htSqfv23HasOVPD
 PccPdwzyzOexptqduvN1VsktMahwrdOT0Hg==
From: virtiofs-bot@sinrega.org
Message-Id: <83408.122110811010501265@us-mta-135.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue,  8 Nov 2022 16:01:07 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Add missing license file header
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Add missing license file header BSD-3-Clause SPDX license identifier

NOTE:
There is another file that needs a license header `fs_cache_req_handler.rs`
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/133

