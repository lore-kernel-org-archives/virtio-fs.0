Return-Path: <vsementsov@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1675154003; bh=/ZzzXnxJEUhn1s6JzrmNCMDRn/vHMwKPIB2mhIMVEtg=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=UNWvpsrE/NP5qGkRgDHvkICtiAG4GotoGADlg4qZgB1KUoXTKpQBLxJYZlpHXOZvL
 SfZqo1MfuoDmqNsUmsfE55g/WgnmbQdBsDO5I3oZ8/V2oVCRIP6WDf2XFWgRNwUTN6
 bCXU6jO6JIEVahr3oVJOAqXPXuUQbigONyMI7yFQ=
Message-ID: <f37db85a-b0aa-b34a-7d5a-b1ab650f1683@yandex-team.ru>
Date: Tue, 31 Jan 2023 11:33:22 +0300
MIME-Version: 1.0
References: <20230130080608.2100-1-quintela@redhat.com>
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20230130080608.2100-1-quintela@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v3] migration: Remove res_compatible
 parameter
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Juan Quintela <quintela@redhat.com>, qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>, qemu-arm@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, Eric Blake <eblake@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Fam Zheng <fam@euphon.net>, David Hildenbrand <david@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eric Farman <farman@linux.ibm.com>, qemu-s390x@nongnu.org, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Laurent Vivier <lvivier@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Gerd Hoffmann <kraxel@redhat.com>, Thomas Huth <thuth@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Eduardo Habkost <eduardo@habkost.net>, Klaus Jensen <its@irrelevant.dk>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Laurent Vivier <laurent@vivier.eu>, Xiaojuan Yang <yangxiaojuan@loongson.cn>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Keith Busch <kbusch@kernel.org>, Thomas Huth <huth@tuxfamily.org>, Song Gao <gaosong@loongson.cn>, Richard Henderson <richard.henderson@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org, virtio-fs@redhat.com

On 1/30/23 11:06, Juan Quintela wrote:
> It was only used for RAM, and in that case, it means that this amount
> of data was sent for memory.  Just delete the field in all callers.

Could you describe, why it's safe to change the behavior for RAM?

Also, I think it would be a lot better to split the change for RAM (s/res_compatible/res_postcopy) in one patch, and then drop the totally unused res_compatible file in the second patch


-- 
Best regards,
Vladimir

