Date: Tue, 12 Oct 2021 08:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=R/ArR3XmEEfe3QTgT09vivv5qufDnSb8UJafW
	Ypf0rI=; b=Hcf8GpgkT1hmuKGA4fAHJvhgBVs3Wu1kG9fld+H00PyLRDJ5vylH8
	LkJFoT8SiGn54+JAIpbFHpc29ZC4wrjbEoVwzENjhNlRmBAoG/EdKGgL/6sMNhzu
	ICCw1aAipmCWjL0RfF04FfdZWW+u3Y0r5vFK4LYcxfGZ4jGYKi1PDgaLQXWvnjHj
	o0FQcH966T9yNv6o43ob8i9dsA0bFaUr6TGIfRF9GICnIixm2a9+w2yWyHoo0yRx
	sahyuWMF+o6FvjvH+f8P12PpTS92yVwRN0XMgh723b193A2LOeJ/0ndaZZ17acgo
	E1egFw6TekMOIf2Ko8WjGy9cpiHgnSafg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=R/ArR3XmEEfe3QTgT
	09vivv5qufDnSb8UJafWYpf0rI=; b=JWPplcnRWGV25cE25yOg+wXBWxnj/iiwu
	rXX4VIjsO8yc/0CigiW0SL5y68f/e9hstfqVVJ+pS+kcg661ZhrD2GCIYrU5EIeJ
	ZLGFRz8RaC/HJ4npf1Dm4iFn/v0JGZlxIbRZVlHwDN6wITjKtXcKvD+/fRgTpe5T
	jiPzbsuYyiCdHgpTnuSehOg0z53Cp/YBg/3MICgbMtC9xvxp7WY7K4UlkjhLvbVa
	oli9JM20ZOInjgNeur9GJ1uG23EpeL/ciNrU/Rz19fgGTOsF88wEFsAvOgayfa+1
	NHgRUzyVs/pMGbbM7cGVWyl+QYtkgAYumMZKWBq8JKNW9jiUsnm6g==
From: virtiofs-bot@sinrega.org
Message-Id: <76632.121101208521600417@us-mta-330.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue opened: Virtiofsd panic when
	reaching max open descriptor.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Virtiofsd reports correctly "too many open files" to the guest until some value, after reaching this point it will just panic with the following message:
```
[...]
[2021-10-12T11:46:16Z DEBUG virtiofsd_rs] QUEUE_EVENT
thread 'vring_worker' panicked at 'called `Result::unwrap()` on an `Err` value: Os { code: 24, kind: Uncategorized, message: "Too many open files"}
```

I think the correct behavior would be to continue the error report to the guest while the guest OS tries to open file descriptors without panicking.

I didn't see any other error related to this limit in the debug logs. Reporting such OS error in the debug log might be interesting?

virtiofsd-rs was launched using the following parameters:
```
virtiofsd-rs --socket=/path/to/socket --shared-dir=/path/to/dir --cache=never --sandbox=chroot --log-level=debug 2> "$VIRTIOFSD_LOG"
```

The issue can be reproduced consistently every time on my setup, before hitting that limit everything works fine.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/15

