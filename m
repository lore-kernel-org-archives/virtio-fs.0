Date: Thu, 2 Sep 2021 08:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm1; bh=oRNwCLPOIU8iwobY16i0gFrsbnk2Ie2KroePG
	T6aaWI=; b=Jw9/J2WN1tJTihnJR3mneuSe+JuEyIkFMVKkg6UNCJgtQ2wEDk+Jr
	CCpsjWIZPTbSJDlh6KDpkSJgYL3d02sIJYuB/doNhTo/+22urTtQJVT025LgmYo1
	UdqyOHxh2OUhB0D+U4yae9Ec/dSHA2QAeO0PTNbSfsLxe8UJ0JiPNfnZ1HqcjBZm
	g70vWADr3uD9y9K64TVDDtqW4XIAVkYzqbtb/LFDJAxj5GqPVWHmFuEyfnD4pUbK
	ScCJ9PTpQTFCRIFJrVwjncsnBLo/l5DH/z83Rj9YzjARe0MFK06eu3hpWruRxwGP
	/v/AS1oMO3DARSLW1WzYs/lYsaY7bRQ5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oRNwCLPOIU8iwobY1
	6i0gFrsbnk2Ie2KroePGT6aaWI=; b=Q2/f8mn6Nu031VBbN+/WdjTh2wMNRj9Sa
	cewuZ9QEBTUJ7B+i2mldAgA8p8a8XVXW6xDbwf3/bIjLbbb97PIQVS5svaPB6dYI
	eMhgBn2ZbOw/uwl3Mx7DIksf/1D0Wrdax8JGfDb316xrA7AMQ4ZDimG/is/SZU+m
	cibGlO21Gn3q8syG/zTQpaKQT8LbRxQKtE70E63Kbt+n366WMgWpZopmctds+S7W
	UmDXGEN+eJ58d3tJ3dxVsw5FWhxLO0hLAtZMUzxk7ZNPJe9l4Y3bKlZAuwBiEOsP
	KmgtSJnfV6zIt1XXZDg93vMqFDKem+6qOlUiUHCmfK8LKpqKVKwVg==
From: virtiofs-bot@sinrega.org
Message-Id: <05754.121090208321400165@us-mta-242.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Add flags and options to be
	compatible with the C implementation (Part 1)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This patch series adds a number of command line flags and options to be compatible with the C implementation.

Those flags and options are added relying on `Clap/StructOpt`, so they are passed in a different way through the command line. After this MR and https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/4 are merged, they'll be a second part that adds a  `-o` option that's parsed manually and brings full command line compatibility with the C implementation.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/37

