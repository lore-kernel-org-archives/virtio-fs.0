Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=9bIfyFRTfn3nCvd3AGih8Ku2POj+jAOGb/Op+4hZye0=; b=E
 umjnM54wD48J1MMKrc71hu+UiCJ9sMxoX+Nbym8ngq2T/E52bUY1WvxImg7/S9UB
 rqhqkm56zKtThD2tTAL67BR+SmBU3Mmf4mVIjZsqOIIvEyPpz0uAi3hUv7ZBSf9J
 kB4sf0Z30NAPrpVFdvTfDGbdyf9OBX0e1tGe2Hct1U0CM/WZWT40NGkqKAGJtx/B
 BVbUhLauVH6d1kc7xSn1BvSTSFwQdqRPp2MZwBcajDKepHYYZ5Ufiag37Ddi3lTz
 cq+2fWNFQFdaJ9kVAfTrSpyJgPCt685M00PmbPO3HIqGCGPj1SU+pJBMJ1yEgw2T
 l7PcEYRRJ80MyYMOsgCQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=9bIfyFRTfn3nCvd3AGih8Ku2POj+j
 AOGb/Op+4hZye0=; b=By4xhojq7LQe2EEasvilwgQzIW47hOtX64jh0/qWq0Dme
 ZeVxGv+3k9q6+J2uw380rWTqJZPOFvQ4plijP2aSJu5+pIJnt59aO4VprM6SpMM/
 IRKC4PSm+MuEFMZIRmIIALSxIO8ROtSLhecF68h06ghueS4OY4tRQ4CPPcnhCCxg
 CSCxnKLbx47An3Hpauy0PALEjRilTZL2BzYFkxjQH/zQmmr/e4e8f2CaP6+eWc6e
 towHwIWq+0CUC5t5yCdrGy0LfnsRoMBXZnnEn+3h9YPgvo7zHmwedtsHkYqnJUrL
 2DdRUXYqHVorlCx3nK/iklI8UcKMcoCoQOSChjsNA==
From: virtiofs-bot@sinrega.org
Message-Id: <37453.122040604553900664@us-mta-610.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed,  6 Apr 2022 08:55:47 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Update inode file handles
 documentation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Replaces the inode file handles deprecated option 'fallback' with 'prefer' introduced in !100.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/109

