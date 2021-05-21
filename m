DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
	h=to : from : subject :
	message-id : date : content-type : content-transfer-encoding :
	mime-version; s=pp1; bh=ycN6zKGnEEqWF3qXm/CcNHvGvjoNJWxGBynYHFRGucw=;
	b=bKtJ1SxJ1R/FEIr7rfwG6Opu5prAz7FQfn3qLbRVvPTJRnf3ri8r5KyIV9UqwBur3xsB
	jI4xB7rZwEh/gvhA6i7GYFd71xlGndkAvnrQqhMoglEJUofD/ZIgRQAcaorXnMk0nd4Q
	MpxAYasERSr3uWfPnU6zwlul6TKDN12ei3xwVv4oE9H4CpVnLhjc0F48BTwk7ETK+iuW
	/5d0sg1JAwMWFPVzB/k6AWE8lkCesGjpOcWl6y+1V1XQWGo3ZoOJ3QgssmHLE0vml+yw
	n9fe8oIS7uo9OlC91sYsP33I6EV8pKkLRlLEDZFuUgJyYjCXnvnf+jchYZxgsnKrrh+7
	sg==
From: Jim Cadden <jcadden@linux.vnet.ibm.com>
Message-ID: <489d6710-2e39-8058-a7db-80166c603ce4@linux.vnet.ibm.com>
Date: Fri, 21 May 2021 11:34:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] virtiofs: Support for SEV encrypted guests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Do you know if virtio-fs can support SEV encrypted guests?

I work on a project adding SEV support into kata containers. So far, 
we've been unable to boot SEV guests
with kata's virtio-fs option (and use virtio-9p instead):

May 19 16:52:05 sev1 virtiofsd[74904]: [ID: 00074904] 
virtio_session_mount: Received vhost-user socket connection
May 19 16:52:05 sev1 virtiofsd[74914]: [ID: 00000001] virtio_loop: Entry
...
May 19 16:52:07 sev1 virtiofsd[74914]: [ID: 00000001] virtio_loop: Got 
VU event
May 19 16:52:07 sev1 virtiofsd[74914]: [ID: 00000001] fv_panic: 
libvhost-user: Invalid vring_addr message

I know that other virtio devices use iommu and DMA apis to share 
non-encrypted pages between the host
and encrypted guest. Could something similar be done with virtiofsd 
andthe virtio-fs virtio device?

There are reported problems with vhost-user and SEV: 
https://bugzilla.redhat.com/show_bug.cgi?id=1797058

Thanks for any insight,
Jim

