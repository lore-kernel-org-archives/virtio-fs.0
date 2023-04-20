Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 20 Apr 2023 08:09:38 -0400
Message-Id: <20230420120948.436661-11-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 10/20] tracetool: use relative paths for '#line'
 preprocessor directives
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, Aarushi Mehta <mehta.aaru20@gmail.com>, Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>

From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>

The event filename is an absolute path. Convert it to a relative path when
writing '#line' directives, to preserve reproducibility of the generated
output when different base paths are used.

Signed-off-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20230406080045.21696-1-thomas.de_schampheleire@nokia.com>
---
 scripts/tracetool/backend/ftrace.py | 4 +++-
 scripts/tracetool/backend/log.py    | 4 +++-
 scripts/tracetool/backend/syslog.py | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/tracetool/backend/ftrace.py b/scripts/tracetool/backend/ftrace.py
index 5fa30ccc08..baed2ae61c 100644
--- a/scripts/tracetool/backend/ftrace.py
+++ b/scripts/tracetool/backend/ftrace.py
@@ -12,6 +12,8 @@
 __email__      = "stefanha@redhat.com"
 
 
+import os.path
+
 from tracetool import out
 
 
@@ -45,7 +47,7 @@ def generate_h(event, group):
         args=event.args,
         event_id="TRACE_" + event.name.upper(),
         event_lineno=event.lineno,
-        event_filename=event.filename,
+        event_filename=os.path.relpath(event.filename),
         fmt=event.fmt.rstrip("\n"),
         argnames=argnames)
 
diff --git a/scripts/tracetool/backend/log.py b/scripts/tracetool/backend/log.py
index 17ba1cd90e..de27b7e62e 100644
--- a/scripts/tracetool/backend/log.py
+++ b/scripts/tracetool/backend/log.py
@@ -12,6 +12,8 @@
 __email__      = "stefanha@redhat.com"
 
 
+import os.path
+
 from tracetool import out
 
 
@@ -53,7 +55,7 @@ def generate_h(event, group):
         '    }',
         cond=cond,
         event_lineno=event.lineno,
-        event_filename=event.filename,
+        event_filename=os.path.relpath(event.filename),
         name=event.name,
         fmt=event.fmt.rstrip("\n"),
         argnames=argnames)
diff --git a/scripts/tracetool/backend/syslog.py b/scripts/tracetool/backend/syslog.py
index 5a3a00fe31..012970f6cc 100644
--- a/scripts/tracetool/backend/syslog.py
+++ b/scripts/tracetool/backend/syslog.py
@@ -12,6 +12,8 @@
 __email__      = "stefanha@redhat.com"
 
 
+import os.path
+
 from tracetool import out
 
 
@@ -41,7 +43,7 @@ def generate_h(event, group):
         '    }',
         cond=cond,
         event_lineno=event.lineno,
-        event_filename=event.filename,
+        event_filename=os.path.relpath(event.filename),
         name=event.name,
         fmt=event.fmt.rstrip("\n"),
         argnames=argnames)
-- 
2.39.2

