Date: Fri, 3 Sep 2021 16:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm1; bh=557VHIHMQfVeYx4BF4IcT6VIHYr7Dk29K2dz3
	A/0Hjs=; b=ZHWgSh70yZs0lw4vnPqdVjufqTK2zDniVYjvnDLqwQVxl2Bosg2Zt
	aNcxl52LUxreNa8dUaVaFIPy+YtZqbTY84eu/zuqWt8XLa0B0Kx4QGPxZEf8xewu
	17rFqjkcSPKr24KvOi0X/S3nDd5Ij34gq/avqoGHaTZ0mNo3uFCmHD1f4+EL6xhh
	mwBs0elfGgCfnLnnktj7nnfecsVGS3GXfuKYOOftXfiqvV2Qd5eOn0YPX/GOjkSG
	KfoMfjpGSQhIEz2XjDA+keB4R6uhDhirylNdVoT/v9U9/st4iupIq/mc+/OXF4Ja
	8geG2fyVuLxO9tt6cskGiPlysXhMNC05Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=557VHIHMQfVeYx4BF
	4IcT6VIHYr7Dk29K2dz3A/0Hjs=; b=Cg5bK0CHU1y9uFk+MPw8VUXuomhqExKlU
	ESu7ZfkNpKHm6OSA6qMZjxxj0s+kHw1QHkDLRHzRtXYn4DKSKmfZeTIp95sroTvo
	/1N+O6Yf8+Cd62U5mEj0QhoD+BYLiAZiiVUZKtzI7Kgb8ia8w2pN9w8FD6ErmU8x
	IACtGFoLTr7QOCV8bPY+TO2hWRpER71io5n61PMZEEdERhLaE+s9cyKuAKI7yOhy
	RqYzytfRfiwJhnaiZaUss52HpIm9QXcHQVzKbUr4ONtFQ3AplDEwQmzASEjlV+QO
	SH2n79Njb9eyNvfvTJJRdP24GXdKO10wvkZSdz6izqTLVsqFV62xQ==
From: virtiofs-bot@sinrega.org
Message-Id: <15299.121090316105500232@us-mta-443.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR closed: Enable killpriv v2 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Most of this series is just setup, introducing the relevant FUSE flags needed to our FUSE types.

When applied, the pjdfstests suite now passes without any failures since the killpriv v2 semantics are upheld by the server.

edit: actually, `getrandom` must be added to our seccomp allow list for the pjdfstests to run to completion. I haven't dug into why, exactly, the server is calling getrandom yet, and it's not included in this series.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/31

