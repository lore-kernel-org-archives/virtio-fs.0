Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695283112; x=1695887912;
 darn=redhat.com; 
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=3DrpI+ZHGjv2FRmLG9rSaZtdD/DlF4umIrUK5n93qbQ=;
 b=ZLq8vULlWmXAd5GXLmDjz6Om5XnvivKOT2rwDi3pMq35vFawKSkL7LSu9ECmzLxTgy
 Kn4ymwQoLh5G5vngJ0QSylUXiHApZ8INvmwkfbxHYb1MASL+OwYqfbTy4GrtShQcsI9F
 DHDPiaVPv3ZG56i4ctdU731y5ZowhMZKbIbEDJChxA4CCF9RMWxt8vHufe3IorN1Nhpe
 mJUDtREY4hVqWpGwvCkuXikCEhPA2+mH3GtsE3k8I3Z8ywEGLDYS1ezMZr59NPPcENAm
 5FPRbIeK6b3+Zxm2a06dQl2JYCi1bxfCYVss7tvxjZKMQLeFtO8N0orx3V8Q6icVXkcD
 IjCw==
Message-ID: <f3895076-5ccc-4542-8cc5-635a99cff182@daynix.com>
Date: Thu, 21 Sep 2023 16:58:28 +0900
MIME-Version: 1.0
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
 <20221110100629.61496-2-akihiko.odaki@daynix.com>
 <CAPMcbCrGkXzeZex_veDYV8HSMMzH8d=zy1jkf21t4qFekGmDpg@mail.gmail.com>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAPMcbCrGkXzeZex_veDYV8HSMMzH8d=zy1jkf21t4qFekGmDpg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 01/10] qga: Remove platform GUID
 definitions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Konstantin Kostiuk <kkostiuk@redhat.com>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>

On 2022/11/17 18:45, Konstantin Kostiuk wrote:
> Reviewed-by: Konstantin Kostiuk <kkostiuk@redhat.com 
> <mailto:kkostiuk@redhat.com>>
> 
> Will merge this patch in QGA series
> 
> On Thu, Nov 10, 2022 at 12:06 PM Akihiko Odaki <akihiko.odaki@daynix.com 
> <mailto:akihiko.odaki@daynix.com>> wrote:
> 
>     GUID_DEVINTERFACE_DISK and GUID_DEVINTERFACE_STORAGEPORT are already
>     defined by MinGW-w64. They are not only unnecessary, but can lead to
>     duplicate definition errors at link time with some unknown condition.
> 
>     Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com
>     <mailto:akihiko.odaki@daynix.com>>
>     ---
>       qga/commands-win32.c | 7 -------
>       1 file changed, 7 deletions(-)
> 
>     diff --git a/qga/commands-win32.c b/qga/commands-win32.c
>     index ec9f55b453..dde5d401bb 100644
>     --- a/qga/commands-win32.c
>     +++ b/qga/commands-win32.c
>     @@ -506,13 +506,6 @@ static GuestDiskBusType
>     find_bus_type(STORAGE_BUS_TYPE bus)
>           return win2qemu[(int)bus];
>       }
> 
>     -DEFINE_GUID(GUID_DEVINTERFACE_DISK,
>     -        0x53f56307L, 0xb6bf, 0x11d0, 0x94, 0xf2,
>     -        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
>     -DEFINE_GUID(GUID_DEVINTERFACE_STORAGEPORT,
>     -        0x2accfe60L, 0xc130, 0x11d2, 0xb0, 0x82,
>     -        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
>     -
>       static void get_pci_address_for_device(GuestPCIAddress *pci,
>                                              HDEVINFO dev_info)
>       {
>     -- 
>     2.38.1
> 

Hi Konstantin,

This patch seems missed since then. Can you merge it?

Regards,
Akihiko Odaki

