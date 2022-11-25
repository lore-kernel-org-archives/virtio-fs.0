Return-Path: <mhartmay@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4KsWE9zzs0hf6f7CsWPNjjvXaflZNjZ14dxEJ23gbFY=;
 b=TUd9JjUTANaQlkXewVe86jDc/c72El2CG7KjUJk3g3B5jvppoHtjWEmUhzRMr6SviI4a
 5uZsFpBrpxWIqhw1qX2S+y8+nTblJegqcsSP2DLhSYQ3v7GmtvQ2sCWWejZ1GQ0Jjt/E
 Oio3D7JoqM7VgF07SB/TivHMjthK8uNiAA/lTfUiA7NuqMPNf91bYhUXjVDcSRvKnMCm
 OnZjdRXQXVxyQMpos8orU5wNUvg5U0tA0fE43xR0yyDa6HE3drFHNE0n38eMWu1xF5Tq
 E0bdo0wzwtC/4REUpe8nNg0OskVXpDZt3G8G3HObJ8O92ECn92+QHwV4KvaDGeVjKQsy jA==
From: Marc Hartmayer <mhartmay@linux.ibm.com>
Date: Fri, 25 Nov 2022 15:39:46 +0100
Message-Id: <20221125143946.27717-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH] virtiofsd: Add `sigreturn` to the seccomp
 whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

The virtiofsd currently crashes on s390x. This is because of a
`sigreturn` system call. See audit log below:

type=SECCOMP msg=audit(1669382477.611:459): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:virtd_t:s0-s0:c0.c1023 pid=6649 comm="virtiofsd" exe="/usr/libexec/virtiofsd" sig=31 arch=80000016 syscall=119 compat=0 ip=0x3fff15f748a code=0x80000000AUID="unset" UID="root" GID="root" ARCH=s390x SYSCALL=sigreturn

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 tools/virtiofsd/passthrough_seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index 888295c073de..0033dab4939e 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -110,6 +110,7 @@ static const int syscall_allowlist[] = {
 #endif
     SCMP_SYS(set_robust_list),
     SCMP_SYS(setxattr),
+    SCMP_SYS(sigreturn),
     SCMP_SYS(symlinkat),
     SCMP_SYS(syncfs),
     SCMP_SYS(time), /* Rarely needed, except on static builds */
-- 
2.34.1

