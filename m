Date: Mon, 3 Jan 2022 14:16:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=U9z4AmqIaRNDfwYOIIT5VVutmMiavJrJvGD9A
	xKrBiU=; b=JkwAxuu/jPY8U4Ku95iDKdiXtI5gORXYJzcSEPNha0HT6v5lqvWAg
	7ObmouCKlaKaN/rnRQwPdeMV4GkgelBq1ST5zBOsT2dAWvfCKfkKKRqytfYytHVZ
	79a69134VkWOWaUT5YELIVDPARJVMX0Kzkl5/zW5qqQDmeQmZDgYRoHqfLSh8sXu
	ToXqvpi4HqJWPkSFdsL3LgiQrsGqWwKtJw1DqJ8bum9UwQvLkkrKiV41vEI0G2Rx
	kq1vb6XEtl6Oy5lC+njs/YkxCgxIlpDpDsFvHZ+l63zNah0vIkkB6izFPRquUNUv
	41+dTemfNQ+H6PtA3S/0ZufhziKzZgS0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=U9z4AmqIaRNDfwYOI
	IT5VVutmMiavJrJvGD9AxKrBiU=; b=eMvZGSlBVCJ25aoxc3m1mi0Xu7ZsIhIKB
	JTlt9yhzU9LhXHDRb3Ym0F/fIb3D60N1w7/pIG3dm0UerUgsJFTH0CFGKYutyrpW
	Ng1dXR3r5EZXrRT20yrSVKZfHAkiJ6UhJb/2J8M/UWaHzYf5em8/4sCbxiqEyDun
	UTLQ9K6THjetRqDmFSuRD/HzjphbB0wtqKPmwjMmakLWSIdF/IXZXrJ4+av+hyWS
	FYDb9GlSLZDet29gpdBNoO3ZDEbJ1yc+9huO6QVmsgqPPA/N0B7uk1pLYcu9RhMl
	NSo4lzjU5DXJs87pNmH7QI+ZENhgn+rH6bmeIDbmXREi73JuIVxBw==
From: virtiofs-bot@sinrega.org
Message-Id: <69754.122010314161302377@us-mta-137.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Adds compatibility option
	no_posix_lock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Adds compatibility option ```no_posix_lock``` because Kata containers
hardcodded ```-o no_posix_lock``` as virtiofsd option.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/61

