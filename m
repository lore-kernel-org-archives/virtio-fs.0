Return-Path: <berrange@redhat.com>
From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Mon, 19 Dec 2022 08:01:59 -0500
Message-Id: <20221219130205.687815-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/6] enforce use of G_GNUC_PRINTF annotations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, Anthony Perard <anthony.perard@citrix.com>, David Gibson <david@gibson.dropbear.id.au>, =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>, Thomas Huth <thuth@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>

We've been very gradually adding G_GNUC_PRINTF annotations
to functions over years. This has been useful in detecting
certain malformed printf strings, or cases where we pass
user data as the printf format which is a potential security
flaw.

Given the inherant memory corruption danger in use of format
strings vs mis-matched variadic arguments, it is worth applying
G_GNUC_PRINTF to all functions using printf, even if we know
they are safe.

The compilers can reasonably reliably identify such places
with the -Wsuggest-attribute=format / -Wmissing-format-attribute
flags.

This series adds G_GNUC_PRINTF / G_GNUC_SCANF to allow the code
locations that the compilers highlight. Then it adds the above
warning flags to the build flags, to catch any future additions
of functions that take printf/scanf format strings.

Daniel P. Berrangé (6):
  disas: add G_GNUC_PRINTF to gstring_printf
  hw/xen: use G_GNUC_PRINTF/SCANF for various functions
  tools/virtiofsd: add G_GNUC_PRINTF for logging functions
  util/error: add G_GNUC_PRINTF for various functions
  tests: add G_GNUC_PRINTF for various functions
  enforce use of G_GNUC_PRINTF attributes

 configure                         |  2 ++
 disas.c                           |  1 +
 hw/xen/xen-bus.c                  |  1 +
 hw/xen/xen_pvdev.c                |  1 +
 include/hw/xen/xen-bus-helper.h   |  6 ++++--
 include/hw/xen/xen-bus.h          |  3 ++-
 tests/qtest/ahci-test.c           |  3 +++
 tests/qtest/arm-cpu-features.c    |  1 +
 tests/qtest/erst-test.c           |  2 +-
 tests/qtest/ide-test.c            |  3 ++-
 tests/qtest/ivshmem-test.c        |  4 ++--
 tests/qtest/libqmp.c              |  2 +-
 tests/qtest/libqos/libqos-pc.h    |  6 ++++--
 tests/qtest/libqos/libqos-spapr.h |  6 ++++--
 tests/qtest/libqos/libqos.h       |  6 ++++--
 tests/qtest/libqos/virtio-9p.c    |  1 +
 tests/qtest/migration-helpers.h   |  1 +
 tests/qtest/rtas-test.c           |  2 +-
 tests/qtest/usb-hcd-uhci-test.c   |  4 ++--
 tests/unit/test-qmp-cmds.c        | 13 +++++++++----
 tools/virtiofsd/fuse_log.c        |  1 +
 tools/virtiofsd/fuse_log.h        |  6 ++++--
 tools/virtiofsd/passthrough_ll.c  |  1 +
 util/error-report.c               |  1 +
 util/error.c                      |  1 +
 25 files changed, 55 insertions(+), 23 deletions(-)

-- 
2.38.1

