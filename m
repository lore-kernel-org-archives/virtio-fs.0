Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=LXH6JsvmPYr3TwSmlX7IsEsxVcOAu/DwAhEjlQYwQuo=;
 b=RB835QzPfHzVmYxh/gJIJPAO4lDUo+7I7Fv8fcQKiSWMLQE+An+KzJVUC0pdXzcj5M
 bCtAKYt8VvcxMhpFrN1q5oa3pr9l7Hk3BzywduXqCJLaTFE1S2Ru1vl/hwb3xm/DSxHI
 xkktK6cMo8oa0Kb1VYue5dwxW7pYFuE+jLQ55sBzKc4WycV+/eS8WgJrOs5OMkUW0rUP
 crOceXPD5HhP1qqGKOq4MX8Pkci78ZyyYyEv6NQxL0xHaHtEtacrkR5CqLOeHjPQQVB2
 oUbhEDxKzSF75Ks7ct93P+wLTLuh80rv2SMuowS9mmCGnNbtaxOcL4xuQNl/0PHp+swP
 FVTg==
MIME-Version: 1.0
References: <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
 <20230122093903-mutt-send-email-mst@kernel.org>
 <70c0f00a-7828-3ccf-c2ea-49aeef8693e9@yandex-team.ru>
 <20230122111618-mutt-send-email-mst@kernel.org>
 <Y87Ri4r6SiETdCrt@work-vm> <Y87lv8fXrYpxkK/3@fedora>
 <CAJSP0QV5wfXxhvjjFnLLUCvmSxiHxTPXh4qQJwHhnKdBu3EOQQ@mail.gmail.com>
 <Y8+p8HFG8NxYlfoo@work-vm>
In-Reply-To: <Y8+p8HFG8NxYlfoo@work-vm>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 24 Jan 2023 07:48:12 -0500
Message-ID: <CAJSP0QUANuLkOjkLsB4LqKdi5_sJj+y6zK5vgcNmYZ5BLQ73rQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000635dc705f301ee7c"
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, qemu-devel <qemu-devel@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru

--000000000000635dc705f301ee7c
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023, 04:50 Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Stefan Hajnoczi (stefanha@gmail.com) wrote:
> > On Mon, 23 Jan 2023 at 14:54, Stefan Hajnoczi <stefanha@redhat.com>
> wrote:
> > >
> > > On Mon, Jan 23, 2023 at 06:27:23PM +0000, Dr. David Alan Gilbert wrote:
> > > > * Michael S. Tsirkin (mst@redhat.com) wrote:
> > > > > On Sun, Jan 22, 2023 at 06:09:40PM +0200, Anton Kuchin wrote:
> > > > > >
> > > > > > On 22/01/2023 16:46, Michael S. Tsirkin wrote:
> > > > > > > On Sun, Jan 22, 2023 at 02:36:04PM +0200, Anton Kuchin wrote:
> > > > > > > > > > This flag should be set when qemu don't need to worry
> about any
> > > > > > > > > > external state stored in vhost-user daemons during
> migration:
> > > > > > > > > > don't fail migration, just pack generic virtio device
> states to
> > > > > > > > > > migration stream and orchestrator guarantees that the
> rest of the
> > > > > > > > > > state will be present at the destination to restore full
> context and
> > > > > > > > > > continue running.
> > > > > > > > > Sorry  I still do not get it.  So fundamentally, why do we
> need this property?
> > > > > > > > > vhost-user-fs is not created by default that we'd then
> need opt-in to
> > > > > > > > > the special "migrateable" case.
> > > > > > > > > That's why I said it might make some sense as a device
> property as qemu
> > > > > > > > > tracks whether device is unplugged for us.
> > > > > > > > >
> > > > > > > > > But as written, if you are going to teach the orchestrator
> about
> > > > > > > > > vhost-user-fs and its special needs, just teach it when to
> migrate and
> > > > > > > > > where not to migrate.
> > > > > > > > >
> > > > > > > > > Either we describe the special situation to qemu and let
> qemu
> > > > > > > > > make an intelligent decision whether to allow migration,
> > > > > > > > > or we trust the orchestrator. And if it's the latter, then
> 'migrate'
> > > > > > > > > already says orchestrator decided to migrate.
> > > > > > > > The problem I'm trying to solve is that most of vhost-user
> devices
> > > > > > > > now block migration in qemu. And this makes sense since qemu
> can't
> > > > > > > > extract and transfer backend daemon state. But this prevents
> us from
> > > > > > > > updating qemu executable via local migration. So this flag is
> > > > > > > > intended more as a safety check that says "I know what I'm
> doing".
> > > > > > > >
> > > > > > > > I agree that it is not really necessary if we trust the
> orchestrator
> > > > > > > > to request migration only when the migration can be
> performed in a
> > > > > > > > safe way. But changing the current behavior of vhost-user-fs
> from
> > > > > > > > "always blocks migration" to "migrates partial state whenever
> > > > > > > > orchestrator requests it" seems a little  dangerous and can
> be
> > > > > > > > misinterpreted as full support for migration in all cases.
> > > > > > > It's not really different from block is it? orchestrator has
> to arrange
> > > > > > > for backend migration. I think we just assumed there's no
> use-case where
> > > > > > > this is practical for vhost-user-fs so we blocked it.
> > > > > > > But in any case it's orchestrator's responsibility.
> > > > > >
> > > > > > Yes, you are right. So do you think we should just drop the
> blocker
> > > > > > without adding a new flag?
> > > > >
> > > > > I'd be inclined to. I am curious what do dgilbert and stefanha
> think though.
> > > >
> > > > Yes I think that's probably OK, as long as we use the flag for
> knowing
> > > > how to handle the discard bitmap as a proxy for the daemon knowing
> how
> > > > to handle *some* migrations; knowing which migrations is then the job
> > > > for the orchestrator to be careful of.
> > >
> > > I think the feature bit is not a good way to detect live migration
> > > support. vhost-user backends typically use libvhost-user, rust-vmm's
> > > vhost-user-backend crate, etc where this feature can be implemented for
> > > free. If the feature bit is advertized we don't know if the device
> > > implementation (net, blk, fs, etc) is aware of migration at all.
> >
> > I checked how bad the situation is. libvhost-user currently enables
> > LOG_ALL by default. :(
> >
> > So I don't think the front-end can use LOG_ALL alone to determine
> > whether or not migration is supported by the back-end.
> >
> > There are several existing back-ends based on libvhost-user that have
> > no concept of reconnection or migration but report the LOG_ALL feature
> > bit.
>
> Ouch, yes that's messy.
>
> Going back to the original question; I don't think a command line flag
> will work though, because even for a given VM there's the possibility
> of some (local) migrations working but other (remote) migrations not
> working; so you don't know at the point you start the VM whether
> your migrations are going to work.
>

The user or management tool should know which types of migration a
vhost-user-fs backend supports. That can be passed in as a per-device
parameter.

Then a migration parameter can be used to distinguish between same host and
remote host migration? QEMU already distinguishes between pre-copy and
post-copy migration, so this can be thought of as yet another type of
migration.

Stefan

>

--000000000000635dc705f301ee7c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr" =
class=3D"gmail_attr">On Tue, Jan 24, 2023, 04:50 Dr. David Alan Gilbert &lt=
;<a href=3D"mailto:dgilbert@redhat.com">dgilbert@redhat.com</a>&gt; wrote:<=
br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;borde=
r-left:1px #ccc solid;padding-left:1ex">* Stefan Hajnoczi (<a href=3D"mailt=
o:stefanha@gmail.com" target=3D"_blank" rel=3D"noreferrer">stefanha@gmail.c=
om</a>) wrote:<br>
&gt; On Mon, 23 Jan 2023 at 14:54, Stefan Hajnoczi &lt;<a href=3D"mailto:st=
efanha@redhat.com" target=3D"_blank" rel=3D"noreferrer">stefanha@redhat.com=
</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt; On Mon, Jan 23, 2023 at 06:27:23PM +0000, Dr. David Alan Gilbert =
wrote:<br>
&gt; &gt; &gt; * Michael S. Tsirkin (<a href=3D"mailto:mst@redhat.com" targ=
et=3D"_blank" rel=3D"noreferrer">mst@redhat.com</a>) wrote:<br>
&gt; &gt; &gt; &gt; On Sun, Jan 22, 2023 at 06:09:40PM +0200, Anton Kuchin =
wrote:<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; On 22/01/2023 16:46, Michael S. Tsirkin wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; On Sun, Jan 22, 2023 at 02:36:04PM +0200, Ant=
on Kuchin wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; This flag should be set when q=
emu don&#39;t need to worry about any<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; external state stored in vhost=
-user daemons during migration:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; don&#39;t fail migration, just=
 pack generic virtio device states to<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; migration stream and orchestra=
tor guarantees that the rest of the<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; state will be present at the d=
estination to restore full context and<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; continue running.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Sorry=C2=A0 I still do not get it.=
=C2=A0 So fundamentally, why do we need this property?<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; vhost-user-fs is not created by def=
ault that we&#39;d then need opt-in to<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; the special &quot;migrateable&quot;=
 case.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; That&#39;s why I said it might make=
 some sense as a device property as qemu<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; tracks whether device is unplugged =
for us.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; But as written, if you are going to=
 teach the orchestrator about<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; vhost-user-fs and its special needs=
, just teach it when to migrate and<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; where not to migrate.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Either we describe the special situ=
ation to qemu and let qemu<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; make an intelligent decision whethe=
r to allow migration,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; or we trust the orchestrator. And i=
f it&#39;s the latter, then &#39;migrate&#39;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; already says orchestrator decided t=
o migrate.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; The problem I&#39;m trying to solve is t=
hat most of vhost-user devices<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; now block migration in qemu. And this ma=
kes sense since qemu can&#39;t<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; extract and transfer backend daemon stat=
e. But this prevents us from<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; updating qemu executable via local migra=
tion. So this flag is<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; intended more as a safety check that say=
s &quot;I know what I&#39;m doing&quot;.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; I agree that it is not really necessary =
if we trust the orchestrator<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; to request migration only when the migra=
tion can be performed in a<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; safe way. But changing the current behav=
ior of vhost-user-fs from<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &quot;always blocks migration&quot; to &=
quot;migrates partial state whenever<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; orchestrator requests it&quot; seems a l=
ittle=C2=A0 dangerous and can be<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; misinterpreted as full support for migra=
tion in all cases.<br>
&gt; &gt; &gt; &gt; &gt; &gt; It&#39;s not really different from block is i=
t? orchestrator has to arrange<br>
&gt; &gt; &gt; &gt; &gt; &gt; for backend migration. I think we just assume=
d there&#39;s no use-case where<br>
&gt; &gt; &gt; &gt; &gt; &gt; this is practical for vhost-user-fs so we blo=
cked it.<br>
&gt; &gt; &gt; &gt; &gt; &gt; But in any case it&#39;s orchestrator&#39;s r=
esponsibility.<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Yes, you are right. So do you think we should just=
 drop the blocker<br>
&gt; &gt; &gt; &gt; &gt; without adding a new flag?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; I&#39;d be inclined to. I am curious what do dgilbert a=
nd stefanha think though.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Yes I think that&#39;s probably OK, as long as we use the fl=
ag for knowing<br>
&gt; &gt; &gt; how to handle the discard bitmap as a proxy for the daemon k=
nowing how<br>
&gt; &gt; &gt; to handle *some* migrations; knowing which migrations is the=
n the job<br>
&gt; &gt; &gt; for the orchestrator to be careful of.<br>
&gt; &gt;<br>
&gt; &gt; I think the feature bit is not a good way to detect live migratio=
n<br>
&gt; &gt; support. vhost-user backends typically use libvhost-user, rust-vm=
m&#39;s<br>
&gt; &gt; vhost-user-backend crate, etc where this feature can be implement=
ed for<br>
&gt; &gt; free. If the feature bit is advertized we don&#39;t know if the d=
evice<br>
&gt; &gt; implementation (net, blk, fs, etc) is aware of migration at all.<=
br>
&gt; <br>
&gt; I checked how bad the situation is. libvhost-user currently enables<br=
>
&gt; LOG_ALL by default. :(<br>
&gt; <br>
&gt; So I don&#39;t think the front-end can use LOG_ALL alone to determine<=
br>
&gt; whether or not migration is supported by the back-end.<br>
&gt; <br>
&gt; There are several existing back-ends based on libvhost-user that have<=
br>
&gt; no concept of reconnection or migration but report the LOG_ALL feature=
<br>
&gt; bit.<br>
<br>
Ouch, yes that&#39;s messy.<br>
<br>
Going back to the original question; I don&#39;t think a command line flag<=
br>
will work though, because even for a given VM there&#39;s the possibility<b=
r>
of some (local) migrations working but other (remote) migrations not<br>
working; so you don&#39;t know at the point you start the VM whether<br>
your migrations are going to work.<br></blockquote></div></div><div dir=3D"=
auto"><br></div><div dir=3D"auto">The user or management tool should know w=
hich types of migration a vhost-user-fs backend supports. That can be passe=
d in as a per-device parameter.</div><div dir=3D"auto"><br></div><div dir=
=3D"auto">Then a migration parameter can be used to distinguish between sam=
e host and remote host migration? QEMU already distinguishes between pre-co=
py and post-copy migration, so this can be thought of as yet another type o=
f migration.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Stefan</div=
><div dir=3D"auto"><div class=3D"gmail_quote"><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">
</blockquote></div></div></div>

--000000000000635dc705f301ee7c--

