Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=wpSrX/s9TOStVHcGx5Jb4bjLgqV7r0jFGh7V2kckMUg=;
 b=fHpBC4MO31XnGFYQGwVWLe3yRHL9XZ4AzoGuKmsGt8r0hy9EoiCJf9Pengt3xOQKD7
 MnbxEkmXxJeohU7zHRtgFPi+LKlRtWHGVdj/ok1EEIkNlC1qRsLTTirxHrYn7QX5UAcF
 MpvtBIs9jQXPf7V+D4oHo97BiSpuHHU60Nt0oGNQHLEZEh1kcglugH0veeCpgcv4WbUJ
 I7NakT9HQPUX98VVlGNJeqJ4xHX5qxo32xLWEgP+JO50qyRaahc82wM/jkJOcAxrwkIG
 sepkIwcBjez898CIabfPya2VPB+8/Tm33VNCNmOlBAd2zXNkhkmsmujY4gNGM5/5z+O5
 6Rjw==
MIME-Version: 1.0
References: <20230130140225.77964-1-akihiko.odaki@daynix.com>
In-Reply-To: <20230130140225.77964-1-akihiko.odaki@daynix.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 30 Jan 2023 11:12:21 -0500
Message-ID: <CAJSP0QX02UCc2oZmz_ZQdxd1sdpQxZGmk4LOhjx1P0G3rN8VzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: Back up vqs before cleaning
 up vhost_dev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, 30 Jan 2023 at 09:03, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> vhost_dev_cleanup() clears vhost_dev so back up its vqs member to free
> the memory pointed by the member.
>
> Fixes: 98fc1ada4c ("virtio: add vhost-user-fs base device")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  hw/virtio/vhost-user-fs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Merged into my block tree, thank you!

Stefan

