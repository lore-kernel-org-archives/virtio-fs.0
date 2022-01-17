Date: Mon, 17 Jan 2022 08:23:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=dPOWouEkgUn4pisK/FpgVfg4ngycjGfFHXca/
	ndrI+E=; b=uRkqpAwKQVrti4B4VzD+vRzK6WD0sVhsPbS9jiWP6j+I12z+H5HM7
	r8lM5s4dUoDCt7sSaSpXCXanfV9Z4Pwr+OCIVmfegRyDUL7tdbMf1scuZR2qA4/P
	4McdjAGKDgQZtxuay7EHIGLeRcPtLdKeLDOH30X0Q5XCx8sOc0enjlTdIPSWEiCa
	ZP4U5d8A5uQh2mB9acmo7+wbOQ1valPDf41AOmIc5shshHW2nWIpuAbDvcbbxIRB
	wNH+vr9xFQW/v33A4Lm62MgHfO20EhTSavIErEKH0q7eFPfurUQP2mAwOJiUVLZZ
	3CJ5foIcD3To4fnz2ACXNFDW+TMa2TeoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dPOWouEkgUn4pisK/
	FpgVfg4ngycjGfFHXca/ndrI+E=; b=W/DNnKUzTSlg52uvwLt+C6GaoNCUJITrp
	6X3K39QstTfnxLa73+JpGuTJouUq2SW7sWybOCvNyCx8MZy99JoKO8fCBgnEhXbJ
	Oo+ANJ805fMslukH4ZZFj2gtrrpTqv5mD6FGMrkukRQJ+oaeyrjXfJm54iO4jteT
	2fus0BiuubTDJxKfKhKqXcTRuugdjg4+cLHeCqeO1OL2tQnyXYn6uiU5taV+A2Ul
	nNMwycRnpWeSI448m1hB1Q7WWJNrdbz9yJ05Qp1EUJJXe+YbmmbhLv+9yN2xo3X3
	M/ySQI5w781uQWXscECZs+x89juzXWgCm0ZtL1Gds4aEQ51s/jeVg==
From: virtiofs-bot@sinrega.org
Message-Id: <35693.122011708231000409@us-mta-439.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: FUSE_CREATE can fail with
	ENOENT (No such file or directory)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

!38 introduced a race condition in `<PassthroughFs as FileSystem>::create()`.

The new code first calls `libc::openat()` with `O_CREAT|O_EXCL`. If the file already exists, then it's opened using a subsequent call to `libc::openat()` (in `do_open()`) without those flags. But if the file was removed between those two calls, then the latter fails with `ENOENT (No such file or directory)`.

**How to reproduce**

It's easier to reproduce by adding a sleep call between the too `libc::openat()` calls.
Furthermore, in my case (Fedora 35 guest), e.g. when running `touch` from the guest, it only sends `FUSE_CREATE` if the file doesn't already exist.
Therefore, we also need to add a sleep before the first `libc::openat()` call, to make it easier to reproduce.
To do this, apply the following patch to `virtiofsd` (applicable on top of https://gitlab.com/virtio-fs/virtiofsd/-/commit/36383911e7039996f19e130815ae36035e4636f3):

```diff
diff --git a/src/passthrough/mod.rs b/src/passthrough/mod.rs
index ce766ba..0fdef22 100644
--- a/src/passthrough/mod.rs
+++ b/src/passthrough/mod.rs
@@ -20,13 +20,13 @@ use std::borrow::Cow;
 use std::collections::{btree_map, BTreeMap};
 use std::ffi::{CStr, CString};
 use std::fs::File;
-use std::io;
 use std::mem::MaybeUninit;
 use std::os::unix::io::{AsRawFd, FromRawFd, RawFd};
 use std::str::FromStr;
 use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
 use std::sync::{Arc, RwLock};
 use std::time::Duration;
+use std::{io, thread, time};
 use xattrmap::{AppliedRule, XattrMap};
 
 const EMPTY_CSTR: &[u8] = b"\0";
@@ -1232,6 +1232,8 @@ impl FileSystem for PassthroughFs {
 
         let parent_file = data.get_file()?;
 
+        thread::sleep(time::Duration::from_millis(500));
+
         let fd = {
             let (_uid, _gid) = set_creds(ctx.uid, ctx.gid)?;
 
@@ -1267,6 +1269,8 @@ impl FileSystem for PassthroughFs {
                 _ => return Err(last_error),
             }
 
+            thread::sleep(time::Duration::from_millis(500));
+
             let entry = self.do_lookup(parent, name)?;
             let (handle, _) = self.do_open(entry.inode, kill_priv, flags)?;
             let handle = handle.ok_or_else(ebadf)?;
diff --git a/src/seccomp.rs b/src/seccomp.rs
index 89eca14..7d9b76e 100644
--- a/src/seccomp.rs
+++ b/src/seccomp.rs
@@ -65,6 +65,7 @@ pub fn enable_seccomp(action: SeccompAction) -> Result<(), Error> {
     allow_syscall!(ctx, libc::SYS_capget); // For CAP_FSETID
     allow_syscall!(ctx, libc::SYS_capset);
     allow_syscall!(ctx, libc::SYS_clock_gettime);
+    allow_syscall!(ctx, libc::SYS_clock_nanosleep);
     allow_syscall!(ctx, libc::SYS_clone);
     allow_syscall!(ctx, libc::SYS_clone3);
     allow_syscall!(ctx, libc::SYS_close);
```

On the host, run the following sh command where `test/shared` is the path to the shared directory:

```shell
while true; do
  touch test/shared/test
  sleep 0.5
  rm test/shared/test
  sleep 0.5
done
```

On the guest, mount the shared directory on `/mnt`.
This is typically done via

```
sudo mount -t virtiofs host /mnt
```

or the like.
Then run `touch /mnt/test` a few times until you see the error:

```
$ touch /mnt/test
touch: cannot touch '/mnt/test': No such file or directory
```

**strace**

Here's the relevant part of the output of `virtiofsd` run with `strace -f`:

```
[pid 984595] write(2, "\33[0m\33[38;5;8m[\33[0m2022-01-17T12:"..., 98[2022-01-17T12:56:57Z DEBUG virtiofsd] QUEUE_EVENT
) = 98
[pid 984595] write(2, "\33[0m\33[38;5;8m[\33[0m2022-01-17T12:"..., 115[2022-01-17T12:56:57Z DEBUG virtiofsd::server] Received request: 35
) = 115
[pid 984595] clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=500000000}, 0x7efd4cf00d00) = 0
[pid 984595] setresgid(-1, 1001, -1)    = 0
[pid 984595] setresuid(-1, 1000, -1)    = 0
[pid 984595] openat(11, "test", O_WRONLY|O_CREAT|O_EXCL|O_NONBLOCK|O_LARGEFILE|O_NOFOLLOW|O_CLOEXEC, 0100644) = -1 EEXIST (File exists)
[pid 984595] setresgid(-1, 0, -1)       = 0
[pid 984595] setresuid(-1, 0, -1)       = 0
[pid 984595] clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=500000000}, 0x7efd4cf00d00) = 0
[pid 984595] openat(11, "test", O_RDONLY|O_NOFOLLOW|O_CLOEXEC|O_PATH) = -1 ENOENT (No such file or directory)
[pid 984595] write(2, "\33[0m\33[38;5;8m[\33[0m2022-01-17T12:"..., 164[2022-01-17T12:56:58Z DEBUG virtiofsd::server] Replying ERROR, header: OutHeader { len: 16, error: -2, unique: 128 }
) = 164
```
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/22

