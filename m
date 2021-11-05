Date: Fri, 5 Nov 2021 10:17:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=e/SlsAfIziS2msnMSoWafokGZplIQHYc3W7mZ
	JJCWNs=; b=RQ7BMqQWf8YSzofwVQqJJE/k1AWuNFVmcs48XNLcF7jqUVMkNvKU7
	N2M+lITuLReQLFIbz7FQ7bxJur3IC6cYCCdP8YcwHmGfnq6uz3W491GkgnGCM7T+
	LSCw3sZt9Vu7UyxooUjGNPsUJ1axS9rPq19Tg1cyClG+fbI/zG1mfDs7X/PLTdLq
	NAOOZV3EoWkQD4PWg2ZkNMnNmPUc1gAVQdK++g4fynwTE7o1xgswWFTEXi028JOb
	jDaimJlhkaAmyHyCKXx4vOF4D3Be8sKPOKatd8nPbYoO3L57BhWy2vjNgibN4Hjl
	CSqSs/zgGEuNFTJ1xvVOcHtnavXIx+svQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=e/SlsAfIziS2msnMS
	oWafokGZplIQHYc3W7mZJJCWNs=; b=RTZB36K4ZQoO7Cx5hESQR0KTpnnLE0RJ8
	JQ6hAztz10Y/j+2nIWGMrmWFc9NhrQ+wL7L0S+7Y8tblzZwQCBn7TLv86U/NsiOZ
	/HfCB7OaDb8z29dKm0tPfzjLvfb6f8282+Hmdj38LknM5fzqYxAoVqxEJRAe2GGU
	PEPi+La4avB6TBUPjdu8LmgKMv0I81c/+n527Mtx83s8OieIOHEEkXTRB/N0UHrc
	sn0rK5ye0Zq2MxITxYXPsPWKfvAnqN8CZRMnxn7IWXxtb/yODoQmDVUZSyBHD1aQ
	uSVy0i6SUBRx8vPDOLbQ1g+sGruTCLNLEu4iCG2WIugGv6D5ZrUDw==
From: virtiofs-bot@sinrega.org
Message-Id: <43070.121110510172600326@us-mta-449.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Drop capabilties and don't
	announce KILLPRIV
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This series introduces the ability to drop the capabilities before starting the service, and also stops announcing KILLPRIV support, which we never really supported.

This changes set up the stage for the upcoming KILLPRIV_V2 support.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/44

