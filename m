Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1667923326; x=1668009726; bh=jTIbWc1ZL/o5pFcItO6iS
 aQ3MD23fZw6kH8bRYGO69I=; b=R4a5m18gzWLCbz6DlnhhgsAyPSrM16hm+yEw/
 Lmpdn3K8QlUDeODpgRFp3NnUQDvPEorP43srQQbcXIRnpa53b1YGZITd0K80odnL
 g2wE7HMqKUnAh0WKUtGDTGMe0iqd197xGZKO81eSfmjFg8xCKeCZncDeERogr0LC
 bKlHINe5H7dHq+lb+ES2MoE9aaGYxYQYuyqEGeKp0Dj6lQVkXq3SkeabkTBwp5UX
 Qfldp8qzzr7LFjBRFQ2QImhd/+jGipbNrJ+ZbFp5N8ktWjdSv0gJOZcQOsXjQigl
 VU9/Kow7iOIPxBUod2++knAXdNBlCg7+ERN13oDz5BAyVxk7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1667923326; x=1668009726; bh=jTIbWc1ZL/o5pFcItO6iSaQ3MD23fZw6kH8
 bRYGO69I=; b=Fyn2G1cuxSK7bkQuW1SmNcM+efY9WWGbt1NwUhzWi2lFin/59bB
 vD347SZJ/f7LiYesIidmkrAQcRHiUw1iajxki1qb9tHyIZ/hX1I7oGsS7hVwL3Ej
 03lNZdTwe81k7EHTE4IUxMTZYwqyi+K3OyGFD1dA3cTvUDzBFb9QTV9MHe+PXQUO
 TFaVr/2Q/ZIqGODptHoIE0xLmeHljssJdu9lUnZoMtYbvr1hgfwSiwYb1vilkPsN
 BqzUJ1UClFpSfrAcRsXEU11c27eakWw7V5vnLzkodjbzltmPswSrHFssbt/VFxmL
 XnLg6jsnbmlBMNECx3lh/4W/OzG3wuhc0fA==
From: virtiofs-bot@sinrega.org
Message-Id: <68290.122110811020602504@us-mta-635.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue,  8 Nov 2022 16:02:09 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: sandbox: Allow non-root users
 run the daemon without isolation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Although, virtiofsd expect to run as root, either as the real one, or the pseudo-root inside a user namespace, there are use cases there are use cases that need to be able to run virtiofsd as a non-privileged user outside a user namespace.
In this mode many operations will not be available (e.g. chown).

There are some issues that are related to this MR: #8 and #43. Besides the request in #8 recently there was a request for this functionality in the matrix channel, I am creating this MR to have that discussion here.

Notes:

- Some operations fails, like chown, but these also fail with --sandbox=namespace.
- I want to move the capability-related code and `enable_seccomp()` call into `sandbox.rs`, so I don't need to "leak" the info about the sandbox type chosen by the user.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/136

