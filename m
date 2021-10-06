Date: Wed, 6 Oct 2021 15:42:34 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YV212nXgIuxtKZmS@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<1950551.Wq8TZpmmRU@silver>
	<YV2DT+EMqDN+gSHf@stefanha-x1.localdomain>
	<6923459.JjrQbDWbmU@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="av0hJQZISPGNunoE"
Content-Disposition: inline
In-Reply-To: <6923459.JjrQbDWbmU@silver>
Subject: Re: [Virtio-fs] [PATCH v2 1/3] virtio: turn VIRTQUEUE_MAX_SIZE into
	a variable
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, Raphael Norwitz <raphael.norwitz@nutanix.com>


--av0hJQZISPGNunoE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 06, 2021 at 02:50:07PM +0200, Christian Schoenebeck wrote:
> On Mittwoch, 6. Oktober 2021 13:06:55 CEST Stefan Hajnoczi wrote:
> > On Tue, Oct 05, 2021 at 06:32:46PM +0200, Christian Schoenebeck wrote:
> > > On Dienstag, 5. Oktober 2021 17:10:40 CEST Stefan Hajnoczi wrote:
> > > > On Tue, Oct 05, 2021 at 03:15:26PM +0200, Christian Schoenebeck wro=
te:
> > > > > On Dienstag, 5. Oktober 2021 14:45:56 CEST Stefan Hajnoczi wrote:
> > > > > > On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian Schoenebeck=
=20
> wrote:
> > > > > > > Refactor VIRTQUEUE_MAX_SIZE to effectively become a runtime
> > > > > > > variable per virtio user.
> > > > > >=20
> > > > > > virtio user =3D=3D virtio device model?
> > > > >=20
> > > > > Yes
> > > > >=20
> > > > > > > Reasons:
> > > > > > >=20
> > > > > > > (1) VIRTQUEUE_MAX_SIZE should reflect the absolute theoretical
> > > > > > >=20
> > > > > > >     maximum queue size possible. Which is actually the maximum
> > > > > > >     queue size allowed by the virtio protocol. The appropriate
> > > > > > >     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
> > > > > > >    =20
> > > > > > >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virti=
o-v1.
> > > > > > >     1-cs
> > > > > > >     01.h
> > > > > > >     tml#x1-240006
> > > > > > >    =20
> > > > > > >     Apparently VIRTQUEUE_MAX_SIZE was instead defined with a
> > > > > > >     more or less arbitrary value of 1024 in the past, which
> > > > > > >     limits the maximum transfer size with virtio to 4M
> > > > > > >     (more precise: 1024 * PAGE_SIZE, with the latter typically
> > > > > > >     being 4k).
> > > > > >=20
> > > > > > Being equal to IOV_MAX is a likely reason. Buffers with more io=
vecs
> > > > > > than
> > > > > > that cannot be passed to host system calls (sendmsg(2), pwritev=
(2),
> > > > > > etc).
> > > > >=20
> > > > > Yes, that's use case dependent. Hence the solution to opt-in if i=
t is
> > > > > desired and feasible.
> > > > >=20
> > > > > > > (2) Additionally the current value of 1024 poses a hidden lim=
it,
> > > > > > >=20
> > > > > > >     invisible to guest, which causes a system hang with the
> > > > > > >     following QEMU error if guest tries to exceed it:
> > > > > > >    =20
> > > > > > >     virtio: too many write descriptors in indirect table
> > > > > >=20
> > > > > > I don't understand this point. 2.6.5 The Virtqueue Descriptor T=
able
> > >=20
> > > says:
> > > > > >   The number of descriptors in the table is defined by the queue
> > > > > >   size
> > > > > >   for
> > > > > >=20
> > > > > > this virtqueue: this is the maximum possible descriptor chain
> > > > > > length.
> > > > > >=20
> > > > > > and 2.6.5.3.1 Driver Requirements: Indirect Descriptors says:
> > > > > >   A driver MUST NOT create a descriptor chain longer than the Q=
ueue
> > > > > >   Size
> > > > > >   of
> > > > > >=20
> > > > > > the device.
> > > > > >=20
> > > > > > Do you mean a broken/malicious guest driver that is violating t=
he
> > > > > > spec?
> > > > > > That's not a hidden limit, it's defined by the spec.
> > > > >=20
> > > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00781.ht=
ml
> > > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00788.ht=
ml
> > > > >=20
> > > > > You can already go beyond that queue size at runtime with the
> > > > > indirection
> > > > > table. The only actual limit is the currently hard coded value of=
 1k
> > > > > pages.
> > > > > Hence the suggestion to turn that into a variable.
> > > >=20
> > > > Exceeding Queue Size is a VIRTIO spec violation. Drivers that opera=
te
> > > > outsided the spec do so at their own risk. They may not be compatib=
le
> > > > with all device implementations.
> > >=20
> > > Yes, I am ware about that. And still, this practice is already done, =
which
> > > apparently is not limited to 9pfs.
> > >=20
> > > > The limit is not hidden, it's Queue Size as defined by the spec :).
> > > >=20
> > > > If you have a driver that is exceeding the limit, then please fix t=
he
> > > > driver.
> > >=20
> > > I absolutely understand your position, but I hope you also understand=
 that
> > > this violation of the specs is a theoretical issue, it is not a real-=
life
> > > problem right now, and due to lack of man power unfortunately I have =
to
> > > prioritize real-life problems over theoretical ones ATM. Keep in mind=
 that
> > > right now I am the only person working on 9pfs actively, I do this
> > > voluntarily whenever I find a free time slice, and I am not paid for =
it
> > > either.
> > >=20
> > > I don't see any reasonable way with reasonable effort to do what you =
are
> > > asking for here in 9pfs, and Greg may correct me here if I am saying
> > > anything wrong. If you are seeing any specific real-life issue here, =
then
> > > please tell me which one, otherwise I have to postpone that "specs
> > > violation" issue.
> > >=20
> > > There is still a long list of real problems that I need to hunt down =
in
> > > 9pfs, afterwards I can continue with theoretical ones if you want, but
> > > right now I simply can't, sorry.
> >=20
> > I understand. If you don't have time to fix the Linux virtio-9p driver
> > then that's fine.
>=20
> I will look at this again, but it might be tricky. On doubt I'll postpone=
 it.
>=20
> > I still wanted us to agree on the spec position because the commit
> > description says it's a "hidden limit", which is incorrect. It might
> > seem pedantic, but my concern is that misconceptions can spread if we
> > let them. That could cause people to write incorrect code later on.
> > Please update the commit description either by dropping 2) or by
> > replacing it with something else. For example:
> >=20
> >   2) The Linux virtio-9p guest driver does not honor the VIRTIO Queue
> >      Size value and can submit descriptor chains that exceed it. That is
> >      a spec violation but is accepted by QEMU's device implementation.
> >=20
> >      When the guest creates a descriptor chain larger than 1024 the
> >      following QEMU error is printed and the guest hangs:
> >=20
> >      virtio: too many write descriptors in indirect table
>=20
> I am fine with both, probably preferring the text block above instead of=
=20
> silently dropping the reason, just for clarity.
>=20
> But keep in mind that this might not be limited to virtio-9p as your text=
=20
> would suggest, see below.
>=20
> > > > > > > (3) Unfortunately not all virtio users in QEMU would currently
> > > > > > >=20
> > > > > > >     work correctly with the new value of 32768.
> > > > > > >=20
> > > > > > > So let's turn this hard coded global value into a runtime
> > > > > > > variable as a first step in this commit, configurable for each
> > > > > > > virtio user by passing a corresponding value with virtio_init=
()
> > > > > > > call.
> > > > > >=20
> > > > > > virtio_add_queue() already has an int queue_size argument, why =
isn't
> > > > > > that enough to deal with the maximum queue size? There's probab=
ly a
> > > > > > good
> > > > > > reason for it, but please include it in the commit description.
> > > > >=20
> > > > > [...]
> > > > >=20
> > > > > > Can you make this value per-vq instead of per-vdev since virtqu=
eues
> > > > > > can
> > > > > > have different queue sizes?
> > > > > >=20
> > > > > > The same applies to the rest of this patch. Anything using
> > > > > > vdev->queue_max_size should probably use vq->vring.num instead.
> > > > >=20
> > > > > I would like to avoid that and keep it per device. The maximum si=
ze
> > > > > stored
> > > > > there is the maximum size supported by virtio user (or vortio dev=
ice
> > > > > model,
> > > > > however you want to call it). So that's really a limit per device=
, not
> > > > > per
> > > > > queue, as no queue of the device would ever exceed that limit.
> > > > >=20
> > > > > Plus a lot more code would need to be refactored, which I think is
> > > > > unnecessary.
> > > >=20
> > > > I'm against a per-device limit because it's a concept that cannot
> > > > accurately describe reality. Some devices have multiple classes of
> > >=20
> > > It describes current reality, because VIRTQUEUE_MAX_SIZE obviously is=
 not
> > > per queue either ATM, and nobody ever cared.
> > >=20
> > > All this series does, is allowing to override that currently project-=
wide
> > > compile-time constant to a per-driver-model compile-time constant. Wh=
ich
> > > makes sense, because that's what it is: some drivers could cope with =
any
> > > transfer size, and some drivers are constrained to a certain maximum
> > > application specific transfer size (e.g. IOV_MAX).
> > >=20
> > > > virtqueues and they are sized differently, so a per-device limit is
> > > > insufficient. virtio-net has separate rx_queue_size and tx_queue_si=
ze
> > > > parameters (plus a control vq hardcoded to 64 descriptors).
> > >=20
> > > I simply find this overkill. This value semantically means "my driver
> > > model
> > > supports at any time and at any coincidence at the very most x * PAGE=
_SIZE
> > > =3D max_transfer_size". Do you see any driver that might want a more =
fine
> > > graded control over this?
> >=20
> > One reason why per-vq limits could make sense is that the maximum
> > possible number of struct elements is allocated upfront in some code
> > paths. Those code paths may need to differentiate between per-vq limits
> > for performance or memory utilization reasons. Today some places
> > allocate 1024 elements on the stack in some code paths, but maybe that's
> > not acceptable when the per-device limit is 32k. This can matter when a
> > device has vqs with very different sizes.
> >=20
> [...]
> > > ... I leave that up to Michael or whoever might be in charge to decid=
e. I
> > > still find this overkill, but I will adapt this to whatever the decis=
ion
> > > eventually will be in v3.
> > >=20
> > > But then please tell me the precise representation that you find
> > > appropriate, i.e. whether you want a new function for that, or rather=
 an
> > > additional argument to virtio_add_queue(). Your call.
> >=20
> > virtio_add_queue() already takes an int queue_size argument. I think the
> > necessary information is already there.
> >=20
> > This patch just needs to be tweaked to use the virtio_queue_get_num()
> > (or a new virtqueue_get_num() API if that's easier because only a
> > VirtQueue *vq pointer is available) instead of introducing a new
> > per-device limit.
>=20
> My understanding is that both the original 9p virtio device authors, as w=
ell=20
> as other virtio device authors in QEMU have been and are still using this=
 as a=20
> default value (i.e. to allocate some upfront, and the rest on demand).
>=20
> So yes, I know your argument about the specs, but AFAICS if I would just =
take=20
> this existing numeric argument for the limit, then it would probably brea=
k=20
> those other QEMU devices as well.

This is a good point that I didn't consider. If guest drivers currently
violate the spec, then restricting descriptor chain length to vring.num
will introduce regressions.

We can't use virtio_queue_get_num() directly. A backwards-compatible
limit is required:

  int virtio_queue_get_desc_chain_max(VirtIODevice *vdev, int n)
  {
      /*
       * QEMU historically allowed 1024 descriptors even if the
       * descriptor table was smaller.
       */
      return MAX(virtio_queue_get_num(vdev, qidx), 1024);
  }

Device models should call virtio_queue_get_desc_chain_max(). It
preserves the 1024 descriptor chain length but also allows larger values
if the virtqueue was configured appropriately.

Does this address the breakage you were thinking about?

Stefan

--av0hJQZISPGNunoE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFdtdoACgkQnKSrs4Gr
c8iGeQf/b0/sEsRvNv35Aa5WH4ZFQjaVTga17FXscfzkOVQsLxsGd4LhgIhyRTPJ
2iFgTraTzI+46Yy5g6X6FA01Yjn6oKise3y5YkBZqPrvSNmbZypJk0qhN/LOG7DX
yp7aYYbu+pfn+z6n8oIa4w+rKbmOpgNa/4GtyfLXmO5PPYzpSxbsGxO6voAc6+vr
kerGnlAJYCK76ntGXE8+Ie7/PPzz3s9NDgdZarA/K7YmO0ErTrsXDpjnObCbGTOE
rdxdgiZNig6KE9AGGpcfUSsGFAFMd5KDWQLFuRHNByRl4Uol1k2E/vaduzsWGy5w
k7De/XwFO1PYbE60x1iu71dFZAbSug==
=u1ft
-----END PGP SIGNATURE-----

--av0hJQZISPGNunoE--

