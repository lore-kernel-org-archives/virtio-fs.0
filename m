References: <cover.1633376313.git.qemu_oss@crudebyte.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <54ce3304-ee62-4e95-eb4c-7ea1a81f30a0@redhat.com>
Date: Tue, 5 Oct 2021 09:38:53 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1633376313.git.qemu_oss@crudebyte.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtio: increase VIRTQUEUE_MAX_SIZE
	to 32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>

On 04.10.21 21:38, Christian Schoenebeck wrote:
> At the moment the maximum transfer size with virtio is limited to 4M
> (1024 * PAGE_SIZE). This series raises this limit to its maximum
> theoretical possible transfer size of 128M (32k pages) according to the
> virtio specs:
> 
> https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-240006
> 

I'm missing the "why do we care". Can you comment on that?


-- 
Thanks,

David / dhildenb

