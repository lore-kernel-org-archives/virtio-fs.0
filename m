Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695282916; x=1695887716;
 darn=redhat.com; 
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=BwxdqCjoYRjwt5W3IBIll6piBuHczsH0wiYwmGYAieo=;
 b=MBltuBDUq0FB0AwLzQyH7vr76HRNrct4fdVYjU7LIVYqht79JHeTYuOnmiucydgV9J
 jPh3wjmidDzV3TT5dpDfgzdGwaRTcMSLJF1vP2rluaDwcZpvYLHFibz1Fca2Gu7cToVz
 0MixuplxM8Kxj4mfcAqc/JdOo7nPI11DJM9YT2pDGQkW53bOaOOMzWwbits3Zj8Dm30Y
 LWGigHw1lrOmHNsMyqaoLn0wPDZla+lYvXQ19943JhJ96hr5/0vEBFI6OIY1+FVt7AUr
 7+qLZYQX23sQZAPBeQaa6T3Ripfz4I0izclgGeq+tLyksKIjztecFrOwWi5rp/deKBcq
 m18w==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 21 Sep 2023 16:54:21 +0900
Message-ID: <20230921075425.16738-8-akihiko.odaki@daynix.com>
In-Reply-To: <20230921075425.16738-1-akihiko.odaki@daynix.com>
References: <20230921075425.16738-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v3 7/8] util: Remove qemu_get_local_state_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

There are no users of the function anymore.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 include/qemu/osdep.h |  8 --------
 util/oslib-posix.c   |  6 ------
 util/oslib-win32.c   | 10 ----------
 3 files changed, 24 deletions(-)

diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index bb857c910f..cc585447ef 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -628,14 +628,6 @@ ssize_t qemu_write_full(int fd, const void *buf, size_t count)
 
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
index 0c82717be5..f3054ad2cd 100644
--- a/util/oslib-posix.c
+++ b/util/oslib-posix.c
@@ -267,12 +267,6 @@ int qemu_socketpair(int domain, int type, int protocol, int sv[2])
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
index 38df7b57b5..f93c3bff8e 100644
--- a/util/oslib-win32.c
+++ b/util/oslib-win32.c
@@ -229,16 +229,6 @@ int qemu_get_thread_id(void)
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
2.41.0

