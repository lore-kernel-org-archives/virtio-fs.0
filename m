Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681733070; x=1684325070;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+D315PiBS/y+y+FzxtjkIREoi/fpBaombpPK2YUGb3Q=;
 b=xqKrCfJ6qnTmFdSfVRIPIxFvXFhDR7a1uUMWIYa64RXCGq/+0UTB12LhIVd+gFwHRu
 IudJlwlM6wyYpysH7wd4mpAy3jbyiD6CSfITRHKPxzazZIbsbaDAM01UpmhauY9dEtHu
 Ik9QNBdgVRGZBvEoXwYDCf1BTIa4C08Mbr7nZIav9MPkuyrRgA+BUUiK0iIiUqurCl7i
 9wtOskV+3svtkuGyZZyXRR4jM/LtqjPW8tPLijt6ZAr59IrjTvMnjnCsfJBg5WDY5QK0
 vd1sF5fV+5PXvwSlMB58xdZaKPIrlvSCIX+RLqBJCp8VmslQST10o23hrNZTw6X4O199
 K97Q==
MIME-Version: 1.0
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
 <20230414160433.2096866-9-alex.bennee@linaro.org>
 <87bkjmddxi.fsf@pond.sub.org> <878req9211.fsf@linaro.org>
In-Reply-To: <878req9211.fsf@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 17 Apr 2023 13:04:19 +0100
Message-ID: <CAFEAcA9k424MwkX9Nhwb-x+oTWYJNUCXeRPvfRePtidckidpvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 08/12] qom: allow for properties to become
 "fixed"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>

On Mon, 17 Apr 2023 at 12:33, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
> The use-case is this whole series. Basically I want to have a generic
> device (vhost-user-device) which has a bunch of control knobs the user
> can fiddle with (e.g. virtio id, num_vqs and the like). However for the
> specialised versions of this device (e.g. vhost-user-gpio) some of these
> values (e.g. virtio id) need to be fixed.

> Mark suggested maybe just duplicating the properties in a similar way to
> DEFINE_AUDIO_PROPERTIES but that doesn't really address the problem
> wanting to "fix" some of the values for the subclasses and preventing
> the user from changing things.

This shouldn't be something visible to the user of the object,
though, surely? An object which doesn't have a configurable
virtio-id property because the specific subclass has a fixed
value should look exactly like an object which doesn't have
a configurable virtio-id property because that property just
doesn't exist.

If we add a facility for "constant properties" (which is pretty
much what this would be) then we should do it because it's
useful for users of QOM objects (and especially for users of
QOM objects via the QMP interface) to be able to introspect
them and say "ah, this is a property of the object but it's
a constant value".

thanks
-- PMM

