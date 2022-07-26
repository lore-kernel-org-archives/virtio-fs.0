Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1658826514; x=1658912914; bh=JJxb8c/26uVLP3RUglAyu
 5TC4wINLGKiioPdytpjIAc=; b=gWWnplf4Klv7oXwWifbac20h415ubM7upQwwN
 iNicgUdxZTjQ3upjzvGk0XoXLJ4tglpt1owcgzjlNoNFHMDUEFlGqc/Aky8AIXfz
 nYJtFyQF7WL3b5ifkhhIbKUD6iE1/7brXJZdqpL7P/sr4kCiNjNUk1nglywuherX
 Ws+2Bv3jqR1SvWrtMwkZTT7E2dHiguN2WWdq4KFgOzEEB26c0xI4cSb4AFoM3hMV
 Bjt8oCt3Oefe/qBD+sp/ONXd2tSJOI3D8vgMfGVf7+FzsE9YCdaPnWiHHG6Z0iUI
 IZAT/hjb2EtNyDPBG8XnihrajaBvv6AvM9PuG6o7KLJ7CvbNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1658826514; x=1658912914; bh=JJxb8c/26uVLP3RUglAyu5TC4wINLGKiioP
 dytpjIAc=; b=JpdQjuPHgn2vAN9MxgfDjKk/yzdzhDlpQXaWe3SigLAFdVPOJpa
 6l+1d7rIfGZlPStQBdI1BVfKmNwbBvIYRtMaUDXE95CBdRobQhMPZ4KdfZv0VDvp
 7JsWhCNUMd3lriTvU5Cib49q5Xltjbvadtp5NqSQjF06hRV+eAllc3l+8Ounsaag
 D8ueveMXSzdcrHJ7Cz4hkRYfSv0v/Sb9Lwifr2u80VWWh0HBrbRLixGswkWmDr+s
 sXjfqwRGRniaaGvnJv1TlCqc6+G6ky6S+6NcVyDNsQwGA3FbfUmqmjL1dZ3Sxn10
 0d1N1YS6BdtCcfgGZ5ZKwNQQsd2KMZx5SIA==
From: virtiofs-bot@sinrega.org
Message-Id: <74316.122072605083500119@us-mta-478.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 26 Jul 2022 09:09:03 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Get ready to release v1.4.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Updates deps and bump version to 1.4.0
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/128

