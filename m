Return-Path: <mst@redhat.com>
Date: Wed, 1 Mar 2023 10:40:30 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230301103618-mutt-send-email-mst@kernel.org>
References: <20230222074214-mutt-send-email-mst@kernel.org>
 <22fee9b6-1dc0-792c-13cf-54c9303556ab@yandex-team.ru>
 <8372550f-def7-4336-c597-d22155abf145@yandex-team.ru>
 <333c4451-8eef-0603-c3f5-10e38c0eb24e@yandex-team.ru>
 <20230222115106-mutt-send-email-mst@kernel.org>
 <11593688-7ca4-def3-6212-7c26faa4d1c6@yandex-team.ru>
 <20230222121133-mutt-send-email-mst@kernel.org>
 <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <352dc254-f468-4214-413c-5da8ed4fcf8f@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <352dc254-f468-4214-413c-5da8ed4fcf8f@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v3 1/1] vhost-user-fs: add migration type
 property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On Wed, Feb 22, 2023 at 10:50:02PM +0200, Anton Kuchin wrote:
> > Property on source does not satisfy both at the same time.
> > Property on destination does.
> 
> If destination QEMUs on local and remote hosts have same properties

I'd say just make an exception from this rule.



> how can
> we
> write check that passes on the same host and fails on remote?
> Sorry, I don't understand how qemu can help to handle this. It knows nothing
> about the hosts so this is responsibility of management to software to know
> where it can migrate and configure it appropriately.
> 
> Maybe I didn't understand your scenario or what you propose to check on
> destination. Could you explain a bit more?

Basically you would add "migration=external" to device before loading.
Pre load check fails migration of vhost-user-fs device if migration
has not been set.

-- 
MST

