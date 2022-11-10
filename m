Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=S71uA1qqGC/6TbeUsoWwC8+Ke/IgKE6MHXg9S63X/NM=;
 b=SvdcrHY2llLs4WZ3DvA/ncziaTqbJB351OtwHnPQwOYmURQ8NlIRyreRtXb/DesUKz
 PdCHpes9TJ23o6WK6f/3o7tpq3e6NK1B9FM5nrdRbDhGOf+VvkFH5ZRAtH0HL5I8amaz
 OWuN8NeilWMFejjIupDvX4e6kyHQj9vS2Kjdu7u7VMC7PbOF7UbMUn7Y0aOeul9+oRcg
 HcjzOHQoOJJe5S6Ld0XRHyP2V4qeP6hfj04Q6ub0Zv+ge5R5uEl9DCP8bwgbji+dH+0h
 DZ+CqHbtgVrxDZDCwLKzimc6BUCC62u9+4r9wUuifusx8LO1kvdNzeMfBL50A7pUHhj1
 i99Q==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 15:23:20 +0900
Message-Id: <20221110062329.13363-2-akihiko.odaki@daynix.com>
In-Reply-To: <20221110062329.13363-1-akihiko.odaki@daynix.com>
References: <20221110062329.13363-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH 01/10] qga: Remove platform GUID definitions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

GUID_DEVINTERFACE_DISK and GUID_DEVINTERFACE_STORAGEPORT are already
defined by MinGW-w64. They are not only unnecessary, but can lead to
duplicate definition errors at link time with some unknown condition.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 qga/commands-win32.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/qga/commands-win32.c b/qga/commands-win32.c
index ec9f55b453..dde5d401bb 100644
--- a/qga/commands-win32.c
+++ b/qga/commands-win32.c
@@ -506,13 +506,6 @@ static GuestDiskBusType find_bus_type(STORAGE_BUS_TYPE bus)
     return win2qemu[(int)bus];
 }
 
-DEFINE_GUID(GUID_DEVINTERFACE_DISK,
-        0x53f56307L, 0xb6bf, 0x11d0, 0x94, 0xf2,
-        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
-DEFINE_GUID(GUID_DEVINTERFACE_STORAGEPORT,
-        0x2accfe60L, 0xc130, 0x11d2, 0xb0, 0x82,
-        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
-
 static void get_pci_address_for_device(GuestPCIAddress *pci,
                                        HDEVINFO dev_info)
 {
-- 
2.38.1

