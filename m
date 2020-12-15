DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=grwCj9JPsFDR4xWxnfKbVq52apKa/i7CSMyqFMWUTU0=;
	b=r7Wf8l4KJCiynPbwVCnIaQFerTekQBW8VlhAM5VCyLRTTNSWzfr9LC+Jk6qjU5v94J
	Mb7JNwVqwbICjT+Xpijn+qO+2Yvf5ceRtNVf7ZeAH4xntbjzWkx7xsLqArkrxp5aBgfE
	Zfs73igqHRuDYsnONsVSGHvjoPo6nzTuY4g0AhrRxeptzTqLaDxXXVtQRTLMV4xKA6te
	aOkUUtikW6CxLrJj9+Q+ZAK5zltuhcRSoUh6ptIw0nqZy5iqk9mveBY1XnDbRwBvKBS8
	PyKdPG4OTkXBhQ1k+p/sr7Af13jNuA3tW2m2wbKxaKmxFzKVwiO8wKSXH813EtIKJiAu
	fbkw==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 16 Dec 2020 00:21:15 +0800
Message-Id: <20201215162119.27360-6-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [RFC PATCH 5/9] virtiofsd: Convert the struct lo_map
	array to a more flatten layout
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr . David Alan Gilbert" <dgilbert@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Xie Yongji <xieyongji@bytedance.com>
Cc: virtio-fs@redhat.com, Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>, qemu-devel@nongnu.org

In the original implementation, lo_inodes and lo_dirps are dynamically
allocated by calloc() and attached to the pointer in its corresponding
lo_map_elem.

However, as we need to share the memory regions of the lo_maps with QEMU,
using dynamic allocation will cause virtiofsd to share a larger number of
memory regions with QEMU. In such a case, when a new memory region is
allocated or deallocated, virtiofsd needs to send a slave message to QEMU.
That might lead a complex code logic and poor performance.

Therefore, in this commit, we integrate the inode and dirp into lo_map_elem
directly. This decision touches many code lines in passthrough_ll.c. However,
the code changes can be divided into several distinct situations:
    1. Use memfd_create and mmap to initialize the lo_maps. Replace
    realloc by ftruncate & mmap for lo_map growing.
    2. Change the root filed of struct lo_data to a pointer pointing to
    the second lo_inode map.
    3. Change the input arguments of lo_inode_put and lo_dirp_put to use
    struct lo_inode* and struct lo_dirp* instead of struct lo_inode** and
    struct lo_dirp**.
    4. Use refcount alone and deprecate the in_use flag in lo_map_elem.
    That is because previously, a lo_map slot can be in a not in_use
    state because its corresponding dirp / inode pointer is pointed to
    NULL, while the already unhooked lo_inode / lo_dirp objects may not
    be freed. But now, the lo_inode / lo_dirp are integrated just inside
    the lo_map_elem, so the slot releasing and lo_inode / lo_dirp
    freeing should be happened at the same time. Therefore we will not
    need two counter to indicate the available status of the lo_map
    slots. The refcount it also took out from struct lo_inode to struct
    lo_map_elem, in case every type of lo_map needs the deprecated
    in_use flag.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 tools/virtiofsd/passthrough_ll.c      | 468 +++++++++++++++-----------
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 2 files changed, 278 insertions(+), 191 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 97485b22b4..815b001076 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -68,6 +68,7 @@
 #include "qemu/cutils.h"
 #include "passthrough_helpers.h"
 #include "passthrough_seccomp.h"
+#include "qemu/memfd.h"
 
 /* Keep track of inode posix locks for each owner. */
 struct lo_inode_plock {
@@ -75,23 +76,6 @@ struct lo_inode_plock {
     int fd; /* fd for OFD locks */
 };
 
-struct lo_map_elem {
-    union {
-        struct lo_inode *inode;
-        struct lo_dirp *dirp;
-        int fd;
-        ssize_t freelist;
-    };
-    bool in_use;
-};
-
-/* Maps FUSE fh or ino values to internal objects */
-struct lo_map {
-    struct lo_map_elem *elems;
-    size_t nelems;
-    ssize_t freelist;
-};
-
 struct lo_key {
     ino_t ino;
     dev_t dev;
@@ -101,12 +85,6 @@ struct lo_key {
 struct lo_inode {
     int fd;
 
-    /*
-     * Atomic reference count for this object.  The nlookup field holds a
-     * reference and release it when nlookup reaches 0.
-     */
-    gint refcount;
-
     struct lo_key key;
 
     /*
@@ -127,6 +105,38 @@ struct lo_inode {
     GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
 
     mode_t filetype;
+} __attribute__((packed));
+
+struct lo_dirp {
+    int fd;
+    DIR *dp;
+    struct dirent *entry;
+    off_t offset;
+} __attribute__((packed));
+
+struct lo_map_elem {
+    union {
+        struct lo_inode inode;
+        struct lo_dirp dirp;
+        int fd;
+    };
+    ssize_t freelist;
+    gint refcount;
+} __attribute__((packed));
+
+/* Maps FUSE fh or ino values to internal objects */
+struct lo_map {
+    size_t nelems;
+    ssize_t freelist;
+    int map_type;
+    int memfd;
+    struct lo_map_elem elems[];
+} __attribute__((packed));
+
+const char *MAP_NAME[] = {
+    "fd_map",
+    "ino_map",
+    "dirp_map"
 };
 
 struct lo_cred {
@@ -151,6 +161,11 @@ typedef struct xattr_map_entry {
     unsigned int flags;
 } XattrMapEntry;
 
+#define FD_MAP 0
+#define INO_MAP 1
+#define DIRP_MAP 2
+#define MAP_TYPE_NUM 3
+
 struct lo_data {
     pthread_mutex_t mutex;
     int sandbox;
@@ -170,11 +185,9 @@ struct lo_data {
     int allow_direct_io;
     int announce_submounts;
     bool use_statx;
-    struct lo_inode root;
+    struct lo_inode *root;
     GHashTable *inodes; /* protected by lo->mutex */
-    struct lo_map ino_map; /* protected by lo->mutex */
-    struct lo_map dirp_map; /* protected by lo->mutex */
-    struct lo_map fd_map; /* protected by lo->mutex */
+    struct lo_map *maps[MAP_TYPE_NUM]; /* protected by lo->mutex */
     XattrMapEntry *xattr_map_list;
     size_t xattr_map_nentries;
 
@@ -182,6 +195,8 @@ struct lo_data {
     int proc_self_fd;
 };
 
+static struct lo_data lo;
+
 static const struct fuse_opt lo_opts[] = {
     { "sandbox=namespace",
       offsetof(struct lo_data, sandbox),
@@ -245,7 +260,7 @@ static int is_safe_path_component(const char *path)
 
 static struct lo_data *lo_data(fuse_req_t req)
 {
-    return (struct lo_data *)fuse_req_userdata(req);
+    return &lo;
 }
 
 /*
@@ -365,65 +380,104 @@ out:
     return ret;
 }
 
-static void lo_map_init(struct lo_map *map)
+
+static void lo_map_init(int map_type)
 {
-    map->elems = NULL;
-    map->nelems = 0;
-    map->freelist = -1;
+    int memfd;
+    int ret;
+
+    memfd = memfd_create(MAP_NAME[map_type], 0);
+    ret = ftruncate(memfd, sizeof(struct lo_map) + sizeof(struct lo_map_elem));
+    if (-1 == ret) {
+        exit(1);
+    }
+
+    int page_size = getpagesize();
+    void *fake_addr = mmap(NULL, 1024 * 1024 * 1024, PROT_READ | PROT_WRITE,
+                                                MAP_SHARED | MAP_ANON, -1, 0);
+    unsigned long tgt_addr = ((unsigned long)fake_addr / page_size + 1) *
+                                                                    page_size;
+    lo.maps[map_type] = mmap((void *)tgt_addr,
+                    sizeof(struct lo_map) + sizeof(struct lo_map_elem),
+                    PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED, memfd, 0);
+
+    if (lo.maps[map_type] == MAP_FAILED) {
+        fuse_log(FUSE_LOG_ERR, "map %d init failed!\n", MAP_NAME[map_type]);
+        exit(1);
+    }
+    lo.maps[map_type]->nelems = 0;
+    lo.maps[map_type]->freelist = -1;
+    lo.maps[map_type]->map_type = map_type;
+    lo.maps[map_type]->memfd = memfd;
+
+    printf("memfd: %d\n", lo.maps[map_type]->memfd);
+    ret = system("ls -lsh /proc/self/fd");
+    fuse_log(FUSE_LOG_DEBUG, "map %s init succeed!\n",
+                             MAP_NAME[lo.maps[map_type]->map_type]);
 }
 
-static void lo_map_destroy(struct lo_map *map)
+static void lo_map_destroy(int map_type)
 {
-    free(map->elems);
+    munmap(lo.maps[map_type], sizeof(struct lo_map) +
+           lo.maps[map_type]->nelems * sizeof(struct lo_map_elem));
+
 }
 
-static int lo_map_grow(struct lo_map *map, size_t new_nelems)
+static int lo_map_grow(int map_type, size_t new_nelems)
 {
-    struct lo_map_elem *new_elems;
     size_t i;
+    size_t new_size;
+    int ret;
 
-    if (new_nelems <= map->nelems) {
+    if (new_nelems <= lo.maps[map_type]->nelems) {
         return 1;
     }
 
-    new_elems = realloc(map->elems, sizeof(map->elems[0]) * new_nelems);
-    if (!new_elems) {
+    new_size = sizeof(struct lo_map) + sizeof(struct lo_map_elem) * new_nelems;
+    ret = ftruncate(lo.maps[map_type]->memfd, new_size);
+    if (-1 == ret) {
         return 0;
     }
 
-    for (i = map->nelems; i < new_nelems; i++) {
-        new_elems[i].freelist = i + 1;
-        new_elems[i].in_use = false;
+    lo.maps[map_type] = mmap(lo.maps[map_type], new_size,
+                             PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,
+                             lo.maps[map_type]->memfd, 0);
+    if (lo.maps[map_type] == MAP_FAILED) {
+        return 0;
     }
-    new_elems[new_nelems - 1].freelist = -1;
 
-    map->elems = new_elems;
-    map->freelist = map->nelems;
-    map->nelems = new_nelems;
+    for (i = lo.maps[map_type]->nelems; i < new_nelems; i++) {
+        lo.maps[map_type]->elems[i].freelist = i + 1;
+        g_atomic_int_set(&lo.maps[map_type]->elems[i].refcount, -1);
+    }
+    lo.maps[map_type]->elems[new_nelems - 1].freelist = -1;
+
+    lo.maps[map_type]->freelist = lo.maps[map_type]->nelems;
+    lo.maps[map_type]->nelems = new_nelems;
     return 1;
 }
 
-static struct lo_map_elem *lo_map_alloc_elem(struct lo_map *map)
+static struct lo_map_elem *lo_map_alloc_elem(int map_type)
 {
     struct lo_map_elem *elem;
+    struct lo_map *map = lo.maps[map_type];
 
-    if (map->freelist == -1 && !lo_map_grow(map, map->nelems + 256)) {
+    if (map->freelist == -1 && !lo_map_grow(map_type, map->nelems + 256)) {
         return NULL;
     }
 
-    elem = &map->elems[map->freelist];
+    elem = &lo.maps[map_type]->elems[map->freelist];
     map->freelist = elem->freelist;
 
-    elem->in_use = true;
-
     return elem;
 }
 
-static struct lo_map_elem *lo_map_reserve(struct lo_map *map, size_t key)
+static struct lo_map_elem *lo_map_reserve(int map_type, size_t key)
 {
     ssize_t *prev;
+    struct lo_map *map = lo.maps[map_type];
 
-    if (!lo_map_grow(map, key + 1)) {
+    if (!lo_map_grow(map_type, key + 1)) {
         return NULL;
     }
 
@@ -433,7 +487,6 @@ static struct lo_map_elem *lo_map_reserve(struct lo_map *map, size_t key)
             struct lo_map_elem *elem = &map->elems[key];
 
             *prev = elem->freelist;
-            elem->in_use = true;
             return elem;
         }
     }
@@ -445,7 +498,7 @@ static struct lo_map_elem *lo_map_get(struct lo_map *map, size_t key)
     if (key >= map->nelems) {
         return NULL;
     }
-    if (!map->elems[key].in_use) {
+    if (g_atomic_int_get(&map->elems[key].refcount) == -1) {
         return NULL;
     }
     return &map->elems[key];
@@ -454,17 +507,29 @@ static struct lo_map_elem *lo_map_get(struct lo_map *map, size_t key)
 static void lo_map_remove(struct lo_map *map, size_t key)
 {
     struct lo_map_elem *elem;
+    int to_del_fd;
 
     if (key >= map->nelems) {
         return;
     }
 
     elem = &map->elems[key];
-    if (!elem->in_use) {
+    if (map->map_type == FD_MAP) {
+        to_del_fd = elem->fd;
+        close(to_del_fd);
+    } else if (map->map_type == INO_MAP) {
+        to_del_fd = elem->inode.fd;
+        close(to_del_fd);
+    } else if (map->map_type == DIRP_MAP) {
+        to_del_fd = elem->dirp.fd;
+        closedir(elem->dirp.dp);
+    }
+
+    if (g_atomic_int_get(&elem->refcount) == -1) {
         return;
     }
 
-    elem->in_use = false;
+    g_atomic_int_set(&elem->refcount, -1);
 
     elem->freelist = map->freelist;
     map->freelist = key;
@@ -475,59 +540,73 @@ static ssize_t lo_add_fd_mapping(fuse_req_t req, int fd)
 {
     struct lo_map_elem *elem;
 
-    elem = lo_map_alloc_elem(&lo_data(req)->fd_map);
+    elem = lo_map_alloc_elem(FD_MAP);
     if (!elem) {
         return -1;
     }
 
+    g_atomic_int_set(&elem->refcount, 1);
+
     elem->fd = fd;
-    return elem - lo_data(req)->fd_map.elems;
+    return ((unsigned long)elem -
+            (unsigned long)lo_data(req)->maps[FD_MAP]->elems) /
+            sizeof(struct lo_map_elem);
 }
 
 /* Assumes lo->mutex is held */
-static ssize_t lo_add_dirp_mapping(fuse_req_t req, struct lo_dirp *dirp)
+static struct lo_map_elem *lo_add_dirp_mapping(fuse_req_t req,
+                                               struct lo_dirp *dirp)
 {
     struct lo_map_elem *elem;
 
-    elem = lo_map_alloc_elem(&lo_data(req)->dirp_map);
+    elem = lo_map_alloc_elem(DIRP_MAP);
     if (!elem) {
-        return -1;
+        return NULL;
     }
 
-    elem->dirp = dirp;
-    return elem - lo_data(req)->dirp_map.elems;
+    memcpy(&elem->dirp, dirp, sizeof(struct lo_dirp));
+    return elem;
 }
 
+static void posix_locks_value_destroy(gpointer data);
+
 /* Assumes lo->mutex is held */
-static ssize_t lo_add_inode_mapping(fuse_req_t req, struct lo_inode *inode)
+static struct lo_map_elem *lo_add_inode_mapping(fuse_req_t req,
+                                                struct lo_inode *inode)
 {
     struct lo_map_elem *elem;
 
-    elem = lo_map_alloc_elem(&lo_data(req)->ino_map);
+    elem = lo_map_alloc_elem(INO_MAP);
     if (!elem) {
-        return -1;
+        return NULL;
     }
 
-    elem->inode = inode;
-    return elem - lo_data(req)->ino_map.elems;
+    memcpy(&elem->inode, inode, sizeof(struct lo_inode));
+    pthread_mutex_init(&elem->inode.plock_mutex, NULL);
+    elem->inode.posix_locks = g_hash_table_new_full(
+        g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
+    return elem;
 }
 
-static void lo_inode_put(struct lo_data *lo, struct lo_inode **inodep)
+static void lo_inode_put_nolock(struct lo_data *lo, struct lo_inode *inode)
 {
-    struct lo_inode *inode = *inodep;
-
     if (!inode) {
         return;
     }
 
-    *inodep = NULL;
-
-    if (g_atomic_int_dec_and_test(&inode->refcount)) {
-        close(inode->fd);
-        free(inode);
+    struct lo_map_elem *elem = container_of(inode, struct lo_map_elem, inode);
+    if (g_atomic_int_dec_and_test(&elem->refcount)) {
+        lo_map_remove(lo->maps[INO_MAP], inode->fuse_ino);
     }
 }
 
+static void lo_inode_put(struct lo_data *lo, struct lo_inode *inode)
+{
+    pthread_mutex_lock(&lo->mutex);
+    lo_inode_put_nolock(lo, inode);
+    pthread_mutex_unlock(&lo->mutex);
+}
+
 /* Caller must release refcount using lo_inode_put() */
 static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
 {
@@ -535,9 +614,9 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
     struct lo_map_elem *elem;
 
     pthread_mutex_lock(&lo->mutex);
-    elem = lo_map_get(&lo->ino_map, ino);
+    elem = lo_map_get(lo->maps[INO_MAP], ino);
     if (elem) {
-        g_atomic_int_inc(&elem->inode->refcount);
+        g_atomic_int_inc(&elem->refcount);
     }
     pthread_mutex_unlock(&lo->mutex);
 
@@ -545,7 +624,7 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
         return NULL;
     }
 
-    return elem->inode;
+    return &elem->inode;
 }
 
 /*
@@ -563,7 +642,7 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino)
     }
 
     fd = inode->fd;
-    lo_inode_put(lo_data(req), &inode);
+    lo_inode_put(lo_data(req), inode);
     return fd;
 }
 
@@ -636,7 +715,7 @@ static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
     struct lo_map_elem *elem;
 
     pthread_mutex_lock(&lo->mutex);
-    elem = lo_map_get(&lo->fd_map, fi->fh);
+    elem = lo_map_get(lo->maps[FD_MAP], fi->fh);
     pthread_mutex_unlock(&lo->mutex);
 
     if (!elem) {
@@ -743,13 +822,13 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
             goto out_err;
         }
     }
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
 
     return lo_getattr(req, ino, fi);
 
 out_err:
     saverr = errno;
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
     fuse_reply_err(req, saverr);
 }
 
@@ -768,7 +847,8 @@ static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
     if (p) {
         assert(p->nlookup > 0);
         p->nlookup++;
-        g_atomic_int_inc(&p->refcount);
+        struct lo_map_elem *elem = container_of(p, struct lo_map_elem, inode);
+        g_atomic_int_inc(&elem->refcount);
     }
     pthread_mutex_unlock(&lo->mutex);
 
@@ -871,7 +951,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
     e->entry_timeout = lo->timeout;
 
     /* Do not allow escaping root directory */
-    if (dir == &lo->root && strcmp(name, "..") == 0) {
+    if (dir == lo->root && strcmp(name, "..") == 0) {
         name = ".";
     }
 
@@ -903,12 +983,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         /* cache only filetype */
         inode->filetype = (e->attr.st_mode & S_IFMT);
 
-        /*
-         * One for the caller and one for nlookup (released in
-         * unref_inode_lolocked())
-         */
-        g_atomic_int_set(&inode->refcount, 2);
-
         inode->nlookup = 1;
         inode->fd = newfd;
         inode->key.ino = e->attr.st_ino;
@@ -918,14 +992,28 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         inode->posix_locks = g_hash_table_new_full(
             g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
 
+        struct lo_map_elem *elem;
         pthread_mutex_lock(&lo->mutex);
-        inode->fuse_ino = lo_add_inode_mapping(req, inode);
+        elem = lo_add_inode_mapping(req, inode);
+
+        /*
+         * One for the caller and one for nlookup (released in
+         * unref_inode_lolocked())
+         */
+        g_atomic_int_set(&elem->refcount, 2);
+
+        free(inode);
+        inode = &elem->inode;
+        inode->fuse_ino = ((unsigned long)elem -
+                        (unsigned long)lo_data(req)->maps[INO_MAP]->elems) /
+                                                sizeof(struct lo_map_elem);
+
         g_hash_table_insert(lo->inodes, &inode->key, inode);
         pthread_mutex_unlock(&lo->mutex);
     }
     e->ino = inode->fuse_ino;
-    lo_inode_put(lo, &inode);
-    lo_inode_put(lo, &dir);
+    lo_inode_put(lo, inode);
+    lo_inode_put(lo, dir);
 
     fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
              name, (unsigned long long)e->ino);
@@ -937,8 +1025,8 @@ out_err:
     if (newfd != -1) {
         close(newfd);
     }
-    lo_inode_put(lo, &inode);
-    lo_inode_put(lo, &dir);
+    lo_inode_put(lo, inode);
+    lo_inode_put(lo, dir);
     return saverr;
 }
 
@@ -1076,11 +1164,11 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
              name, (unsigned long long)e.ino);
 
     fuse_reply_entry(req, &e);
-    lo_inode_put(lo, &dir);
+    lo_inode_put(lo, dir);
     return;
 
 out:
-    lo_inode_put(lo, &dir);
+    lo_inode_put(lo, dir);
     fuse_reply_err(req, saverr);
 }
 
@@ -1132,6 +1220,7 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
     sprintf(procname, "%i", inode->fd);
     res = linkat(lo->proc_self_fd, procname, parent_inode->fd, name,
                  AT_SYMLINK_FOLLOW);
+
     if (res == -1) {
         goto out_err;
     }
@@ -1150,14 +1239,14 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
              name, (unsigned long long)e.ino);
 
     fuse_reply_entry(req, &e);
-    lo_inode_put(lo, &parent_inode);
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, parent_inode);
+    lo_inode_put(lo, inode);
     return;
 
 out_err:
     saverr = errno;
-    lo_inode_put(lo, &parent_inode);
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, parent_inode);
+    lo_inode_put(lo, inode);
     fuse_reply_err(req, saverr);
 }
 
@@ -1177,7 +1266,7 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
 
     res = do_statx(lo, dir->fd, name, &attr,
                    AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, &mnt_id);
-    lo_inode_put(lo, &dir);
+    lo_inode_put(lo, dir);
     if (res == -1) {
         return NULL;
     }
@@ -1206,7 +1295,7 @@ static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
 
     fuse_reply_err(req, res == -1 ? errno : 0);
     unref_inode_lolocked(lo, inode, 1);
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
 }
 
 static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
@@ -1261,10 +1350,10 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
 out:
     unref_inode_lolocked(lo, oldinode, 1);
     unref_inode_lolocked(lo, newinode, 1);
-    lo_inode_put(lo, &oldinode);
-    lo_inode_put(lo, &newinode);
-    lo_inode_put(lo, &parent_inode);
-    lo_inode_put(lo, &newparent_inode);
+    lo_inode_put(lo, oldinode);
+    lo_inode_put(lo, newinode);
+    lo_inode_put(lo, parent_inode);
+    lo_inode_put(lo, newparent_inode);
 }
 
 static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
@@ -1288,7 +1377,7 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
 
     fuse_reply_err(req, res == -1 ? errno : 0);
     unref_inode_lolocked(lo, inode, 1);
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
 }
 
 /* To be called with lo->mutex held */
@@ -1301,7 +1390,6 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
     assert(inode->nlookup >= n);
     inode->nlookup -= n;
     if (!inode->nlookup) {
-        lo_map_remove(&lo->ino_map, inode->fuse_ino);
         g_hash_table_remove(lo->inodes, &inode->key);
         if (g_hash_table_size(inode->posix_locks)) {
             fuse_log(FUSE_LOG_WARNING, "Hash table is not empty\n");
@@ -1310,7 +1398,7 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
         pthread_mutex_destroy(&inode->plock_mutex);
 
         /* Drop our refcount from lo_do_lookup() */
-        lo_inode_put(lo, &inode);
+        lo_inode_put_nolock(lo, inode);
     }
 }
 
@@ -1340,8 +1428,10 @@ static void lo_forget_one(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
              (unsigned long long)ino, (unsigned long long)inode->nlookup,
              (unsigned long long)nlookup);
 
-    unref_inode_lolocked(lo, inode, nlookup);
-    lo_inode_put(lo, &inode);
+    pthread_mutex_lock(&lo->mutex);
+    unref_inode(lo, inode, nlookup);
+    pthread_mutex_unlock(&lo->mutex);
+    lo_inode_put(lo, inode);
 }
 
 static void lo_forget(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
@@ -1380,25 +1470,17 @@ static void lo_readlink(fuse_req_t req, fuse_ino_t ino)
     fuse_reply_readlink(req, buf);
 }
 
-struct lo_dirp {
-    gint refcount;
-    DIR *dp;
-    struct dirent *entry;
-    off_t offset;
-};
-
-static void lo_dirp_put(struct lo_dirp **dp)
+static void lo_dirp_put(struct lo_dirp *d, ssize_t fh)
 {
-    struct lo_dirp *d = *dp;
-
     if (!d) {
         return;
     }
-    *dp = NULL;
 
-    if (g_atomic_int_dec_and_test(&d->refcount)) {
-        closedir(d->dp);
-        free(d);
+    struct lo_map_elem *elem = container_of(d, struct lo_map_elem, dirp);
+    if (g_atomic_int_dec_and_test(&elem->refcount)) {
+        pthread_mutex_lock(&lo.mutex);
+        lo_map_remove(lo.maps[DIRP_MAP], fh);
+        pthread_mutex_unlock(&lo.mutex);
     }
 }
 
@@ -1409,16 +1491,16 @@ static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *fi)
     struct lo_map_elem *elem;
 
     pthread_mutex_lock(&lo->mutex);
-    elem = lo_map_get(&lo->dirp_map, fi->fh);
+    elem = lo_map_get(lo->maps[DIRP_MAP], fi->fh);
     if (elem) {
-        g_atomic_int_inc(&elem->dirp->refcount);
+        g_atomic_int_inc(&elem->refcount);
     }
     pthread_mutex_unlock(&lo->mutex);
     if (!elem) {
         return NULL;
     }
 
-    return elem->dirp;
+    return &elem->dirp;
 }
 
 static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
@@ -1435,12 +1517,15 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
         goto out_err;
     }
 
-    fd = openat(lo_fd(req, ino), ".", O_RDONLY);
+    int to_open_fd = lo_fd(req, ino);
+    fd = openat(to_open_fd, ".", O_RDONLY);
+
     if (fd == -1) {
         goto out_errno;
     }
 
     d->dp = fdopendir(fd);
+    d->fd = dirfd(d->dp);
     if (d->dp == NULL) {
         goto out_errno;
     }
@@ -1448,18 +1533,24 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
     d->offset = 0;
     d->entry = NULL;
 
-    g_atomic_int_set(&d->refcount, 1); /* paired with lo_releasedir() */
+    struct lo_map_elem *elem;
     pthread_mutex_lock(&lo->mutex);
-    fh = lo_add_dirp_mapping(req, d);
-    pthread_mutex_unlock(&lo->mutex);
-    if (fh == -1) {
+    elem = lo_add_dirp_mapping(req, d);
+    if (!elem) {
         goto out_err;
     }
 
+    free(d);
+    d = &elem->dirp;
+    fh = ((unsigned long)elem -
+          (unsigned long)&lo_data(req)->maps[DIRP_MAP]->elems[0]) /
+          sizeof(struct lo_map_elem);
     fi->fh = fh;
     if (lo->cache == CACHE_ALWAYS) {
         fi->cache_readdir = 1;
     }
+    g_atomic_int_set(&elem->refcount, 1); /* paired with lo_releasedir() */
+    pthread_mutex_unlock(&lo->mutex);
     fuse_reply_open(req, fi);
     return;
 
@@ -1472,8 +1563,8 @@ out_err:
         } else if (fd != -1) {
             close(fd);
         }
-        free(d);
     }
+    pthread_mutex_unlock(&lo->mutex);
     fuse_reply_err(req, error);
 }
 
@@ -1537,8 +1628,8 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
         };
 
         /* Hide root's parent directory */
-        if (dinode == &lo->root && strcmp(name, "..") == 0) {
-            e.attr.st_ino = lo->root.key.ino;
+        if (dinode == lo->root && strcmp(name, "..") == 0) {
+            e.attr.st_ino = lo->root->key.ino;
             e.attr.st_mode = DT_DIR << 12;
         }
 
@@ -1571,8 +1662,8 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
 
     err = 0;
 error:
-    lo_dirp_put(&d);
-    lo_inode_put(lo, &dinode);
+    lo_dirp_put(d, fi->fh);
+    lo_inode_put(lo, dinode);
 
     /*
      * If there's an error, we can only signal it if we haven't stored
@@ -1610,18 +1701,17 @@ static void lo_releasedir(fuse_req_t req, fuse_ino_t ino,
     (void)ino;
 
     pthread_mutex_lock(&lo->mutex);
-    elem = lo_map_get(&lo->dirp_map, fi->fh);
+    elem = lo_map_get(lo->maps[DIRP_MAP], fi->fh);
     if (!elem) {
         pthread_mutex_unlock(&lo->mutex);
         fuse_reply_err(req, EBADF);
         return;
     }
 
-    d = elem->dirp;
-    lo_map_remove(&lo->dirp_map, fi->fh);
+    d = &elem->dirp;
     pthread_mutex_unlock(&lo->mutex);
 
-    lo_dirp_put(&d); /* paired with lo_opendir() */
+    lo_dirp_put(d, fi->fh); /* paired with lo_opendir() */
 
     fuse_reply_err(req, 0);
 }
@@ -1719,7 +1809,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
     }
 
 out:
-    lo_inode_put(lo, &parent_inode);
+    lo_inode_put(lo, parent_inode);
 
     if (err) {
         fuse_reply_err(req, err);
@@ -1805,7 +1895,7 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
 
 out:
     pthread_mutex_unlock(&inode->plock_mutex);
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
 
     if (saverr) {
         fuse_reply_err(req, saverr);
@@ -1858,7 +1948,7 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
 
 out:
     pthread_mutex_unlock(&inode->plock_mutex);
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
 
     fuse_reply_err(req, saverr);
 }
@@ -1885,7 +1975,7 @@ static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
         res = fsync(fd);
     }
 
-    lo_dirp_put(&d);
+    lo_dirp_put(d, fi->fh);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
 }
@@ -1931,20 +2021,16 @@ static void lo_release(fuse_req_t req, fuse_ino_t ino,
 {
     struct lo_data *lo = lo_data(req);
     struct lo_map_elem *elem;
-    int fd = -1;
 
     (void)ino;
 
     pthread_mutex_lock(&lo->mutex);
-    elem = lo_map_get(&lo->fd_map, fi->fh);
+    elem = lo_map_get(lo->maps[FD_MAP], fi->fh);
     if (elem) {
-        fd = elem->fd;
-        elem = NULL;
-        lo_map_remove(&lo->fd_map, fi->fh);
+        lo_map_remove(lo->maps[FD_MAP], fi->fh);
     }
     pthread_mutex_unlock(&lo->mutex);
 
-    close(fd);
     fuse_reply_err(req, 0);
 }
 
@@ -1966,7 +2052,7 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
     pthread_mutex_unlock(&inode->plock_mutex);
 
     res = close(dup(lo_fi_fd(req, fi)));
-    lo_inode_put(lo_data(req), &inode);
+    lo_inode_put(lo_data(req), inode);
     fuse_reply_err(req, res == -1 ? errno : 0);
 }
 
@@ -2529,7 +2615,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         /* fchdir should not fail here */
         assert(fchdir(lo->proc_self_fd) == 0);
         ret = getxattr(procname, name, value, size);
-        assert(fchdir(lo->root.fd) == 0);
+        assert(fchdir(lo->root->fd) == 0);
     }
 
     if (ret == -1) {
@@ -2551,7 +2637,7 @@ out_free:
         close(fd);
     }
 
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
     return;
 
 out_err:
@@ -2604,7 +2690,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         /* fchdir should not fail here */
         assert(fchdir(lo->proc_self_fd) == 0);
         ret = listxattr(procname, value, size);
-        assert(fchdir(lo->root.fd) == 0);
+        assert(fchdir(lo->root->fd) == 0);
     }
 
     if (ret == -1) {
@@ -2678,7 +2764,7 @@ out_free:
         close(fd);
     }
 
-    lo_inode_put(lo, &inode);
+    lo_inode_put(lo, inode);
     return;
 
 out_err:
@@ -2740,7 +2826,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         /* fchdir should not fail here */
         assert(fchdir(lo->proc_self_fd) == 0);
         ret = setxattr(procname, name, value, size, flags);
-        assert(fchdir(lo->root.fd) == 0);
+        assert(fchdir(lo->root->fd) == 0);
     }
 
     saverr = ret == -1 ? errno : 0;
@@ -2750,8 +2836,8 @@ out:
         close(fd);
     }
 
-    lo_inode_put(lo, &inode);
     g_free(mapped_name);
+    lo_inode_put(lo, inode);
     fuse_reply_err(req, saverr);
 }
 
@@ -2806,7 +2892,7 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
         /* fchdir should not fail here */
         assert(fchdir(lo->proc_self_fd) == 0);
         ret = removexattr(procname, name);
-        assert(fchdir(lo->root.fd) == 0);
+        assert(fchdir(lo->root->fd) == 0);
     }
 
     saverr = ret == -1 ? errno : 0;
@@ -2816,8 +2902,8 @@ out:
         close(fd);
     }
 
-    lo_inode_put(lo, &inode);
     g_free(mapped_name);
+    lo_inode_put(lo, inode);
     fuse_reply_err(req, saverr);
 }
 
@@ -3371,7 +3457,8 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
     root->key.dev = stat.st_dev;
     root->key.mnt_id = mnt_id;
     root->nlookup = 2;
-    g_atomic_int_set(&root->refcount, 2);
+    struct lo_map_elem *elem = container_of(root, struct lo_map_elem, inode);
+    g_atomic_int_set(&elem->refcount, 2);
 }
 
 static guint lo_key_hash(gconstpointer key)
@@ -3394,16 +3481,17 @@ static void fuse_lo_data_cleanup(struct lo_data *lo)
     if (lo->inodes) {
         g_hash_table_destroy(lo->inodes);
     }
-    lo_map_destroy(&lo->fd_map);
-    lo_map_destroy(&lo->dirp_map);
-    lo_map_destroy(&lo->ino_map);
 
-    if (lo->proc_self_fd >= 0) {
-        close(lo->proc_self_fd);
+    if (lo->root->fd >= 0) {
+        close(lo->root->fd);
     }
 
-    if (lo->root.fd >= 0) {
-        close(lo->root.fd);
+    lo_map_destroy(FD_MAP);
+    lo_map_destroy(DIRP_MAP);
+    lo_map_destroy(INO_MAP);
+
+    if (lo->proc_self_fd >= 0) {
+        close(lo->proc_self_fd);
     }
 
     free(lo->xattrmap);
@@ -3416,18 +3504,17 @@ int main(int argc, char *argv[])
     struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
     struct fuse_session *se;
     struct fuse_cmdline_opts opts;
-    struct lo_data lo = {
-        .sandbox = SANDBOX_NAMESPACE,
-        .debug = 0,
-        .writeback = 0,
-        .posix_lock = 0,
-        .allow_direct_io = 0,
-        .proc_self_fd = -1,
-    };
     struct lo_map_elem *root_elem;
     struct lo_map_elem *reserve_elem;
     int ret = -1;
 
+    lo.sandbox = SANDBOX_NAMESPACE,
+    lo.debug = 0;
+    lo.writeback = 0;
+    lo.posix_lock = 1;
+    lo.allow_direct_io = 0,
+    lo.proc_self_fd = -1;
+
     /* Don't mask creation mode, kernel already did that */
     umask(0);
 
@@ -3435,8 +3522,6 @@ int main(int argc, char *argv[])
 
     pthread_mutex_init(&lo.mutex, NULL);
     lo.inodes = g_hash_table_new(lo_key_hash, lo_key_equal);
-    lo.root.fd = -1;
-    lo.root.fuse_ino = FUSE_ROOT_ID;
     lo.cache = CACHE_AUTO;
 
     /*
@@ -3444,22 +3529,23 @@ int main(int argc, char *argv[])
      * [0] Reserved (will not be used)
      * [1] Root inode
      */
-    lo_map_init(&lo.ino_map);
-    reserve_elem = lo_map_reserve(&lo.ino_map, 0);
+    lo_map_init(FD_MAP);
+    lo_map_init(INO_MAP);
+    reserve_elem = lo_map_reserve(INO_MAP, 0);
     if (!reserve_elem) {
         fuse_log(FUSE_LOG_ERR, "failed to alloc reserve_elem.\n");
         goto err_out1;
     }
-    reserve_elem->in_use = false;
-    root_elem = lo_map_reserve(&lo.ino_map, lo.root.fuse_ino);
+    root_elem = lo_map_reserve(INO_MAP, FUSE_ROOT_ID);
     if (!root_elem) {
         fuse_log(FUSE_LOG_ERR, "failed to alloc root_elem.\n");
         goto err_out1;
     }
-    root_elem->inode = &lo.root;
-
-    lo_map_init(&lo.dirp_map);
-    lo_map_init(&lo.fd_map);
+    lo.root = &root_elem->inode;
+    pthread_mutex_init(&lo.root->plock_mutex, NULL);
+    lo.root->fd = -1;
+    lo.root->fuse_ino = FUSE_ROOT_ID;
+    lo_map_init(DIRP_MAP);
 
     if (fuse_parse_cmdline(&args, &opts) != 0) {
         goto err_out1;
@@ -3570,7 +3656,7 @@ int main(int argc, char *argv[])
 
     setup_sandbox(&lo, se, opts.syslog);
 
-    setup_root(&lo, &lo.root);
+    setup_root(&lo, lo.root);
     /* Block until ctrl+c or fusermount -u */
     ret = virtio_loop(se);
 
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index 11623f56f2..3a0dc60f73 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -115,6 +115,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(utimensat),
     SCMP_SYS(write),
     SCMP_SYS(writev),
+    SCMP_SYS(memfd_create),
 };
 
 /* Syscalls used when --syslog is enabled */
-- 
2.20.1

