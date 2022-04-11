Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1649688999; x=1649775399; bh=9bIfyFRTfn3nCvd3AGih8
 Ku2POj+jAOGb/Op+4hZye0=; b=ThvDeQxkASBCjdwcMogK9WobQDBRbBMNLNYcc
 JBaZmpO1RJpTf5bBqmyrapH6VOUQIqvNCVjpeWuQjvYTXJ6yBdz4u0ls1RHbIoPg
 jW+LetFRH1z68JLJhosf2j9cRFO3FV0Pg5x0YhKogI6W4Qb83ZUDkn7hF/W/GqxM
 HeMCP2nx5UjgtXd/vkFShfnTEwfMqegAZ9jfmwUQ7gpkl7ICErXQIqy63S+ZvZLZ
 dLoJr5DFbPZP3RWbt+VgMUUqY+1RY1wIsLFLR5ZjrZOuVOtrA3+UlXHCFr1+ODvU
 uJhX7ISigyNmc7nWhntjRQyRdYMoaL05IFm+cihCQ2ZNnh75Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; t=1649688999; x=1649775399; bh=9
 bIfyFRTfn3nCvd3AGih8Ku2POj+jAOGb/Op+4hZye0=; b=BaQH0j7ASQeFakcie
 vcV0c6h7dSGdc1glw5FP/tuFrdHVxstVzpGcDDk0V+PVSwb7uKRaLnuCifIqIOyD
 q5U5yuh7QiqxtGvb2UaAN7hZIKYA9K6WbiT8NFPqPx05KU/eRei8nP/RA4NyV292
 /AO1gdlb/qYToIftUZ8t2SNr+yTIIrZV0KqAHI8bEWzqhy2Za05mDYDc+oGnBVMn
 ACQm0ucBVWVY+rQDZu5wwpFtidXyhIoIt55TpLzjid4LZQTIFwAI7BEjZVgskuRc
 B88+6pChTVY0h21MWS+Vnw0882YBq+kLaOnaOuDLEDzrjyFajT1eUbILbmJ8Ct0x
 UNdog==
From: virtiofs-bot@sinrega.org
Message-Id: <02521.122041110563902547@us-mta-122.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 11 Apr 2022 14:56:43 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Update inode file handles
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

