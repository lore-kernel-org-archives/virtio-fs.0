References: <20210112131603.12686-1-lersek@redhat.com>
	<20210113103629.GF250553@stefanha-x1.localdomain>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <11b0f61e-063c-b74b-5e4d-29874e0d7720@redhat.com>
Date: Wed, 13 Jan 2021 11:42:54 +0100
MIME-Version: 1.0
In-Reply-To: <20210113103629.GF250553@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v2] vhost-user-fs: add the "bootindex"
	property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, qemu devel list <qemu-devel@nongnu.org>

On 01/13/21 11:36, Stefan Hajnoczi wrote:
> On Tue, Jan 12, 2021 at 02:16:03PM +0100, Laszlo Ersek wrote:
>> virtio-fs qualifies as a bootable device minimally under OVMF, but
>> currently the necessary "bootindex" property is missing. Add the propert=
y.
>>
>> Expose the property only in the PCI device, for now. There is no boot
>> support for virtiofs on s390x (ccw) for the time being [1] [2], so leave
>> the CCW device unchanged. Add the property to the base device still,
>> because adding the alias to the CCW device later will be easier this way
>> [3].
>>
>> [1] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01745.html
>> [2] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01870.html
>> [3] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01751.html
>>
>> Example OpenFirmware device path for the "vhost-user-fs-pci" device in t=
he
>> "bootorder" fw_cfg file:
>>
>>   /pci@i0cf8/pci-bridge@1,6/pci1af4,105a@0/filesystem@0
>>
>> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: J=E1n Tomko <jtomko@redhat.com>
>> Cc: Stefan Hajnoczi <stefanha@redhat.com>
>> Cc: virtio-fs@redhat.com
>> Signed-off-by: Laszlo Ersek <lersek@redhat.com>
>> Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>> ---
>>
>> Notes:
>>     v2:
>>     - drop "hw/s390x/vhost-user-fs-ccw.c" hunk [Christian, Cornelia]
>>    =20
>>     - document the same in the commit message
>>    =20
>>     - remove fw_cfg kernel boot reference from the commit message (somew=
hat
>>       similar use case, but a comparison or even a hint doesn't necessar=
ily
>>       belong in the commit message)
>>    =20
>>     - pick up Dave's ACK
>>
>>  include/hw/virtio/vhost-user-fs.h |  1 +
>>  hw/virtio/vhost-user-fs-pci.c     |  2 ++
>>  hw/virtio/vhost-user-fs.c         | 10 ++++++++++
>>  3 files changed, 13 insertions(+)
>=20
> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
>=20

Thanks!
Laszlo

