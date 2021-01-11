References: <20210104132401.5100-1-lersek@redhat.com>
	<20210111172208.59a59109.cohuck@redhat.com>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <dab59f0a-023f-eade-27ce-506200f51ef4@redhat.com>
Date: Mon, 11 Jan 2021 17:32:57 +0100
MIME-Version: 1.0
In-Reply-To: <20210111172208.59a59109.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: add the "bootindex" property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, qemu-s390x@nongnu.org, virtio-fs@redhat.com, qemu devel list <qemu-devel@nongnu.org>

On 01/11/21 17:22, Cornelia Huck wrote:
> On Mon,  4 Jan 2021 14:24:01 +0100
> Laszlo Ersek <lersek@redhat.com> wrote:
> 
>> virtio-fs qualifies as a bootable device minimally under OVMF, but
>> currently the necessary "bootindex" property is missing (fw_cfg kernel
>> boot notwithstanding).
>>
>> Add the property. For completeness, add it to the CCW device as well;
>> other virtio-ccw devices seem to have "bootindex" properties too.
>>
>> Example OpenFirmware device path for the "vhost-user-fs-pci" device in the
>> "bootorder" fw_cfg file:
>>
>>   /pci@i0cf8/pci-bridge@1,6/pci1af4,105a@0/filesystem@0
>>
>> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Halil Pasic <pasic@linux.ibm.com>
>> Cc: Stefan Hajnoczi <stefanha@redhat.com>
>> Cc: qemu-s390x@nongnu.org
>> Cc: virtio-fs@redhat.com
>> Signed-off-by: Laszlo Ersek <lersek@redhat.com>
>> ---
>>  include/hw/virtio/vhost-user-fs.h |  1 +
>>  hw/s390x/vhost-user-fs-ccw.c      |  2 ++
>>  hw/virtio/vhost-user-fs-pci.c     |  2 ++
>>  hw/virtio/vhost-user-fs.c         | 10 ++++++++++
>>  4 files changed, 15 insertions(+)
>>
> 
> I agree that you should just drop the ccw hunk for now. The rest of the
> patch looks good to me.
> 

Thank you as well -- with the ccw hunk gone, I guess the CC list will be
shorter in v2, too :)

Dave, Stefan, Michael -- can you please comment? For the files to remain
in v2, "get_maintainer.pl" gives me:

"Dr. David Alan Gilbert" <dgilbert@redhat.com> (supporter:virtiofs)
"Michael S. Tsirkin" <mst@redhat.com> (supporter:vhost)
"Michael S. Tsirkin" <mst@redhat.com> (supporter:virtio)
Stefan Hajnoczi <stefanha@redhat.com> (supporter:virtiofs)

Thanks
Laszlo

