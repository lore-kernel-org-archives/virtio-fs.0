Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=70qff6mZED8Ot/g7ut65nts85KoTdg+GUhUnf1YzgW8=;
 b=TGeRvKaVxpK7WSReu0bsGsxlTyqQ6ZPsL7XyX8d1CrocqpMuQ/c5N3aAXTGTv7tg92
 28BEcVKr9BxE8ydaRguXycEvFbZXpy9Gm+sh8cvGYwTMITGzwVTCyZd3+Md4fCVtw/le
 Hvr7Mcp9qxTXTUg6YOekOyvf7pn6TsR3RYJNgx2uxmI5Cl2XeHqLZSy/0RvRBVaL4Lkj
 A7JaUMKzktsGbsqHxYNsNELqQCrOLS0QVm3QmrahdbUiivVnE3trm2/RyZPQM5zG5Pr5
 Zm1yjWxUiCubIWI/QF71of/Zwl7Vnft6p2bvKCaQ/rroiT/HTvyFPzRBJqzE2YxeBLLj
 pckg==
MIME-Version: 1.0
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <Y9GG+EXX03TAvWDS@fedora>
 <64c249a5-98c2-24a0-d036-c76bb2f0a19a@yandex-team.ru>
In-Reply-To: <64c249a5-98c2-24a0-d036-c76bb2f0a19a@yandex-team.ru>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 26 Jan 2023 10:13:16 -0500
Message-ID: <CAJSP0QUdehnotQD76EBgRq89grbuJoDd1fDbkuDZNdg=wKMuUg@mail.gmail.com>
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
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru, "Michael S. Tsirkin" <mst@redhat.com>

On Thu, 26 Jan 2023 at 09:20, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>
> On 25/01/2023 21:46, Stefan Hajnoczi wrote:
> > On Sun, Jan 15, 2023 at 07:09:03PM +0200, Anton Kuchin wrote:
> >> Now any vhost-user-fs device makes VM unmigratable, that also prevents
> >> qemu update without stopping the VM. In most cases that makes sense
> >> because qemu has no way to transfer FUSE session state.
> >>
> >> But we can give an option to orchestrator to override this if it can
> >> guarantee that state will be preserved (e.g. it uses migration to
> >> update qemu and dst will run on the same host as src and use the same
> >> socket endpoints).
> >>
> >> This patch keeps default behavior that prevents migration with such devices
> >> but adds migration capability 'vhost-user-fs' to explicitly allow migration.
> >>
> >> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> >> ---
> >>   hw/virtio/vhost-user-fs.c | 25 ++++++++++++++++++++++++-
> >>   qapi/migration.json       |  7 ++++++-
> >>   2 files changed, 30 insertions(+), 2 deletions(-)
> > Hi Anton,
> > Sorry for holding up your work with the discussions that we had. I still
> > feel it's important to agree on command-line and/or vhost-user protocol
> > changes that will be able to support non-migratable, stateless
> > migration/reconnect, and stateful migration vhost-user-fs back-ends. All
> > three will exist.
> >
> > As a next step, could you share your code that implements the QEMU side
> > of stateless migration?
> >
> > I think that will make it clearer whether a command-line option
> > (migration capability or per-device) is sufficient or whether the
> > vhost-user protocol needs to be extended.
> >
> > If the vhost-user protocol is extended then maybe no user-visible
> > changes are necessary. QEMU will know if the vhost-user-fs backend
> > supports migration and which type of migration. It can block migration
> > in cases where it's not possible.
> >
> > Thanks,
> > Stefan
>
>
> Thank you, Stefan,
>
> That's OK. The discussion is very helpful and showed me some parts
> that should to be checked to make sure no harm is done by this feature.
> I needed some time to step back, review my approach to this feature
> with all valuable feedback and ideas that were suggested and check
> what other backend implementations can or can't do.
> I'll answer today the emails with questions that were addressed to me.
>
> This is all the code that QEMU needs to support stateless migration.
> Do you mean backend and/or orchestrator parts?

It's unclear to me how the destination QEMU is able to connect to the
vhost-user back-end while the source QEMU is still connected? I
thought additional QEMU changes would be necessary to make migration
handover work.

Stefan

