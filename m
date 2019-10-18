DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=radoMH9HglozDYWtNSK4VZSqX5rJ+59zw/qiExojl3s=;
	b=QyO4YUL7QWOMvG/7Zg0IuMWVTg+AhvCswGmQjppoEyUHDmoG30Al0EYPP3ez4+Lf67
	5Xd6LQ00VpMylbyrYY/r7rtOKpmZGG21B2XIlgGIPlscB7+0iHUn2o2R3BPQm+Dagsd3
	OeqQX3zzqH1tLOBmHKwHeFN1xpJJXpW4jhPfnbzXFt/Pv+l1oCz1bK6H2j6i+GxE2OOa
	f6q01bteBR5FRRY8vs/0Fv0gUjznFThWQA6rVwAmBjdVbmuJwHLN6/q1GFN51ZtSZUS4
	DR0xdd6MYzSD+RccZWj12dQmEvXHjvDGdoW3CZBLffm4srO3esKlIPqnOoJwP2Y/fISB
	vSqQ==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Fri, 18 Oct 2019 15:08:03 -0400
Message-Id: <20191018190803.7448-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: Add clock_gettime() to seccomp white
	list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

virtiofsd receives SIGSYS signal while qemu is shutting down.

  ]# ./virtiofsd -d -o vhost_user_socket=/tmp/vhostqemu0 \
     -o source=/tmp/share0 -o cache=auto
  ...
  virtio_send_msg: elem 0: with 1 in desc of length 16
  virtio_loop: Got VU event
  fv_queue_set_started: qidx=0 started=0
  fv_queue_thread: kill event on queue 0 - quitting
  fv_remove_watch: TODO! fd=9
  virtio_loop: Waiting for VU event
  Bad system call (core dumped)
  ]#

That is because virtiofsd calls clock_gettime() via glib
function and clock_gettime() isn't in seccomp white list,
so virtiofsd receives SIGSYS.
The glib function is called to manage the pool thread.
The calltrace is like as:

  #0  clock_gettime ()
  #1  g_get_monotonic_time ()
  #2  g_async_queue_timeout_pop ()
  #3  g_thread_pool_wait_for_new_pool ()
  #4  g_thread_pool_thread_proxy ()
  #5  g_thread_proxy ()
  #6  start_thread ()
  #7  clone ()

Add clock_gettime() to seccomp white list.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 contrib/virtiofsd/seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index f815ea5bf9..b78056b13f 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -19,6 +19,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(brk),
     SCMP_SYS(capget), /* For CAP_FSETID */
     SCMP_SYS(capset),
+    SCMP_SYS(clock_gettime),
     SCMP_SYS(clone),
     SCMP_SYS(close),
     SCMP_SYS(copy_file_range),
-- 
2.18.1

