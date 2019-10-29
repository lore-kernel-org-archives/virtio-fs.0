Date: Tue, 29 Oct 2019 00:36:05 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191029003605.GC2508@work-vm>
References: <20191025100152.6638-1-stefanha@redhat.com>
	<20191025100152.6638-4-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025100152.6638-4-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [RFC 3/3] tests/vhost-user-fs-test: add
	vhost-user-fs test case
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> Add a test case for the vhost-user-fs device.  There are two
> limitations:
> 
> 1. This test only runs when invoked as root.  The virtiofsd vhost-user
>    device backend currently requires root in order to maintain accurate
>    file system ownership information (uid/gid).
> 
> 2. Cross-endian is not supported because virtiofsd currently only
>    supports same-endian configurations.
> 
> This test uses FUSE_INIT, FUSE_LOOKUP, FUSE_OPEN, FUSE_CREATE,
> FUSE_READ, FUSE_WRITE, FUSE_RELEASE, and FUSE_FORGET messages to perform
> basic sanity testing.
> 
> This test can be expanded on in the future to perform low-level
> virtio-fs testing, including invalid FUSE messages that are hard to
> generate from a real guest.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tests/Makefile.include     |   8 +-
>  tests/libqos/virtio-fs.h   |  46 +++
>  tests/libqos/virtio-fs.c   | 104 ++++++
>  tests/vhost-user-fs-test.c | 660 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 816 insertions(+), 2 deletions(-)
>  create mode 100644 tests/libqos/virtio-fs.h
>  create mode 100644 tests/libqos/virtio-fs.c
>  create mode 100644 tests/vhost-user-fs-test.c
> 
> diff --git a/tests/Makefile.include b/tests/Makefile.include
> index fde8a0c5ef..0472565d96 100644
> --- a/tests/Makefile.include
> +++ b/tests/Makefile.include
> @@ -718,6 +718,7 @@ qos-test-obj-y += tests/libqos/sdhci.o
>  qos-test-obj-y += tests/libqos/tpci200.o
>  qos-test-obj-y += tests/libqos/virtio.o
>  qos-test-obj-$(CONFIG_VIRTFS) += tests/libqos/virtio-9p.o
> +qos-test-obj-$(CONFIG_VHOST_USER_FS) += tests/libqos/virtio-fs.o
>  qos-test-obj-y += tests/libqos/virtio-balloon.o
>  qos-test-obj-y += tests/libqos/virtio-blk.o
>  qos-test-obj-y += tests/libqos/virtio-mmio.o
> @@ -759,6 +760,7 @@ qos-test-obj-y += tests/spapr-phb-test.o
>  qos-test-obj-y += tests/tmp105-test.o
>  qos-test-obj-y += tests/usb-hcd-ohci-test.o $(libqos-usb-obj-y)
>  qos-test-obj-$(CONFIG_VHOST_NET_USER) += tests/vhost-user-test.o $(chardev-obj-y) $(test-io-obj-y)
> +qos-test-obj-$(CONFIG_VHOST_USER_FS) += tests/vhost-user-fs-test.o
>  qos-test-obj-y += tests/virtio-test.o
>  qos-test-obj-$(CONFIG_VIRTFS) += tests/virtio-9p-test.o
>  qos-test-obj-y += tests/virtio-blk-test.o
> @@ -907,7 +909,8 @@ endef
>  $(patsubst %, check-qtest-%, $(QTEST_TARGETS)): check-qtest-%: %-softmmu/all $(check-qtest-y)
>  	$(call do_test_human,$(check-qtest-$*-y) $(check-qtest-generic-y), \
>  	  QTEST_QEMU_BINARY=$*-softmmu/qemu-system-$* \
> -	  QTEST_QEMU_IMG=qemu-img$(EXESUF))
> +	  QTEST_QEMU_IMG=qemu-img$(EXESUF) \
> +	  QTEST_VIRTIOFSD=virtiofsd$(EXESUF))
>  
>  check-unit: $(check-unit-y)
>  	$(call do_test_human, $^)
> @@ -920,7 +923,8 @@ check-speed: $(check-speed-y)
>  $(patsubst %, check-report-qtest-%.tap, $(QTEST_TARGETS)): check-report-qtest-%.tap: %-softmmu/all $(check-qtest-y)
>  	$(call do_test_tap, $(check-qtest-$*-y) $(check-qtest-generic-y), \
>  	  QTEST_QEMU_BINARY=$*-softmmu/qemu-system-$* \
> -	  QTEST_QEMU_IMG=qemu-img$(EXESUF))
> +	  QTEST_QEMU_IMG=qemu-img$(EXESUF) \
> +	  QTEST_VIRTIOFSD=virtiofsd$(EXESUF))
>  
>  check-report-unit.tap: $(check-unit-y)
>  	$(call do_test_tap,$^)
> diff --git a/tests/libqos/virtio-fs.h b/tests/libqos/virtio-fs.h
> new file mode 100644
> index 0000000000..40289ba283
> --- /dev/null
> +++ b/tests/libqos/virtio-fs.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifer: GPL-2.0-or-later */
> +/*
> + * libqos virtio-fs device driver
> + *
> + * Copyright (C) 2019 Red Hat, Inc.
> + */
> +
> +#ifndef TESTS_LIBQOS_VIRTIO_FS_H
> +#define TESTS_LIBQOS_VIRTIO_FS_H
> +
> +#include "libqos/virtio-pci.h"
> +
> +#define VIRTIO_FS_TAG "myfs"
> +
> +typedef struct {
> +    QVirtioDevice *vdev;
> +    QGuestAllocator *alloc;
> +    QVirtQueue *hiprio_vq;
> +    QVirtQueue *request_vq;
> +    uint64_t unique_counter;
> +} QVirtioFS;
> +
> +typedef struct {
> +    QVirtioPCIDevice pci_vdev;
> +    QVirtioFS vfs;
> +} QVirtioFSPCI;
> +
> +typedef struct {
> +    QOSGraphObject obj;
> +    QVirtioFS vfs;
> +} QVirtioFSDevice;
> +
> +static inline uint64_t virtio_fs_get_unique(QVirtioFS *vfs)
> +{
> +    /*
> +     * Interrupt requests share the unique ID of the request, except the
> +     * least-significant bit.
> +     *
> +     * Note that unique ID 0 is invalid so we increment right away.
> +     */
> +    vfs->unique_counter += 2;
> +
> +    return vfs->unique_counter;
> +}
> +
> +#endif /* TESTS_LIBQOS_VIRTIO_FS_H */
> diff --git a/tests/libqos/virtio-fs.c b/tests/libqos/virtio-fs.c
> new file mode 100644
> index 0000000000..47f22d50b9
> --- /dev/null
> +++ b/tests/libqos/virtio-fs.c
> @@ -0,0 +1,104 @@
> +/* SPDX-License-Identifer: GPL-2.0-or-later */
> +/*
> + * libqos virtio-fs device driver
> + *
> + * Copyright (C) 2019 Red Hat, Inc.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "standard-headers/linux/virtio_fs.h"
> +#include "libqos/virtio-fs.h"
> +
> +static void virtio_fs_cleanup(QVirtioFS *vfs)
> +{
> +    QVirtioDevice *vdev = vfs->vdev;
> +
> +    qvirtqueue_cleanup(vdev->bus, vfs->hiprio_vq, vfs->alloc);
> +    qvirtqueue_cleanup(vdev->bus, vfs->request_vq, vfs->alloc);
> +    vfs->hiprio_vq = NULL;
> +    vfs->request_vq = NULL;
> +}
> +
> +static void virtio_fs_setup(QVirtioFS *vfs)
> +{
> +    QVirtioDevice *vdev = vfs->vdev;
> +    uint64_t features;
> +
> +    features = qvirtio_get_features(vdev);
> +    features &= ~(QVIRTIO_F_BAD_FEATURE |
> +                  (1ull << VIRTIO_RING_F_EVENT_IDX));
> +    qvirtio_set_features(vdev, features);
> +
> +    vfs->hiprio_vq = qvirtqueue_setup(vdev, vfs->alloc, 0);
> +    vfs->request_vq = qvirtqueue_setup(vdev, vfs->alloc, 1);
> +
> +    qvirtio_set_driver_ok(vdev);
> +}
> +
> +static void vhost_user_fs_pci_destructor(QOSGraphObject *obj)
> +{
> +    QVirtioFSPCI *vfs_pci = (QVirtioFSPCI *)obj;
> +    QVirtioFS *vfs = &vfs_pci->vfs;
> +
> +    virtio_fs_cleanup(vfs);
> +    qvirtio_pci_destructor(&vfs_pci->pci_vdev.obj);
> +}
> +
> +static void vhost_user_fs_pci_start_hw(QOSGraphObject *obj)
> +{
> +    QVirtioFSPCI *vfs_pci = (QVirtioFSPCI *)obj;
> +    QVirtioFS *vfs = &vfs_pci->vfs;
> +
> +    qvirtio_pci_start_hw(&vfs_pci->pci_vdev.obj);
> +    virtio_fs_setup(vfs);
> +}
> +
> +static void *vhost_user_fs_pci_get_driver(void *object, const char *interface)
> +{
> +    QVirtioFSPCI *vfs_pci = object;
> +
> +    if (g_strcmp0(interface, "virtio-fs") == 0) {
> +        return &vfs_pci->vfs;
> +    }
> +
> +    fprintf(stderr, "%s not present in virtio-fs\n", interface);
> +    g_assert_not_reached();
> +}
> +
> +static void *vhost_user_fs_pci_create(void *pci_bus, QGuestAllocator *alloc, void *addr)
> +{
> +    QVirtioFSPCI *vfs_pci = g_new0(QVirtioFSPCI, 1);
> +    QVirtioFS *vfs = &vfs_pci->vfs;
> +    QOSGraphObject *obj = &vfs_pci->pci_vdev.obj;
> +
> +    virtio_pci_init(&vfs_pci->pci_vdev, pci_bus, addr);
> +    vfs->vdev = &vfs_pci->pci_vdev.vdev;
> +    vfs->alloc = alloc;
> +
> +    g_assert_cmphex(vfs->vdev->device_type, ==, VIRTIO_ID_FS);
> +
> +    obj->destructor = vhost_user_fs_pci_destructor;
> +    obj->start_hw = vhost_user_fs_pci_start_hw;
> +    obj->get_driver = vhost_user_fs_pci_get_driver;
> +
> +    return obj;
> +}
> +
> +static void virtio_fs_register_nodes(void)
> +{
> +    QOSGraphEdgeOptions opts = {
> +        .extra_device_opts = "chardev=char-virtio-fs,addr=04.0,tag=" VIRTIO_FS_TAG,
> +        .before_cmd_line = "-m 512M -object memory-backend-file,id=mem,"
> +            "size=512M,mem-path=/dev/shm,share=on -numa node,memdev=mem",
> +    };
> +    QPCIAddress addr = {
> +        .devfn = QPCI_DEVFN(4, 0),
> +    };
> +
> +    add_qpci_address(&opts, &addr);
> +    qos_node_create_driver("vhost-user-fs-pci", vhost_user_fs_pci_create);
> +    qos_node_consumes("vhost-user-fs-pci", "pci-bus", &opts);
> +    qos_node_produces("vhost-user-fs-pci", "virtio-fs");
> +}
> +
> +libqos_init(virtio_fs_register_nodes);
> diff --git a/tests/vhost-user-fs-test.c b/tests/vhost-user-fs-test.c
> new file mode 100644
> index 0000000000..76394adee6
> --- /dev/null
> +++ b/tests/vhost-user-fs-test.c
> @@ -0,0 +1,660 @@
> +/* SPDX-License-Identifer: GPL-2.0-or-later */
> +/*
> + * vhost-user-fs device test
> + *
> + * Copyright (C) 2019 Red Hat, Inc.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/bswap.h"
> +#include "qemu/iov.h"
> +#include "standard-headers/linux/virtio_fs.h"
> +#include "standard-headers/linux/fuse.h"
> +#include "libqos/virtio-fs.h"
> +#include "libqtest-single.h"
> +
> +#define TIMEOUT_US (30 * 1000 * 1000)
> +
> +#ifdef HOST_WORDS_BIGENDIAN
> +static const bool host_is_big_endian = true;
> +#else
> +static const bool host_is_big_endian; /* false */
> +#endif
> +
> +/*
> + * This macro skips tests when run in a cross-endian configuration.
> + * virtiofsd does not byte-swap FUSE messages and therefore does not support
> + * cross-endian.
> + */
> +#define SKIP_TEST_IF_CROSS_ENDIAN() { \
> +    if (host_is_big_endian != qtest_big_endian(global_qtest)) { \
> +        g_test_skip("cross-endian is not supported by virtiofsd yet"); \
> +        return; \
> +    } \
> +}
> +
> +static char *socket_path;
> +static char *shared_dir;
> +
> +static bool remove_dir_and_children(const char *path)
> +{
> +    GDir *dir;
> +    const gchar *name;
> +
> +    dir = g_dir_open(path, 0, NULL);
> +    if (!dir) {
> +        return false;
> +    }
> +
> +    while ((name = g_dir_read_name(dir)) != NULL) {
> +        g_autofree gchar *child = g_strdup_printf("%s/%s", path, name);
> +
> +        g_test_message("unlinking %s", child);
> +
> +        if (unlink(child) == -1 && errno == EISDIR) {
> +            remove_dir_and_children(child);
> +        }
> +    }
> +
> +    g_dir_close(dir);
> +
> +    g_test_message("rmdir %s", path);
> +    return rmdir(path) == 0;
> +}
> +
> +static void after_test(void *arg G_GNUC_UNUSED)
> +{
> +    unlink(socket_path);
> +
> +    remove_dir_and_children(shared_dir);

This scares me. Especially since it's running as root.
Can we add a bunch of paranoid checks to make sure it doesn't
end up rm -rf / ?

> +    /*
> +     * Both QEMU and virtiofsd need to be restarted after each test and the
> +     * shared directory will be recreated.  This ensures isolation between test
> +     * runs.
> +     */
> +    qos_invalidate_command_line();
> +}
> +
> +/* Called on SIGABRT */
> +static void abrt_handler(void *arg G_GNUC_UNUSED)
> +{
> +    after_test(NULL);
> +}
> +
> +static int create_socket(const char *path)
> +{
> +    union {
> +        struct sockaddr sa;
> +        struct sockaddr_un un;
> +    } sa;
> +    int fd;
> +
> +    fd = socket(AF_UNIX, SOCK_STREAM, 0);
> +    if (fd < 0) {
> +        g_test_message("socket failed (errno=%d)", errno);
> +        abort();
> +    }
> +
> +    unlink(path); /* in case it already exists */
> +
> +    sa.un.sun_family = AF_UNIX;
> +    snprintf(sa.un.sun_path, sizeof(sa.un.sun_path), "%s", path);
> +
> +    if (bind(fd, &sa.sa, sizeof(sa.un)) < 0) {
> +        g_test_message("bind failed (errno=%d)", errno);
> +        abort();
> +    }
> +
> +    if (listen(fd, 1) < 0) {
> +        g_test_message("listen failed (errno=%d)", errno);
> +        abort();
> +    }
> +
> +    return fd;
> +}
> +
> +static const char *qtest_virtiofsd(void)
> +{
> +    const char *virtiofsd_binary;
> +
> +    virtiofsd_binary = getenv("QTEST_VIRTIOFSD");
> +    if (!virtiofsd_binary) {
> +        fprintf(stderr, "Environment variable QTEST_VIRTIOFSD required\n");
> +        exit(1);
> +    }
> +
> +    return virtiofsd_binary;
> +}
> +
> +/* Launch virtiofsd before each test with an empty shared directory */
> +static void *before_test(GString *cmd_line G_GNUC_UNUSED, void *arg)
> +{
> +    g_autofree char *command = NULL;
> +    char *virtiofsd_path;
> +    int fd;
> +    pid_t pid;
> +
> +    fd = create_socket(socket_path);
> +
> +    if (mkdir(shared_dir, 0777) < 0) {
> +        g_message("mkdir failed (errno=%d)", errno);
> +        abort();
> +    }
> +
> +    virtiofsd_path = realpath(qtest_virtiofsd(), NULL);
> +    g_assert_nonnull(virtiofsd_path);
> +
> +    command = g_strdup_printf("exec %s --fd=%d -o source=%s",
> +                              virtiofsd_path,
> +                              fd,
> +                              shared_dir);
> +    free(virtiofsd_path);
> +    g_test_message("starting virtiofsd: %s", command);
> +
> +    /* virtiofsd terminates when QEMU closes the vhost-user socket connection,
> +     * so there is no need to kill it explicitly later on.
> +     */
> +    pid = fork();
> +    g_assert_cmpint(pid, >=, 0);
> +    if (pid == 0) {
> +        execlp("/bin/sh", "sh", "-c", command, NULL);
> +        exit(1);
> +    }
> +
> +    close(fd);
> +
> +    return arg;
> +}
> +
> +/*
> + * Send scatter-gather lists on the request virtqueue and return the number of
> + * bytes filled by the device.
> + *
> + * Note that in/out have opposite meanings in FUSE and VIRTIO.  This function
> + * uses VIRTIO terminology (out - to device, in - from device).
> + */
> +static uint32_t do_request(QVirtioFS *vfs, QTestState *qts,
> +                           struct iovec *sg_out, unsigned out_num,
> +                           struct iovec *sg_in, unsigned in_num)
> +{
> +    QVirtioDevice *dev = vfs->vdev;
> +    QVirtQueue *vq = vfs->request_vq;
> +    size_t out_bytes = iov_size(sg_out, out_num);
> +    size_t in_bytes = iov_size(sg_in, in_num);
> +    uint64_t out_addr;
> +    uint64_t in_addr;
> +    uint64_t addr;
> +    uint32_t head = 0;
> +    uint32_t nfilled;
> +    unsigned i;
> +
> +    g_assert_cmpint(out_num, >, 0);
> +    g_assert_cmpint(in_num, >, 0);
> +
> +    /* Add out buffers */
> +    addr = out_addr = guest_alloc(vfs->alloc, out_bytes);
> +    for (i = 0; i < out_num; i++) {
> +        size_t len = sg_out[i].iov_len;
> +        uint32_t desc_idx;
> +        bool first = i == 0;
> +
> +        qtest_memwrite(qts, addr, sg_out[i].iov_base, len);
> +        desc_idx = qvirtqueue_add(qts, vq, addr, len, false, true);
> +
> +        if (first) {
> +            head = desc_idx;
> +        }
> +
> +        addr += len;
> +    }
> +
> +    /* Add in buffers */
> +    addr = in_addr = guest_alloc(vfs->alloc, in_bytes);
> +    for (i = 0; i < in_num; i++) {
> +        size_t len = sg_in[i].iov_len;
> +        bool next = i != in_num - 1;
> +
> +        qvirtqueue_add(qts, vq, addr, len, true, next);
> +
> +        addr += len;
> +    }
> +
> +    /* Process the request */
> +    qvirtqueue_kick(qts, dev, vq, head);
> +    qvirtio_wait_used_elem(qts, dev, vq, head, &nfilled, TIMEOUT_US);
> +
> +    /* Copy in buffers back */
> +    addr = in_addr;
> +    for (i = 0; i < in_num; i++) {
> +        size_t len = sg_in[i].iov_len;
> +
> +        qtest_memread(qts, addr, sg_in[i].iov_base, len);
> +        addr += len;
> +    }
> +
> +    guest_free(vfs->alloc, in_addr);
> +    guest_free(vfs->alloc, out_addr);
> +
> +    return nfilled;
> +}
> +
> +/* Byte-swap values if host endianness differs from guest */
> +static uint32_t guest32(uint32_t val)
> +{
> +    if (qtest_big_endian(global_qtest) != host_is_big_endian) {
> +        return bswap32(val);
> +    }
> +    return val;
> +}
> +
> +static uint64_t guest64(uint64_t val)
> +{
> +    if (qtest_big_endian(global_qtest) != host_is_big_endian) {
> +        return bswap64(val);
> +    }
> +    return val;
> +}
> +
> +/* Make a FUSE_INIT request */
> +static void fuse_init(QVirtioFS *vfs)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_INIT),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +    };
> +    struct fuse_init_in in = {
> +        .major = guest32(FUSE_KERNEL_VERSION),
> +        .minor = guest32(FUSE_KERNEL_MINOR_VERSION),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = &in, .iov_len = sizeof(in) },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct fuse_init_out out;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +        { .iov_base = &out, .iov_len = sizeof(out) },
> +    };
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +               sg_out, G_N_ELEMENTS(sg_out));
> +
> +    g_assert_cmpint(guest32(out_hdr.error), ==, 0);
> +    g_assert_cmpint(guest32(out.major), ==, FUSE_KERNEL_VERSION);
> +}
> +
> +/* Look up a directory entry by name using FUSE_LOOKUP */
> +static int32_t fuse_lookup(QVirtioFS *vfs, uint64_t parent, const char *name,
> +                           struct fuse_entry_out *entry)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_LOOKUP),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +        .nodeid = guest64(parent),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = (void *)name, .iov_len = strlen(name) + 1 },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +        { .iov_base = entry, .iov_len = sizeof(*entry) },
> +    };
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +               sg_out, G_N_ELEMENTS(sg_out));
> +
> +    return guest32(out_hdr.error);
> +}
> +
> +/* Open a file by nodeid using FUSE_OPEN */
> +static int32_t fuse_open(QVirtioFS *vfs, uint64_t nodeid, uint32_t flags,
> +                         uint64_t *fh)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_OPEN),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +        .nodeid = guest64(nodeid),
> +    };
> +    struct fuse_open_in in = {
> +        .flags = guest32(flags),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = &in, .iov_len = sizeof(in) },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct fuse_open_out out;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +        { .iov_base = &out, .iov_len = sizeof(out) },
> +    };

I wonder if anything can be done to reduce the size of the iovec boiler
plate?

> +    int32_t error;
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +               sg_out, G_N_ELEMENTS(sg_out));
> +
> +    error = guest32(out_hdr.error);
> +    if (!error) {
> +        *fh = guest64(out.fh);
> +    } else {
> +        *fh = 0;
> +    }
> +    return error;
> +}
> +
> +/* Create a file using FUSE_CREATE */
> +static int32_t fuse_create(QVirtioFS *vfs, uint64_t parent, const char *name,
> +                           uint32_t mode, uint32_t flags,
> +                           uint64_t *nodeid, uint64_t *fh)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_CREATE),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +        .nodeid = guest64(parent),
> +    };
> +    struct fuse_create_in in = {
> +        .flags = guest32(flags),
> +        .mode = guest32(mode),
> +        .umask = guest32(0002),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = &in, .iov_len = sizeof(in) },
> +        { .iov_base = (void *)name, .iov_len = strlen(name) + 1 },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct fuse_entry_out entry;
> +    struct fuse_open_out out;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +        { .iov_base = &entry, .iov_len = sizeof(entry) },
> +        { .iov_base = &out, .iov_len = sizeof(out) },
> +    };
> +    int32_t error;
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +               sg_out, G_N_ELEMENTS(sg_out));
> +
> +    error = guest32(out_hdr.error);
> +    if (!error) {
> +        *nodeid = guest64(entry.nodeid);
> +        *fh = guest64(out.fh);
> +    } else {
> +        *nodeid = 0;
> +        *fh = 0;
> +    }
> +    return error;
> +}
> +
> +/* Read bytes from a file using FILE_READ */
> +static ssize_t fuse_read(QVirtioFS *vfs, uint64_t fh, uint64_t offset,
> +                         void *buf, size_t len)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_READ),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +    };
> +    struct fuse_read_in in = {
> +        .fh = guest64(fh),
> +        .offset = guest64(offset),
> +        .size = guest32(len),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = &in, .iov_len = sizeof(in) },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +        { .iov_base = buf, .iov_len = len },
> +    };
> +    uint32_t nread;
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    nread = do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +                       sg_out, G_N_ELEMENTS(sg_out));
> +    g_assert_cmpint(guest32(out_hdr.error), ==, 0);
> +
> +    return nread - sizeof(out_hdr);
> +}
> +
> +/* Write bytes to a file using FILE_WRITE */
> +static ssize_t fuse_write(QVirtioFS *vfs, uint64_t fh, uint64_t offset,
> +                          const void *buf, size_t len)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_WRITE),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +    };
> +    struct fuse_write_in in = {
> +        .fh = guest64(fh),
> +        .offset = guest64(offset),
> +        .size = guest32(len),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = &in, .iov_len = sizeof(in) },
> +        { .iov_base = (void *)buf, .iov_len = len },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct fuse_write_out out;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +        { .iov_base = &out, .iov_len = sizeof(out) },
> +    };
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +               sg_out, G_N_ELEMENTS(sg_out));
> +    g_assert_cmpint(guest32(out_hdr.error), ==, 0);
> +
> +    return guest32(out.size);
> +}
> +
> +/* Close a file handle using FUSE_RELEASE */
> +static void fuse_release(QVirtioFS *vfs, uint64_t fh)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_RELEASE),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +    };
> +    struct fuse_release_in in = {
> +        .fh = guest64(fh),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = &in, .iov_len = sizeof(in) },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +    };
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +               sg_out, G_N_ELEMENTS(sg_out));
> +
> +    g_assert_cmpint(guest32(out_hdr.error), ==, 0);
> +}
> +
> +/* Drop an inode reference using FUSE_FORGET */
> +static void fuse_forget(QVirtioFS *vfs, uint64_t nodeid)
> +{
> +    struct fuse_in_header in_hdr = {
> +        .opcode = guest32(FUSE_FORGET),
> +        .unique = guest64(virtio_fs_get_unique(vfs)),
> +        .nodeid = guest64(nodeid),
> +    };
> +    struct fuse_forget_in in = {
> +        .nlookup = guest64(1),
> +    };
> +    struct iovec sg_in[] = {
> +        { .iov_base = &in_hdr, .iov_len = sizeof(in_hdr) },
> +        { .iov_base = &in, .iov_len = sizeof(in) },
> +    };
> +    struct fuse_out_header out_hdr;
> +    struct iovec sg_out[] = {
> +        { .iov_base = &out_hdr, .iov_len = sizeof(out_hdr) },
> +    };
> +
> +    in_hdr.len = guest32(iov_size(sg_in, G_N_ELEMENTS(sg_in)));
> +
> +    do_request(vfs, global_qtest, sg_in, G_N_ELEMENTS(sg_in),
> +               sg_out, G_N_ELEMENTS(sg_out));
> +
> +    g_assert_cmpint(guest32(out_hdr.error), ==, 0);
> +}
> +
> +/* Check contents of VIRTIO Configuration Space */
> +static void test_config(void *parent, void *arg, QGuestAllocator *alloc)
> +{
> +    QVirtioFS *vfs = parent;
> +    size_t i;
> +    uint32_t num_request_queues;
> +    char tag[37];
> +
> +    SKIP_TEST_IF_CROSS_ENDIAN();
> +
> +    for (i = 0; i < sizeof(tag) - 1; i++) {
> +        tag[i] = qvirtio_config_readw(vfs->vdev, i);
> +    }
> +    tag[36] = '\0';
> +
> +    g_assert_cmpstr(tag, ==, VIRTIO_FS_TAG);
> +
> +    num_request_queues = qvirtio_config_readl(vfs->vdev,
> +            offsetof(struct virtio_fs_config, num_request_queues));
> +
> +    g_assert_cmpint(num_request_queues, ==, 1);
> +}
> +
> +/* Create file on host and check its contents and metadata in guest */
> +static void test_file_from_host(void *parent, void *arg, QGuestAllocator *alloc)
> +{
> +    g_autofree gchar *filename = g_strdup_printf("%s/%s", shared_dir, "foo");
> +    const char *str = "This is a test\n";
> +    char buf[strlen(str)];
> +    QVirtioFS *vfs = parent;
> +    struct fuse_entry_out entry;
> +    int32_t error;
> +    uint64_t nodeid;
> +    uint64_t fh;
> +    ssize_t nread;
> +    gboolean ok;
> +
> +    SKIP_TEST_IF_CROSS_ENDIAN();
> +
> +    /* Create the test file in the shared directory */
> +    ok = g_file_set_contents(filename, str, strlen(str), NULL);
> +    g_assert(ok);
> +
> +    fuse_init(vfs);
> +
> +    error = fuse_lookup(vfs, FUSE_ROOT_ID, "foo", &entry);
> +    g_assert_cmpint(error, ==, 0);
> +    g_assert_cmpint(guest64(entry.attr.size), ==, strlen(str));
> +    nodeid = guest64(entry.nodeid);
> +
> +    error = fuse_open(vfs, nodeid, O_RDONLY, &fh);
> +    g_assert_cmpint(error, ==, 0);
> +
> +    nread = fuse_read(vfs, fh, 0, buf, sizeof(buf));
> +    g_assert_cmpint(nread, ==, sizeof(buf));
> +    g_assert_cmpint(memcmp(buf, str, sizeof(buf)), ==, 0);
> +
> +    fuse_release(vfs, fh);
> +    fuse_forget(vfs, nodeid);
> +}
> +
> +/* Create file from host and check its contents and metadata on host */
> +static void test_file_from_guest(void *parent, void *arg,
> +                                 QGuestAllocator *alloc)
> +{
> +    g_autofree gchar *filename = g_strdup_printf("%s/%s", shared_dir, "foo");
> +    const char *str = "This is a test\n";
> +    gchar *contents = NULL;
> +    gsize length = 0;
> +    QVirtioFS *vfs = parent;
> +    int32_t error;
> +    uint64_t nodeid;
> +    uint64_t fh;
> +    ssize_t nwritten;
> +    gboolean ok;
> +
> +    SKIP_TEST_IF_CROSS_ENDIAN();
> +
> +    fuse_init(vfs);
> +
> +    error = fuse_create(vfs, FUSE_ROOT_ID, "foo", 0644, O_CREAT | O_WRONLY,
> +                        &nodeid, &fh);
> +    g_assert_cmpint(error, ==, 0);
> +
> +    nwritten = fuse_write(vfs, fh, 0, str, strlen(str));
> +    g_assert_cmpint(nwritten, ==, strlen(str));
> +
> +    fuse_release(vfs, fh);
> +    fuse_forget(vfs, nodeid);
> +
> +    /* Check the file on the host */
> +    ok = g_file_get_contents(filename, &contents, &length, NULL);
> +    g_assert(ok);
> +    g_assert_cmpint(length, ==, strlen(str));
> +    g_assert_cmpint(memcmp(contents, str, strlen(str)), ==, 0);
> +    g_free(contents);
> +}
> +
> +static void register_vhost_user_fs_test(void)
> +{
> +    g_autofree gchar *cmd_line =
> +        g_strdup_printf("-chardev socket,id=char-virtio-fs,path=%s",
> +                        socket_path);
> +    QOSGraphTestOptions opts = {
> +        .edge.before_cmd_line = cmd_line,
> +        .before = before_test,
> +        .after = after_test,
> +    };
> +
> +    if (geteuid() != 0) {
> +        g_test_message("Skipping vhost-user-fs tests because root is "
> +                       "required for virtiofsd");
> +        return;
> +    }
> +
> +    qtest_add_abrt_handler(abrt_handler, NULL);
> +
> +    qos_add_test("config", "virtio-fs", test_config, &opts);
> +    qos_add_test("file-from-host", "virtio-fs", test_file_from_host, &opts);
> +    qos_add_test("file-from-guest", "virtio-fs", test_file_from_guest, &opts);
> +}
> +
> +libqos_init(register_vhost_user_fs_test);
> +
> +static void __attribute__((constructor)) init_paths(void)
> +{
> +    socket_path = g_strdup_printf("/tmp/qtest-%d-vhost-fs.sock", getpid());
> +    shared_dir = g_strdup_printf("/tmp/qtest-%d-virtio-fs-dir", getpid());
> +}
> +
> +static void __attribute__((destructor)) destroy_paths(void)
> +{
> +    g_free(shared_dir);
> +    shared_dir = NULL;
> +
> +    g_free(socket_path);
> +    socket_path = NULL;
> +}
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

