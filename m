Return-Path: <hreitz@redhat.com>
Message-ID: <07282c72-7a83-70c5-395d-454281663eb1@redhat.com>
Date: Wed, 27 Sep 2023 10:32:14 +0200
MIME-Version: 1.0
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230925204852.GG323580@fedora>
 <fc005d50-03ba-0b8f-d9af-64a5297395a3@redhat.com>
 <CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com>
 <CAJSP0QWC1VsAr6k745cumQ7zehEYWRqY_0+gdj9ZtNuwZDNtAQ@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QWC1VsAr6k745cumQ7zehEYWRqY_0+gdj9ZtNuwZDNtAQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 0/5] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, "Michael S . Tsirkin" <mst@redhat.com>

On 26.09.23 22:10, Stefan Hajnoczi wrote:
> Hi Hanna,
> I was thinking about how this could work without SUSPEND/RESUME. What
> do you think of the following?
>
> 1. The front-end sends VHOST_USER_RESET_DEVICE (or
> VHOST_USER_RESET_OWNER, when necessary) when the guest driver resets
> the device but not on vhost_dev_start()/vhost_dev_stop().

This is half the work of SUSPEND/RESUME.  It isn’t easy to do.

> 2. Suspend the device when all virtqueues are stopped via
> VHOST_USER_GET_VRING_BASE. Resume the device after at least one
> virtqueue is started and enabled.
> 3. Ignore VHOST_USER_SET_STATUS.
>
> Reset would work. The device would suspend and resume without losing
> state. Existing vhost-user backends already behave like this in
> practice (they often don't implement RESET_DEVICE).

I don’t understand the point, though.  Today, reset in practice is a 
no-op anyway, precisely because we only send SET_STATUS 0, don’t fall 
back to
RESET_OWNER/RESET_DEVICE, and no back-end implements SET_STATUS 0 as a 
reset.  By sending RESET_* in case of a guest-initiated reset and 
nothing in case of stop/cont, we effectively don’t change anything about 
the latter (which is what SUSPEND/RESUME would be for), but only fix the 
former case.  While I agree that it’s wrong that we don’t really reset 
the back-end in case of a guest-initiated reset, this is the first time 
in this whole discussion that that part has been presented as a problem 
that needs fixing now.

So the proposal effectively changes nothing for the 
vhost_dev_stop()/start() case where we’d want to make use of 
SUSPEND/RESUME, but only for the case where we would not use it.

Hanna

