Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=sc0H+0gmVKP1oP3Lc8YZbSe5M9VsRpfAa6swb68wD80=;
 b=xZfyIV0sEKGpOPdpeDLh1ncn62F4ZubWU/Co/cps4799Dad3FYLz3r562cz7OkcSYY
 hQE9r3jQ+yFCZ7WuKOYK59gEWy07ddGKeZOHO1ROwSnrcoDwVea18pUkSxcegOAnUjFY
 0QEDVkNqi1p2xWecerXX+4z6JsDBzQMfks1XtoQVZL4PgdSaVuHd47v9OoG3kcIpoEPk
 UvMiwy4m9/gq5wtDmLm0rROdCH/qGOIl5NI82sQTMBW6GXXI5ktPVt/p1ffH4s2t35cv
 V6TgGKzm7qQ+/NNCPn8s4VY5j/thNg/PIdGWeXKaV0y+uZTS4M7JzhY/w3ER7eh8J1X9
 LO/g==
References: <20221107121407.1010913-1-alex.bennee@linaro.org>
 <20221107071516-mutt-send-email-mst@kernel.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 07 Nov 2022 13:30:38 +0000
In-reply-to: <20221107071516-mutt-send-email-mst@kernel.org>
Message-ID: <875yfqhl2o.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [RFC PATCH] hw/virtio: introduce
 virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David
 Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>


"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Mon, Nov 07, 2022 at 12:14:07PM +0000, Alex Benn=C3=A9e wrote:
>> The previous fix to virtio_device_started revealed a problem in its
>> use by both the core and the device code. The core code should be able
>> to handle the device "starting" while the VM isn't running to handle
>> the restoration of migration state. To solve this duel use introduce a
>> new helper for use by the vhost-user backends who all use it to feed a
>> should_start variable.
>>=20
>> We can also pick up a change vhost_user_blk_set_status while we are at
>> it which follows the same pattern.
>>=20
>> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_device_sta=
rted)
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>
> Hi Alex, did you actually check this under gitlab CI?

It's had a clean pass as part of my for-7.2/misc-fixes branch but I've
been unable to replicate the crash it was meant to fix locally as of
yet.

  https://gitlab.com/stsquad/qemu/-/pipelines/687366712

--=20
Alex Benn=C3=A9e

