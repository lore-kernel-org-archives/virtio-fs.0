Return-Path: <philippe.mathieu.daude@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=4cgW4U8ITpr8xl01FZhR66S3GEP6d9Ku/vbe89riB7s=;
 b=L5sAL10kHjjqhHcNm1/GD9nBUdXY1AeQthGB2xApkfn936+Ki6RjHYRSLgkZLyhTQ/
 sM8XEvGsfF64vDOHFwBsyfAw/cX0nt/EBIVAk/rep8Kh5tnZprvDYByVT1mdY9RLOX5a
 9slEGIGJL1tN4lEghXZjSIMGB2mcHUCkeHCd46PFi9Vsv6UD7vdYdurbqAHQA1Tdc51p
 FwLX8y5Rgf4/65uvIUF6RPTL0enjB4/K5FGLYnZjIzXlDOjV+UQtCKWQe6r7CtjdFoAu
 ckVaAYS4LJIWfFk75KJHlrPE6cmOQZIvnvVP5PbUiVI9n4QjOADEzD/Ep9TWki0aVVL9
 S24Q==
Message-ID: <676212de-2519-02fe-6a13-2df9d58e0e58@gmail.com>
Date: Mon, 21 Mar 2022 23:27:53 +0100
MIME-Version: 1.0
References: <20220321153037.3622127-1-alex.bennee@linaro.org>
 <20220321153037.3622127-2-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
 <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220321153037.3622127-2-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v1 01/13] hw/virtio: move virtio-pci.h into
 shared include space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: slp@redhat.com, mathieu.poirier@linaro.org, mst@redhat.com, viresh.kumar@linaro.org, David Hildenbrand <david@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, "open list:virtiofs" <virtio-fs@redhat.com>, Eric Auger <eric.auger@redhat.com>, stefanha@redhat.com, marcandre.lureau@redhat.com

On 21/3/22 16:30, Alex Bennée wrote:
> This allows other device classes that will be exposed via PCI to be
> able to do so in the appropriate hw/ directory. I resisted the
> temptation to re-order headers to be more aesthetically pleasing.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20200925125147.26943-4-alex.bennee@linaro.org>
> 
> ---
> v2
>    - add i2c/rng device to changes
> ---
>   {hw => include/hw}/virtio/virtio-pci.h | 0
>   hw/virtio/vhost-scsi-pci.c             | 2 +-
>   hw/virtio/vhost-user-blk-pci.c         | 2 +-
>   hw/virtio/vhost-user-fs-pci.c          | 2 +-
>   hw/virtio/vhost-user-i2c-pci.c         | 2 +-
>   hw/virtio/vhost-user-input-pci.c       | 2 +-
>   hw/virtio/vhost-user-rng-pci.c         | 2 +-
>   hw/virtio/vhost-user-scsi-pci.c        | 2 +-
>   hw/virtio/vhost-user-vsock-pci.c       | 2 +-
>   hw/virtio/vhost-vsock-pci.c            | 2 +-
>   hw/virtio/virtio-9p-pci.c              | 2 +-
>   hw/virtio/virtio-balloon-pci.c         | 2 +-
>   hw/virtio/virtio-blk-pci.c             | 2 +-
>   hw/virtio/virtio-input-host-pci.c      | 2 +-
>   hw/virtio/virtio-input-pci.c           | 2 +-
>   hw/virtio/virtio-iommu-pci.c           | 2 +-
>   hw/virtio/virtio-net-pci.c             | 2 +-
>   hw/virtio/virtio-pci.c                 | 2 +-
>   hw/virtio/virtio-rng-pci.c             | 2 +-
>   hw/virtio/virtio-scsi-pci.c            | 2 +-
>   hw/virtio/virtio-serial-pci.c          | 2 +-
>   21 files changed, 20 insertions(+), 20 deletions(-)
>   rename {hw => include/hw}/virtio/virtio-pci.h (100%)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

