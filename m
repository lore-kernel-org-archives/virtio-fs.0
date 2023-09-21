Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695282907; x=1695887707;
 darn=redhat.com; 
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+WqIB3gVUWoV5tx6z3hTNmJPFl9aZDKmRqWqmbRKnMA=;
 b=SuudaWJhJFp+JnKEI4g0X7aluCUzOvdV0eNRM6Bqx8Cr0Dcu6v96iiCFH0nz5e33rf
 2FODbOXc+AFOPxSCqbzwdxdSAvu3rjQ6V6OLlSntNpo20DMbsPkMfuNi1a40NLn19Kkk
 l7BUTIiF9Vt4wKx+8g/VwXFdVhPX4r8mVTHtq5z4wgMVzllVWTdQK3zT4Q0GuOq6Gikv
 Y/Adf6bW5DBjVqG+lXm3ZWt7oZ9Ch0mSbtGyv6bnUoO85EnznVznSzMyD+aKJQBi6F7d
 pGhPxgqY4f42asO63mewUCGreoG38t78YSRqeaJGx5TK1i7FogjrdVjEmwEDo6oOa9aM
 Ptew==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 21 Sep 2023 16:54:19 +0900
Message-ID: <20230921075425.16738-6-akihiko.odaki@daynix.com>
In-Reply-To: <20230921075425.16738-1-akihiko.odaki@daynix.com>
References: <20230921075425.16738-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v3 5/8] scsi: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() is used to construct the default paths.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 scsi/qemu-pr-helper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scsi/qemu-pr-helper.c b/scsi/qemu-pr-helper.c
index c6c6347e9b..507f23357f 100644
--- a/scsi/qemu-pr-helper.c
+++ b/scsi/qemu-pr-helper.c
@@ -77,10 +77,10 @@ static int gid = -1;
 
 static void compute_default_paths(void)
 {
-    g_autofree char *state = qemu_get_local_state_dir();
+    g_autofree char *run = qemu_get_runtime_dir();
 
-    socket_path = g_build_filename(state, "run", "qemu-pr-helper.sock", NULL);
-    pidfile = g_build_filename(state, "run", "qemu-pr-helper.pid", NULL);
+    socket_path = g_build_filename(run, "qemu-pr-helper.sock", NULL);
+    pidfile = g_build_filename(run, "qemu-pr-helper.pid", NULL);
 }
 
 static void usage(const char *name)
-- 
2.41.0

