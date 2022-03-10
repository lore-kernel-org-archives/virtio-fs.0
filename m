Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=BwfVvNrgpoQuQ1ShHkg+kDtSQpgeXHnC8Nw4lEvDoYY=; b=C
 6/PhVXZkJ6EyI+efUZOy0yPKiviBbGO2azxSZGVNLzbiLHM2l/3z3cE6nFaO+kmx
 XVK/430Idj42oW6XefDPnP3GgPrQK2Lh6mhefsaTqoYyPdoVWThGcn0zgQUxJwRY
 I7/ultqDvkQYXgU/Gq/3fr78GyzMNDaeV63PlW7B6MThGOrWL3QRPp/uYJQeZak3
 +5/s0CGsBDnKGOv+afvDjjrC8aJonIBflpamWH4nb5HQjVQkDnRfj/xGiyTtbfEr
 w5HfUCcYLFwi/Gjl/bT3gvJ74zkMJ/PMo1XIRIL+R+/4NEp9/mAEGrZFZuI+uqJo
 4Y+aEpJ4tUsb9kW1hqVrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=BwfVvNrgpoQuQ1ShHkg+kDtSQpgeX
 HnC8Nw4lEvDoYY=; b=SHbFA/Oz3Mc8yGjMYQY13YFWn9RKNQeH+cES0Yg7GQsKR
 YIhv4aX4IRAgI4u+QkwT1f4O/YYOoKtJNcxep58qMlH58i0Ag5QBD/BW6Ipc1YOj
 UrwZ9PRTqWGBocGnkjC/bnhzrhbQgIy4apdYFJeZKfL13Ad4Xka//H3ug/XsCBM9
 IFMPFHzrHQOFRyYk0riK3mYp4J7BB+yEwK+lROOudi71u1nccnRGay6rx8d3tGh6
 bvCVBfxGKrLhwyoelJG/IBVVfBZUxNvAzMq/Gbrz1RCm3gUzI4IvyYMr8Jvp6vuG
 zpk7t7Ph6WvX8JgGibk41supfdGqXYJVX3xBmHNYQ==
From: virtiofs-bot@sinrega.org
Message-Id: <27727.122031010074001438@us-mta-441.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Thu, 10 Mar 2022 15:07:48 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Extend the documentation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This MR extends the documentation in the following ways:
- enumerating the required capabilities
- showing a short description of each flag/option
- porting the documentation from the C version on how to do xattr mapping
- adding links to relevant sections/documents, such as contributing, running as non-root and xattr mapping
- adding the uid/gid mapping requirement for user namespaces 
- adding a shot FAQ section

It also adds the `off` option to the `--log-level` documentation and changes `--sandbox none` to `--sandbox chroot` in the "Running as non-privileged user" section examples.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/97

