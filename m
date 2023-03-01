Return-Path: <mst@redhat.com>
Date: Wed, 1 Mar 2023 12:17:27 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230301121224-mutt-send-email-mst@kernel.org>
References: <20230223023604-mutt-send-email-mst@kernel.org>
 <Y/fZm12yGIPnwaDX@fedora>
 <20230224034258-mutt-send-email-mst@kernel.org>
 <8611d901-0940-3747-c2cd-9c193c7f24f2@yandex-team.ru>
 <20230228094756-mutt-send-email-mst@kernel.org>
 <f3338868-d43a-a499-5db8-2fb06d244e37@yandex-team.ru>
 <20230228161602-mutt-send-email-mst@kernel.org>
 <8c3c140a-3c11-ba21-0c53-9cf25928bad0@yandex-team.ru>
 <20230301101212-mutt-send-email-mst@kernel.org>
 <78299aea-4049-991b-fe89-de0d1845bdff@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <78299aea-4049-991b-fe89-de0d1845bdff@yandex-team.ru>
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

On Wed, Mar 01, 2023 at 06:04:31PM +0200, Anton Kuchin wrote:
> On 01/03/2023 17:24, Michael S. Tsirkin wrote:
> > On Wed, Mar 01, 2023 at 05:07:28PM +0200, Anton Kuchin wrote:
> > > On 28/02/2023 23:24, Michael S. Tsirkin wrote:
> > > > On Tue, Feb 28, 2023 at 07:59:54PM +0200, Anton Kuchin wrote:
> > > > > On 28/02/2023 16:57, Michael S. Tsirkin wrote:
> > > > > > On Tue, Feb 28, 2023 at 04:30:36PM +0200, Anton Kuchin wrote:
> > > > > > > I really don't understand why and what do you want to check on
> > > > > > > destination.
> > > > > > Yes I understand your patch controls source. Let me try to rephrase
> > > > > > why I think it's better on destination.
> > > > > > Here's my understanding
> > > > > > - With vhost-user-fs state lives inside an external daemon.
> > > > > > A- If after load you connect to the same daemon you can get migration mostly
> > > > > >      for free.
> > > > > > B- If you connect to a different daemon then that daemon will need
> > > > > >      to pass information from original one.
> > > > > > 
> > > > > > Is this a fair summary?
> > > > > > 
> > > > > > Current solution is to set flag on the source meaning "I have an
> > > > > > orchestration tool that will make sure that either A or B is correct".
> > > > > > 
> > > > > > However both A and B can only be known when destination is known.
> > > > > > Especially as long as what we are really trying to do is just allow qemu
> > > > > > restarts, Checking the flag on load will thus achive it in a cleaner
> > > > > > way, in that orchestration tool can reasonably keep the flag
> > > > > > clear normally and only set it if restarting qemu locally.
> > > > > > 
> > > > > > 
> > > > > > By comparison, with your approach orchestration tool will have
> > > > > > to either always set the flag (risky since then we lose the
> > > > > > extra check that we coded) or keep it clear and set before migration
> > > > > > (complex).
> > > > > > 
> > > > > > I hope I explained what and why I want to check.
> > > > > > 
> > > > > > I am far from a vhost-user-fs expert so maybe I am wrong but
> > > > > > I wanted to make sure I got the point across even if other
> > > > > > disagree.
> > > > > > 
> > > > > Thank you for the explanation. Now I understand your concerns.
> > > > > 
> > > > > You are right about this mechanism being a bit risky if orchestrator is
> > > > > not using it properly or clunky if it is used in a safest possible way.
> > > > > That's why first attempt of this feature was with migration capability
> > > > > to let orchestrator choose behavior right at the moment of migration.
> > > > > But it has its own problems.
> > > > > 
> > > > > We can't move this check only to destination because one of main goals
> > > > > was to prevent orchestrators that are unaware of vhost-user-fs specifics
> > > > > from accidentally migrating such VMs. We can't rely here entirely on
> > > > > destination to block this because if VM is migrated to file and then
> > > > > can't be loaded by destination there is no way to fallback and resume
> > > > > the source so we need to have some kind of blocker on source by default.
> > > > Interesting.  Why is there no way? Just load it back on source? Isn't
> > > > this how any other load failure is managed? Because for sure you
> > > > need to manage these, they will happen.
> > > Because source can be already terminated
> > So start it again.
> 
> What is the difference between restarting the source and restarting
> the destination to retry migration? If stream is correct it can be
> loaded by destination if it is broken it won't be accepted at source too.

No.  First, destination has a different qemu version. Second file
can be corrupted in transfer. Third transfer can fail. Etc ...



> > > and if load is not supported by
> > > orchestrator and backend stream can't be loaded on source too.
> > How can an orchestrator not support load but support migration?
> 
> I was talking about orchestrators that rely on old device behavior
> of blocking migration. They could attempt migration anyway and check if
> it was blocked that is far from ideal but was OK and safe, and now this
> becomes dangerous because state can be lost and VM becomes unloadable.
> 
> > 
> > > So we need to
> > > ensure that only orchestrators that know what they are doing explicitly
> > > enable
> > > the feature are allowed to start migration.
> > that seems par for the course - if you want to use a feature you better
> > have an idea about how to do it.
> > 
> > If orchestrator is doing things like migrating to file
> > then scp that file, then it better be prepared to
> > restart VM on source because sometimes it will fail
> > on destination.
> > 
> > And an orchestrator that is not clever enough to do it, then it
> > just should not come up with funky ways to do migration.
> > 
> > 
> > > > > Said that checking on destination would need another flag and the safe
> > > > > way of using this feature would require managing two flags instead of one
> > > > > making it even more fragile. So I'd prefer not to make it more complex.
> > > > > 
> > > > > In my opinion the best way to use this property by orchestrator is to
> > > > > leave default unmigratable behavior at start and just before migration when
> > > > > destination is known enumerate all vhost-user-fs devices and set properties
> > > > > according to their backends capability with QMP like you mentioned. This
> > > > > gives us single point of making the decision for each device and avoids
> > > > > guessing future at VM start.
> > > > this means that you need to remember what the values were and then
> > > > any failure on destination requires you to go back and set them
> > > > to original values. With possibility of crashes on the orchestrator
> > > > you also need to recall the temporary values in some file ...
> > > > This is huge complexity much worse than two flags.
> > > > 
> > > > Assuming we need two let's see whether just reload on source is good
> > > > enough.
> > > Reload on source can't be guaranteed to work too. And even if we could
> > > guarantee it to work then we would also need to setup its incoming migration
> > > type in case outgoing migration fails.
> > Since it's local you naturally just set it to allow load. It's trivial - just
> > a command line property no games with QOM and no state.
> 
> It is not too hard but it adds complexity
> 
> > 
> > > If orchestrator crashes and restarts it can revert flags for all devices
> > revert to what?
> 
> To default migration=none, and set correct value before next migration
> attempt.
> 
> > > or can rely on next migration code to setup them correctly because they have
> > > no effect between migrations anyway.
> > but the whole reason we have this stuff is to protect against
> > an orchestrator that forgets to do it.
> 
> No, it is to protect orchestrators that doesn't even know this feature
> exists.
> 
> > > Reverting migration that failed on destination is not an easy task too.
> > > It seems to be much more complicated than refusing to migrate on source.
> > It is only more complicated because you do not consider that
> > migration can fail even if QEMU allows it.
> > 
> > Imagine that you start playing with features through QOM.
> > Now you start migration, it fails for some reason (e.g. a network
> > issue), and you are left with a misconfigured feature.
> > 
> > Your answer is basically that we don't need this protection at all,
> > we can trust orchestrators to do the right thing.
> > In that case just drop the blocker and be done with it.
> 
> Yes, we don't need to protect from orchestrators. But we need to protect
> unaware orchestrators.

Right. You just trust orchestrators to do the right thing more than I do :)
I feel they will blindly set flag and then we are back to square one.
I feel it's less likely with load because load already has a slightly
different command line.


In fact, if we wanted to we could fail qemu if the property is set
but VM is started and not migrated.




> > 
> > > I believe we should perform sanity checks if we have data but engineering
> > > additional checks and putting extra restrictions just to prevent
> > > orchestrator
> > > from doing wrong things is an overkill.
> > Exactly. The check on source is such an overkill - your problem
> > is not on source, source has no issue sending the VM. Your problem is
> > on destination - it can not get the data from daemon since the daemon
> > is not local.
> > 
> > 
> > > > > But allowing setup via command-line is valid too because some backends may
> > > > > always be capable of external migration independent of hosts and don't need
> > > > > the manipulations with QMP before migration at all.
> > > > I am much more worried that the realistic schenario is hard to manage
> > > > safely than about theoretical state migrating backends that don't exist.
> > > > 
> > > > 

