DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=4Vd1LVCweAvX2Sz35G8Yh
	4MEiwAnNSbPi4z+pLp3JnY=; b=owkF6Fk4qC3bHi2fLCpsMHkOCAkVLfonpX4++
	4dgaNgmIuXiNMxCv+eXYOjfFiFyMmBxuNpOMHlr1sK9efcl9Lq+kfLe2e1jBQVxO
	R3btKTKTRrpPcO2DGubF2TNIU/715jsIxatzo9NsNP2xVR4R8kITdstyldVoZ5Ue
	ZPr5RNZqEGpZkAVC8CU6QPnFygZGWpT7zP4mtwSTt/YLlFt9PuQivZmUKM/IczwV
	zKnxh7aSNqcpWCNrjXhgchMmuDZdND/H5sR1SInVHli/30nL+CCY0A1bhmdNYZHY
	BWoM07EERe1oJGzxx/xCVIVoh7WXP+6wBWiu4HMS7XZMfI9CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=4Vd1LVCweAvX2Sz35G8Yh4MEiwAnNSbPi4z+pLp3JnY=; b=Wut7k6ea
	8z0XR+gtJR6FUNDkmkqVQxVb8TCUphaCHXDK016qXMNshce4/xUtrV4qwwTbltQx
	pCMbqu59MNi72sLweOvoontRJVAJ2/A9wwbmQTb8mRxfnuwCHOeneFWYwjhQQGAE
	SPDiB+19X+Q/6eWdbTQYIVNNV1H+PdZKLnqBwWvLHM1r6AThPdtv+bA0vbVMBD6u
	66ehmIx9MsuHZ1b4DyCbw80TI8pqdD1DIVVTzXEM/zsOvFuxpqhxB/4YYNjYqvqu
	KMddqjJ9R3yPkMHd3XpwWK913gxLIAwXUjVoOjrnbKMSYdOpPgX0zpdaXgicLWYf
	enRYbxyG93gO9Q==
Message-Id: <20210405123403.7B4231080057@mailuser.nyi.internal>
Date: Mon,  5 Apr 2021 08:34:03 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Implement xattr name mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtiofs-bot@sinrega.org

Closes #3 

These patches are an implementation of the [xattr name mapping specification](https://gitlab.com/qemu-project/qemu/-/blob/master/docs/tools/virtiofsd.rst) which is held in the QEMU tree.

I also performed a fair bit of manual testing with various rules in addition to the automated unit tests which exercise map parsing and rule executions in isolation so I could see how it all worked end-to-end. To tell you the truth, I did not have any experience with extended attributes or using xattr mappings with virtio-fs prior to starting this work, so any additional test cases or reviews for correctness are sincerely appreciated.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/9

