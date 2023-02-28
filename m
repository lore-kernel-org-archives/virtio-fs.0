Return-Path: <mst@redhat.com>
Date: Tue, 28 Feb 2023 16:29:18 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230228162500-mutt-send-email-mst@kernel.org>
References: <11593688-7ca4-def3-6212-7c26faa4d1c6@yandex-team.ru>
 <20230222121133-mutt-send-email-mst@kernel.org>
 <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <20230223023604-mutt-send-email-mst@kernel.org>
 <Y/fZm12yGIPnwaDX@fedora>
 <20230224034258-mutt-send-email-mst@kernel.org>
 <8611d901-0940-3747-c2cd-9c193c7f24f2@yandex-team.ru>
 <20230228094756-mutt-send-email-mst@kernel.org>
 <CAJSP0QWz4o8Sa_MHU=zkERqU2=iim8adN7Hg1eLZ_v+yfsHeFQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJSP0QWz4o8Sa_MHU=zkERqU2=iim8adN7Hg1eLZ_v+yfsHeFQ@mail.gmail.com>
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Anton Kuchin <antonkuchin@yandex-team.ru>, Stefan Hajnoczi <stefanha@redhat.com>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On Tue, Feb 28, 2023 at 02:18:25PM -0500, Stefan Hajnoczi wrote:
> On Tue, 28 Feb 2023 at 09:58, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Feb 28, 2023 at 04:30:36PM +0200, Anton Kuchin wrote:
> > > I really don't understand why and what do you want to check on
> > > destination.
> >
> > Yes I understand your patch controls source. Let me try to rephrase
> > why I think it's better on destination.
> > Here's my understanding
> > - With vhost-user-fs state lives inside an external daemon.
> > A- If after load you connect to the same daemon you can get migration mostly
> >   for free.
> > B- If you connect to a different daemon then that daemon will need
> >   to pass information from original one.
> >
> > Is this a fair summary?
> >
> > Current solution is to set flag on the source meaning "I have an
> > orchestration tool that will make sure that either A or B is correct".
> >
> > However both A and B can only be known when destination is known.
> > Especially as long as what we are really trying to do is just allow qemu
> > restarts, Checking the flag on load will thus achive it in a cleaner
> > way, in that orchestration tool can reasonably keep the flag
> > clear normally and only set it if restarting qemu locally.
> >
> >
> > By comparison, with your approach orchestration tool will have
> > to either always set the flag (risky since then we lose the
> > extra check that we coded) or keep it clear and set before migration
> > (complex).
> >
> > I hope I explained what and why I want to check.
> >
> > I am far from a vhost-user-fs expert so maybe I am wrong but
> > I wanted to make sure I got the point across even if other
> > disagree.
> 
> How do the source QEMU and virtiofsd know which migration mode to use?
> The virtiofsd implementation might support both external and internal
> migration. Source QEMU needs to know whether to ask source virtiofsd
> for device state so it can be included in the migration stream or not.
> 
> Stefan

Well internal migration does not exist yet.  So it is simple.
When it does maybe then we worry about how to support it?
When it does will there be a reason to do external one at all?
Why?  We do internal for everything else after all.

Or maybe we tie it to machine property? We'll know more when
it actually exists, if it ever does.


-- 
MST

