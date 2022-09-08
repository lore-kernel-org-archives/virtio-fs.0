Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1662670197; x=1662756597; bh=5wiZ81TA1AjhSfC21Kbmd
 S5RQ3FFMEL0LhGt39zKVPk=; b=KR83RI/ijcQs9/cSqdr6zrmwlPJtwZqJQEmfI
 N+Y7EiVqImAoa6PDMA9r0Vq694Xs8oAr7RsCDl2wCePMqpkEtGFO56HhAio3P1u/
 ZZnUnm+RbItECZHw5ucA8KXjrPYqsVByj36lm9vimPgucxX2oSuGV9UO/L8fRlTH
 2XcrA0AHgXO0JtioU/2wVHX8ED9DZwLxrCSa07K2Y/F7nv6Svw7PpM+6w+dlTD+q
 6RaE+v47SyjmIW7DURX9AQ6qD6DJ3a5Xzw4qF+0B1UMrT2kkP712QNTCG+JSqp5+
 nqbgcB3uG9q3GgqNyYok2C3/eWtKkc7NgyR2x+OV+ndHNkmGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1662670197; x=1662756597; bh=5wiZ81TA1AjhSfC21KbmdS5RQ3FFMEL0LhG
 t39zKVPk=; b=wfgk94iTnWnBUAGiZCMQ37TrmD0ehhWQkXjfgo6r7lotEZOBLW2
 VXSefjAMNXI9GoMmzIJ5F6HTq/HlcIH79e4nb+lGg4IIay3H8/M1sZwYue9Ix5fz
 Vc1wnflVA6jOlzjW+lYgj0rHLoodJLFIfrO+rZKQwEhAv3qhoVyyzRD1v/WEwsrS
 2Ewa0V4XWyKtBSV8r4Xxx8jJyOySvLUQTFIFgPQzr++dxp9X/zRRibA6d/KR/4F/
 coapZNu6PnV+yoGYPZanHztivrJY3LgSXDrHDi6DFg5zEgYaaGeHPVh5kcDTUswJ
 G/2xzzsB4qLr9WvbU1CPQOzn6gTO7DynsOw==
From: virtiofs-bot@sinrega.org
Message-Id: <91993.122090816500001879@us-mta-447.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  8 Sep 2022 20:50:04 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Draft: enabling a non-root user
 to set the UID/GID mappings inside a sandbox
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This patch enables a non-root user to map a set of UID/GID mappings from a namespace to another set outside the namespace. Since unshare is used on the main thread of the virtiofsd, once the thread goes inside a namespace it is not able to map a range of UID/GID other than the current user/group that is running the virtiofsd. This patch enables a non-root user with CAP_SETUID, CAP_SETGID capabilities to set multiple mappings and then drop those capabilities. The UID/GID ranges can be specified using virtiofsd command line parameters.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/137

