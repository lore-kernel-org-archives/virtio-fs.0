Date: Thu, 20 May 2021 04:00:12 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <97276.121052004000600227@us-mta-77.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mBKj/BzMzkjOL51PB
	AwqDguQiRCGY3Io2NfzuT3A3iE=; b=T6kTXFkdE9dezO5DfjqtoPhWD4hXVfk3l
	dHcTSsqSQVSIGU8ex141R04zpzhXlgiA0EXNLmLRehw7OuOVONXYWjHsKeCslGUm
	ukAznd/GqASQYAGvc+jumFky+PSK4j96Gi2NqHxx+S82s5McQhxWH8NBS217xOKt
	iZd96RA7h9+L+SaGWU0WMuj7wmRqJBGDogW7Fn6iwIKukIMRaoXSXUndQub96Hun
	CcIkkmOe5LLNxX27Pltu1IMjsPr15L79ZaQrU4Y//mQokr4fD32vGkId/vZ4+oco
	f0xan2vkECeE0JgB7JNDPi9xEEtaQJoPFicDVLKfU002MTjkaIyqg==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Fix protocol features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When virtio-fs uses the DAX option, this means we expect the backend to
send some requests to the VMM, and this is why SLAVE_REQ protocol
feature was exposed. But this is not enough since the requests that are
sent by the backend may contain some file descriptors. That's why we
need the additional protocol feature SLAVE_SEND_FD to be exposed.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/27

