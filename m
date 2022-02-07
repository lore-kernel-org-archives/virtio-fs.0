Date: Mon, 7 Feb 2022 08:55:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=h5edD2I6QkmKGFz4Rf4/rPm+0USYFMxGVUHw2vRl9rc=; b=q
	lT1BbG6aex9eZzJ97LLr64x12fwpk3o0FtyrEhnM8ZtL52gD/+DJAvkUAiotsgKJ
	qzHsgjslAu5BdSQR6sFfoVJ5VN6T+OTJkliKTPYcEv56Lu8GmCLPCf9+xk/1fL/l
	6mpBkWFX3uXVVEg/o9729EBTd5zlt52k2gVrQemd6NyP/CdXa/rFQfH5j2Qc/mb1
	v1Ij+eck/HjdVnY4iaeUaD3kq0haeIzh1YzfKGWd8WT4ARmV4dqgtUD71IEpqFzj
	TjhJdFZdCajPnGtrHg5w8kQNzlItJOpFUCE+xFIc97E2JxcooWE8mT6d4C8bfSlQ
	6XUWfSfIbAqGuv7QRWkEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=h5edD2I6QkmKGFz4Rf4/rPm+0USYF
	MxGVUHw2vRl9rc=; b=WAxu7RNI+Xl9sISig/Eq0Gl9paZ5d/MBR0NQk73AJXs/Y
	logiOGHyA1he8JECXuqBJh4Hv7ru+OHbhfIyzmvdjydDP57D1EICFhx93b41XkjZ
	kqlfCKwEh5ZQxgLcLKXAO8Crl9qWj4tWkd0B1n97W6QJba3DoaED+0QFXnWvjoSY
	ycz+7LKge+AhRrlu6kW6Ri6bbU0hWmoCVOogG6RYp2JHWh1Wf44RBNU2bVedLJnP
	ynmIlQ9eMW2OfmQZ79dX7oNYbOZAzjiWp8W7XJIFWLAVGq4AGz1Us3MNyB0F/88B
	4C7lhV2tOUFbsezjxf6DEe0UpGxuSwoMJVyBoz5tQ==
From: virtiofs-bot@sinrega.org
Message-Id: <96773.122020708555300841@us-mta-124.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue closed: Exit child process if parent
	exits
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, in namespace sandbox mode, if the parent process is terminated (by e.g. SIGINT), the child doesn't terminate.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/23

