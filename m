Date: Wed, 2 Jun 2021 02:08:48 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <05275.121060202084202111@us-mta-228.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/WTd2Xkb25tn3uJbc
	DixJZR1MujxgTcqdJyDb4iGl8k=; b=v0YKNdB+S35HpRnFLBnsynAOJcy2AUNt1
	CIaF5dFIeTENSy066G3c7F/RP8l8tMADAZqO7ftJUEDmAKgfMHOC8nqHbdTdgyLw
	bJ702FM4XC7Xu5fiInST8KlR6icee3kNm/HZ3/bSWuwEqlz1ftK2up+TlcOYAyOI
	sDvt5O5J95IoAZNmocrlCxvw5U4XRP1yHHY4+Rw/53qHcGDBLgfhLS661iGBpt9o
	kpAivydWK7EvCZiIPnv9m7u7YoBlhhhOySn4kcAlFxW12wF332RefoHUPmPOV/ql
	nwNx3sZjQGiaXjzhhdCIDgDVAFyb3UjvQvZXLHTj8JmYQiwhSBmEQ==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Allow using file handles
	instead of O_PATH FDs to reference inodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Storing an `O_PATH` file descriptor in every `InodeData` means we have a lot of FDs open, which is sometimes bad.  This series adds an option (`--inode-file-handles`) that will make virtiofsd-rs attempt to generate a file handle for new inodes and store that instead of an FD.  When an FD is needed for a given inode, we open the handle.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/26

