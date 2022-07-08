Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1657292244; x=1657378644; bh=29iIEq9Ayh7xJN5qCpGl9
 Jf8W/c0mjkU+deF9hXAevI=; b=RivDqjbj8L6SBUwDGvhQbWAT7KMQMtG8vTzjd
 D5eWbzSLaLKO7QEeEa0XYNn7qg6DDnnh/GnaCg3NBp/18c07GPOn0xf/cJLm2hBF
 Pt6VZDyhPkKfrxXxuy601gB1PZWrAip81m930vgoLa0q9NdXckxtmExo1MZ75y1P
 XmvcnqNV5sRqcRXPFhCcRLGgi+IuoX2anDPPJPSnduUGhvmA0iaPp7DSu62rFSot
 KLPdb12ngR8cg2WbVfoYi/iyLzKuDhpU+D2ADGnwngxA8+l2oZUKRav2fQyhs3EE
 hoTUCNIpr0d2S5X6T6D+F8MPJT94cTPV+FNJFy8PcpjWsxexg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1657292244; x=1657378644; bh=29iIEq9Ayh7xJN5qCpGl9Jf8W/c0mjkU+de
 F9hXAevI=; b=FRucDgG4vRI5APZo3lCYDZgqTtYpI8sgrfysYuMxJRay//3pAhS
 Y5QBHoxnXp7K8XahQ+SJXAF2tttOwiRIoD6H9ROgTzCksMqt0GNR4kHRvI6OJ13A
 7FJYio9oKc+i7WdzWUYyYffGF5evFGMFBHRzwpNJeMJtFc3LfbHCLwCyBT+r6Ous
 kUvpH4CnPlwbF/yDGqsvS2Oahpf6mUWW09NIqND7PaSxHwQH2lEPBRINYnPNt+VN
 MIyOU7YmeOAoWhGOvYFXqOzAPaZAYw1+WP23LjiimdaLMc/BgXqD5Ii2uBEr2Q+b
 ckZAk4DjHaamsGpfxkp6ojdwhWM20sW+klA==
From: virtiofs-bot@sinrega.org
Message-Id: <82986.122070810572500156@us-mta-395.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri,  8 Jul 2022 14:57:27 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Update virtio-queue and
 vhost-user-backend deps
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

There are new releases of virtio-queue (0.4.0) and
vhost-user-backend (0.5.0), update our dependencies to use them.

This time, the API has stayed stable and we don't need any other
changes than bumping their versions in Cargo.toml.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/126

