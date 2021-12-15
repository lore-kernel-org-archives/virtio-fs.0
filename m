Date: Wed, 15 Dec 2021 09:36:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=L6iK9Vwgb3ESHbXe7JL4H+mDtMpw35ouCk9Yk
	mHg/vs=; b=fmd5c342YT8L+JEbWcw3XjIKDU/4cJDnJDFPSunT8zZNVJaty3wNg
	MDGU50WQYz9cRxL0lUaXiHf7HD4xTBOEIb0JfcYfJNSTjXHHEq5+gEE7DdcekvLz
	86Qm3pL11FRl6DMr/y7LubbEw6uIwQoaMdZPp/+JJxhFA143lOj0Veb52/L4DOmS
	mrt8fDCDHWVqKIufU3xLgzjBeaUzTPXOaTwzs4zuk+qIabYKQBJ6W4kz89t39cNK
	6WIT1HJ4OzCW4ac5as0EPH3Hb6B4o7gdoqJ6axdurTRJZAK1nELbaqqUhi1Oqz70
	Kq2lO3SpY/UHdpqN+1Rd4X58/3JJq59Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=L6iK9Vwgb3ESHbXe7
	JL4H+mDtMpw35ouCk9YkmHg/vs=; b=XE7isGG8z38xuJVV4hg9T6S9Zj7b51DaA
	17iwhNmROfjVlmuP10tt05W7ff5Kjyp5+SmoAiWSNF2aMHdHxh49eyUHQsCAbVhC
	HXseAfQ6sN+nD7Md99sAVqnDqtKM2N4z1hJGNYlRViuedqU4BTNZhsEArYCa6JJS
	HDDs6jd+mGS+2qjNnw1ypOVspOeyCiyEIfRln3GhcQNesLmJNz1MY3bGa6BP0+fG
	9YfKcXm1zqg1IYL0Fo5C/GY0Sds9hnZDIlkzK8AlD15EpObEB5JRxNUpaW7iAJvt
	T2Ry780IoApeE1yzttUoWrJZ21Iun+4JSNoUPMU8BmoEBPwE5PNfA==
From: virtiofs-bot@sinrega.org
Message-Id: <60015.121121509360000570@us-mta-509.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Display vhost-user Listener
	error messages
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If the socket creation fails, it shows only the error message instead of being mixed with rust errors.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/55

