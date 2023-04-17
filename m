Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681731196; x=1684323196;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=DrlnDqm9t4GCDwRLA0BVqcv3xQUQ/GO+I8SKwBgxv/k=;
 b=wsFHvT1BdB7SQ7ryjJaBSDh/R7j4vLZvk5sgWkFUKST+J+UsMCe4colhyWt7Rvwf9+
 XJwLpk36ZWu2SYwIv8zdexJqQQH+yb2ayAOUcBj6bS0opwAftgtSz106y73xe6N5uOFO
 KZwvkRLtUPOfa0W0aib1+BVJMcB2evUp76zlXkTw0/KIje3rZokK1bSSeu3cryTmHqJq
 4aK4Lq/+dMkM8RuFAYAqvZ2+mobgT/oE4MDZgdZuU+UG4WzP2XjlfQOgIWtVzXPR8E9t
 U1WiqOH6X+tylcaApiT9/x35Xa5Y1JdSshEQbNe5el3N2NFoorleOh+1GtrcBJ2lyJzs
 jyNw==
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
 <20230414160433.2096866-9-alex.bennee@linaro.org>
 <87bkjmddxi.fsf@pond.sub.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 17 Apr 2023 12:26:31 +0100
In-reply-to: <87bkjmddxi.fsf@pond.sub.org>
Message-ID: <878req9211.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>


Markus Armbruster <armbru@redhat.com> writes:

> Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:
>
>> When specialising general purpose objects it is sometimes useful to
>> "fix" some of the properties that were configurable by the base
>> classes. We will use this facility when specialising
>> vhost-user-device.
>>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>  qapi/qom.json           |  2 ++
>>  include/qom/object.h    | 16 +++++++++++++++-
>>  qom/object.c            | 14 ++++++++++++++
>>  qom/object_interfaces.c |  9 ++++++---
>>  qom/qom-qmp-cmds.c      |  1 +
>>  softmmu/qdev-monitor.c  |  1 +
>>  6 files changed, 39 insertions(+), 4 deletions(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index a877b879b9..4cda191f00 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -33,12 +33,14 @@
>>  # @description: if specified, the description of the property.
>>  #
>>  # @default-value: the default value, if any (since 5.0)
>> +# @fixed: if specified if value has been fixed (since 8.1)
>
> Wat?
>
>>  #
>>  # Since: 1.2
>>  ##
>>  { 'struct': 'ObjectPropertyInfo',
>>    'data': { 'name': 'str',
>>              'type': 'str',
>> +            'fixed': 'bool',
>>              '*description': 'str',
>>              '*default-value': 'any' } }
>> =20
>
> qom-list and qom-list-properties return a list of this.  Use cases for
> the new member?

The use-case is this whole series. Basically I want to have a generic
device (vhost-user-device) which has a bunch of control knobs the user
can fiddle with (e.g. virtio id, num_vqs and the like). However for the
specialised versions of this device (e.g. vhost-user-gpio) some of these
values (e.g. virtio id) need to be fixed.

Mark suggested maybe just duplicating the properties in a similar way to
DEFINE_AUDIO_PROPERTIES but that doesn't really address the problem
wanting to "fix" some of the values for the subclasses and preventing
the user from changing things.

I appreciate this is possibly a horrible hack so I'm open to the QOM
experts showing me the correct way to model this sort of behaviour.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

