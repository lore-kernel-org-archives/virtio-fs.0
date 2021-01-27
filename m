DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=cVQJ9l6PbkVVPrA93K9y/ncT+nggdqVCoQtRPNf3PSU=;
	b=vM1NsLIWioepzvyVAo4FpfRHrsyJwiUkXnzKFq3MVnxxerPnS/Wow6FK+3OoYC5Oxt
	b80uMUhcs5F4J9CZqZkBJ5KuId/Ls2XZfJQEp8Mz9cZcBBv9jMVDj7biccJqsiYq2aCW
	gE2M7DTd4ygJe0CCio4HFfA1rqG4vtIBEJO0n0+zZWSkHytxYh4yTCzbguWKUN+7B6/E
	7d8CG398qkxkpGC3DQuLC5AONnNQBlPyArj9pWQKq8axj7bOsRbUBp1QPAt6SC14QDi7
	k2BZly+TyvRTlK5xyF0zRtl9iJjEXxEH78n4tVEwmGcdGoPjEodX7rQ7LzLir+21W9jA
	LqGg==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <e262f9ea-cf4d-a841-6b56-ce00295ff03e@gmail.com>
Date: Wed, 27 Jan 2021 09:27:17 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: [Virtio-fs] Is dax the default in 5.10.10?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

Is dax available and if so the default in kernel v5.10.10?  Or does it
need a mount option?

Thanks for all the work!

Harry Coin


