Return-Path: <mst@redhat.com>
Date: Sun, 22 Jan 2023 09:46:18 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230122093903-mutt-send-email-mst@kernel.org>
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <20230119074602-mutt-send-email-mst@kernel.org>
 <f9993404-f8b8-7a23-37f8-530313783466@yandex-team.ru>
 <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: add capability to allow
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru

On Sun, Jan 22, 2023 at 02:36:04PM +0200, Anton Kuchin wrote:
> > > This flag should be set when qemu don't need to worry about any
> > > external state stored in vhost-user daemons during migration:
> > > don't fail migration, just pack generic virtio device states to
> > > migration stream and orchestrator guarantees that the rest of the
> > > state will be present at the destination to restore full context and
> > > continue running.
> > Sorry  I still do not get it.  So fundamentally, why do we need this pr=
operty?
> > vhost-user-fs is not created by default that we'd then need opt-in to
> > the special "migrateable" case.
> > That's why I said it might make some sense as a device property as qemu
> > tracks whether device is unplugged for us.
> >=20
> > But as written, if you are going to teach the orchestrator about
> > vhost-user-fs and its special needs, just teach it when to migrate and
> > where not to migrate.
> >=20
> > Either we describe the special situation to qemu and let qemu
> > make an intelligent decision whether to allow migration,
> > or we trust the orchestrator. And if it's the latter, then 'migrate'
> > already says orchestrator decided to migrate.
>=20
> The problem I'm trying to solve is that most of vhost-user devices
> now block migration in qemu. And this makes sense since qemu can't
> extract and transfer backend daemon state. But this prevents us from
> updating qemu executable via local migration. So this flag is
> intended more as a safety check that says "I know what I'm doing".
>=20
> I agree that it is not really necessary if we trust the orchestrator
> to request migration only when the migration can be performed in a
> safe way. But changing the current behavior of vhost-user-fs from
> "always blocks migration" to "migrates partial state whenever
> orchestrator requests it" seems a little=A0 dangerous and can be
> misinterpreted as full support for migration in all cases.

It's not really different from block is it? orchestrator has to arrange
for backend migration. I think we just assumed there's no use-case where
this is practical for vhost-user-fs so we blocked it.
But in any case it's orchestrator's responsibility.

--=20
MST

