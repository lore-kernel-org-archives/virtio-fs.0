Resent-Message-Id: <202006191807.05JI7JH3010189@lists01.pubmisc.prod.ext.phx2.redhat.com>
Message-ID: <159258912098.3204.6213663823948036933@d1fd068a5071>
In-Reply-To: <20200619171809.30984-1-dgilbert@redhat.com>
MIME-Version: 1.0
From: no-reply@patchew.org
Date: Fri, 19 Jun 2020 10:52:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Allow capability restriction to
	be turned off
Reply-To: qemu-devel@nongnu.org
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: dgilbert@redhat.com
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

Patchew URL: https://patchew.org/QEMU/20200619171809.30984-1-dgilbert@redhat.com/



Hi,

This series failed the asan build test. Please find the testing commands and
their output below. If you have Docker installed, you can probably reproduce it
locally.

=== TEST SCRIPT BEGIN ===
#!/bin/bash
export ARCH=x86_64
make docker-image-fedora V=1 NETWORK=1
time make docker-test-debug@fedora TARGET_LIST=x86_64-softmmu J=14 NETWORK=1
=== TEST SCRIPT END ===

  GEN     docs/interop/qemu-qmp-ref.txt
  GEN     docs/interop/qemu-qmp-ref.7
  CC      qga/commands.o
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  CC      qga/guest-agent-command-state.o
  CC      qga/main.o
  CC      qga/commands-posix.o
---
  GEN     docs/interop/qemu-ga-ref.html
  GEN     docs/interop/qemu-ga-ref.txt
  GEN     docs/interop/qemu-ga-ref.7
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  LINK    qemu-keymap
  LINK    ivshmem-client
  LINK    ivshmem-server
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  AS      pc-bios/optionrom/multiboot.o
  AS      pc-bios/optionrom/linuxboot.o
  CC      pc-bios/optionrom/linuxboot_dma.o
  AS      pc-bios/optionrom/kvmvapic.o
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  LINK    qemu-nbd
  LINK    qemu-storage-daemon
  AS      pc-bios/optionrom/pvh.o
  LINK    qemu-img
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  LINK    qemu-io
  CC      pc-bios/optionrom/pvh_main.o
  BUILD   pc-bios/optionrom/multiboot.img
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  BUILD   pc-bios/optionrom/linuxboot.img
  BUILD   pc-bios/optionrom/kvmvapic.img
  LINK    qemu-edid
  BUILD   pc-bios/optionrom/multiboot.raw
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  BUILD   pc-bios/optionrom/linuxboot.raw
  BUILD   pc-bios/optionrom/kvmvapic.raw
  SIGN    pc-bios/optionrom/multiboot.bin
  LINK    fsdev/virtfs-proxy-helper
  SIGN    pc-bios/optionrom/linuxboot.bin
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  BUILD   pc-bios/optionrom/linuxboot_dma.img
  SIGN    pc-bios/optionrom/kvmvapic.bin
  BUILD   pc-bios/optionrom/pvh.img
---
  SIGN    pc-bios/optionrom/linuxboot_dma.bin
  SIGN    pc-bios/optionrom/pvh.bin
  LINK    scsi/qemu-pr-helper
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  LINK    qemu-bridge-helper
  LINK    virtiofsd
  LINK    vhost-user-input
  LINK    qemu-ga
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o)/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `: warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
  GEN     x86_64-softmmu/hmp-commands-info.h
  GEN     x86_64-softmmu/hmp-commands.h
  GEN     x86_64-softmmu/config-devices.h
---
  CC      x86_64-softmmu/gdbstub-xml.o
  CC      x86_64-softmmu/trace/generated-helpers.o
  LINK    x86_64-softmmu/qemu-system-x86_64
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
common.rc: line 50: test: check: binary operator expected
(printf '#define QEMU_PKGVERSION ""\n'; printf '#define QEMU_FULL_VERSION "5.0.50"\n'; ) > qemu-version.h.tmp
make -C /tmp/qemu-test/src/slirp BUILD_DIR="/tmp/qemu-test/build/slirp" PKG_CONFIG="pkg-config" CC="clang" AR="ar"      LD="ld" RANLIB="ranlib" CFLAGS="-I/usr/include/pixman-1   -Werror -fsanitize=undefined -fsanitize=address  -pthread -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include  -fPIE -DPIE -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -std=gnu99  -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wno-initializer-overrides -Wno-missing-include-dirs -Wno-shift-negative-value -Wno-string-plus-int -Wno-typedef-redefinition -Wno-tautological-type-limit-compare -fstack-protector-strong   -I/usr/include/p11-kit-1   -DSTRUCT_IOVEC_DEFINED  -I/usr/include/libpng16  -I/usr/include/spice-1 -I/usr/include/spice-server -I/usr/include/cacard -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -I/usr/include/nss3 -I/usr/include/nspr4 -pthread -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/pixman-1   -I/tmp/qemu-test/src/tests -I/tmp/qemu-test/src/tests/qtest -g " LDFLAGS="-Wl,--warn-common -fsanitize=undefined -fsanitize=address -Wl,-z,relro -Wl,-z,now -pie -m64  -fstack-protector-strong"
---
clang -iquote /tmp/qemu-test/build/. -iquote . -iquote /tmp/qemu-test/src/tcg/i386 -isystem /tmp/qemu-test/src/linux-headers -isystem /tmp/qemu-test/build/linux-headers -iquote . -iquote /tmp/qemu-test/src -iquote /tmp/qemu-test/src/accel/tcg -iquote /tmp/qemu-test/src/include -iquote /tmp/qemu-test/src/disas/libvixl -I/tmp/qemu-test/src/tests/fp -I/tmp/qemu-test/src/tests/fp/berkeley-softfloat-3/source/include -I/tmp/qemu-test/src/tests/fp/berkeley-softfloat-3/source/8086-SSE -I/tmp/qemu-test/src/tests/fp/berkeley-testfloat-3/source -I/usr/include/pixman-1 -Werror -fsanitize=undefined -fsanitize=address -pthread -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -fPIE -DPIE -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -std=gnu99 -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wno-initializer-overrides -Wno-missing-include-dirs -Wno-shift-negative-value -Wno-string-plus-int -Wno-typedef-redefinition -Wno-tautological-type-limit-compare -fstack-protector-strong -I/usr/include/p11-kit-1 -DSTRUCT_IOVEC_DEFINED -I/usr/include/libpng16 -I/usr/include/spice-1 -I/usr/include/spice-server -I/usr/include/cacard -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -I/usr/include/nss3 -I/usr/include/nspr4 -pthread -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/pixman-1 -DHW_POISON_H -DTARGET_ARM  -DSOFTFLOAT_ROUND_ODD -DINLINE_LEVEL=5 -DSOFTFLOAT_FAST_DIV32TO16 -DSOFTFLOAT_FAST_DIV64TO32 -DSOFTFLOAT_FAST_INT64  -DFLOAT16 -DFLOAT64 -DEXTFLOAT80 -DFLOAT128 -DFLOAT_ROUND_ODD -DLONG_DOUBLE_IS_EXTFLOAT80 -MMD -MP -MT softfloat.o -MF ./softfloat.d -g   -c -o softfloat.o /tmp/qemu-test/src/fpu/softfloat.c
clang -iquote /tmp/qemu-test/build/tests/qtest -iquote tests/qtest -iquote /tmp/qemu-test/src/tcg/i386 -isystem /tmp/qemu-test/src/linux-headers -isystem /tmp/qemu-test/build/linux-headers -iquote . -iquote /tmp/qemu-test/src -iquote /tmp/qemu-test/src/accel/tcg -iquote /tmp/qemu-test/src/include -iquote /tmp/qemu-test/src/disas/libvixl -I/usr/include/pixman-1   -Werror -fsanitize=undefined -fsanitize=address  -pthread -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include  -fPIE -DPIE -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -std=gnu99  -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wno-initializer-overrides -Wno-missing-include-dirs -Wno-shift-negative-value -Wno-string-plus-int -Wno-typedef-redefinition -Wno-tautological-type-limit-compare -fstack-protector-strong   -I/usr/include/p11-kit-1   -DSTRUCT_IOVEC_DEFINED  -I/usr/include/libpng16  -I/usr/include/spice-1 -I/usr/include/spice-server -I/usr/include/cacard -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -I/usr/include/nss3 -I/usr/include/nspr4 -pthread -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/pixman-1   -I/tmp/qemu-test/src/tests -I/tmp/qemu-test/src/tests/qtest -MMD -MP -MT tests/qtest/ide-test.o -MF tests/qtest/ide-test.d -g   -c -o tests/qtest/ide-test.o /tmp/qemu-test/src/tests/qtest/ide-test.c
clang -iquote /tmp/qemu-test/build/tests/qtest/libqos -iquote tests/qtest/libqos -iquote /tmp/qemu-test/src/tcg/i386 -isystem /tmp/qemu-test/src/linux-headers -isystem /tmp/qemu-test/build/linux-headers -iquote . -iquote /tmp/qemu-test/src -iquote /tmp/qemu-test/src/accel/tcg -iquote /tmp/qemu-test/src/include -iquote /tmp/qemu-test/src/disas/libvixl -I/usr/include/pixman-1   -Werror -fsanitize=undefined -fsanitize=address  -pthread -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include  -fPIE -DPIE -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -std=gnu99  -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wno-initializer-overrides -Wno-missing-include-dirs -Wno-shift-negative-value -Wno-string-plus-int -Wno-typedef-redefinition -Wno-tautological-type-limit-compare -fstack-protector-strong   -I/usr/include/p11-kit-1   -DSTRUCT_IOVEC_DEFINED  -I/usr/include/libpng16  -I/usr/include/spice-1 -I/usr/include/spice-server -I/usr/include/cacard -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -I/usr/include/nss3 -I/usr/include/nspr4 -pthread -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/pixman-1   -I/tmp/qemu-test/src/tests -I/tmp/qemu-test/src/tests/qtest -MMD -MP -MT tests/qtest/libqos/pci.o -MF tests/qtest/libqos/pci.d -g   -c -o tests/qtest/libqos/pci.o /tmp/qemu-test/src/tests/qtest/libqos/pci.c
/tmp/qemu-test/src/tests/qht-bench.c:287:29: error: implicit conversion from 'unsigned long' to 'double' changes value from 18446744073709551615 to 18446744073709551616 [-Werror,-Wimplicit-int-float-conversion]
        *threshold = rate * UINT64_MAX;
                          ~ ^~~~~~~~~~
/usr/include/stdint.h:130:23: note: expanded from macro 'UINT64_MAX'
---
18446744073709551615UL
^~~~~~~~~~~~~~~~~~~~~~
1 error generated.
make: *** [/tmp/qemu-test/src/rules.mak:69: tests/qht-bench.o] Error 1
make: *** Waiting for unfinished jobs....
clang -iquote /tmp/qemu-test/build/. -iquote . -iquote /tmp/qemu-test/src/tcg/i386 -isystem /tmp/qemu-test/src/linux-headers -isystem /tmp/qemu-test/build/linux-headers -iquote . -iquote /tmp/qemu-test/src -iquote /tmp/qemu-test/src/accel/tcg -iquote /tmp/qemu-test/src/include -iquote /tmp/qemu-test/src/disas/libvixl -I/tmp/qemu-test/src/tests/fp -I/tmp/qemu-test/src/tests/fp/berkeley-softfloat-3/source/include -I/tmp/qemu-test/src/tests/fp/berkeley-softfloat-3/source/8086-SSE -I/tmp/qemu-test/src/tests/fp/berkeley-testfloat-3/source -I/usr/include/pixman-1 -Werror -fsanitize=undefined -fsanitize=address -pthread -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -fPIE -DPIE -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -std=gnu99 -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wno-initializer-overrides -Wno-missing-include-dirs -Wno-shift-negative-value -Wno-string-plus-int -Wno-typedef-redefinition -Wno-tautological-type-limit-compare -fstack-protector-strong -I/usr/include/p11-kit-1 -DSTRUCT_IOVEC_DEFINED -I/usr/include/libpng16 -I/usr/include/spice-1 -I/usr/include/spice-server -I/usr/include/cacard -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -I/usr/include/nss3 -I/usr/include/nspr4 -pthread -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/pixman-1 -DHW_POISON_H -DTARGET_ARM  -DSOFTFLOAT_ROUND_ODD -DINLINE_LEVEL=5 -DSOFTFLOAT_FAST_DIV32TO16 -DSOFTFLOAT_FAST_DIV64TO32 -DSOFTFLOAT_FAST_INT64  -DFLOAT16 -DFLOAT64 -DEXTFLOAT80 -DFLOAT128 -DFLOAT_ROUND_ODD -DLONG_DOUBLE_IS_EXTFLOAT80  -Wno-strict-prototypes -Wno-unknown-pragmas -Wno-uninitialized -Wno-missing-prototypes -Wno-return-type -Wno-unused-function -Wno-error -MMD -MP -MT uint128_inline.o -MF ./uint128_inline.d -g   -c -o uint128_inline.o /tmp/qemu-test/src/test
s/fp/berkeley-testfloat-3/source/uint128_inline.c
clang -iquote /tmp/qemu-test/build/. -iquote . -iquote /tmp/qemu-test/src/tcg/i386 -isystem /tmp/qemu-test/src/linux-headers -isystem /tmp/qemu-test/build/linux-headers -iquote . -iquote /tmp/qemu-test/src -iquote /tmp/qemu-test/src/accel/tcg -iquote /tmp/qemu-test/src/include -iquote /tmp/qemu-test/src/disas/libvixl -I/tmp/qemu-test/src/tests/fp -I/tmp/qemu-test/src/tests/fp/berkeley-softfloat-3/source/include -I/tmp/qemu-test/src/tests/fp/berkeley-softfloat-3/source/8086-SSE -I/tmp/qemu-test/src/tests/fp/berkeley-testfloat-3/source -I/usr/include/pixman-1 -Werror -fsanitize=undefined -fsanitize=address -pthread -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -fPIE -DPIE -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -std=gnu99 -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wno-initializer-overrides -Wno-missing-include-dirs -Wno-shift-negative-value -Wno-string-plus-int -Wno-typedef-redefinition -Wno-tautological-type-limit-compare -fstack-protector-strong -I/usr/include/p11-kit-1 -DSTRUCT_IOVEC_DEFINED -I/usr/include/libpng16 -I/usr/include/spice-1 -I/usr/include/spice-server -I/usr/include/cacard -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -I/usr/include/nss3 -I/usr/include/nspr4 -pthread -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/pixman-1 -DHW_POISON_H -DTARGET_ARM  -DSOFTFLOAT_ROUND_ODD -DINLINE_LEVEL=5 -DSOFTFLOAT_FAST_DIV32TO16 -DSOFTFLOAT_FAST_DIV64TO32 -DSOFTFLOAT_FAST_INT64  -DFLOAT16 -DFLOAT64 -DEXTFLOAT80 -DFLOAT128 -DFLOAT_ROUND_ODD -DLONG_DOUBLE_IS_EXTFLOAT80  -Wno-strict-prototypes -Wno-unknown-pragmas -Wno-uninitialized -Wno-missing-prototypes -Wno-return-type -Wno-unused-function -Wno-error -MMD -MP -MT uint128.o -MF ./uint128.d -g   -c -o uint128.o /tmp/qemu-test/src/tests/fp/berkeley-testflo
at-3/source/uint128.c
---
rm -f libtestfloat.a && ar rcs libtestfloat.a uint128_inline.o uint128.o fail.o functions_common.o functionInfos.o standardFunctionInfos.o random.o genCases_common.o genCases_ui32.o genCases_ui64.o genCases_i32.o genCases_i64.o genCases_f16.o genCases_f32.o genCases_f64.o genCases_extF80.o genCases_f128.o genCases_writeTestsTotal.o verCases_inline.o verCases_common.o verCases_writeFunctionName.o readHex.o writeHex.o writeCase_a_ui32.o writeCase_a_ui64.o writeCase_a_f16.o writeCase_ab_f16.o writeCase_abc_f16.o writeCase_a_f32.o writeCase_ab_f32.o writeCase_abc_f32.o writeCase_a_f64.o writeCase_ab_f64.o writeCase_abc_f64.o writeCase_a_extF80M.o writeCase_ab_extF80M.o writeCase_a_f128M.o writeCase_ab_f128M.o writeCase_abc_f128M.o writeCase_z_bool.o writeCase_z_ui32.o writeCase_z_ui64.o writeCase_z_f16.o writeCase_z_f32.o writeCase_z_f64.o writeCase_z_extF80M.o writeCase_z_f128M.o testLoops_common.o test_a_ui32_z_f16.o test_a_ui32_z_f32.o test_a_ui32_z_f64.o test_a_ui32_z_extF80.o test_a_ui32_z_f128.o test_a_ui64_z_f16.o test_a_ui64_z_f32.o test_a_ui64_z_f64.o test_a_ui64_z_extF80.o test_a_ui64_z_f128.o test_a_i32_z_f16.o test_a_i32_z_f32.o test_a_i32_z_f64.o test_a_i32_z_extF80.o test_a_i32_z_f128.o test_a_i64_z_f16.o test_a_i64_z_f32.o test_a_i64_z_f64.o test_a_i64_z_extF80.o test_a_i64_z_f128.o test_a_f16_z_ui32_rx.o test_a_f16_z_ui64_rx.o test_a_f16_z_i32_rx.o test_a_f16_z_i64_rx.o test_a_f16_z_ui32_x.o test_a_f16_z_ui64_x.o test_a_f16_z_i32_x.o test_a_f16_z_i64_x.o test_a_f16_z_f32.o test_a_f16_z_f64.o test_a_f16_z_extF80.o test_a_f16_z_f128.o test_az_f16.o test_az_f16_rx.o test_abz_f16.o test_abcz_f16.o test_ab_f16_z_bool.o test_a_f32_z_ui32_rx.o test_a_f32_z_ui64_rx.o test_a_f32_z_i32_rx.o test_a_f32_z_i64_rx.o test_a_f32_z_ui32_x.o test_a_f32_z_ui64_x.o test_a_f32_z_i32_x.o test_a_f32_z_i64_x.o test_a_f32_z_f16.o test_a_f32_z_f64.o test_a_f32_z_extF80.o test_a_f32_z_f128.o test_az_f32.o test_az_f32_rx.o test_abz_f32.o test_abcz_f32.o test_ab_f32_z_bool.o test_a_f64_z_ui32_rx.o test_a_f64_z_ui64_rx.o test_a_f6
4_z_i32_rx.o test_a_f64_z_i64_rx.o test_a_f64_z_ui32_x.o test_a_f64_z_ui64_x.o test_a_f64_z_i32_x.o test_a_f64_z_i64_x.o test_a_f64_z_f16.o test_a_f64_z_f32.o test_a_f64_z_extF80.o test_a_f64_z_f128.o test_az_f64.o test_az_f64_rx.o test_abz_f64.o test_abcz_f64.o test_ab_f64_z_bool.o test_a_extF80_z_ui32_rx.o test_a_extF80_z_ui64_rx.o test_a_extF80_z_i32_rx.o test_a_extF80_z_i64_rx.o test_a_extF80_z_ui32_x.o test_a_extF80_z_ui64_x.o test_a_extF80_z_i32_x.o test_a_extF80_z_i64_x.o test_a_extF80_z_f16.o test_a_extF80_z_f32.o test_a_extF80_z_f64.o test_a_extF80_z_f128.o test_az_extF80.o test_az_extF80_rx.o test_abz_extF80.o test_ab_extF80_z_bool.o test_a_f128_z_ui32_rx.o test_a_f128_z_ui64_rx.o test_a_f128_z_i32_rx.o test_a_f128_z_i64_rx.o test_a_f128_z_ui32_x.o test_a_f128_z_ui64_x.o test_a_f128_z_i32_x.o test_a_f128_z_i64_x.o test_a_f128_z_f16.o test_a_f128_z_f32.o test_a_f128_z_f64.o test_a_f128_z_extF80.o test_az_f128.o test_az_f128_rx.o test_abz_f128.o test_abcz_f128.o test_ab_f128_z_bool.o
rm -f libsoftfloat.a && ar rcs libsoftfloat.a s_eq128.o s_le128.o s_lt128.o s_shortShiftLeft128.o s_shortShiftRight128.o s_shortShiftRightJam64.o s_shortShiftRightJam64Extra.o s_shortShiftRightJam128.o s_shortShiftRightJam128Extra.o s_shiftRightJam32.o s_shiftRightJam64.o s_shiftRightJam64Extra.o s_shiftRightJam128.o s_shiftRightJam128Extra.o s_shiftRightJam256M.o s_countLeadingZeros8.o s_countLeadingZeros16.o s_countLeadingZeros32.o s_countLeadingZeros64.o s_add128.o s_add256M.o s_sub128.o s_sub256M.o s_mul64ByShifted32To128.o s_mul64To128.o s_mul128By32.o s_mul128To256M.o s_approxRecip_1Ks.o s_approxRecip32_1.o s_approxRecipSqrt_1Ks.o s_approxRecipSqrt32_1.o s_roundToUI32.o s_roundToUI64.o s_roundToI32.o s_roundToI64.o s_normSubnormalF16Sig.o s_roundPackToF16.o s_normRoundPackToF16.o s_addMagsF16.o s_subMagsF16.o s_mulAddF16.o s_normSubnormalF32Sig.o s_roundPackToF32.o s_normRoundPackToF32.o s_addMagsF32.o s_subMagsF32.o s_mulAddF32.o s_normSubnormalF64Sig.o s_roundPackToF64.o s_normRoundPackToF64.o s_addMagsF64.o s_subMagsF64.o s_mulAddF64.o s_normSubnormalExtF80Sig.o s_roundPackToExtF80.o s_normRoundPackToExtF80.o s_addMagsExtF80.o s_subMagsExtF80.o s_normSubnormalF128Sig.o s_roundPackToF128.o s_normRoundPackToF128.o s_addMagsF128.o s_subMagsF128.o s_mulAddF128.o softfloat_state.o ui32_to_f16.o ui32_to_f32.o ui32_to_f64.o ui32_to_extF80.o ui32_to_extF80M.o ui32_to_f128.o ui32_to_f128M.o ui64_to_f16.o ui64_to_f32.o ui64_to_f64.o ui64_to_extF80.o ui64_to_extF80M.o ui64_to_f128.o ui64_to_f128M.o i32_to_f16.o i32_to_f32.o i32_to_f64.o i32_to_extF80.o i32_to_extF80M.o i32_to_f128.o i32_to_f128M.o i64_to_f16.o i64_to_f32.o i64_to_f64.o i64_to_extF80.o i64_to_extF80M.o i64_to_f128.o i64_to_f128M.o f16_to_ui32.o f16_to_ui64.o f16_to_i32.o f16_to_i64.o f16_to_ui32_r_minMag.o f16_to_ui64_r_minMag.o f16_to_i32_r_minMag.o f16_to_i64_r_minMag.o f16_to_f32.o f16_to_f64.o f16_to_extF80.o f16_to_extF80M.o f16_to_f128.o f16_to_f128M.o f16_roundToInt.o f16_add.o f16_sub.o f16_mul.o f16_mulAdd.o f16_div.o f16_rem.o f16_sqrt.o f
16_eq.o f16_le.o f16_lt.o f16_eq_signaling.o f16_le_quiet.o f16_lt_quiet.o f16_isSignalingNaN.o f32_to_ui32.o f32_to_ui64.o f32_to_i32.o f32_to_i64.o f32_to_ui32_r_minMag.o f32_to_ui64_r_minMag.o f32_to_i32_r_minMag.o f32_to_i64_r_minMag.o f32_to_f16.o f32_to_f64.o f32_to_extF80.o f32_to_extF80M.o f32_to_f128.o f32_to_f128M.o f32_roundToInt.o f32_add.o f32_sub.o f32_mul.o f32_mulAdd.o f32_div.o f32_rem.o f32_sqrt.o f32_eq.o f32_le.o f32_lt.o f32_eq_signaling.o f32_le_quiet.o f32_lt_quiet.o f32_isSignalingNaN.o f64_to_ui32.o f64_to_ui64.o f64_to_i32.o f64_to_i64.o f64_to_ui32_r_minMag.o f64_to_ui64_r_minMag.o f64_to_i32_r_minMag.o f64_to_i64_r_minMag.o f64_to_f16.o f64_to_f32.o f64_to_extF80.o f64_to_extF80M.o f64_to_f128.o f64_to_f128M.o f64_roundToInt.o f64_add.o f64_sub.o f64_mul.o f64_mulAdd.o f64_div.o f64_rem.o f64_sqrt.o f64_eq.o f64_le.o f64_lt.o f64_eq_signaling.o f64_le_quiet.o f64_lt_quiet.o f64_isSignalingNaN.o extF80_to_ui32.o extF80_to_ui64.o extF80_to_i32.o extF80_to_i64.o extF80_to_ui32_r_minMag.o extF80_to_ui64_r_minMag.o extF80_to_i32_r_minMag.o extF80_to_i64_r_minMag.o extF80_to_f16.o extF80_to_f32.o extF80_to_f64.o extF80_to_f128.o extF80_roundToInt.o extF80_add.o extF80_sub.o extF80_mul.o extF80_div.o extF80_rem.o extF80_sqrt.o extF80_eq.o extF80_le.o extF80_lt.o extF80_eq_signaling.o extF80_le_quiet.o extF80_lt_quiet.o extF80_isSignalingNaN.o extF80M_to_ui32.o extF80M_to_ui64.o extF80M_to_i32.o extF80M_to_i64.o extF80M_to_ui32_r_minMag.o extF80M_to_ui64_r_minMag.o extF80M_to_i32_r_minMag.o extF80M_to_i64_r_minMag.o extF80M_to_f16.o extF80M_to_f32.o extF80M_to_f64.o extF80M_to_f128M.o extF80M_roundToInt.o extF80M_add.o extF80M_sub.o extF80M_mul.o extF80M_div.o extF80M_rem.o extF80M_sqrt.o extF80M_eq.o extF80M_le.o extF80M_lt.o extF80M_eq_signaling.o extF80M_le_quiet.o extF80M_lt_quiet.o f128_to_ui32.o f128_to_ui64.o f128_to_i32.o f128_to_i64.o f128_to_ui32_r_minMag.o f128_to_ui64_r_minMag.o f128_to_i32_r_minMag.o f128_to_i64_r_minMag.o f128_to_f16.o f128_to_f32.o f128_to_extF80.o f128_to_f64.o
 f128_roundToInt.o f128_add.o f128_sub.o f128_mul.o f128_mulAdd.o f128_div.o f128_rem.o f128_sqrt.o f128_eq.o f128_le.o f128_lt.o f128_eq_signaling.o f128_le_quiet.o f128_lt_quiet.o f128_isSignalingNaN.o f128M_to_ui32.o f128M_to_ui64.o f128M_to_i32.o f128M_to_i64.o f128M_to_ui32_r_minMag.o f128M_to_ui64_r_minMag.o f128M_to_i32_r_minMag.o f128M_to_i64_r_minMag.o f128M_to_f16.o f128M_to_f32.o f128M_to_extF80M.o f128M_to_f64.o f128M_roundToInt.o f128M_add.o f128M_sub.o f128M_mul.o f128M_mulAdd.o f128M_div.o f128M_rem.o f128M_sqrt.o f128M_eq.o f128M_le.o f128M_lt.o f128M_eq_signaling.o f128M_le_quiet.o f128M_lt_quiet.o softfloat_raiseFlags.o s_f16UIToCommonNaN.o s_commonNaNToF16UI.o s_propagateNaNF16UI.o s_f32UIToCommonNaN.o s_commonNaNToF32UI.o s_propagateNaNF32UI.o s_f64UIToCommonNaN.o s_commonNaNToF64UI.o s_propagateNaNF64UI.o extF80M_isSignalingNaN.o s_extF80UIToCommonNaN.o s_commonNaNToExtF80UI.o s_propagateNaNExtF80UI.o f128M_isSignalingNaN.o s_f128UIToCommonNaN.o s_commonNaNToF128UI.o s_propagateNaNF128UI.o
clang++ -g  -Wl,--warn-common -fsanitize=undefined -fsanitize=address -Wl,-z,relro -Wl,-z,now -pie -m64  -fstack-protector-strong -o fp-test fp-test.o slowfloat.o softfloat.o  libtestfloat.a libsoftfloat.a /tmp/qemu-test/build/libqemuutil.a   -lm -lz  -lgthread-2.0 -pthread -lglib-2.0  -lnettle  -lgnutls  -lzstd   -lrt
/usr/bin/ld: /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors_vfork.S.o): warning: common of `__interception::real_vfork' overridden by definition from /usr/lib64/clang/10.0.0/lib/linux/libclang_rt.asan-x86_64.a(asan_interceptors.cpp.o)
make[1]: Leaving directory '/tmp/qemu-test/build/tests/fp'
Traceback (most recent call last):
  File "./tests/docker/docker.py", line 669, in <module>
---
    raise CalledProcessError(retcode, cmd)
subprocess.CalledProcessError: Command '['sudo', '-n', 'docker', 'run', '--label', 'com.qemu.instance.uuid=668db22dbb11404ebcfb4dbf57460f04', '-u', '1003', '--security-opt', 'seccomp=unconfined', '--rm', '-e', 'TARGET_LIST=x86_64-softmmu', '-e', 'EXTRA_CONFIGURE_OPTS=', '-e', 'V=', '-e', 'J=14', '-e', 'DEBUG=', '-e', 'SHOW_ENV=', '-e', 'CCACHE_DIR=/var/tmp/ccache', '-v', '/home/patchew2/.cache/qemu-docker-ccache:/var/tmp/ccache:z', '-v', '/var/tmp/patchew-tester-tmp-z5a3auqg/src/docker-src.2020-06-19-13.47.06.23020:/var/tmp/qemu:z,ro', 'qemu:fedora', '/var/tmp/qemu/run', 'test-debug']' returned non-zero exit status 2.
filter=--filter=label=com.qemu.instance.uuid=668db22dbb11404ebcfb4dbf57460f04
make[1]: *** [docker-run] Error 1
make[1]: Leaving directory `/var/tmp/patchew-tester-tmp-z5a3auqg/src'
make: *** [docker-run-test-debug@fedora] Error 2

real    4m54.495s
user    0m8.721s


The full log is available at
http://patchew.org/logs/20200619171809.30984-1-dgilbert@redhat.com/testing.asan/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com

