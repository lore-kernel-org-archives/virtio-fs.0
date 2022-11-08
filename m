Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1667923461; x=1668009861; bh=NG0vFtx2hG1yU6ROinaoq
 Sc16BbKi/l/KOB+b7dmhRM=; b=O0OajdtEcb7WvssAVigEC/P8QlmDvkN1uZtdc
 PnDcTPkKzW0460L4JjlBculCZk7hZhvqw7qQ3F6tsn0WCMAs2UiRYkxNbcP8p1kW
 MALoDuAUmZE23+q4uyytgHI2gsYWl45tEU7ThiPYnWh3R8qVJt3DGvEh1/3KFaXQ
 0N5yBkOn1Xi0XMwEmlbBrqzhlw5AXrchRSFmVN3q5iPmFNPFtL4HGwb6w+SjZq+6
 PfDctqCJolXTc77Ktf5yMUoK6sSPqYR7iPNBtC29awr4HDrCkmZi1fQau+TwE6gZ
 NScwBWvB+q5CO51vE7VyrPrR66gfzJID0FiJuUd0BCi0pr8CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1667923461; x=1668009861; bh=NG0vFtx2hG1yU6ROinaoqSc16BbKi/l/KOB
 +b7dmhRM=; b=sARPIBsUR2twHT/z8L3nAEDiUS0LfbOBKKRQvNEiQ3GsQGhtnjc
 t+nBC5g4bREVj9H1XQYU5NJM+1MSbRgputgyq/1fcyK2irKTGVM4At4pTAdsKWEm
 wZqOI3t/r8mRY9jlWZ5tXbQ3iqPvei3Belv0K/L9sooArvh5cYtQG8d+4MTZ2n+b
 tJs3jD6BstM+baxValclt18ogrlTFEGY68wR4gv1uIuvDMyjuP1qexle3EFI1m40
 3bLPHGtofjbpe7XBmqdePe7R/RPrNXR5fJyz9RaWzNjGE5UWHz/k5n2OgtrOkeMK
 PPmCtGu9WMNmL5+3/ssoBCb3SXp9anvVfww==
From: virtiofs-bot@sinrega.org
Message-Id: <09870.122110811042200447@us-mta-38.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue,  8 Nov 2022 16:04:23 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: xfs test generic/375 fails
 when using file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The XFS test generic/375 only fails when using file handles. To reproduce the error just run (in the guest):

```
# mount -t virtiofs myfs /mnt
# cd /mnt
# touch testfile
# chown 100.100 testfile
# chmod 2755 testfile
# runas -u 100 -g 101 -- setfacl -m u::rwx,g::rwx,o::rwx testfile
setfacl: tesfile: Operation not permited
```
(runas is part of the xfs test suite)

virtiofsd has `CAP_DAC_READ_SEARCH` but (before calling setxattr) `open_by_handle_at()` returns `EPERM` anyway:

```rust
// passthrough/mod.rs
fn setxattr (..) {
  let file = self.open_inode(...) {
    data.open_file(...)
          // calls
          // passthrough/inode_store.rs
          FileOrHandle::Handle(h) => {
            let new_file = h.open(flags)?;
                              // calls
                              // passthrough/file_handle.rs
                              fn do_open(&self, mount_fd: &impl AsRawFd, flags: libc::c_int) -> io::Result<File> {
                                let ret = unsafe { open_by_handle_at(mount_fd.as_raw_fd(), &self.handle.handle, flags) };
                                                                   ^--- this returns EPERM
```
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/56

