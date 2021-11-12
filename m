Date: Fri, 12 Nov 2021 06:54:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=uWhUYrYa0lWQS7xISBWwoCLzaqOpoLcA5gkGh
	52QrOE=; b=JBD3LiB7gDKDS3DhjnxXYLNugSdK/j8mfEkVWWtdjO99kz1bu8dDp
	fIwlkU1/KpKJGprQocl/PYBcK/bb7NRIJRGYm7Dg9U6ySHutYfOSly13kWsxYqh+
	1I9qF9jkqRlZ63eHySsSjazRv9tXMSEJvGNF7N6SlCiX66OQnN7JJtmOMISnXQhX
	/kE0KOZEPsNeqjp9eA/MU1DcN7Rc0XK3RuooMQeOiQQs5oAXcZiOzRKRV+UZbpP0
	djot9KgQTCcv9TUAkjcEx2gb+hmjVX+XH4bqtlwpEklDWYFVX0nd5vtGF9M+JLC3
	mGYI2inVcfIqiDzdjZm5prDqmO4nRDIrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uWhUYrYa0lWQS7xIS
	BWwoCLzaqOpoLcA5gkGh52QrOE=; b=AkS573ZDyUaeXL5lw58tCETzc8BsmKe9P
	hR+ez1oUDGh7H8QQrSGW1mfw1WY8SQCHH0CjA5b3Mnm+kUhkIvC+uVqx/gmIjTs2
	UpJMSlTXwFcxsnZG7d8DBfqRRD729yr3WR7YFq54VRa3qtmJEvQ/JjOVhZPNIpOf
	6rmGhxFFlMfkQGzJr+MupeJku5c7taplE7WQhohTu7liQC1yRwOXPJLWdyFxDM8k
	QEi7Zbo6+Vx3kt6h3PQiwu7GILqYvrLbGijG1N7UOEY0Rio19DubcthBbOD/hKdo
	YcrhJQM4HTO6UqiPH1OO148H57sm4aB88DIEsp4InlY5Z3h4EZeDg==
From: virtiofs-bot@sinrega.org
Message-Id: <13198.121111206543500385@us-mta-320.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Allow clone3 syscall in
	seccomp filter
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Some versions of glibc make use of the clone3 syscall when spawning
new threads, so allow it in our seccomp filter.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/46

