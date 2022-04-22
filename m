Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1650630339; x=1650716739; bh=zG5YSkG3FK5bRGjlGFUOe
 JhDsmXxIQG32uDrMDRvwS4=; b=hrHZtzzwJc8drFTKw4X3T8X+GWlPDOGHS0mtI
 s6zA/qt0mzx2BM7xR5YQEK/Cc+MM9BEoYki1Z9Akh0eFUIq7R36N7NAgwa9Yr+u3
 WWuPd/jtESJDzMrIeVT1tlrNos3capCNGWupyaeyn98jKkWWYWEDSRme64SrWrGJ
 sBHjNQLDXKuBQC4F9CTwglW2XhbpSXQgjvT48GeEx9TZLELIGUXBSZi8MTfwN8kS
 nSDS304kWHOGcL3w1pMWow1PQmwzS0gIXRN2HBgVPlYM05+wA/G0MRKF8TKMDkYb
 VPEBg118T87RFDQ+VVtU1ObIolvWSxyB3qeHY3C4mcKWNP+Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1650630339; x=1650716739; bh=z
 G5YSkG3FK5bRGjlGFUOeJhDsmXxIQG32uDrMDRvwS4=; b=mBfuW9K5uSLArxkF9
 LZST9AWvaCKG0tmz0+FGkjChZfOx+y0fCn2+IgqiuwtnF0WNt4IzC/ij8e2Dz39m
 d6k/wSkaNhMvjrwNoSLflo+dEWWdXF/qwrzgQidJM6K6GJTDtEaBWvf96U07pQzV
 eyDXUCvB7H4A6t7RMyz3tCggZgigcZ5TqVMkwQ/wwN++N4iUeM9oK0eL1pcPaxDb
 SM7srF6MKsBtZN+vFsKA4HHk0jQqrDFShICScBu+3BqxzxNLXQe9JmbBvWhzkT7r
 xMQYsSzHrP1VM7H2IrSk2GMMgrfsl0vilrVnW6njazYkARHH9gPVIzw/tIsuW1sr
 EC2ww==
From: virtiofs-bot@sinrega.org
Message-Id: <38966.122042208253906279@us-mta-630.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 22 Apr 2022 12:25:42 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Replace deprecated MAX with the
 associated constant on each type
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Replace the deprecated form of std::<type>::MAX with the associated MAX constant on each type <type>::MAX.
For instance:
```rust
// deprecated way
let max = std::usize::MAX;

// intended way
let max = usize::MAX;
```

See https://doc.rust-lang.org/core/usize/constant.MAX.html
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/112

