Date: Thu, 27 Jan 2022 11:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=5aNlIrN07XJMAH64uTvTOzRMyRgZYfY3wP7gUaRCquQ=; b=n
	k1eQqfTcPFuO+C3Ra2PyVT8wzG0kobVSB+BZ6ZOcPCFxdcOutkTIzEBK2PnSGy+G
	T7QdvoKRJW7nbemIZB5NQ5k6uRIFPko0SGIt3Lz2djDgXwpydLrFFkeja7aZl9r+
	YOsZ5eyUZEBxJEJCaIIOZf09abyYoSFPtUb6f4p6l9lHgdvQhGwIKFu664lkOvvq
	dL76dCCojBp7766GNwzDzZ/gDfkgkNQPH6jVSDLnYXVYcZ+t0uJO8BFiMNK6fLT4
	d/NkdeJRmAlCp6nzcMaFo88vyxNuHdh/t0EYIKeeJmp/z71zYTzLcHbNxKeeKkDe
	AEanwSIaeWrxl7qldswgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=5aNlIrN07XJMAH64uTvTOzRMyRgZY
	fY3wP7gUaRCquQ=; b=gcRFLG+Mt5RZhW9JdhDcX5Y+idOS8tSs0CRD7EFXWA/hs
	JkpCCHLz9erq5pQKOPbPQXh/LZ/tAqtk9rtorTrxvox5v2WcPXEGqMwNFZLy3sGe
	fPXjjnzQ/aAIXGPjQt9MBXb14u7VN1ADIphrtMbZw2qU+aoReFk7y7WskBrzLeum
	1EL/UYC8Wm9TDR6yoOrNxcswfoYm9KXfkF1P+GGkW9BvKArbhGDhoL7Fa2pzLEM+
	41N/uTxh88NB0Mm0pH2Px40oDwGTVogJpEGI1cwHPTOVwHAFbLyDM9Jf+2P1XHYn
	2H1Q2CVkcJobSf97JRBPNH2VfohG1j3D7Miy+wbXQ==
From: virtiofs-bot@sinrega.org
Message-Id: <18446.122012711332001169@us-mta-261.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: mount_fd: Manually manage mount
	file descriptors
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Still we have a hash map of all existing mount FDs. But instead of
refcounting mount FDs and letting them remove themselves from the
map, we manually

- add a mount FD when the (sub)mount inode is looked up, and
- remove a mount FD when the (sub)mount inode is forgotten.

When later implementing FUSE_SYNCFS for the case without
--announce-submounts, we need to defer removing mount FDs until
syncfs was called by them. This can be done by either (a) calling
syncfs on any mount FD that is about to be removed, or (b) keeping
them until the client calls syncfs. Both ways ((a) or (b)) are
easier to implement on top of the manual management introduced
in this commit.

This MR is an alternative to !73.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/79

