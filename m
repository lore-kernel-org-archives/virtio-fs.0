Date: Tue, 30 Nov 2021 04:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=ndC7pBj2W6rUvfRKy2zHEC4kz0aXrcq9ZSnPO
	jKe/YM=; b=CpNsG/avJSxc83OMLjkxIZmCK1IU2R/LDVex/CHv4UClpM4/JxdU/
	AZ3F7UZ9SBJ3frpRr+igyHlnbQTc7LHQeE1+UUFGCkb+6NIdcwHejqpU18rgOWdE
	dpcCYYXwgiaEs75JkFCyXOuQ36eeNfE2CQQa4GTU63xjIVK19yULadN/5EYp7lYx
	eJei0BCqoqevKBl05C9rnpuwOwP5YT3i+G+XB1pTx/FRBaZoAmbWW7biBbQ23+Cj
	YNO9Bk4Bn2ln9v0DwsTRVUCYXKefylRUCRb42qLrzjCc5keVHJhsKY1Dqdg7SO4S
	FwS62MQ2nKBIBFrrQ76zZV3VaTOvLkYZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ndC7pBj2W6rUvfRKy
	2zHEC4kz0aXrcq9ZSnPOjKe/YM=; b=Y60nOChdykjJxJfhlLpM+DYLIkzdIb+XU
	K14RwIv2ZDD4eEDzf+L02ib6E1NC7VzLandM9o+4v09afvYNuCz8SHedO/7cr6yK
	C2/X1BVHYY3lXO1NKX8s9c1N99W9zD21K0PtMDzoV2bkCmUzrj3uwbSQlgC5uQI2
	wCB2lszIWIN1S1jRhvmEca6x7uXECAvjaQV3L+BLOVk3552a+gEORsnRoh2wOCcF
	fb3bHWF7TEF3lojq0reIVz5yXqWL48HzWN256lGbULZB83MW+MfEEawv2xEC/hac
	bsGvt7tGduO9zfYMNBhX8snrFMQhvx/5gf3pHk+GNXZyWheYijyrA==
From: virtiofs-bot@sinrega.org
Message-Id: <26053.121113004043301283@us-mta-558.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Buggy
	DescriptorChainConsummer::split_at()?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

While working on moving the code to mm-virtio, I realize this part looks wrong:

https://gitlab.com/virtio-fs/virtiofsd-rs/-/blob/main/src/descriptor_utils.rs#L158

```rust
                self.buffers
                    .push_back(front.offset(rem).map_err(Error::VolatileMemoryError)?);
                other.push_front(front.offset(rem).map_err(Error::VolatileMemoryError)?);
```

The "other" end correctly receives the end of the buffer (at offset rem). But self should be truncated instead.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/6

