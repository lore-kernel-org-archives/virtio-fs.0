Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=c0nUnLAeOew6kS70/dF7WuB6fjVZ/CQXHBlYs2LKkRM=; b=U
 uwntOQtN9MFpv55BJuaFQLykaKOQYQqvlTGfitfTUHeZ7Wvrg4pZy+gFYGN8O90U
 epQ85yoM21OjmFKLshgo4DxZ5KnyvkZ8RgQrwD9NFuyRHTJklONiShrQtfGaDUvT
 gHmgEorX/0+rvzC0S86JgZ7lZpQZcJaqp5J1lcxpJnpshuIAkT5qw3fvKnMfXhr7
 edIzaUtwZgKMohSw5FYnarAxofJwbPPUx5iMHQ7A9Myjdgz71xvQKAnBwBDGsRuk
 tZnIB/XWow5YZeE8OFsjlIE/SiPR4UZ5HEC+8nTXOdR01Q0FbbmioaypWhFQH+b7
 LUNniN3i+uFo1of2xYhKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=c0nUnLAeOew6kS70/dF7WuB6fjVZ/
 CQXHBlYs2LKkRM=; b=bdR5QU6UknDnmXTFtjo9AWpeWgxLyIRuAsZ3aX0BqlBTV
 h0fggctVe+RU2gWbGE5GUMwLP80GpQ6SkHVf7he8a9FdRjgi+aPceE0RNNly/2Xy
 KahZblB9RcSjjxyKTv0+E+4xX3/HDQdyiuvEXHqQT8q1UY+aXvYu3958v0DIbV1n
 aLWIz1Ij7j6pSCoC5KxflZaM/IHazXncwDWjzmuyDoGSX7hjNMuk2T6oMcb0ppfU
 /ShgUVMCqA06YnIIUChQPVsWTyvtAjbaDsAPSYKj1D83Z26CQZP1ZyH5GxD23i0t
 y9JOgEZ57a9sNvwFB7OgCZKpsCJGwEdwgG+grmsPg==
From: virtiofs-bot@sinrega.org
Message-Id: <65007.122032312484500555@us-mta-214.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 23 Mar 2022 16:48:48 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Implement
 VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The DAX support is only partial at the moment, as a complete support of this feature expects the command `VHOST_USER_SLAVE_FS_IO` to be honored.
Without this command, the guest might expect the backend to access some non-guest memory ranges, which it won't be able to do without this extra command.

Reference: https://gitlab.com/virtio-fs/virtiofsd/-/issues/39 and https://github.com/cloud-hypervisor/cloud-hypervisor/issues/3869
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/41

