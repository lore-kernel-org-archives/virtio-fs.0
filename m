Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383632749DF
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 06:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873391; cv=none; b=uEKFzRNJjGGUvcXpxuUDRVmkE0EGJFUh4ZIORwCAawhv+YW5aYlceC5svqOAFpL48AE1b8KNFf7KRcPz8flMtMSN7lrMyLaBMzLYkAsaMl0O0rbayOXq8pQKGJc760LpsFP+c+vRVrV7R7hYmxWDPaIXMay+xsGPRoS39sQZe0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873391; c=relaxed/simple;
	bh=lWtRmGTaK4+oY26dRaa0T6C8CkV1LQ9cnm24CHzVOzM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YuV1ZxrEkl9ulzsgdhU3/zATQ5cB6EN+NJ2GlLtqA0rPyu/8Ar8BiZJyCtaYjn7ybsE2hLHaMj58VbRblIY96wyKRgfWb9rypIw4V2aOH9bwYMOvQZoc4MZfA0g4dEL24q5v0/UaJe1rhXl93jJ3nHHA3YAuL0ugTI9E3kt0ni4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TaRbav6F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TaRbav6F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784873389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lWtRmGTaK4+oY26dRaa0T6C8CkV1LQ9cnm24CHzVOzM=;
	b=TaRbav6FzDsC456b6oXdzBPPEEJB8Q0VTtH9LQ2w1rttIGRssdcE2pWZkeXdl0GhxjRC14
	BOHKEppbVDgP+52/YPo0RyiRSAMxwoHfZHV/WZXeVRGi1HsrSnlX3DnPoQUhh8aN/Qeulw
	SA8p1xoCOw/oFi0KGNBlRAFXU0JQ9RI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-M_nHmmGyOmu7IJnIUqjh8w-1; Fri,
 24 Jul 2026 02:09:45 -0400
X-MC-Unique: M_nHmmGyOmu7IJnIUqjh8w-1
X-Mimecast-MFC-AGG-ID: M_nHmmGyOmu7IJnIUqjh8w_1784873383
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 894811954239;
	Fri, 24 Jul 2026 06:09:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10C6B1800240;
	Fri, 24 Jul 2026 06:09:39 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 3703121E6920; Fri, 24 Jul 2026 08:09:37 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: ConKite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org,  "Michael S. Tsirkin" <mst@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
  Viresh Kumar <viresh.kumar@linaro.org>,  Gerd Hoffmann
 <kraxel@redhat.com>,  Mathieu Poirier <mathieu.poirier@linaro.org>,  Manos
 Pitsidianakis <manos.pitsidianakis@linaro.org>,  Haixu Cui
 <quic_haixcui@quicinc.com>,  Raphael Norwitz <rnorwitz@nvidia.com>,  Kevin
 Wolf <kwolf@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  =?utf-8?Q?Mar?=
 =?utf-8?Q?c-Andr=C3=A9?=
 Lureau <marcandre.lureau@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Fam Zheng <fam@euphon.net>,  Stefan Hajnoczi
 <stefanha@redhat.com>,  Milan Zamazal <mzamazal@redhat.com>,  Akihiko
 Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,  Dmitry Osipenko
 <dmitry.osipenko@collabora.com>,  qemu-block@nongnu.org,
  virtio-fs@lists.linux.dev,  "Gonglei (Arei)" <arei.gonglei@huawei.com>,
  zhenwei pi <zhenwei.pi@linux.dev>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric Blake <eblake@redhat.com>,  Jason Wang
 <jasowangio@gmail.com>,  Peter Xu <peterx@redhat.com>,  Eugenio
 =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>,  Alyssa Ross <hi@alyssa.is>,  Demi Marie Obenour
 <demiobenour@gmail.com>
Subject: Re: [PATCH RFC 01/15] vhost-user: Consolidate chardev property
 definitions
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-1-6b97c439eb28@gmail.com>
	(ConKite's message of "Thu, 23 Jul 2026 15:30:00 -0700")
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
	<20260723-vhost-user-isolated-memory-v1-1-6b97c439eb28@gmail.com>
Date: Fri, 24 Jul 2026 08:09:37 +0200
Message-ID: <87bjbwdila.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: xX7SWI_Q3yBCC_YpIYVPGP6eAFU3rwAWjeItG98Z6qk_1784873383
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

This patch and the next one are From: ConKite, whereas the remainder are
From: Connor Kite, which is nicer.

