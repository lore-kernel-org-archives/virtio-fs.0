Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1693933473; x=1694538273; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ekx867mHXd66kuN1xrBjKNaFWHlYvLgGYX8Lg7d62g0=;
 b=ovFL0bDS8gvn1iBAwO/Pk0ZfXdVAszKfPUhVEhDKvghLh87DfXFf208R1VOs0ba9LQ
 Rre6+EEHViw3zzI2zYbS048zEERg4JBJMn/5hRT6rSKNpxTWRoteAqKCfP8PjL4ZtH6a
 f9JHgL9hPQ/zjn7SlM7pZdOId27pzCZSCxJI7z9zLyMKwnC/K9Y8AJQjvFAhgSv6oURj
 qAfq1kJZ1ZOAWm9g9/ALJvlml22dzWnM3J6YdjRQ007lvsJvWGTE1JJayRn0SOwqrqmJ
 XChxhziCQXW0RxVs9PpAv3YxkaOfH3e3IECrcYY7RnovcPVTCvqsReKgI8Hwe1V8MM7n
 fqtQ==
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
 <20230710153522.3469097-8-alex.bennee@linaro.org>
 <ZPc44//qJCPNAOXE@fedora>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 05 Sep 2023 18:01:56 +0100
In-reply-to: <ZPc44//qJCPNAOXE@fedora>
Message-ID: <87ledkh7q7.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v3 07/20] virtio: add vhost-user-base and a
 generic vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Cc: qemu-devel@nongnu.org, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>


Matias Ezequiel Vara Larsen <mvaralar@redhat.com> writes:

> On Mon, Jul 10, 2023 at 04:35:09PM +0100, Alex Benn=C3=A9e wrote:
>> In theory we shouldn't need to repeat so much boilerplate to support
>> vhost-user backends. This provides a generic vhost-user-base QOM
>> object and a derived vhost-user-device for which the user needs to
>> provide the few bits of information that aren't currently provided by
>> the vhost-user protocol. This should provide a baseline implementation
>> from which the other vhost-user stub can specialise.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>=20
>> ---
>> v2
>>   - split into vub and vud
<snip>
>> +
>> +    /*
>> +     * Disable guest notifiers, by default all notifications will be vi=
a the
>> +     * asynchronous vhost-user socket.
>> +     */
>> +    vdev->use_guest_notifier_mask =3D false;
>> +
>> +    /* Allocate queues */
>> +    vub->vqs =3D g_ptr_array_sized_new(vub->num_vqs);
>> +    for (int i =3D 0; i < vub->num_vqs; i++) {
>> +        g_ptr_array_add(vub->vqs,
>> +                        virtio_add_queue(vdev, 4, vub_handle_output));
>> +    }
>> +
>
> Hello Alex, apologies if someone already asked this. If I understand
> correctly, the second parameter of virtio_add_queue() is the len of the
> queue. Why have you chosen "4" as its value? Shall qemu query the len of
> the queue from the vhost-user device instead?

Hmm yeah that is inherited from the virtio-rng backend which has a
pretty short queue. I don't think it is intrinsic to the device
implementation (although I guess that depends if a device will have
multiple requests in flight).

I propose making is some useful ^2 (like 64) and adding a config knob to
increase it if needed.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

