Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=Z3a+uika0IuKJSzenVXCbwEeRP8jHQz1XjaRHlAccWc=;
 b=3J0mI99k88V6+rgMqq+qNiEIY4rKvJtS40pQb3MeWVpaW8r81XOqhs8EhH8U7K7U7B
 XIfXtE8bDSu8m+B5vAQcgCwmNjHzud4bFze8yP0rk+7HWnMMM9kzu84AtQ+xoX+8awFh
 rFswlS+eGrpSJ8cYUn9Mal0EetquY5+7LdJFAsD806Y91fQTyIIuCXlzjyXgPDlWVB/X
 M48TMYMVMAZRbD5LWbtp2Hx981Zfx128Tw+RSl2BHC28v2oY3hFBEFgX+/z5KcTen0n6
 ObmYKd5Z7JeJaj5jk6PbxbIqGigrh1dnl2UX0bITtOsJW2CX2Djj+UiKT3R56ovTsRvh
 unvg==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 15:23:19 +0900
Message-Id: <20221110062329.13363-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH 00/10] util: Introduce qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() returns a dynamically allocated directory path
that is appropriate for storing runtime files. It corresponds to "run"
directory in Unix.

With a tree-wide search, it was found that there are several cases
where such a functionality is implemented so let's have one as a common
utlity function.

A notable feature of qemu_get_runtime_dir() is that it uses
$XDG_RUNTIME_DIR if available. While the function is often called by
executables which requires root privileges, it is still possible that
they are called from a user without privilege to write the system
runtime directory. In fact, I decided to write this patch when I ran
virtiofsd in a Linux namespace created by a normal user and realized
it tries to write the system runtime directory, not writable in this
case. $XDG_RUNTIME_DIR should provide a writable directory in such
cases.

This function does not use qemu_get_local_state_dir() or its logic
for Windows. Actually the implementation of qemu_get_local_state_dir()
for Windows seems not right as it calls g_get_system_data_dirs(),
which refers to $XDG_DATA_DIRS. In Unix terminology, it is basically
"/usr/share", not "/var", which qemu_get_local_state_dir() is intended
to provide. Instead, this function try to use the following in order:
- $XDG_RUNTIME_DIR
- LocalAppData folder
- get_relocated_path(CONFIG_QEMU_LOCALSTATEDIR "/run")

This function does not use g_get_user_runtime_dir() either as it
falls back to g_get_user_cache_dir() when $XDG_DATA_DIRS is not
available. In the case, we rather use:
get_relocated_path(CONFIG_QEMU_LOCALSTATEDIR "/run")

Akihiko Odaki (10):
  qga: Remove platform GUID definitions
  util: Introduce qemu_get_runtime_dir()
  ivshmem-server: Use qemu_get_runtime_dir()
  contrib/rdmacm-mux: Use qemu_get_runtime_dir()
  qga: Use qemu_get_runtime_dir()
  scsi: Use qemu_get_runtime_dir()
  virtiofsd: Use qemu_get_runtime_dir()
  module: Use qemu_get_runtime_dir()
  util: Remove qemu_get_local_state_dir()
  spice-app: Use qemu_get_runtime_dir()

 include/qemu/osdep.h           | 10 +++++++---
 contrib/ivshmem-server/main.c  | 20 ++++++++++++++++----
 contrib/rdmacm-mux/main.c      | 22 ++++++++++++++--------
 qga/commands-win32.c           |  7 -------
 qga/main.c                     |  9 ++++-----
 scsi/qemu-pr-helper.c          |  6 +++---
 tools/virtiofsd/fuse_virtio.c  |  6 +++---
 ui/spice-app.c                 |  4 ++--
 util/module.c                  |  3 ++-
 util/oslib-posix.c             |  9 +++++++--
 util/oslib-win32.c             | 24 ++++++++++++++++++++----
 contrib/rdmacm-mux/meson.build |  2 +-
 12 files changed, 79 insertions(+), 43 deletions(-)

-- 
2.38.1

