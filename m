Return-Path: <dgilbert@redhat.com>
From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 18 Jan 2023 15:38:30 +0000
Message-Id: <20230118153833.102731-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] Remove C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, hczenczek@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

We deprecated the C virtiofsd in commit 34deee7b6a1418f3d62a
in v7.0 in favour of the Rust implementation at

  https://gitlab.com/virtio-fs/virtiofsd

since then, the Rust version has had more development and
has held up well.  It's time to say goodbye to the C version
that got us going.

The only thing I've not cleaned up here is
  tests/avocado/virtiofs_submounts.py

which I guess needs to figure out where the virtiofsd implementation
is and use it; suggestions welcome.

Dave


Dr. David Alan Gilbert (3):
  virtiofsd: Remove build and docs glue
  virtiofsd: Remove source
  virtiofsd: Swing deprecated message to removed-features

 MAINTAINERS                                   |    2 -
 docs/about/deprecated.rst                     |   18 -
 docs/about/removed-features.rst               |   13 +
 docs/conf.py                                  |    4 -
 docs/meson.build                              |    1 -
 docs/tools/index.rst                          |    1 -
 docs/tools/virtiofsd.rst                      |  403 --
 meson.build                                   |    1 -
 meson_options.txt                             |    2 -
 .../ci/org.centos/stream/8/x86_64/configure   |    2 -
 scripts/coverity-scan/COMPONENTS.md           |    3 -
 scripts/meson-buildoptions.sh                 |    3 -
 tools/meson.build                             |   13 -
 tools/virtiofsd/50-qemu-virtiofsd.json.in     |    5 -
 tools/virtiofsd/buffer.c                      |  350 --
 tools/virtiofsd/fuse_common.h                 |  837 ---
 tools/virtiofsd/fuse_i.h                      |  107 -
 tools/virtiofsd/fuse_log.c                    |   40 -
 tools/virtiofsd/fuse_log.h                    |   75 -
 tools/virtiofsd/fuse_lowlevel.c               | 2732 ----------
 tools/virtiofsd/fuse_lowlevel.h               | 1988 --------
 tools/virtiofsd/fuse_misc.h                   |   59 -
 tools/virtiofsd/fuse_opt.c                    |  446 --
 tools/virtiofsd/fuse_opt.h                    |  272 -
 tools/virtiofsd/fuse_signals.c                |   93 -
 tools/virtiofsd/fuse_virtio.c                 | 1081 ----
 tools/virtiofsd/fuse_virtio.h                 |   33 -
 tools/virtiofsd/helper.c                      |  409 --
 tools/virtiofsd/meson.build                   |   18 -
 tools/virtiofsd/passthrough_helpers.h         |   51 -
 tools/virtiofsd/passthrough_ll.c              | 4521 -----------------
 tools/virtiofsd/passthrough_seccomp.c         |  182 -
 tools/virtiofsd/passthrough_seccomp.h         |   14 -
 33 files changed, 13 insertions(+), 13766 deletions(-)
 delete mode 100644 docs/tools/virtiofsd.rst
 delete mode 100644 tools/virtiofsd/50-qemu-virtiofsd.json.in
 delete mode 100644 tools/virtiofsd/buffer.c
 delete mode 100644 tools/virtiofsd/fuse_common.h
 delete mode 100644 tools/virtiofsd/fuse_i.h
 delete mode 100644 tools/virtiofsd/fuse_log.c
 delete mode 100644 tools/virtiofsd/fuse_log.h
 delete mode 100644 tools/virtiofsd/fuse_lowlevel.c
 delete mode 100644 tools/virtiofsd/fuse_lowlevel.h
 delete mode 100644 tools/virtiofsd/fuse_misc.h
 delete mode 100644 tools/virtiofsd/fuse_opt.c
 delete mode 100644 tools/virtiofsd/fuse_opt.h
 delete mode 100644 tools/virtiofsd/fuse_signals.c
 delete mode 100644 tools/virtiofsd/fuse_virtio.c
 delete mode 100644 tools/virtiofsd/fuse_virtio.h
 delete mode 100644 tools/virtiofsd/helper.c
 delete mode 100644 tools/virtiofsd/meson.build
 delete mode 100644 tools/virtiofsd/passthrough_helpers.h
 delete mode 100644 tools/virtiofsd/passthrough_ll.c
 delete mode 100644 tools/virtiofsd/passthrough_seccomp.c
 delete mode 100644 tools/virtiofsd/passthrough_seccomp.h

-- 
2.39.0

