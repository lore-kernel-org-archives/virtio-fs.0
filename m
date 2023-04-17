Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
 <20230414160433.2096866-9-alex.bennee@linaro.org>
Date: Mon, 17 Apr 2023 12:02:33 +0200
In-Reply-To: <20230414160433.2096866-9-alex.bennee@linaro.org> ("Alex
 =?utf-8?Q?Benn=C3=A9e=22's?= message of "Fri, 14 Apr 2023 17:04:29 +0100")
Message-ID: <87bkjmddxi.fsf@pond.sub.org>
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
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, "Daniel P. =?utf-8?Q?Berrang=C3=A9?=" <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>

Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> When specialising general purpose objects it is sometimes useful to
> "fix" some of the properties that were configurable by the base
> classes. We will use this facility when specialising
> vhost-user-device.
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> ---
>  qapi/qom.json           |  2 ++
>  include/qom/object.h    | 16 +++++++++++++++-
>  qom/object.c            | 14 ++++++++++++++
>  qom/object_interfaces.c |  9 ++++++---
>  qom/qom-qmp-cmds.c      |  1 +
>  softmmu/qdev-monitor.c  |  1 +
>  6 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index a877b879b9..4cda191f00 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -33,12 +33,14 @@
>  # @description: if specified, the description of the property.
>  #
>  # @default-value: the default value, if any (since 5.0)
> +# @fixed: if specified if value has been fixed (since 8.1)

Wat?

>  #
>  # Since: 1.2
>  ##
>  { 'struct': 'ObjectPropertyInfo',
>    'data': { 'name': 'str',
>              'type': 'str',
> +            'fixed': 'bool',
>              '*description': 'str',
>              '*default-value': 'any' } }
>=20=20

qom-list and qom-list-properties return a list of this.  Use cases for
the new member?

[...]
