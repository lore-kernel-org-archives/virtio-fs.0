DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=mcXxcb9+BrDnmN1xe+1DXWOQNYMVPPd4PSVdpoKGR64=;
	b=nkP214E7hEWlsybNSfbCO+e3yEj2bvcbsWAil283WyUEtQmh4waLDT1FEkU5aZkjoH
	CMrawoxgWi6zagzbPtLesswZAZpgPE+coqMt7fsEEaEckQMbZOTuTIAy8azGip29vvAg
	+QTZ3V4a2BiI8gDkFa4nJiOnxsw9+/+K0+kO3pxzhW9sUecg07GraGUFFdpZcY/vOU81
	YdElWct6u6UjMgupAX6lLc57bL/mWAmskYSrTxzwxiq3AZBaI7dW62YDshIJIq6+ma/m
	11eWu/npsyriR3Lb3keKlk1SmLnmXlNNWBAyOG5rNNwvHr4nTfmhs/4R2FlPCPv3wDDA
	Z9Og==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Tue, 30 Jul 2019 17:50:00 -0400
Message-Id: <20190730215000.15660-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: Add gettimeofday to the seccomp
	whitelist
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

When I run fsstress on the virtio filesystem, virtiofsd sometimes
exits abnormally because it receives SIGSYS.

>From strace:
  195852 15:07:47.799331 read(8, "\1\0\0\0\0\0\0\0", 8) = 8 <0.000011>
  195852 15:07:47.799379 gettimeofday( <unfinished ...>
  195852 15:07:53.354340 <... gettimeofday resumed> <unfinished ...>) = ?
  195852 15:07:53.400243 +++ killed by SIGSYS (core dumped) +++

That is because virtiofsd calls gettimeofday() system call but
the system call isn't in the seccomp whitelist.

virtiofsd doesn't call gettimeofday() directly. glib library
function may call g_get_current_time() and g_get_current_time()
calls the system call.

Add gettimeofday() to the seccomp whitelist.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 contrib/virtiofsd/seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index ffb9f4c..cea4cc5 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -44,6 +44,7 @@ static const int syscall_whitelist[] = {
 	SCMP_SYS(geteuid),
 	SCMP_SYS(getpid),
 	SCMP_SYS(gettid),
+	SCMP_SYS(gettimeofday),
 	SCMP_SYS(linkat),
 	SCMP_SYS(lseek),
 	SCMP_SYS(madvise),
-- 
2.18.1

