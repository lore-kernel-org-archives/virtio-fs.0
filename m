Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1655445751; x=1655532151; bh=AX4gEIruj5vmlDK4DrHTG
 fv+Y9YY+iZs8uaAZIid4qY=; b=dR70ccqK3RtAeITu+1ACEor3TXtyo4oNdKBW0
 2ndBAlYzOlK0vs8vuf5vjUupyUYn2KWO/c9S5LsHOSeAD1NEJ7cKQtLOilAXcgsy
 b5JteWMyS7/k6x2awfiI2N/q8TtinvWc8bk6kkbEjRhHwO7/wLCg0AdOU8jysBB7
 vMSdjrZH71Dnt/zxnZn84VCmnmtcyCqCxBFG9Zgaw5JeRAu2MW9UoZEcR1kc+LD5
 vclVQwaYhdg3r19ao4NmF6UpOAWsNKpNvq+BQeQneidLRCCmr6nwztOfnASVPj9j
 +t3M6XoJSzI88FFWtWMzvWFw8ts/4uzdabg0w73zvNRJ8Z7xQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1655445751; x=1655532151; bh=AX4gEIruj5vmlDK4DrHTGfv+Y9YY+iZs8ua
 AZIid4qY=; b=V1ARMsBaBY1QTjCVfJ7x0EPA63Hn9ZJGzKGrCyLJkrk0BLvZlvN
 jvaT2bdCV8Ph+bwR9ZEx34FTA36q67SyiUeLDSFSj5nbGRoBwWmPFGRyABQk1HcS
 XWlFwfFPXa4pLR0WDZCwt2uRRHNZhviWVGjtK9y87qXtvxXiDfQLCoanSng2leo0
 u/tXvtRZ12/THiguR0G/wY4wmwwDHqkef6uy7WZTbPCyMaFArjp10aPz1kVJ82LF
 INrYznYBhXW1M0pC66/1fr8AFEor9okPWUh2C8GI7rK1X8HW88b1ob0VuvIRiCqr
 oroyMGd5/XNWnpgmIAR17NnGmNha8Zl8NzA==
From: virtiofs-bot@sinrega.org
Message-Id: <82490.122061702023200585@us-mta-226.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 17 Jun 2022 06:02:35 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Fixes failed open mount point
 when using file handles with chroot
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When using a mount point as a shared directory (e.g. bind mount),
using `--sandbox=chroot` and `--inode-file-handles=mandatory/prefer`,
virtiofsd fails to open the mount point, with the following error:

```
[2022-06-03T15:44:22Z ERROR virtiofsd::passthrough] Filesystem mounted on "" (mount ID: 744): Failed to open mount point "": No such file or directory (os rror 2)
[2022-06-03T15:44:22Z ERROR virtiofsd] Failed to create internal filesystem representation: Os { code: 2, kind: NotFound, message: "No such file or irectory" }
```

When using `--inode-file-handles=mandatory/prefer` checks whether the
root's (i.e. the shared directory) file handle is usable, calling
`check_working_file_handles()` from within `PassthroughFs::new()`.
To do this we need to determine the filesystem's mount point form
the mount_id in `/proc/self/mountinfo` and open it. But, when using
`--sandbox=chroot`,  `/proc/self/mountinfo` still contains the 
pre-chroot mount point paths. To open filesystem's mount point,
within 'get_mount_root()', we need to strip the shared directory as a
prefix from it.

However, when the shared directory is a mount point (e.g. when is bind
mounted) striping the shared directory from the filesystem's mount
point:

```rust
    if let Some(suffix) = p.strip_prefix(prefix) {
         Ok(suffix.into())
    } else {
         Ok("/".into())
    }
```
    
the `p.strip_prefix(prefix)` call returns `Some("")`, because the
shared directory and the filesystem's mount point are equal. And
that means that `get_mount_root()` instead of returning `Ok("\")` it
returns `Ok("")` that cannot be opened. A quick fix is to filter out
`""` to return `None`.

This is a temporal solution, a better solution, suggested by Vivek,
is to open `/proc/self`, call `chroot(shared_dir)`, and then open
`/proc/self/mountinfo` using the previous `/proc/self` file descriptor.
So, now the paths in `/proc/self/mountinfo` are relative to shared 
directory. This makes unnecessary the mountinfo_prefix logic.
Since this solution requires a wider change and needs to be tested
well to make sure we don't break any supported configuration, it will
be implemented in a future MR.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/124

