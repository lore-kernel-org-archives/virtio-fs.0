Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1666017438; x=1666103838; bh=a5vhP98003yd0auPldjXR
 JxaNnzaEnUrlDckNjsc0ns=; b=4MqDysoOlGk9MPh9oG/YNC7MLacfcIBT8Q4Ls
 C6kivdfyAdubjERyV/2tPyRzTyHMu0OXWxrgtM0Nwbef/IA+sY2zP9eT5aSuCUZD
 pPCZnr69RLjD4vQIeJdRPoMxkI7WIKypdC0m4V9vGzYQS2jbm7JCjb2kGdBhRQaR
 k0BSH9bJ/Pzyj6/Kg5MhmCK/l4up7Fu51lKBHSKBW6lQON8CbHbaWVx7iYa3QX5m
 jxnuZxMEEhNcOMQL9CQ4Fg/8HW/bzzxWxpig3BFV6+KHci9Z0uKs1qdjZ3VyZZQY
 99BTrpouIYH0evXM1lEMI0DJvRQeuCkcSWcSRLPN6yjrk1Enw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1666017438; x=1666103838; bh=a5vhP98003yd0auPldjXRJxaNnzaEnUrlDc
 kNjsc0ns=; b=TpM1vRz+4NJZR79awtZXVQWpSKxrTZIDBOG0EFQlIuDxBrcT3Xi
 9ckZs6OQIu3/HGzboYgdrLvxaEpledXnkLwcPVzRfXDTcptvgjLf24ayjROy6EXt
 b9DHohVuDgOu4qS4TdNaDkIAfeMG01EznZkUkwkTnCytOvR6SdqW/kqZRj0OcyTt
 7Xef5YkzDgEkbawbj3gvy2VFQd7Pj4ah+qNhraAChwyxfiDpSLZmEpmlex8S65k/
 a+MPbulCM9k/fm1tX4kALajwyB6WQ0JXKL6o8HaDAOaIpOSYuyII/L3cYhp9Qve6
 cDGvps6tHiLyxY7cqiXTOTMg3+kiyJFYUKg==
From: virtiofs-bot@sinrega.org
Message-Id: <07050.122101710371901767@us-mta-455.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 17 Oct 2022 14:37:21 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: [Draft] Keep DAC_READ_SEARCH on
 setxattr with posix acl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If posix acl is enabled we change the effective uid, if it's changed
to a non-zero uid hen the effective set is cleared from all
capabilities. We need to keep `DAC_READ_SEARCH` if file handles is
enabled. This fixes the xfs test `generic/375`.

closes #56
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/140

