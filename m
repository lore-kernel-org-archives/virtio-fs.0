Date: Mon, 17 Jan 2022 12:56:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=WEJhf84gbbue1VGiMsXDM6jm20J+GHuuD1MPo
	sOVS/w=; b=iN0ljQl3nKJfHuKhbtRxeFojlyArAIb+BdVN49AdAJCLXXcKB5/oJ
	aBShjmvRDWGTKDXU0n3IaLh+9lHfwXC7jIQCnpZLH/yHNStEz8tT8vBZFdLbOhD2
	cEu4ahX5Ytz9B4LRfhQLqmBrheHw5BF0B+VeRAzFW1Tprcj2iazYRILZA/lmrvUf
	TYcS/3zDvKjvYvVVneIm6QTOSqzm+robLGJbhs0agR5IJsjcoRGYrTQBpjtxMJMI
	ozAd95JhNdpf8FGnPAwTAb7TRldwnxB4HAM9pxmnbmGCQEEQ5vphlnT0FX1FpXM0
	/8SWFXA5fcaS3vkZcZSinOFHakJSDeilA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WEJhf84gbbue1VGiM
	sXDM6jm20J+GHuuD1MPosOVS/w=; b=Ac7Yd525XddYLY0dbihdWZjCtZDO9vqpi
	+anszb7CM1Ay3O9V+Z+JwkwP47Oc/Zk7r2R8qMubLdYIBU9MVVEsKQ7puyvvjimy
	A5IWW0jyb3bZFEsZg7cv9XQVloE3b/BznhEkHUc96jnQbBD1KtcIBdIpv+Sheo3x
	qKaPQXMm+6z4562XGr5Pu0egnBiraZFycGgjyP/9Yq6Js/8kLD2D5orA2r3eaD7x
	XNXmIwTEkuPtQsUpzHoigVbJvFH1cw9um3/Ahu3+cfoHaj0p6GyJO8ZAprpL3fuY
	X5YQuo4a/e8uyFqktEG4KMTFjQwG00r3uA2mLt94A0tu9oVUOE8vQ==
From: virtiofs-bot@sinrega.org
Message-Id: <23469.122011712560900299@us-mta-612.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Clean up the command line usage
	message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

In the usage message, we show legacy and deprecated options whose use we discourage, as in the case of "socket".

Although the plan is to support the old options forever,  any new feature must be exposed only using the new cli. Also, we do not have a usage message for most of the legacy options (`-o`) and also there is a mismatch with some new options (e.g. sandbox).

Regarding "socket", we've already replaced it by "socket-path" showing a warning if the "socket" is used.

Here we go one step further by hiding those option from the usage message.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/69

