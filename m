Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E8935A941
	for <virtio-fs@lists.linux.dev>; Tue,  6 Jan 2026 19:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726276; cv=none; b=Pcb2K+J5iYlboZPCZwTMRI2il59oo4K7JyxQMjhXjB6RQb5TQxw+6DyQA9rXJDxdlQTDaal57l5DwMPMUnEQVeqEvcDKOmgxV3UX+5prHmHoHZ1h6teb9mSlSDS7AaZO1DnYxMAVL/nMCgMxrvcpZNvkOZtKKP69j1a3M9q+4uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726276; c=relaxed/simple;
	bh=WOoHP1K6q3QyjHIPyZqQtGHAOu1l6UOlXkfP/QR6q7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6gt9x4AQ5I0DG2oNxNUhKP44UtpFkmv1qb/KRIZ5xlHv+GNY13UZGMRC4ccBDL6Z0GNkO3Bf1EN/8hhndXbt4zVLJvBr6GN27G8xOLe4Qfc/IeDsYweNvpBC/cd2SFmYV+IUaRaaML+CfM78+sr7hBAVCgDSC1+ui11D2vMTnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YKLu2duT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YKLu2duT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767726273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6B2GOa8sk2YJRGgj/5Cgjht+D/XHmdiUp+JGwX9fpZc=;
	b=YKLu2duTuGsHorYw0DZwzzV5ZybEywhOov6mW7GEWfVz+LEDHdAiyOPbWh3pyzj7cmr5IJ
	8oMGQpemFsEh8/zPJdQvBcJuyr03K7kYecPRWHIkeV8zPNnfm+n5aeoPyO5MftTIpHsZOF
	gbmhqisCvKpreEoC0bpcqmNnBTlfXPI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-Lri2g7bTMhagO-KH9BmRuA-1; Tue,
 06 Jan 2026 14:04:29 -0500
X-MC-Unique: Lri2g7bTMhagO-KH9BmRuA-1
X-Mimecast-MFC-AGG-ID: Lri2g7bTMhagO-KH9BmRuA_1767726268
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7F291800669;
	Tue,  6 Jan 2026 19:04:26 +0000 (UTC)
Received: from localhost (unknown [10.2.16.158])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93D4E30001B9;
	Tue,  6 Jan 2026 19:04:23 +0000 (UTC)
Date: Tue, 6 Jan 2026 14:04:22 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com, Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v4 0/5] support inflight migration
Message-ID: <20260106190422.GB123256@fedora>
References: <20251229102107.1291790-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lR1D359lv927RKOO"
Content-Disposition: inline
In-Reply-To: <20251229102107.1291790-1-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--lR1D359lv927RKOO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 03:21:03PM +0500, Alexandr Moshkov wrote:
> v4:
> While testing inflight migration, I notices a problem with the fact that
> GET_VRING_BASE is needed during migration, so the back-end stops
> dirtying pages and synchronizes `last_avail` counter with QEMU. So after
> migration in-flight I/O requests will be looks like resubmited on destina=
tion vm.
>=20
> However, in new logic, we no longer need to wait for in-flight requests
> to be complete at GET_VRING_BASE message. So support new parameter
> `should_drain` in the GET_VRING_BASE to allow back-end stop vrings
> immediately without waiting for in-flight I/O requests to complete.
>=20
> Also:
> - modify vhost-user rst
> - refactor on vhost-user-blk.c, now `should_drain` is based on
>   device parameter `inflight-migration`
>=20
> v3:
> - use pre_load_errp instead of pre_load in vhost.c
> - change vhost-user-blk property to
>   "skip-get-vring-base-inflight-migration"
> - refactor vhost-user-blk.c, by moving vhost_user_blk_inflight_needed() h=
igher
>=20
> v2:
> - rewrite migration using VMSD instead of qemufile API
> - add vhost-user-blk parameter instead of migration capability
>=20
> I don't know if VMSD was used cleanly in migration implementation, so
> feel free for comments.
>=20
> Based on Vladimir's work:
> [PATCH v2 00/25] vhost-user-blk: live-backend local migration
>   which was based on:
>     - [PATCH v4 0/7] chardev: postpone connect
>       (which in turn is based on [PATCH 0/2] remove deprecated 'reconnect=
' options)
>     - [PATCH v3 00/23] vhost refactoring and fixes
>     - [PATCH v8 14/19] migration: introduce .pre_incoming() vmsd handler
>=20
> Based-on: <20250924133309.334631-1-vsementsov@yandex-team.ru>
> Based-on: <20251015212051.1156334-1-vsementsov@yandex-team.ru>
> Based-on: <20251015145808.1112843-1-vsementsov@yandex-team.ru>
> Based-on: <20251015132136.1083972-15-vsementsov@yandex-team.ru>
> Based-on: <20251016114104.1384675-1-vsementsov@yandex-team.ru>
>=20
> ---
>=20
> Hi!
>=20
> During inter-host migration, waiting for disk requests to be drained
> in the vhost-user backend can incur significant downtime.
>=20
> This can be avoided if QEMU migrates the inflight region in vhost-user-bl=
k.
> Thus, during the qemu migration, the vhost-user backend can cancel all in=
flight requests and
> then, after migration, they will be executed on another host.

I'm surprised by this statement because cancellation requires
communication with the disk. If in-flight requests are slow to drain,
then I would expect cancellation to be slow too. What kind of storage
are you using?

>=20
> At first, I tried to implement migration for all vhost-user devices that =
support inflight at once,
> but this would require a lot of changes both in vhost-user-blk (to transf=
er it to the base class) and
> in the vhost-user-base base class (inflight implementation and remodeling=
 + a large refactor).
>=20
> Therefore, for now I decided to leave this idea for later and
> implement the migration of the inflight region first for vhost-user-blk.

Sounds okay to me.

I'm not sure about the change to GET_VRING_BASE. A new parameter is
added without a feature bit, so there is no way to detect this feature
at runtime. Maybe a VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT
feature bit should be added?

Once a feature bit exists, it may not even be necessary to add the
parameter to GET_VRING_BASE:

When VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT is zero,
GET_VRING_BASE drains in-flight I/O before completing. When
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT is one, the backend may
leave requests in-flight (but host I/O requests must be cancelled in
order to comply with the "Suspended device state" semantics) when
GET_VRING_BASE completes.

What do you think?

>=20
> Alexandr Moshkov (5):
>   vhost-user.rst: specify vhost-user back-end action on GET_VRING_BASE
>   vhost-user: introduce should_drain on GET_VRING_BASE
>   vmstate: introduce VMSTATE_VBUFFER_UINT64
>   vhost: add vmstate for inflight region with inner buffer
>   vhost-user-blk: support inter-host inflight migration
>=20
>  backends/cryptodev-vhost.c         |  2 +-
>  backends/vhost-user.c              |  2 +-
>  docs/interop/vhost-user.rst        |  8 +++-
>  hw/block/vhost-user-blk.c          | 28 ++++++++++++-
>  hw/net/vhost_net.c                 |  9 ++--
>  hw/scsi/vhost-scsi-common.c        |  2 +-
>  hw/virtio/vdpa-dev.c               |  2 +-
>  hw/virtio/vhost-user-base.c        |  2 +-
>  hw/virtio/vhost-user-fs.c          |  2 +-
>  hw/virtio/vhost-user-scmi.c        |  2 +-
>  hw/virtio/vhost-vsock-common.c     |  2 +-
>  hw/virtio/vhost.c                  | 66 ++++++++++++++++++++++++++----
>  include/hw/virtio/vhost-user-blk.h |  1 +
>  include/hw/virtio/vhost.h          | 13 +++++-
>  include/migration/vmstate.h        | 10 +++++
>  15 files changed, 125 insertions(+), 26 deletions(-)
>=20
> --=20
> 2.34.1
>=20

--lR1D359lv927RKOO
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmldXLYACgkQnKSrs4Gr
c8g6gAf/VL4ZomBb6GATtXAkile4plROc2EAm17yF8OUMCF+Y/sBupMJ+nCRORDh
598RhQDUsrQUszNA6htXaS003iFbSR12wvkPWHeyrdf3SRwPio3k37sBM/rLA/8n
GaVs+C8MFxe0GURE0ahhZzX93OOiMKUWnCir94hOuvUC5/WZ857qoqZ50tkTqctf
IgLrI8HA4vrYKwBGpPWb+yWcJyCc7uXc4mNGJat/ekKTpuftM3Z7YTNPTFrzPFMu
biFYr524xA+LQhJhKCthlMGrkrl5xp6kRSbd5v+5QIlNvS40/8K+cdlILuowf9jN
0Z39sDza3pystM5JcGJ3M6QONtY9UA==
=ME9P
-----END PGP SIGNATURE-----

--lR1D359lv927RKOO--

