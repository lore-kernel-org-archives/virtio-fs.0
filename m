Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=djQvtbI+5ceah01/E9QXrKDRfdUAtdLN189JgwjzOBQ=;
 b=X7619O6+AdiYwxaT+Q0YWH3poE/y/5bmr5FbkZZd/9sZtKl7M659hX3aOJebhv1yTg
 H24CA6PMegkFkfvXIwXlHtTpNP8NvBiWrUgupsUQHROjhWIqwIKofkIvFdxZh70Blvb1
 YWiHSdSUYGoF3Bmy0h0ajrO4vFrCoaA2KdAj4GWdhiiv8UUmjE74DZ1D59Ky1DnOEZ1L
 jmoBy5AgGa5mu5ZXXi1UuIDb2Cb6zoLaaR7c8O+dJxsb1uBqRnr6Ov+oWigM6Gy9o7wV
 AEV7MG1l1f0FyGRkWf1XFzlpaUhwZ1c9fW4z83U9B8MGTHOIahkADiJBqA19/WsUn2sT
 3/qQ==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 19:06:28 +0900
Message-Id: <20221110100629.61496-10-akihiko.odaki@daynix.com>
In-Reply-To: <20221110100629.61496-1-akihiko.odaki@daynix.com>
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v2 09/10] util: Remove qemu_get_local_state_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

There are no users of the function anymore.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 include/qemu/osdep.h |  8 --------
 util/oslib-posix.c   |  6 ------
 util/oslib-win32.c   | 10 ----------
 3 files changed, 24 deletions(-)

diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index 86445aad25..f21ebf2b27 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -557,14 +557,6 @@ ssize_t qemu_write_full(int fd, const void *buf, size_t count)
 
 void qemu_set_cloexec(int fd);
 
-/* Return a dynamically allocated directory path that is appropriate for storing
- * local state.
- *
- * The caller is responsible for releasing the value returned with g_free()
- * after use.
- */
-char *qemu_get_local_state_dir(void);
-
 /**
  * qemu_get_runtime_dir:
  *
diff --git a/util/oslib-posix.c b/util/oslib-posix.c
index 9a0b3913ff..b8d79876b2 100644
--- a/util/oslib-posix.c
+++ b/util/oslib-posix.c
@@ -273,12 +273,6 @@ int qemu_socketpair(int domain, int type, int protocol, int sv[2])
     return ret;
 }
 
-char *
-qemu_get_local_state_dir(void)
-{
-    return get_relocated_path(CONFIG_QEMU_LOCALSTATEDIR);
-}
-
 char *
 qemu_get_runtime_dir(void)
 {
diff --git a/util/oslib-win32.c b/util/oslib-win32.c
index 6ad1bb4bac..a32cc5b1be 100644
--- a/util/oslib-win32.c
+++ b/util/oslib-win32.c
@@ -233,16 +233,6 @@ int qemu_get_thread_id(void)
     return GetCurrentThreadId();
 }
 
-char *
-qemu_get_local_state_dir(void)
-{
-    const char * const *data_dirs = g_get_system_data_dirs();
-
-    g_assert(data_dirs && data_dirs[0]);
-
-    return g_strdup(data_dirs[0]);
-}
-
 char *
 qemu_get_runtime_dir(void)
 {
-- 
2.38.1

