Return-Path: <mst@redhat.com>
Date: Wed, 1 Mar 2023 12:19:36 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230301121751-mutt-send-email-mst@kernel.org>
References: <20230224034258-mutt-send-email-mst@kernel.org>
 <8611d901-0940-3747-c2cd-9c193c7f24f2@yandex-team.ru>
 <20230228094756-mutt-send-email-mst@kernel.org>
 <f3338868-d43a-a499-5db8-2fb06d244e37@yandex-team.ru>
 <20230228161602-mutt-send-email-mst@kernel.org>
 <e1f45021-071c-b8c4-69bd-85f8c29c669a@yandex-team.ru>
 <20230301094424-mutt-send-email-mst@kernel.org>
 <39577b2c-71ec-5e83-d796-2c4fe3d1fc10@yandex-team.ru>
 <20230301104316-mutt-send-email-mst@kernel.org>
 <59d5d035-c787-1536-5a02-d979a3c0904e@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <59d5d035-c787-1536-5a02-d979a3c0904e@yandex-team.ru>
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
Cc: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On Wed, Mar 01, 2023 at 06:29:50PM +0200, Anton Kuchin wrote:
> On 01/03/2023 17:52, Michael S. Tsirkin wrote:
> > On Wed, Mar 01, 2023 at 05:40:09PM +0200, Anton Kuchin wrote:
> > > So catching errors in not the only purpose of this property, but it
> > > definitely
> > > allows us to catch some obvious ones.
> > OK let's say this. If migration=external then migration just works.
> > If migration=internal it fails for now. We are agreed here right?
> > 
> > Our argument is whether to check on load or save?
> > 
> > I propose this compromize: two properties:
> > 	migration-load and migration-save
> > 
> > 	migration-load : how is incoming migration handled.
> > 			 internal - through qemu
> > 			 external - through the daemon
> > 
> > 			  checked in pre-load
> > 
> > 	migration-save : how is outgoing migration handled.
> > 			 internal - through qemu
> > 			 external - through the daemon
> > 
> > 			  checked in post-save
> > 
> > This way whether the check is on source or destination or both
> > is up to the user.
> > 
> > Hmm?
> 
> Hmm, sounds interesting, this can be a really good compromise.
> 
> So migration-save will be "none" by default to protect unaware
> orchestrators.
> What do you think should migration-load be "none" too to force orchestrator
> set proper incoming migration type?

Yes.
I am also thinking whether we should block setting migration-load
if qemu is starting a VM as opposed to loading it.
Thoughts?


-- 
MST

