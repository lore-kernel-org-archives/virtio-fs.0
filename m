Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=8SeWRB3y/Z9aDdI2nXCquDmgnbx3SEB7gZ839vxftqk=;
 b=m16lCzYOR7D6qo/p8jX0623yLmAqv8n1nOUeZnBDFzeyz79su89pWQzgWvAvfA8Q8p
 qeDk9AP5OagqcYiJozEaCkFVDN65hmH2APl4Lq7Mrw7P9FBjtfWKnBNibS3CyDO4e1xc
 sy8qyTGyVfHrvsNkNfwARBKuyGc9U0RSGygdb6eyowMIBOIqtjAUG1MGh+3NBNRXK7MA
 BTJkuBgywTj3oA5AKLP7LYIN+0Pcq69WmzW5M1mEJBGTuJc6DxqMdPnMqIoPd1mAt329
 Wd+Hk1XXCzT4y9b4e858fuB2eRaBpqCMKNVx/8eadQ9/dxYn1nnph/Ri5Dx1E0jLykvu
 5zXg==
MIME-Version: 1.0
References: <20220804074833.892604-1-sw@weilnetz.de>
In-Reply-To: <20220804074833.892604-1-sw@weilnetz.de>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 4 Aug 2022 14:45:24 -0400
Message-ID: <CAJSP0QWPduu2rqti-=zviJwuHGamK=n1pd1xwfL5tamYJtNqZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH for-7.1] virtiofsd: Fix format strings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Weil <sw@weilnetz.de>
Cc: qemu-devel@nongnu.org, David Alan Gilbert <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com

On Thu, 4 Aug 2022 at 03:50, Stefan Weil via <qemu-devel@nongnu.org> wrote:
>
> Signed-off-by: Stefan Weil <sw@weilnetz.de>
> ---
>
> I have also several patches which add missing G_GNUC_PRINTF.
> Would such changes still be wanted for 7.1?

Hi Stefan,
Thanks for the fix! I have merged it for 7.1. Please send the
G_GNUC_PRINTF fixes for 7.2.

Stefan

