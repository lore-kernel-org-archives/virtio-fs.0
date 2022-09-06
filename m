Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1662478381; x=1662564781; bh=O9X0etpPKyumczpKxHWQ3
 GD6E4uPOAMhyXVtn4mpJEw=; b=TfsFjnsFccZzkK0bS+PEfTNm/GqvZF7ZUOppM
 E8Cv4QxJgSALInZrlZOLArA8+fbFscsRF5TFGia9uV1IELfA2Ms4XRTDulKMpWzf
 nb/lhzhpOqNJY1H4JjV1PiTkPdLGUT2GiGYF/NLyM4/m7hxLmkhn8relQqm1c6u2
 orufnfngXGb+DFOUxZHbQaKvvJjB30tIEmUT5aUiuP+9iiDOGtjQuD4Wvj+dgRqw
 kA5zE/9rncGt6Xy2iu78gTCMQWcFbgoly897zS0azM4DxjMhZJTOGPeHRTgkTgQj
 q1vFcsynVEjQkJ2/MPQWKo4kP6DawCSBiOm3ZI31jB/b7YuBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1662478381; x=1662564781; bh=O9X0etpPKyumczpKxHWQ3GD6E4uPOAMhyXV
 tn4mpJEw=; b=UwWnWd7Z2es+kKx83E9Us2eoalnIs9JAN1myW3ejbjnzwjOaAkJ
 s7aOA7c2uULmhIB523nH3j/wggiqdt8jFajwiHUn9jf1udw0C9oGiqFd2kPwIMaO
 fpZUEpE+v3jVlttenILUzRa8Acl9pO7hm4pD/uA7VpIG+8xDmW8xROplPlS8O99L
 FCH9HyyNmttLZtxjFh84JhT8JJSyGkyy7EBgdM5PNzuEkx74WskvSnBfm1OnmI+i
 EIpB5IdExghCdrgwEhWMt4Mm2HEfEpYW027OasAkQZhxxD0QKTDO7HDVAQxwnJkh
 X0IjAlDSDvGGYzpYHE2bMQjT2de0C4edzRg==
From: virtiofs-bot@sinrega.org
Message-Id: <89147.122090611330300221@us-mta-315.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue,  6 Sep 2022 15:33:06 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: xfs test generic/375 fails
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

