Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=WucApCTkJT5rooZV90lXdHz09CCeNKU5flMO7geRqco=;
 b=oqo0CKKGEoVI8y2f+qKAEt1ktzQfSouq5y/xJEEdkyUyoHoZMudW82tR6Qlb3HFyY6
 31Q5QbHz79EglxCroMPOwkrApl54lCd8VRFdAXywFAhOLasNCdl4zz2m0HFyRqhROJHY
 JZvcG9WVooQ7yZfo+HAQ6saEYtTY5U7b+QSUfo3m7gMRk5/2L0YO1scnIAHFN/NUndzu
 PpLDFjmS+w/r1SaFxkmWXKkW8X0gCXfMcbScf3Us837pzKwzSYBEG+Vd3tryJPxjhBmt
 pcvlhm/JCr0egt42/Zhcxsd8geY7EcHd2ZmHaMFPE0qCI1xpLSPbwMUBHoUhEMafRPaD
 tCdw==
MIME-Version: 1.0
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <20230119074602-mutt-send-email-mst@kernel.org>
 <f9993404-f8b8-7a23-37f8-530313783466@yandex-team.ru>
 <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
 <20230122093903-mutt-send-email-mst@kernel.org>
 <70c0f00a-7828-3ccf-c2ea-49aeef8693e9@yandex-team.ru>
 <20230122111618-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230122111618-mutt-send-email-mst@kernel.org>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 23 Jan 2023 09:09:36 -0500
Message-ID: <CAJSP0QXnKGrX3WuSJxe7pLctcueW1AkEc_KUsHGucaDq=VJZkg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Anton Kuchin <antonkuchin@yandex-team.ru>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru

On Sun, 22 Jan 2023 at 11:18, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Jan 22, 2023 at 06:09:40PM +0200, Anton Kuchin wrote:
> >
> > On 22/01/2023 16:46, Michael S. Tsirkin wrote:
> > > On Sun, Jan 22, 2023 at 02:36:04PM +0200, Anton Kuchin wrote:
> > > > > > This flag should be set when qemu don't need to worry about any
> > > > > > external state stored in vhost-user daemons during migration:
> > > > > > don't fail migration, just pack generic virtio device states to
> > > > > > migration stream and orchestrator guarantees that the rest of the
> > > > > > state will be present at the destination to restore full context and
> > > > > > continue running.
> > > > > Sorry  I still do not get it.  So fundamentally, why do we need this property?
> > > > > vhost-user-fs is not created by default that we'd then need opt-in to
> > > > > the special "migrateable" case.
> > > > > That's why I said it might make some sense as a device property as qemu
> > > > > tracks whether device is unplugged for us.
> > > > >
> > > > > But as written, if you are going to teach the orchestrator about
> > > > > vhost-user-fs and its special needs, just teach it when to migrate and
> > > > > where not to migrate.
> > > > >
> > > > > Either we describe the special situation to qemu and let qemu
> > > > > make an intelligent decision whether to allow migration,
> > > > > or we trust the orchestrator. And if it's the latter, then 'migrate'
> > > > > already says orchestrator decided to migrate.
> > > > The problem I'm trying to solve is that most of vhost-user devices
> > > > now block migration in qemu. And this makes sense since qemu can't
> > > > extract and transfer backend daemon state. But this prevents us from
> > > > updating qemu executable via local migration. So this flag is
> > > > intended more as a safety check that says "I know what I'm doing".
> > > >
> > > > I agree that it is not really necessary if we trust the orchestrator
> > > > to request migration only when the migration can be performed in a
> > > > safe way. But changing the current behavior of vhost-user-fs from
> > > > "always blocks migration" to "migrates partial state whenever
> > > > orchestrator requests it" seems a little  dangerous and can be
> > > > misinterpreted as full support for migration in all cases.
> > > It's not really different from block is it? orchestrator has to arrange
> > > for backend migration. I think we just assumed there's no use-case where
> > > this is practical for vhost-user-fs so we blocked it.
> > > But in any case it's orchestrator's responsibility.
> >
> > Yes, you are right. So do you think we should just drop the blocker
> > without adding a new flag?
>
> I'd be inclined to. I am curious what do dgilbert and stefanha think though.

If the migration blocker is removed, what happens when a user attempts
to migrate with a management tool and/or vhost-user-fs server
implementation that don't support migration?

Anton: Can you explain how stateless migration will work on the
vhost-user-fs back-end side? Is it reusing vhost-user reconnect
functionality or introducing a new mode for stateless migration? I
guess the vhost-user-fs back-end implementation is required to
implement VHOST_F_LOG_ALL so dirty memory can be tracked and drain all
in-flight requests when vrings are stopped?

Stefan

