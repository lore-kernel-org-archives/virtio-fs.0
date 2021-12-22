Date: Wed, 22 Dec 2021 10:30:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=dBaWyPD5bAZgMfFYuuejzalriA9ri8tFa8yUT
	XCldWs=; b=eu0pfFHKRiqToO780N3aMhJoml/sxiZcZs3zFoLBcqfDNxYrPn1U8
	7x/YFUMzMfHZL0uC24Xjppr2GGfaOkVIGZxGSAhY+n34zP+3n1qA7JzBAdMUt4g+
	nlooG7RxJao7L+1YpLARWScbqEQOh+OTbjePsoxkTxe16wxKcaAo3rGvM+JN0zHY
	T2I/QPO1R2CirTpu3Bw1K1xDybRaW2d7q+bhLCarRDZzhrCecPrIdVeaOGRYRq6q
	RUrpql/TnfmR5o5b/EZZsa8bM5Tq4ynkwZ6kj1PFHBQQEQlXtKEJbsWsX8rh96dt
	AshH7cuDopPkUHi93Uu0g0/VvPUIV2O/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dBaWyPD5bAZgMfFYu
	uejzalriA9ri8tFa8yUTXCldWs=; b=fzgO5SIVrYo7cuhNFWJQwuLQiWJVbJI/R
	FEFnxLFogUwY67OJqjieo4OWc4Vhmw0/+htjSSNGALB9SYuqaiG+szGHflnuNtun
	t+XPoOawsTJijpkzW3Kc8NmxUDhJIq49xGR3zfIK0k0F+rCuZoJP593KynbCmPj4
	UgsA4zbeo0gn0g7fZO2XG/QmGo+D2EdfX2hz66Eq3X38Ch8HUSCT1Frpc4C9ju7i
	DfiYKJLIjmw9eJ+CtdmlrXYVAWz+hZFYm58EifC5Ffmk5eAaOKza506EVoTnpKfW
	UxwXHJpgMtRTbur0wBxI7wOJSYbTvdTPEguisHuTAM77Pijap8Yxw==
From: virtiofs-bot@sinrega.org
Message-Id: <37519.121122210300900125@us-mta-389.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] =?utf-8?q?=5Bvirtiofsd-rs=5D_MR_merged=3A_Strip_share?=
	=?utf-8?q?d_directory_from_mountinfo=E2=80=99s_mount_points_with_s?=
	=?utf-8?q?andbox=3Dchroot?=
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When using *sandbox=chroot*, `/proc/self/mountinfo` still contains the pre-chroot mount point paths.  To open them, we need to strip the shared directory as a prefix from them.

This series does so by first canonicalizing the shared directory path, and then (when using *sandbox=chroot*) stripping it from every mount point in `/proc/self/mountinfo` that we want to open.

(Reported by German)
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/58

