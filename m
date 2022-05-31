Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653995611; x=1654082011; bh=BQ8Z96znvkVZhDxKmXZBq
 Ac4oRi+H1r/ollbC+6rqa4=; b=b36gOgF227AKaZi/OiI3/UYomSaW7i+SKMYyw
 roeSzTAqdlNQnnQznD0hllq4pzZRgIiU3mnoA6Vhudb2tTNvX1gN+EhDA2/tu7Ri
 WEYAelekdeGpD6m0eWZoViC76bIiaxhujZR3Tlq2b1kBtZNriQvJ2hNezT9WumcK
 oqEOMZVv5HfRLNeSzmywTsRoLxGfX8PDWsKPquayscFR4EMwgnroJaJRWqKIUsK8
 3YPJb1xf2m9IB0wwiYo2+DGoeyEQ82X9jrwayuZI4ajbYcAcBCzDhHfyucfLyhkj
 n4MJL2tOjfqQCJSj61oJF41kkXGS8H2/81wLgQI9QSRoUrAgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653995611; x=1654082011; bh=BQ8Z96znvkVZhDxKmXZBqAc4oRi+H1r/oll
 bC+6rqa4=; b=rn8QjxCYNPs0DtnaffjORiuJnB4Ly/Utp28acm1EUybSvuIeN6b
 4NfOPRYYcffaVnnbOllcBxnbNyLTIuQrG1bMzb8oQCej0Z99GblbRoYShRfmW9hA
 0wS+3Tsm4+sxjzyVKz3TE5slpHRf2rFKMwE5VeTpVELB8ROlDZIhQiHL+TWujsnB
 t7O8ikmtuB0T7RsTNcQ1GZR6sGbrlZ4kYGo/4toVkibdXc0XsdGNqwdxDF3ujGil
 TCNIcY9fwRN8bByzzZAKtLar8e1E0pZVtyBB1fU47J5wUny4I6oQix/jzKhaGHLq
 D4i4FFb5tpu1mM4LDEmfLegVhsFQE1duVfw==
From: virtiofs-bot@sinrega.org
Message-Id: <87192.122053107133301613@us-mta-282.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 31 May 2022 11:13:36 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Show the nofile hard limit value
 in the warning message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If increasing the nofile rlimit to 1M fails, try the hard limit, let's display the value of this limit in the warning message.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/120

