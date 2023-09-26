Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20230601; t=1695759024; x=1696363824; darn=redhat.com;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=5W5UuzApDobFxllbahNZg+wSgqqg/hh/L/DeY9gruqM=;
 b=AqgjSnAC3TsuTi/FugC7C6VyAO4QQN0GnNXDO7qJ65b8fJMvdp2SlBIyVlBArfJUaf
 IEZ/dvXKWM/ZEzWJkFKQZNUkC7yYgA33294TPBKx7rPTHA0l/IGOKtyPo35GTk8B9tvh
 AYY1LMl1n3PANPxaVKyGldipfTuNgtLRrfoelxPREYH/0hYzTFO2uuqbuSEKFmoRUkBt
 4n5kaAQtent1JexvFSXRqm5GlnT1c4a/JB4mf4BftrUeg8a06nUf7J5SUZdXSjd4MwhN
 wBhAtIlz9bIa6dus+YpMbkwGQV4JhK+Jiw0PaLGKE03pjfNR9/RWwMi+eryIdAxt+zOR
 wC7w==
MIME-Version: 1.0
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230925204852.GG323580@fedora>
 <fc005d50-03ba-0b8f-d9af-64a5297395a3@redhat.com>
 <CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com>
In-Reply-To: <CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 26 Sep 2023 16:10:11 -0400
Message-ID: <CAJSP0QWC1VsAr6k745cumQ7zehEYWRqY_0+gdj9ZtNuwZDNtAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 0/5] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, "Michael S . Tsirkin" <mst@redhat.com>

Hi Hanna,
I was thinking about how this could work without SUSPEND/RESUME. What
do you think of the following?

1. The front-end sends VHOST_USER_RESET_DEVICE (or
VHOST_USER_RESET_OWNER, when necessary) when the guest driver resets
the device but not on vhost_dev_start()/vhost_dev_stop().
2. Suspend the device when all virtqueues are stopped via
VHOST_USER_GET_VRING_BASE. Resume the device after at least one
virtqueue is started and enabled.
3. Ignore VHOST_USER_SET_STATUS.

Reset would work. The device would suspend and resume without losing
state. Existing vhost-user backends already behave like this in
practice (they often don't implement RESET_DEVICE).

It's close enough to what you're proposing that it doesn't require
much additional work, but I think it covers the cases.

Two concerns:
1. It's specific to vhost-user and diverges from vDPA.
2. VHOST_USER_SET_STATUS might be needed in the future even though
it's not useful today.

Stefan

