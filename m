Date: Wed, 1 Sep 2021 09:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm1; bh=A0hpIiFjE8lmeIepgEiRSuA9mgKmqsACtbQkP
	fClmUU=; b=eeZ77GRVK9VAYBurNCUyw4+VDnOWcyshqdbiErMPCp4IghRxsv3De
	lZftGG6x8+uQCFGDN+TCxO+S+Ip8nsvVgmdhFF7KAP3PEufVzpyjcPwMgh11NyXV
	b9sOIjKJjRyv9OqU5p4PT2bfRdbZTGvLZsXJLbWgqGBjT7MU8ZKZMNm4UDLwNxGz
	yeCter31OcyqExsuTHH/xWhMY532mRFNuUq1v3iTXHqcXecUfm4pKTMfvB7VD6Ie
	p3BKyxGbjYaawA5khYsH0KU4OR2regqDjwFlfAjcp3cSG9GiXIfDHE8RG7LiTF5i
	czMWDWVODWHlY3HWFnf3hIb0+GhWUElzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A0hpIiFjE8lmeIepg
	EiRSuA9mgKmqsACtbQkPfClmUU=; b=VSa2VTtvNfkrT4YILgnEKktgFNu61QL4F
	iBrqDIUnht29bIyfrrxFIqRDgjVEOv7vOQQUIzaTz7N5NagvZ9vRRWQTlcYxAbH2
	ZePhuvXMCnCC/yjBuvHjFOsTwvVorFZ4Ino3u1Fngrul99Y2F4K5qLlDPQ98bCpn
	LlARrTxDp26zONN1Wpr53iEwiuQtUHFkxl/BLtJYJj4rxYSVDBMLvlEbnXIYjXyD
	48658Fr4FZNpWLqywue+sPn5Tu5ywI8ajgt61buUV8W+FpUo6dYsjFl5swJ5cvPc
	u7BzeR5zFiefQbgZHg7pEEZCzpekNUmvV2xRGQTVzzuB0W89iu+8g==
From: virtiofs-bot@sinrega.org
Message-Id: <98300.121090109255801165@us-mta-590.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Fix clippy errors with latest
	toolchain
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Fix some clippy errors triggered with the latest version of the Rust
toolchain.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/36

