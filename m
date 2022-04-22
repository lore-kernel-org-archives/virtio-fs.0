Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1650630570; x=1650716970; bh=YpGe8o+X+ot5SfAsrLAgp
 QwllLhHhLpxygo/hJ10Fws=; b=LwR/MfeVvGdGVdv4k61dkva/5zxLbGT8w4eQn
 vseyKhEr0hioTqUaW6PmGk5EPxC9jY02gDSdXNs1M5SDmo6/wFvK9CgkfYyZ0+qw
 lWgkluRBy187z5EWya+JeX7lVeZlI5SFyEWmdwYBXjyGyhdsjDXP2kY0SApRRyF6
 Iv1D9frDSNvVmIeCPVFia2+iN8ljTPASZ7vdtDZGO1c8wefXb9sa6mv/RW4PfuXz
 g/N8bkDab64Q/I3s+AJguZyPLv76G3kNreUtyuxT8GMmre/G7Gk0+03EH+SHlVuh
 vBPq80exjTPPhD+fXN+4fJoGZHJLiy3gx2BJICDyWo6ZjsAMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1650630570; x=1650716970; bh=Y
 pGe8o+X+ot5SfAsrLAgpQwllLhHhLpxygo/hJ10Fws=; b=EImFJoYJyOfmI6J2I
 LGqlz/9PxWcf3EIr6IvwiVam52t6hqBuAHGf3NaOSAeotOkaU0SwaoXEiVkajPNa
 v+hHKudGBAhv8mOrxwnqS0J9DQi8ieH0GYzC6rWEd0fg0oBvb7G3kgto4hZ5N+V1
 URfex79ujYt/FhyRGy8o3eE1uhf+33YpW3g1kHnONeXco00rnhA70hHRvpev1Bbs
 /3YjbtQdsBQa1RjjaqdV+Ha4emO51HFWr+XVfz6guUPzTNWPcOybvuo0Pkwb77xl
 OO60laBBq0vmcvEyYAtnDHiErtX+/AkzjFUdxAsANRhv56E8VHjBNpP/EVXZYCpa
 QAntg==
From: virtiofs-bot@sinrega.org
Message-Id: <26725.122042208293100267@us-mta-404.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 22 Apr 2022 12:29:33 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR closed: fuse: Debug-log opcode name and
 inode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When log-level is debug, log the opcode name (instead of just the
number) and the inode for each request.  Example:

```
[2022-02-11T17:04:34Z INFO  virtiofsd] Waiting for vhost-user socket connection...
[2022-02-11T17:04:37Z INFO  virtiofsd] Client connected, servicing requests
[2022-02-11T17:04:41Z DEBUG virtiofsd] HIPRIO_QUEUE_EVENT
[2022-02-11T17:04:41Z DEBUG virtiofsd] QUEUE_EVENT
[2022-02-11T17:06:39Z DEBUG virtiofsd] QUEUE_EVENT
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Received request: opcode=Init, inode=0
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Replying OK, header: OutHeader { len: 80, error: 0, unique: 2 }
[2022-02-11T17:06:39Z DEBUG virtiofsd] QUEUE_EVENT
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Received request: opcode=Getxattr, inode=1
[2022-02-11T17:06:39Z DEBUG virtiofsd::server] Replying ERROR, header: OutHeader { len: 16, error: -38, unique: 4 }
```
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/93

