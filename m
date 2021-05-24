Date: Mon, 24 May 2021 09:10:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YKtfdQBLLqUt7Ycx@work-vm>
References: <489d6710-2e39-8058-a7db-80166c603ce4@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489d6710-2e39-8058-a7db-80166c603ce4@linux.vnet.ibm.com>
Subject: Re: [Virtio-fs] virtiofs: Support for SEV encrypted guests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jim Cadden <jcadden@linux.vnet.ibm.com>
Cc: virtio-fs@redhat.com

* Jim Cadden (jcadden@linux.vnet.ibm.com) wrote:
> Do you know if virtio-fs can support SEV encrypted guests?
> 
> I work on a project adding SEV support into kata containers. So far, we've
> been unable to boot SEV guests
> with kata's virtio-fs option (and use virtio-9p instead):
> 
> May 19 16:52:05 sev1 virtiofsd[74904]: [ID: 00074904] virtio_session_mount:
> Received vhost-user socket connection
> May 19 16:52:05 sev1 virtiofsd[74914]: [ID: 00000001] virtio_loop: Entry
> ...
> May 19 16:52:07 sev1 virtiofsd[74914]: [ID: 00000001] virtio_loop: Got VU
> event
> May 19 16:52:07 sev1 virtiofsd[74914]: [ID: 00000001] fv_panic:
> libvhost-user: Invalid vring_addr message
> 
> I know that other virtio devices use iommu and DMA apis to share
> non-encrypted pages between the host
> and encrypted guest. Could something similar be done with virtiofsd andthe
> virtio-fs virtio device?

I guess if you can guarantee that everything is going through
non-encrypted pages with the iommu, there shouldn't be a difference?
My only other worry is whether SEV works with a shared-memory backing
(e.g. /dev/shm or memfd with mmap shared).

I know there's an existing bug saying that virtio-fs doesn't work with
viommu:
https://bugzilla.redhat.com/show_bug.cgi?id=1812886

so I suspect it's fall out from that;  I think we just haven't
implemented the iommu compat code in the daemon.

> There are reported problems with vhost-user and SEV:
> https://bugzilla.redhat.com/show_bug.cgi?id=1797058

Yes, although it wasn't clear if that was just a performance problem or
not.

Dave

> Thanks for any insight,
> Jim
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

