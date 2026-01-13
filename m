Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94A320A30
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768327235; cv=none; b=prrOQRqR43vc1T494CTr8lAvGoGvPVWqAT+kOlP/qYmHCER5MOQQ17Mk4lbvKY2a4kJZJk3mIdWCSPz+DjzFTENQRN4xn3V11jWdQCfpGUbzSlFqcTbhtl0ffHgIsmk+HQ21v0IKzfzF4AlM8G4azRrlEEDajKaWIoSPNrg0vGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768327235; c=relaxed/simple;
	bh=ApFGJAv4+zoNFUSrZ8Gu/wrrH22PFQseU9zDdEPIA9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxsJFsD8713XCuVqO/DPggusIE6Yg06u/8PbZfhf1pjYncSDKmbIY3jpvUAh5f6fI+ylMMEdWat14GzLD2+njwcaQC8NK/UEGQ+nB4EjaI+AdDEyRNDBVj35S35/+e7BwDtdp6SGyaWibDAQlppjRdS1uuzCwbwT5ZLaxA+XC7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BcV42RPT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BcV42RPT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768327232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kbm9NA9dD6Isl74EALCx7+xC5wTeYij3XnD/Hv+cVLw=;
	b=BcV42RPTSaNsdzlJYv0pWNOkXI/iE9CBGud99HpY6czPSKzcMdJ1RLco3VhhV94PFVKiKb
	3T1TST6e3i6NXe8GqwG/TnU8TwlT3m6oL9E8jEKJXJwuX7J8nOtptXFGeyLEci3A7dBhij
	3K+sROf7JqEmeIAQf7+4h/TBR5PmJ6s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-tt9ZX0QiPuue0clRnaufUg-1; Tue,
 13 Jan 2026 13:00:26 -0500
X-MC-Unique: tt9ZX0QiPuue0clRnaufUg-1
X-Mimecast-MFC-AGG-ID: tt9ZX0QiPuue0clRnaufUg_1768327223
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1DCD19560B2;
	Tue, 13 Jan 2026 18:00:21 +0000 (UTC)
Received: from localhost (unknown [10.2.16.89])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 388821800285;
	Tue, 13 Jan 2026 18:00:18 +0000 (UTC)
Date: Tue, 13 Jan 2026 13:00:17 -0500
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
Subject: Re: [PATCH v6 2/5] vhost-user: introduce protocol feature for skip
 drain on GET_VRING_BASE
Message-ID: <20260113180017.GA528940@fedora>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113095813.134810-3-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JD+DUASqegM5fptM"
Content-Disposition: inline
In-Reply-To: <20260113095813.134810-3-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--JD+DUASqegM5fptM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 02:58:13PM +0500, Alexandr Moshkov wrote:
> Add vhost-user protocol feature
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT
>=20
> Now on GET_VRING_BASE this feature can control whether to wait for
> in-flight requests to complete or not.
> Also we have to validate that this feature will be enabled only when
> qemu and back-end supports in-flight buffer and in-flight migration
>=20
> It will be helpfull in future for in-flight requests migration in
> vhost-user devices.
>=20
> Update docs, add ref to label for inflight-io-tracking
>=20
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  docs/interop/vhost-user.rst    | 59 +++++++++++++++++++++-------------
>  hw/virtio/vhost-user.c         |  5 +++
>  include/hw/virtio/vhost-user.h |  2 ++
>  3 files changed, 44 insertions(+), 22 deletions(-)
>=20
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index 02908b48fa..dcf79de0c0 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -736,6 +736,8 @@ negotiated, back-end can send file descriptors (at mo=
st 8 descriptors in
>  each message) to front-end via ancillary data using this fd communication
>  channel.
> =20
> +.. _inflight_io_tracking:
> +
>  Inflight I/O tracking
>  ---------------------
> =20
> @@ -1033,26 +1035,27 @@ Protocol features
> =20
>  .. code:: c
> =20
> -  #define VHOST_USER_PROTOCOL_F_MQ                    0
> -  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD             1
> -  #define VHOST_USER_PROTOCOL_F_RARP                  2
> -  #define VHOST_USER_PROTOCOL_F_REPLY_ACK             3
> -  #define VHOST_USER_PROTOCOL_F_MTU                   4
> -  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ           5
> -  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN          6
> -  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION        7
> -  #define VHOST_USER_PROTOCOL_F_PAGEFAULT             8
> -  #define VHOST_USER_PROTOCOL_F_CONFIG                9
> -  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD      10
> -  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER        11
> -  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD       12
> -  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE         13
> -  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS 14
> -  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS  15
> -  #define VHOST_USER_PROTOCOL_F_STATUS               16
> -  #define VHOST_USER_PROTOCOL_F_XEN_MMAP             17
> -  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT        18
> -  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE         19
> +  #define VHOST_USER_PROTOCOL_F_MQ                       0
> +  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD                1
> +  #define VHOST_USER_PROTOCOL_F_RARP                     2
> +  #define VHOST_USER_PROTOCOL_F_REPLY_ACK                3
> +  #define VHOST_USER_PROTOCOL_F_MTU                      4
> +  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ              5
> +  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN             6
> +  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION           7
> +  #define VHOST_USER_PROTOCOL_F_PAGEFAULT                8
> +  #define VHOST_USER_PROTOCOL_F_CONFIG                   9
> +  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD         10
> +  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER           11
> +  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD          12
> +  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE            13
> +  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS    14
> +  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS     15
> +  #define VHOST_USER_PROTOCOL_F_STATUS                  16
> +  #define VHOST_USER_PROTOCOL_F_XEN_MMAP                17
> +  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT           18
> +  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE            19
> +  #define VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT 20
> =20
>  Front-end message types
>  -----------------------
> @@ -1243,12 +1246,24 @@ Front-end message types
> =20
>    When and as long as all of a device's vrings are stopped, it is
>    *suspended*, see :ref:`Suspended device state
> -  <suspended_device_state>`. The back-end must complete all inflight I/O
> -  requests for the specified vring before stopping it.
> +  <suspended_device_state>`.
> =20
>    The request payload's *num* field is currently reserved and must be
>    set to 0.
> =20
> +  By default, the back-end must complete all inflight I/O requests for t=
he
> +  specified vring before stopping it.
> +
> +  If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
> +  feature has been negotiated, the back-end may suspend in-flight I/O
> +  requests and record them as described in :ref:`Inflight I/O tracking
> +  <inflight_io_tracking>` instead of completing them before stopping the=
 vring.
> +  How to suspend an in-flight request depends on the implementation of t=
he back-end
> +  but it typically can be done by aborting or cancelling the underlying =
I/O
> +  request. The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
> +  protocol feature must only be neogotiated if
> +  ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` is also negotiated.
> +
>  ``VHOST_USER_SET_VRING_KICK``
>    :id: 12
>    :equivalent ioctl: ``VHOST_SET_VRING_KICK``
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index a820214188..793d1b36d8 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -2320,6 +2320,11 @@ static int vhost_user_backend_connect(struct vhost=
_dev *dev, Error **errp)
>              }
>          }
> =20
> +        if (!u->user->supports_inflight_migration ||
> +            !virtio_has_feature(VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {

This looks like it will not compile since virtio_has_features() takes
two arguments. I think it should be:

  !virtio_has_feature(dev->protocol_features,
                      VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)

> +            protocol_features &=3D ~(1ULL <<
> +                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFL=
IGHT);
> +        }
> +
>          /* final set of protocol features */
>          u->protocol_features =3D protocol_features;
>          err =3D vhost_user_set_protocol_features(dev, u->protocol_featur=
es);

I seem to have different version of hw/virtio/vhost-user.c. Is this
patch against qemu.git/master?

> diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-use=
r.h
> index fb89268de2..f30c1792e4 100644
> --- a/include/hw/virtio/vhost-user.h
> +++ b/include/hw/virtio/vhost-user.h
> @@ -33,6 +33,7 @@ enum VhostUserProtocolFeature {
>      /* Feature 17 reserved for VHOST_USER_PROTOCOL_F_XEN_MMAP. */
>      VHOST_USER_PROTOCOL_F_SHARED_OBJECT =3D 18,
>      VHOST_USER_PROTOCOL_F_DEVICE_STATE =3D 19,
> +    VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT =3D 20,
>      VHOST_USER_PROTOCOL_F_MAX
>  };
> =20
> @@ -69,6 +70,7 @@ typedef struct VhostUserState {
>      GPtrArray *notifiers;
>      int memory_slots;
>      bool supports_config;
> +    bool supports_inflight_migration;
>  } VhostUserState;
> =20
>  /**
> --=20
> 2.34.1
>=20

--JD+DUASqegM5fptM
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmlmiDEACgkQnKSrs4Gr
c8gpyAf9FQyDPYo0dF8rKYGTS4a/pZBgzg4jCagsrcGxtdgcxAFGn86yRWRgSWlX
VAPpMl3rbr2JrXbNlWpVMBIN+qHyEFnTzjYGraNoJDylWBeLYJes/BKzfN+FnIF/
lTQWPjPllXif155xxAqO4k5wz6STKgYIwXwD7qp6rkl5jqgFI8dDXjeTNnZ9VF70
+EO8vcmJ9Yu2Ict6YFolIdpGtC7C/4CtdBrSFlhFP5P59+EwPld7+QP3fwmsU/sC
BcMaNkIxQKALSU1LSE3AarIZEY378pvNbfihkHo7p+Co8DKyQky9alCnJODOnM4c
bzuF9AEgmFtSnthcPzkZazpTLmuBPA==
=P+Ih
-----END PGP SIGNATURE-----

--JD+DUASqegM5fptM--

