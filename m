Return-Path: <dgilbert@redhat.com>
Date: Tue, 24 Jan 2023 09:50:40 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <Y8+p8HFG8NxYlfoo@work-vm>
References: <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
 <20230122093903-mutt-send-email-mst@kernel.org>
 <70c0f00a-7828-3ccf-c2ea-49aeef8693e9@yandex-team.ru>
 <20230122111618-mutt-send-email-mst@kernel.org>
 <Y87Ri4r6SiETdCrt@work-vm> <Y87lv8fXrYpxkK/3@fedora>
 <CAJSP0QV5wfXxhvjjFnLLUCvmSxiHxTPXh4qQJwHhnKdBu3EOQQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJSP0QV5wfXxhvjjFnLLUCvmSxiHxTPXh4qQJwHhnKdBu3EOQQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru

* Stefan Hajnoczi (stefanha@gmail.com) wrote:
> On Mon, 23 Jan 2023 at 14:54, Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Mon, Jan 23, 2023 at 06:27:23PM +0000, Dr. David Alan Gilbert wrote:
> > > * Michael S. Tsirkin (mst@redhat.com) wrote:
> > > > On Sun, Jan 22, 2023 at 06:09:40PM +0200, Anton Kuchin wrote:
> > > > >
> > > > > On 22/01/2023 16:46, Michael S. Tsirkin wrote:
> > > > > > On Sun, Jan 22, 2023 at 02:36:04PM +0200, Anton Kuchin wrote:
> > > > > > > > > This flag should be set when qemu don't need to worry about any
> > > > > > > > > external state stored in vhost-user daemons during migration:
> > > > > > > > > don't fail migration, just pack generic virtio device states to
> > > > > > > > > migration stream and orchestrator guarantees that the rest of the
> > > > > > > > > state will be present at the destination to restore full context and
> > > > > > > > > continue running.
> > > > > > > > Sorry  I still do not get it.  So fundamentally, why do we need this property?
> > > > > > > > vhost-user-fs is not created by default that we'd then need opt-in to
> > > > > > > > the special "migrateable" case.
> > > > > > > > That's why I said it might make some sense as a device property as qemu
> > > > > > > > tracks whether device is unplugged for us.
> > > > > > > >
> > > > > > > > But as written, if you are going to teach the orchestrator about
> > > > > > > > vhost-user-fs and its special needs, just teach it when to migrate and
> > > > > > > > where not to migrate.
> > > > > > > >
> > > > > > > > Either we describe the special situation to qemu and let qemu
> > > > > > > > make an intelligent decision whether to allow migration,
> > > > > > > > or we trust the orchestrator. And if it's the latter, then 'migrate'
> > > > > > > > already says orchestrator decided to migrate.
> > > > > > > The problem I'm trying to solve is that most of vhost-user devices
> > > > > > > now block migration in qemu. And this makes sense since qemu can't
> > > > > > > extract and transfer backend daemon state. But this prevents us from
> > > > > > > updating qemu executable via local migration. So this flag is
> > > > > > > intended more as a safety check that says "I know what I'm doing".
> > > > > > >
> > > > > > > I agree that it is not really necessary if we trust the orchestrator
> > > > > > > to request migration only when the migration can be performed in a
> > > > > > > safe way. But changing the current behavior of vhost-user-fs from
> > > > > > > "always blocks migration" to "migrates partial state whenever
> > > > > > > orchestrator requests it" seems a little  dangerous and can be
> > > > > > > misinterpreted as full support for migration in all cases.
> > > > > > It's not really different from block is it? orchestrator has to arrange
> > > > > > for backend migration. I think we just assumed there's no use-case where
> > > > > > this is practical for vhost-user-fs so we blocked it.
> > > > > > But in any case it's orchestrator's responsibility.
> > > > >
> > > > > Yes, you are right. So do you think we should just drop the blocker
> > > > > without adding a new flag?
> > > >
> > > > I'd be inclined to. I am curious what do dgilbert and stefanha think though.
> > >
> > > Yes I think that's probably OK, as long as we use the flag for knowing
> > > how to handle the discard bitmap as a proxy for the daemon knowing how
> > > to handle *some* migrations; knowing which migrations is then the job
> > > for the orchestrator to be careful of.
> >
> > I think the feature bit is not a good way to detect live migration
> > support. vhost-user backends typically use libvhost-user, rust-vmm's
> > vhost-user-backend crate, etc where this feature can be implemented for
> > free. If the feature bit is advertized we don't know if the device
> > implementation (net, blk, fs, etc) is aware of migration at all.
> 
> I checked how bad the situation is. libvhost-user currently enables
> LOG_ALL by default. :(
> 
> So I don't think the front-end can use LOG_ALL alone to determine
> whether or not migration is supported by the back-end.
> 
> There are several existing back-ends based on libvhost-user that have
> no concept of reconnection or migration but report the LOG_ALL feature
> bit.

Ouch, yes that's messy.

Going back to the original question; I don't think a command line flag
will work though, because even for a given VM there's the possibility
of some (local) migrations working but other (remote) migrations not
working; so you don't know at the point you start the VM whether
your migrations are going to work.

Dave

> Stefan
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

