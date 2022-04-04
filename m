Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=a61E4znYOnXKt1M6WZYJzd/Pxwqd1UoUn7+UesWg0ZE=; b=E
 1kePIOk8wJIAARV9rZhUeacs9/Rs1wPPyowioevj+YgvxypGGkNBmtpV4vQA8DPf
 mh4kKaN84tPZ3J9FmRWn2kUb9R+x8VUjd/B9UaAH8LysafVBu6QULaaWla6czbsT
 8kZFSlo4jSjqj37fIqPs9/vafY4GYqK01eBRUVMcL3nPjerYI3M5qhhzPb1bvijH
 ZZ6Orw46cF1TV8UPCAO/4qPOcxAVm/cl+0XiJB184xvBTZFag1BMqgQbSQQ/adZD
 q09weiabzsZxliV61edc4B0YMUR1/F988mA/l20st2pQsH5rtn0XC5qj/SWmwikM
 QYkntHZ/LTs//qN5wdreg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=a61E4znYOnXKt1M6WZYJzd/Pxwqd1
 UoUn7+UesWg0ZE=; b=JnX0rxS+AzEoupcLWwuVkUvH5p53v45hObsDFUSY9SY9x
 XnEiLu2vOvaBAz71l2EWZOZ+EsFU1zVQJwZ7gLSoEPFRT9XAPXJHogbwFEq22mOy
 ruOSlutDxuWASPUyAthcMxTLyDmXcbp+GEf+V23L+XeIo1LRdBp8so1A3mMy80j+
 f7NC9mTDgtAkmnTcOERLt0KdlORNFR73GYtZ2KyvuntU5yKmDQgWhMKkREwMEbaj
 4ers5zy1vPJsExfeqqNULBRKGvJX6c4ojZgAO818OFlnrW9o78f/wlytUwBp6JgF
 OyfyV230U8iXKzeyDheY1fmmzNOmxXkdkmxR2lsqA==
From: virtiofs-bot@sinrega.org
Message-Id: <24158.122040406223700185@us-mta-320.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon,  4 Apr 2022 10:22:41 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Switch to building statically
 linked binaries for publishing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Switch to building statically linked binaries for publishing
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/106

