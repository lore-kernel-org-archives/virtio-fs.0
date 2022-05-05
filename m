Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1651748986; x=1651835386; bh=zG5YSkG3FK5bRGjlGFUOe
 JhDsmXxIQG32uDrMDRvwS4=; b=LaYBzA0a5Pzt9BlYIqRcnwgo1xnZHOtXqBvL+
 A3B6qaAJFYQi7g139C7OUK+n6XJzX+s5pK1Zt0FS4/kkmmGxXJu+4SLu4O72luqY
 9L1Zr3xoLvrEKHydBCCwgQxn+EOukJ0/3vUQwn+eSas56YHXEWz8E1t6bgYgE6je
 9n826TyKk5mIKIf0OdizCr311Ib2JSDLnoFdN7A5mXJnFVfarqQalYUg9W3ylYME
 NzpdZS31VPjG/u9Rp6jpKVoq9PKIWD3nGVfn3yEwxCDNzo4nOvCat2fAE2u2orSP
 +9IUQxmYylK55Aybo+aYm/9OlT83f0M2pzLeRzJ27W6INHfZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1651748986; x=1651835386; bh=z
 G5YSkG3FK5bRGjlGFUOeJhDsmXxIQG32uDrMDRvwS4=; b=YFqRuR1wHfK31PZnz
 oM8kSqHnFXBqL9Nc9nIU8HqonVT+uVwoSMI8GQzTo0NasWi14xhKUd8lMxxH+WIe
 zKjI18fmFkYdn0RwZiupHiW/EbD0MqPhqI8Wcs8DB9VXTMv1v/L/K9PxDLvJYIlM
 4GHKLkaSzHIZTMyZGVrSj1axJaxtIkgZS48O6Wdlx29pEl3uRX+uJKQruiVUqGXu
 jFWGC+L6cLkP86LdvbkhJc3tI2d272oeePvwgNXuBsbtX6krfKpNKZ/Iy2ZAwUsD
 vaOV6xORt/x4YEjz4T6T5mOAucJMOT0MB67D0UX0S/E7/j1ZjqajK3Vtt5Qrcigr
 KSWzw==
From: virtiofs-bot@sinrega.org
Message-Id: <20812.122050507094600237@us-mta-146.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  5 May 2022 11:09:48 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Replace deprecated MAX with the
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

