Return-Path: <mst@redhat.com>
Date: Mon, 6 Mar 2023 16:53:16 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230306165137-mutt-send-email-mst@kernel.org>
References: <20230228094756-mutt-send-email-mst@kernel.org>
 <f3338868-d43a-a499-5db8-2fb06d244e37@yandex-team.ru>
 <20230228161602-mutt-send-email-mst@kernel.org>
 <8c3c140a-3c11-ba21-0c53-9cf25928bad0@yandex-team.ru>
 <20230301101212-mutt-send-email-mst@kernel.org>
 <78299aea-4049-991b-fe89-de0d1845bdff@yandex-team.ru>
 <20230301121224-mutt-send-email-mst@kernel.org>
 <bc89a1b1-2478-7780-0d74-64aac91beed5@yandex-team.ru>
 <20230301152038-mutt-send-email-mst@kernel.org>
 <c85c067f-5bbb-ca5c-a6ba-bae1c356eef1@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <c85c067f-5bbb-ca5c-a6ba-bae1c356eef1@yandex-team.ru>
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
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On Mon, Mar 06, 2023 at 10:55:29PM +0200, Anton Kuchin wrote:
> On 01/03/2023 22:22, Michael S. Tsirkin wrote:
> > On Wed, Mar 01, 2023 at 09:35:56PM +0200, Anton Kuchin wrote:
> > > I do trust them :)
> > > I have to, otherwise we would need to pack all the properties and
> > > flags of qemu to the migration stream and validate them at
> > > destination or entire migration ends up broken beyond repair if
> > > orchestrators tend to do stupid things and need babysitting.
> > This is not at all a crazy idea. It has some disadvantages
> > too esp around cross version migration, which is why we
> > don't do this yet.
> > 
> 
> Indeed. I know VMMs that chose this path. But as long as
> qemu decided to trust orchestrators I think we'd better
> keep this consistent across the codebase.
> 
> Only ivshmem_pre_load callback bothers to check device
> property and virtio_net_tx_waiting_pre_load checks that
> number of queue pairs doesn't exceed allowed maximum, all
> other *_pre_load functions generally just initialize some
> parts of state that need to be set before stream starts
> loading.

We do validate things by necessity we just try to do
as much as we can table-driver so it's not open-coded
and less visible. We used to have lot more callbacks
nowdays we try to keep it table driven.
But e.g. pci streams RO state and validates that it's the same
on destination.


-- 
MST

