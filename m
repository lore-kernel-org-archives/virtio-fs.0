From: Laszlo Ersek <lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
	<20201216211125.19496-7-lersek@redhat.com>
	<20201217114950.GC4117@work-vm>
	<936ba94a-8226-8649-d9af-b5f6382ebbc2@redhat.com>
Message-ID: <e6b72ff0-187b-7711-d9bf-ef094df2d1c4@redhat.com>
Date: Thu, 17 Dec 2020 15:32:01 +0100
MIME-Version: 1.0
In-Reply-To: <936ba94a-8226-8649-d9af-b5f6382ebbc2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [edk2 PATCH 06/48] OvmfPkg/VirtioFsDxe: introduce
 the basic FUSE request/response headers
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Jordan Justen <jordan.l.justen@intel.com>, devel@edk2.groups.io, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>, Ard Biesheuvel <ard.biesheuvel@arm.com>

On 12/17/20 14:57, Laszlo Ersek wrote:

> So, as long as it's up to me, OVMF never "just takes" but "adds from
> zero", and I do stick with the absolute minimum needed.

... I mean this specific patch only adds the two most basic headers
really (VIRTIO_FS_FUSE_REQUEST, VIRTIO_FS_FUSE_RESPONSE), and the rest
of the structs are introduced gradually over the series -- only when an
actual FUSE request type needs to be sent for the desired functionality.
So it's not a "dump of definitions" at any point in the series.

The complete set of structures+flags, defined in the FUSE 7.31 interface
version, never lands in its entirety in "OvmfPkg/Include/IndustryStandard".

Thanks,
Laszlo

