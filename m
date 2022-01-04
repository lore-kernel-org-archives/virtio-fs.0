Date: Tue, 4 Jan 2022 02:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=YosFvFqyx7Hp5JUroHAK+nxmcYMlP6hI27hLS
	LMSWXg=; b=fjX+bsus8Th26wif1XqAqHM+DtZXR8Qwwsqj6pKwA7zOgYRhYLCMT
	N8GR+Uzu44r1JWih9kzuBM1sy5aHaayuD18umEjHr9tjOHLwrPLGjwzZQj9ya7U4
	6ux67eBSBRDDa+Hxv2h8PH9wZuAbCvQvPOGoX3jabIMp7OA/cYKujjyeKlilGZrx
	GqyXrUZ0LQvmer6bzBB3dZ/sgeMcsY9AtnG+AI15UQQzYjzcQwYATJqU1j+hj8Y7
	nLR4/hsUzopM24qjOktJVG8ssQw/JqmkkqpfoM7Jh5JxnbrJ8581W2ats+V1urWc
	yk9wSTcbft17bQfdZ002qcOy4elfVIRTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YosFvFqyx7Hp5JUro
	HAK+nxmcYMlP6hI27hLSLMSWXg=; b=fqXIYmlT4al+HmlL+02yAj0lIE/vOOe40
	g9/G8HyJI9B+zlbjHUmnMiBu/64BY/1pwoxHyvig4ts/rxU9oxxt58+VBWxWT3VV
	DOKxz+PTkgW4DwEU5EqFmg0sItUhiWtH82SGLx5CDqrqzSBHqHeWKoSr9bJkLacj
	35rcAMwdIJx795iYiifF3ZstKGkiu9R1iJZYA60llHGezdyKxKzIAMi4aW8N45Ds
	aI9G3wgOVLMAZ+vI6yKH6qrpJDDGQFHctMNG9eh4ej8hChjrPwYqHDAN2v3jKdGi
	D0uxw8kmfkdz2V93gdYxqeBBr4hrfm5E5raMqjs0iYoIn5e8gNpJA==
From: virtiofs-bot@sinrega.org
Message-Id: <89102.122010402550500681@us-mta-615.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Adds killpriv_v2/no_killpriv_v2
	options
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Adds options to enable/disable FUSE_HANDLE_KILLPRIV_V2 by specifying
option ```--killpriv_v2/--no_killprov_v2``` or ```-o killpriv_v2/no_killpriv_v2```
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/62

