Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653995665; x=1654082065; bh=0032Qy8oaRZoOeUl1NjUK
 TSw/VEsB+2sIXbAvFnc/8k=; b=nREleR1n/lHEQNz59gn/6BjnRcHJrRl4xTYQF
 00w/RbrqQw4UJ9+V/lmyYp42TaXolD+H97wN26c7/mSTS4q+owxZhKGYo/GDmjgb
 u1gCPg4Bpg5Xe4P9P3xth6bmLdNqFTPQjdLtzn7/Fw411acG0Or6tPqS1lm6LPXU
 hW8B/hi/H2Qhx2QAmqddaSlOrSAFH/WBLb3d9xrfyeFi3VE+QUG7ViwBWsL11EEO
 B0WPZeFmmS5AYy8CvPPjm6Z+lRfxwAipONCZebbJ/OnOG5X9sl0MjNNSiGJnZXI3
 xxPXLkif1i8pj4pZH8YyOBkN3tb/gRLi30DBIyHvV1p1POyvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653995665; x=1654082065; bh=0032Qy8oaRZoOeUl1NjUKTSw/VEsB+2sIXb
 AvFnc/8k=; b=NCQwt1/LbE0pqIz/8lWJc2Wx4up6RgDbwvmWmgz2qWwaSGQg0QZ
 1w3bNFDrOxIHUNv1ImHsoai5dN8bVOekdpQYbZzLRJ21kwv/zWmCRVBnDEt8FxVE
 7RuyJX6boJv3jS8fqsvDEfw1jeSuhaBF+rx1RAV4GdL+R3C2xZSOfCXwOvK2qF2v
 0TdCHWrz0XKRjjhVcGjHY7pd0HBRJODt7l3AIhKFR2poJHY4ULYrfTDlyykSydr8
 KXqmu1hosiPaK5dZHplAL/k/AJ+HAsYd93nPIKmwRNv6om4kXC5RUXre05zMXpms
 QPZpz8LIDXnvk53D1BJ8acgeCFXfu7SDU/w==
From: virtiofs-bot@sinrega.org
Message-Id: <13116.122053107142601615@us-mta-518.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 31 May 2022 11:14:28 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Disable killpriv_v2 by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Right now killpriv_v2 is enabled by default. It has few issues.

- Does not work on NFS. And I think there are other remote filesystems it
  will not work on because it primarily relies on dropping CAP_FSETID when
  needed and that triggers clearing suid/sgid in many of the cases as
  needed.

- killpriv_v2 is not perfect. Came to know that couple of fstests
  (generic/193 and generic/355) are failing. Something fails on
  ext4 and while other thing fails on xfs etc. Some of them are probably
  deep filesystem issues which need to be investigated and fixed.

I plan to start diving into the these issues and see how many of these
are fixable. But that will take time and fixes will show up slowly in
future kernels. And we need to also cater to existing kernels.
  
Hence I think disabling killpriv_v2 by default is better default for
our users. 

Given it is disabled by default now, I also had to add a new parameter
"--killpriv-v2" so that users can enable it if they want to test/debug
with this option.

Usage of overrides_with() allows POSIX style command line ordering
between --killpriv-v2 and --no-killpriv-v2 where last option wins
and takes affect if user decides to pass multiple of these arguments
on command line. 
 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/116

