DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=4TLFTDWcRr6HtVvMDUMwQ
	Zb9iR6wInp0qmdK7g63J6c=; b=JQIOuJhbUBpydri91b+V3TcXgNli4N6ZrDZMG
	aEpNfUefozys9xIZ7jbmD0+6GyxvfTWomjh/+0MLVFJvN/TjnN44DG6BKDj7DicI
	G5b8w46M5AuUIQkmw2ksGUWeA8jxXwmVKcz/Arkx8jWN6MpIxWfwABZRj4Gdtb63
	eof72qhTC2LbYWfnwgiA/Fo5Cf+6FgFXll78k7frM95DLwPzGNN0BLpy/WCdcdnT
	ygKJl9L+ow1eCoMz8LYHlLBZcGLh3i4mlftzzsDO7A1GYue85oeQu8fc+QbH/jPs
	j/Z8mxD2aaeFUyEsEC6OXu4qxWUoWdGAaHZMxuG/D9yeKVQ2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=4TLFTDWcRr6HtVvMDUMwQZb9iR6wInp0qmdK7g63J6c=; b=n721ky1D
	OdNq0mpRcjIqre1W48ZN2kYB28SzjJGNZ7DEL05mEtLGOGyZFVOEfiit9cFtUtAL
	z2UtHMkOS+Tpu1m7KG8Pxc9bUhtvdVS6MIxoQ6q6LVGVLj4M/ObBny5s/tAOs0VY
	z+cUKeWSOyjvEMLoDF5ZTCJ67SglT38G3fXFcQSV/DKydm7OpjnA/LEi1ZAKQ+/H
	4yM4NVgC/p0qw44lZO7OT3t3WR8SjQL2kWA9PL4gEt3P4r0TiINZXMbvzlCLm6YV
	bTnXy+tSz/oBl/KVauV8pkJJxKT5QpLlv5f8r16yARmlxTQBoJjKXpKb2pig4Bx0
	3pOwo9FJLb98+A==
Message-Id: <20210421092455.E6B65240066@mailuser.nyi.internal>
Date: Wed, 21 Apr 2021 05:24:55 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue opened: build: Cargo fails to
	build the project based on Ubuntu 18.04 environment
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

I'm getting the following error when trying to build virtiofsd-rs on Ubuntu 18.04:
```
error: linking with `cc` failed: exit code: 1
  |
  = note: "cc" "-Wl,--as-needed" "-Wl,-z,noexecstack" "-m64"
"-Wl,--eh-frame-hdr" "-L"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.0.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.1.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.10.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.11.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.12.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.13.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.14.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.15.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.2.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.3.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.4.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.5.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.6.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.7.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.8.rcgu.o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.virtiofsd_rs.5vwbdaed-cgu.9.rcgu.o"
"-o"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1"
"/root/workloads/virtiofsd_rs_build/target/release/deps/virtiofsd_rs-ae99b236cad712d1.23nu4c2xym2eqlov.rcgu.o"
"-Wl,--gc-sections" "-pie" "-Wl,-zrelro" "-Wl,-znow" "-Wl,-O1"
"-nodefaultlibs" "-L"
"/root/workloads/virtiofsd_rs_build/target/release/deps" "-L"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib"
"-Wl,-Bstatic"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvirtiofsd_rs-db8a3339575369be.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libtempdir-f11ec1f478381911.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libremove_dir_all-a2db9479af3068ac.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/librand-aa16576ba5b9392c.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvhost_user_backend-3c7c4e0b648f2048.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libepoll-731ef9040489f5aa.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvm_virtio-0a4e924a77987334.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvm_memory-8e36d6dac6c201c8.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libarc_swap-e6322bdd9bbda381.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvirtio_bindings-f9a171ce7b13a7b5.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvhost-1c8ac54972853645.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvmm_sys_util-d9c56c4a2b27552c.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libseccomp-9888cb76b4b89f98.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/liblog-26151b12ef260e13.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libcfg_if-0b1d0733c6ac953a.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures-cc61a9fd7f8900b0.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures_executor-1d41c3b8dcbe87de.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libnum_cpus-383326fa85306546.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures_util-dd34ea9b0be945a9.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libmemchr-63c5445cdbee0d67.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures_io-4c0f5af5d6d14f1e.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libslab-7c378fecdd145a1f.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures_channel-193b9d71b781f2ca.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libpin_project_lite-682d3321dc2bbe4a.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures_sink-77fc5a4244377a96.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures_task-c37495857747fe61.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libonce_cell-9bec28672c574ba9.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libpin_utils-772382b0bbe51e23.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libfutures_core-44fede59828ea2bf.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libclap-5276dbc49cf0a5cb.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libvec_map-7710e0aa1820f58b.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libtextwrap-5c146e6d5c5b1b6e.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libunicode_width-b8b37d5da2aa8f4a.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libterm_size-d106b04f81264f05.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libstrsim-be518b8b7cca0422.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libbitflags-5624065210ca120e.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libatty-f0ca163b1176c05c.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/liblibc-5b3ef7634a8413c7.rlib"
"/root/workloads/virtiofsd_rs_build/target/release/deps/libansi_term-8403b5b7bcdb97e5.rlib"
"-Wl,--start-group"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libstd-b1047a2788193be4.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libpanic_unwind-e8e399e2092f3b2a.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libminiz_oxide-c6b02b522c91c060.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libadler-eaad965909c4200f.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libobject-dca728ac8ed54d87.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libaddr2line-4b4efaa8c4601753.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libgimli-d36e07ed2cc56ee4.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/librustc_demangle-3855d04b1bb40ceb.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libhashbrown-58a065cdff5508a2.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/librustc_std_workspace_alloc-82aeeedcc8d1450a.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libunwind-5c4d6c9d7595f844.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libcfg_if-2642d2bccc00517a.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/liblibc-760e48b3f782e7f5.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/liballoc-d4ef8bf89076ed01.rlib"
"/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux
 -gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/librustc_std_workspace_core-36070e2029bb21ea.rlib" "/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libcore-3aaf8f932781f33e.rlib" "-Wl,--end-group" "/usr/local/rust/toolchains/1.51.0-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libcompiler_builtins-e2523c360f03ba10.rlib" "-Wl,-Bdynamic" "-lgcc_s" "-lutil" "-lrt" "-lpthread" "-lm" "-ldl" "-lc"
  = note: /root/workloads/virtiofsd_rs_build/target/release/deps/libvirtiofsd_rs-db8a3339575369be.rlib(virtiofsd_rs-db8a3339575369be.virtiofsd_rs.f1lp7avh-cgu.2.rcgu.o): In function `virtiofsd_rs::passthrough::PassthroughFs::new':
          virtiofsd_rs.f1lp7avh-cgu.2:(.text._ZN12virtiofsd_rs11passthrough13PassthroughFs3new17h2c0f6b174348215dE+0xf9): undefined reference to `statx'
          /root/workloads/virtiofsd_rs_build/target/release/deps/libvirtiofsd_rs-db8a3339575369be.rlib(virtiofsd_rs-db8a3339575369be.virtiofsd_rs.f1lp7avh-cgu.2.rcgu.o): In function `virtiofsd_rs::passthrough::PassthroughFs::do_lookup':
          virtiofsd_rs.f1lp7avh-cgu.2:(.text._ZN12virtiofsd_rs11passthrough13PassthroughFs9do_lookup17hc8ba433e9e8847ffE+0x223): undefined reference to `statx'
          /root/workloads/virtiofsd_rs_build/target/release/deps/libvirtiofsd_rs-db8a3339575369be.rlib(virtiofsd_rs-db8a3339575369be.virtiofsd_rs.f1lp7avh-cgu.2.rcgu.o): In function `virtiofsd_rs::passthrough::PassthroughFs::do_getattr':
          virtiofsd_rs.f1lp7avh-cgu.2:(.text._ZN12virtiofsd_rs11passthrough13PassthroughFs10do_getattr17h20a69500901cdbebE+0x1de): undefined reference to `statx'
          /root/workloads/virtiofsd_rs_build/target/release/deps/libvirtiofsd_rs-db8a3339575369be.rlib(virtiofsd_rs-db8a3339575369be.virtiofsd_rs.f1lp7avh-cgu.2.rcgu.o): In function `<virtiofsd_rs::passthrough::PassthroughFs as virtiofsd_rs::filesystem::FileSystem>::init':
          virtiofsd_rs.f1lp7avh-cgu.2:(.text._ZN97_$LT$virtiofsd_rs..passthrough..PassthroughFs$u20$as$u20$virtiofsd_rs..filesystem..FileSystem$GT$4init17h1458bbcbdcf78211E+0x148): undefined reference to `statx'
          /root/workloads/virtiofsd_rs_build/target/release/deps/libvirtiofsd_rs-db8a3339575369be.rlib(virtiofsd_rs-db8a3339575369be.virtiofsd_rs.f1lp7avh-cgu.2.rcgu.o): In function `<virtiofsd_rs::passthrough::PassthroughFs as virtiofsd_rs::filesystem::FileSystem>::access':
          virtiofsd_rs.f1lp7avh-cgu.2:(.text._ZN97_$LT$virtiofsd_rs..passthrough..PassthroughFs$u20$as$u20$virtiofsd_rs..filesystem..FileSystem$GT$6access17h29a0480f57392834E+0x1ee): undefined reference to `statx'
          collect2: error: ld returned 1 exit status
          

error: aborting due to previous error

error: could not compile `virtiofsd-rs`
```

It seems the code expects statx() to be present, but that's not the case with Bionic Beaver.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/12

