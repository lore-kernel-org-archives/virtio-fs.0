Return-Path: <mst@redhat.com>
Date: Mon, 23 Jan 2023 16:00:50 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230123155228-mutt-send-email-mst@kernel.org>
References: <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
 <20230122093903-mutt-send-email-mst@kernel.org>
 <70c0f00a-7828-3ccf-c2ea-49aeef8693e9@yandex-team.ru>
 <20230122111618-mutt-send-email-mst@kernel.org>
 <CAJSP0QXnKGrX3WuSJxe7pLctcueW1AkEc_KUsHGucaDq=VJZkg@mail.gmail.com>
 <21b87a0d-99b1-2755-00de-d1201d85a63e@yandex-team.ru>
 <Y87k0wBnHuf5Oktp@fedora>
MIME-Version: 1.0
In-Reply-To: <Y87k0wBnHuf5Oktp@fedora>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Anton Kuchin <antonkuchin@yandex-team.ru>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru

On Mon, Jan 23, 2023 at 02:49:39PM -0500, Stefan Hajnoczi wrote:
> The point of the migration blocker is to prevent breaking running
> guests. Situations where a migration completes but results in a broken
> guest are problematic for users (especially when they are not logged in
> to guests and able to fix them interactively).

I thought it's the reverse - we block when we are sure it can't work.
If we are not sure we should leave policy to orchestrators.

You can always get into situations like this with stateful storage (as
opposed to RO one).  For example, naively scp the backend file then
start migration. Will seem to work but corrupts the disk (I didn't try,
for sure with raw but what about qcow2?)

> If a command-line option is set to override the blocker, that's fine.
> But there needs to be a blocker by default if external knowledge is
> required to decide whether or not it's safe to migrate.

If all the command line says is "I want migration to work" then
that's more like shifting the blame than helping users.
They just learn this one weird trick and it seems to work
until it doesn't.  Then we are like "we told you only to set this
flag if you are sure" and they are like "well I was sure".

-- 
MST

