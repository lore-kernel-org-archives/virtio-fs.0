Date: Tue, 18 Jan 2022 05:53:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=rWkubUZNhMjF2IwGu3Wz2q+r941eYzc59G7cm
	c0jG8Y=; b=iMVYpiR2FjdUo9mRWK0hIWMbzDgN3iXkFjLqNdsUhb2RvLb2XfX8y
	NOiqAupFChWE1Gz+VANFxWui2l14aMWhfbYEZ6dmqURiXHeA+ODaMsgp6PRSUac6
	j6VdZvG3ktmn/2R+DFnb0lJAuAeNAeOO62Q1abljDrQFa3ms9QMZ7JyPAqcSou03
	vNY2Ks3lS71eptswTkXIeFx9l9qkVANyQLDAcdQMIrFwUamyVg7HnVYFSG+J5i8E
	/UwaiCL2lVBF+cpPGzL3jnHkoToN18NkA7/cEq49sGjqFs180WmPqOLddeO/5T7i
	ksk6TuXlGPTtzTY+2G3MnO8t9B/WSGP2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rWkubUZNhMjF2IwGu
	3Wz2q+r941eYzc59G7cmc0jG8Y=; b=UsSYTXSRUSnoqYW5cCFdN5j6fcJEfM/nA
	fI9OoNQkEDYV+zTbi1o9zzacDd6it3C7u8kw33PnlX1AXs2crfkJJw/PvSyP8smc
	wzQrsNsCoa8cAwGS86JH8//F8nOMZyLGv71nocnKIruLF4MzImsP3exxAF5TPvoz
	MrSY7THVesGdTp+kZcZ4e0yB8DcRv6q/M6OCb09uwQlEUsPxqeyiVU8YCn+BJyZw
	5YlIqbv6l7VN0O86Na1GDfWXl/eAMYWdQD1eZjCdI1ZhuqOLuyj3+nkIzZy3QwMz
	g2L7cEWNpUTtvOANX4WfppAWTwdTGZBnrlPKEU+meyCaaEx8LFMkg==
From: virtiofs-bot@sinrega.org
Message-Id: <08955.122011805530200405@us-mta-380.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: sandbox: Support combining
	--rlimit-nofile and --sandbox=chroot
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Related: #15
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/65

