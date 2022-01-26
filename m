Date: Wed, 26 Jan 2022 13:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=VRpi5pbikYakVmSNaY/3WvdOZqhkaVbKP7TcspU4tG0=; b=T
	EoPuXErihpYm4J4GlW1PQIFnhdeqrJSxEo4oYFeU3drb+PoG6cF5/3R924wVQPuK
	ED0gkrEYph3fOeKhW7TgwKsrd5BqBJZRrttAAQqWIwaRYLEwHbLg5Cv2PP4r4iww
	/uxC+8KQnuyd2UgBtluillFru2Xk5sMh/HzPphzCMUPwlF9ifSA/QHc9fXxOUX11
	hyvX/iuYQaX6/b7aaJxqLq1wKCX4L1V6ZMMMZhK1Sb/RGjOLZ3Slz4oGW5kFwW0C
	hjs0rpdoRxDn2oBeztbMQcGcy013WiFDkaNTKcDtnVzJAa0igjSyvesUJ4rIkh2W
	JC/wofPNad0Z150lvZbuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=VRpi5pbikYakVmSNaY/3WvdOZqhka
	VbKP7TcspU4tG0=; b=cnsEXH4/KFXi1AMK2vqssiKYj7yIMOWaRoW4tIi/f1pFA
	B71iGXr/pNEFo+oth3mA/86yeb6Rr/V3M/N6ChCje7tTecS9+yJmo9RgKxL3bSiQ
	nK/HnUvLDMpiY71ugJb1c+9oLTMX4H0BRtDgsP1KFpewB/KwOokZLI9gdbwBe9wk
	y7IJIksI2foYaor83ixCjP/CZGHgP7IbZ/SPAoMmTY06VhCYnJ6pogykGIu3CsOc
	ID8RK4bRtNIa/NLisCkphrxFLqEvcw/Br7oQZB/9CCUZizAFzpbI/BTe2TLWxx0w
	kP9rQWDwxXFZmmpw27udz9ru8/x5RzYM97nAdIIOQ==
From: virtiofs-bot@sinrega.org
Message-Id: <45539.122012613102400501@us-mta-492.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Adds killpriv_v2/no_killpriv_v2
	options
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Adds options to enable/disable FUSE_HANDLE_KILLPRIV_V2 by specifying
option `--no-killpriv-v2` or `-o killpriv_v2/no_killpriv_v2`
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/62

