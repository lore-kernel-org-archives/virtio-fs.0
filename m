Date: Mon, 14 Feb 2022 02:53:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=9LmaaXDwhFJu8GF97co3mYJVRZEAYfPwCRdjUDCFcBs=; b=X
	gGW2lp0DIbeDQhbS8EZfJlT5hYU7BOQtT+ZIfFdo26tcDTgbIqYwVA5lwFuyKQy6
	wK2GKe+XqTGhPIFncAThpxt6j4y59xisB6LmqfZ3qgZOEcoTUd35fu6PrRYSO6gp
	55kU2Osvh4EwM6yTufDay6sQ7mFNbF3VJPWF8xsi9NrIB51GU8g4vZKESFpAMkCH
	H8/AcpGOQUblbN1GfCUc9Kz7rbzTMRJmvApHwxfbTathcmJ9CDNiQYZiF0rqWUq2
	OoIej7URTCOBBB8IP8i3SzBOeud5JhuEpcSQM4Oz0sf3p9O4BsRLR1AXl4dRwLj/
	UJu/HWmpCGi+weOVK9OuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=9LmaaXDwhFJu8GF97co3mYJVRZEAY
	fPwCRdjUDCFcBs=; b=S/9SgCbh7ymamwDmJ3Wc4JdaQ6qaTh4PNhd6BJoOpCZ8L
	DgQRn8vcMQurej1k09mhLDTKjyZJfA6jFD7FZ0WGQx4x25eU6nltGWDN7VkYip5+
	/dMvEsW0owMXDQtm5xTEgFPtTg4kPGrm7WdLEuRVnweGLUdzYHGDRs/lciEHxlqc
	Wy2sY2dDNbyOqoh71vvf0usXms47rTwqbx6I54zAlFrH6NcK8LYXXxHD1Ngc3+lz
	+sokWWaAE8WxUEuEI/EPSeBNKrVHjCFdlP+4c2FCmLZKhfChOlAjtkEZMrFywXFn
	Sy+iw+fLhUJNFGCBHfIpFXoeRvE1g1deaPvQ8i4wg==
From: virtiofs-bot@sinrega.org
Message-Id: <97691.122021402531500117@us-mta-367.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Support using `musl` libc.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
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

