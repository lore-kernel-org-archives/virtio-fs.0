Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1657808407; x=1657894807; bh=LdOjIu8qijiLqcgmVsRia
 ZXOMWEjreLb+q9L7obB4Qg=; b=LP4vaWVSMxiIlXFoA51LNJrrpb7VlinIcRYpS
 PBYg7dos4/EWfdE7071rDIlEySeEeUilWoRp226/Sncv7kfjaxu4G4YQx8ZUGnLi
 +Pk8YeJhsz4AFyxJHdRTzzRzLyJ7mJIZYpwe+klwoRmeGafMsxJt+mDEUzAEh/fY
 mI+71f/korCtwLxDAQIMTV97JblHsZQeJp3ToZGReISivLvVVD8M5DvAvZHPpptb
 8XIx24hQHwRwGwapmDkOIKeD+yINKLwFVzHjlt4kHn8F8GtuE9sfmx/QMaIh84OV
 oUUyA8ZnVMwSGacfQVj6pILS6CA0JRB4OQuOehWmE7acMriWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1657808407; x=1657894807; bh=LdOjIu8qijiLqcgmVsRiaZXOMWEjreLb+q9
 L7obB4Qg=; b=alxTGwGonu55Dy0mXbO7IktCqoNHlRVa8qdmCBNkTqAE5E6xQ4k
 +8i8ebLtOGypDl6XAA1RTVb3jCAiOHcQ4kDwzXq+pU/cUCkvvVlCJ1goINdmx2hC
 KBTH1sGgXTliszHcOIH6XsZ4mUoML0VyQqKUtwvkMb0GGuPYvwetN4yyRWS2hkru
 pAS9mvmYOIjfyxbd5SxOii9a0LuNH7Z4Nk4Z09wZIPSiFw6uiTiuDp4+tneVQuQw
 uprBeZpCKU15rp0Sett8/1eXZXIy3KgJigzEhB+k/ThyMb7Q1EPI0poRzSwr3zCk
 pIvtP+3SUfmRIxa6yM+5/nr8t1MC4WvniEw==
From: virtiofs-bot@sinrega.org
Message-Id: <23997.122071410200800577@us-mta-344.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 14 Jul 2022 14:20:11 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Adds safe versions of
 `libc::mount()` and `libc::umount2()`
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

As part of the effort to remove `unsafe` blocks to increase code
clarity, the wrappers for `libc::mount()` and `libc::umount2()`
are added and used inside sandbox.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/127

