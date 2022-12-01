Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1669876026; x=1669962426; bh=s3k+tcsbh8FCpTdSioBnF
 d4dcBAM/BRiOT0YWmloPiQ=; b=7MqtqHIxMEJgJZmaDGD9csTHTg0Ew0qOsaNUn
 +y+g6EqyAUH2vgISdxasSAWbNurM3oiu0KiepNfaVov3Lu0Kup3BrLcfZ70hTGbP
 M1hkNYicBEqmyeTnKZhHWVMcSkW6E4VkZha0dxW+wmM92ugFJRl9loZvGPh5Oxan
 QeLHdorPM0Zj+Jbe3Jk2h7ursb30vlepbrGQ6Q+M8aw9kReBQ8RuMPQIu4P8vT5n
 T9IOTE3u9VBKv0S5fvmxvCDKbX7l6iMFSxrttBDV3V5bSh47FHluHaJ+1/2+Knu3
 otz2PWmr184H4kZfpB32Y8k5PEbAvFUHldihyTQajvL6c5MlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1669876026; x=1669962426; bh=s3k+tcsbh8FCpTdSioBnFd4dcBAM/BRiOT0
 YWmloPiQ=; b=tAbYx+OwVGTLbt3dHkSRzTFQujgSS6jF6/NF5vgZ1i/pEZTgFa5
 RCXDVecKGh6512y7asgVLi01vnjBsMBBrmTSo0gZXhi9aVvkcDoY4WJQWELduZWr
 Sk+3yxUbOpECydMJsPSimDWbECSTLvDXqQe6ccF8fj168X6jjQItC4ZsnlPs/49f
 lOVUXQtV8FpUbkcXEsWSt31tbBhITTtAjOFXEYci1GVqYIYGXst7Am4Hg/d736KW
 yvEYeuP1L9n6wfx4BOI94pjsgHc/XKDHZucf2b1Dn2nxI3ikOf2ozLeS8Vs73tVj
 WfFIZHFambV+6QafZbJQ9JeIlmLg5FhMVkw==
From: virtiofs-bot@sinrega.org
Message-Id: <24069.122120101270900176@us-mta-572.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  1 Dec 2022 06:27:12 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: seccomp: Allow `SYS_sigreturn`
 for s390x
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The virtiofsd currently crashes on s390x. This is because of a `sigreturn` system call.

This was originally reported and fixed, for the C version, by Marc Hartmayer <mhartmay@linux.ibm.com>
https://listman.redhat.com/archives/virtio-fs/2022-November/005292.html


Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/144

