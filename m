Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=9LmaaXDwhFJu8GF97co3mYJVRZEAYfPwCRdjUDCFcBs=; b=B
 i+upkht8yaUWkAVAy41kGikOungUIwDQ1WLSJS9kV00fhAwTkLx6FhiZW5K5GhmN
 0u+4ssvE59GdtHTIcjcw97rgGuIjDHTJeob7IO/oq5OKyEZqeenNoPA6IzBWLvIT
 mU2bOBy2FFhhaXiT86AcZUiIGObxbAdcOY6/6KxvpjGops2gJtUmhryNKIiDJKPn
 fYlnGBHeP8ipyUClDZqcwKOXqhxM39IelbAEOEMyw6BxXiBdI/gdztAQ4/gXSrzY
 Lynrh01feKQSzlDzu/Boc9GPm4iIXGoSf60Z7LTXw2v5EUVFFX4waiBfLgG3dgmp
 pMqR2UVheZA9eMUzeT/dQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=9LmaaXDwhFJu8GF97co3mYJVRZEAY
 fPwCRdjUDCFcBs=; b=ZnqoxEZBk3ExZTFGnkwNPSYue/6hYE4xVoydAaSmU+a7V
 fFqA0BsscVY1My61gje7eFmYZB0L6Z1T9rBWgMIz6fzGFLYt8d/PTl3p5kypd08w
 L8qu/XWv6mSvhsqovGK8IgAyxC+I29oOTOpeqWE3+iav/ncgS4OfaO0GZU1mrX1K
 5sBNzxLKwiZEZm8glSCXRpuwU60BxOR4kAMOmeVpyGwdAln/pgKtlogNF0/bNWI6
 0E3OqOVL+lvKVQuKiiM0upge1YuLvolTIG7C0WbQmpoimOlyxgdFpp4kceMtVD9k
 3I7Zuie/o5nXCfaq6CJ2aAAdjSP0k3Bf6DBxPJcFw==
From: virtiofs-bot@sinrega.org
Message-Id: <47147.122032111552201687@us-mta-355.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 21 Mar 2022 15:55:25 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Support using `musl` libc.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When trying to build virtiofsd using `musl` libc we get the following errors:
```
$ cargo build --release --target x86_64-unknown-linux-musl
...
   Compiling virtiofsd v1.1.0 (/home/ffidenci/src/upstream/virtiofsd-rs)
error[E0412]: cannot find type `statx` in crate `libc`
   --> src/passthrough/stat.rs:58:32
    |
58  |   impl SafeStatXAccess for libc::statx {
    |                                  ^^^^^ help: a struct with a similar name exists: `stat`
    |
   ::: /home/ffidenci/.cargo/registry/src/github.com-1ecc6299db9ec823/libc-0.2.112/src/unix/linux_like/linux/musl/b64/x86_64/mod.rs:8:1
    |
8   | / s! {
9   | |     pub struct stat {
10  | |         pub st_dev: ::dev_t,
11  | |         pub st_ino: ::ino_t,
...   |
121 | |     }
122 | | }
    | |_- similarly named struct `stat` defined here

error[E0425]: cannot find value `STATX_BASIC_STATS` in crate `libc`
  --> src/passthrough/stat.rs:65:34
   |
65 |         if self.stx_mask & libc::STATX_BASIC_STATS != 0 {
   |                                  ^^^^^^^^^^^^^^^^^ not found in `libc`

error[E0425]: cannot find value `STATX_MNT_ID` in crate `libc`
   --> src/passthrough/stat.rs:100:34
    |
100 |         if self.stx_mask & libc::STATX_MNT_ID != 0 {
    |                                  ^^^^^^^^^^^^ not found in `libc`

error[E0412]: cannot find type `statx` in crate `libc`
   --> src/passthrough/stat.rs:121:26
    |
121 |       statxbuf: *mut libc::statx,
    |                            ^^^^^ help: a struct with a similar name exists: `stat`
    |
   ::: /home/ffidenci/.cargo/registry/src/github.com-1ecc6299db9ec823/libc-0.2.112/src/unix/linux_like/linux/musl/b64/x86_64/mod.rs:8:1
    |
8   | / s! {
9   | |     pub struct stat {
10  | |         pub st_dev: ::dev_t,
11  | |         pub st_ino: ::ino_t,
...   |
121 | |     }
122 | | }
    | |_- similarly named struct `stat` defined here

error[E0412]: cannot find type `statx` in crate `libc`
   --> src/passthrough/stat.rs:129:42
    |
129 |       let mut stx_ui = MaybeUninit::<libc::statx>::zeroed();
    |                                            ^^^^^ help: a struct with a similar name exists: `stat`
    |
   ::: /home/ffidenci/.cargo/registry/src/github.com-1ecc6299db9ec823/libc-0.2.112/src/unix/linux_like/linux/musl/b64/x86_64/mod.rs:8:1
    |
8   | / s! {
9   | |     pub struct stat {
10  | |         pub st_dev: ::dev_t,
11  | |         pub st_ino: ::ino_t,
...   |
121 | |     }
122 | | }
    | |_- similarly named struct `stat` defined here

error[E0425]: cannot find value `STATX_BASIC_STATS` in crate `libc`
   --> src/passthrough/stat.rs:141:19
    |
141 |             libc::STATX_BASIC_STATS | libc::STATX_MNT_ID,
    |                   ^^^^^^^^^^^^^^^^^ not found in `libc`

error[E0425]: cannot find value `STATX_MNT_ID` in crate `libc`
   --> src/passthrough/stat.rs:141:45
    |
141 |             libc::STATX_BASIC_STATS | libc::STATX_MNT_ID,
    |                                             ^^^^^^^^^^^^ not found in `libc`

```

Those happen as libc:statx doesn't seem to be supported when using musl, at least not yet.
Building it with `musl` could as simple as guarding the right functions, as shown below:
```
diff --git a/src/passthrough/stat.rs b/src/passthrough/stat.rs
index 2e2705c..8340739 100644
--- a/src/passthrough/stat.rs
+++ b/src/passthrough/stat.rs
@@ -55,6 +55,7 @@ trait SafeStatXAccess {
     fn mount_id(&self) -> Option<u64>;
 }
 
+#[cfg(all(target_os = "linux", any(target_env = "gnu")))]
 impl SafeStatXAccess for libc::statx {
     fn stat64(&self) -> Option<libc::stat64> {
         fn makedev(maj: libc::c_uint, min: libc::c_uint) -> libc::dev_t {
@@ -107,7 +108,7 @@ impl SafeStatXAccess for libc::statx {
 
 // Only works on Linux, and libc::SYS_statx is only defined for these
 // environments
-#[cfg(all(target_os = "linux", any(target_env = "gnu", target_env = "musl")))]
+#[cfg(all(target_os = "linux", any(target_env = "gnu")))]
 /// Performs a statx() syscall.  libc provides libc::statx() that does
 /// the same, however, the system's libc may not have a statx() wrapper
 /// (e.g. glibc before 2.28), so linking to it may fail.
@@ -124,7 +125,7 @@ unsafe fn do_statx(
 }
 
 // Real statx() that depends on do_statx()
-#[cfg(all(target_os = "linux", any(target_env = "gnu", target_env = "musl")))]
+#[cfg(all(target_os = "linux", any(target_env = "gnu")))]
 pub fn statx(dir: &impl AsRawFd, path: Option<&CStr>) -> io::Result<StatExt> {
     let mut stx_ui = MaybeUninit::<libc::statx>::zeroed();
 
@@ -159,7 +160,7 @@ pub fn statx(dir: &impl AsRawFd, path: Option<&CStr>) -> io::Result<StatExt> {
 }
 
 // Fallback for when do_statx() is not available
-#[cfg(not(all(target_os = "linux", any(target_env = "gnu", target_env = "musl"))))]
+#[cfg(not(all(target_os = "linux", any(target_env = "gnu"))))]
 pub fn statx(_dir: &impl AsRawFd, _path: Option<&CStr>) -> io::Result<StatExt> {
     Err(io::Error::from_raw_os_error(libc::ENOSYS))
 }
-- 
2.35.1
```

Although the simple patch above allows **building** using `musl` libc, when trying to spawn a VM using the patched daemon I get:
```
Failed to create pod sandbox: rpc error: code = Unknown desc = CreateContainer failed: error: 500  reason: VmBoot(VmBoot(DeviceManager(CreateVirtioFs(VhostUserGetFeatures(VhostUserProtocol(SocketBroken(Os { code: 104, kind: ConnectionReset, message: "Connection reset by peer" }))))))): unknown
```
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/27

