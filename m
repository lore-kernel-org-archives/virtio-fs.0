Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566E228DCB
	for <virtio-fs@lists.linux.dev>; Fri,  9 Feb 2024 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707478241; cv=none; b=IhKjkVsNE2+aWreSA33X7syWzstfFilWhUA1qrsLN5qRFbhij20MTLk7PwMoQCD8kGV2QtAHLljMFFcCbpPKc3/IgRjA5+LHyIjV30HWKQBrbuC2CpeHpmSHAqJ8xsKfYEbVHxt8Mydh29lP+YMZKJdhAMhWoVNWYm0KMRhlBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707478241; c=relaxed/simple;
	bh=jPyi0YFU6UubKNVN0yr2/yOVx0MG1YPat+OIForxo/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdSmDmjquMOVS3C5/Tw2OgWlFWme/xSZNMhQ4v/niY+vBtm9TUlSOIunKuZwRoDm4oloA+6hmdOlHCy8q+2CuMpxtdyMfTYnWi4wmBLc+UFu7nqXxatfY0/EW+WGlD5p+UVG0RJzQxmrehSh9UFGeD8wQjpvbRLX7ifIlG+VTzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJRW5BsE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJRW5BsE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707478238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RKNyYbIDISSdKU79eD+9vFfLTqADaQHmHbs1OnkHR5o=;
	b=EJRW5BsEL/2c9eu75avGYfppOJsJBnPnOYSybtqBPFLr5dpD05FhOFJRphhM34pPAZ0aiC
	usgfB8x9FgEYXRUv/k3F92G1siCwntJcfCsinoPltWROwgVQXW6iqzde4EujGPcbyi6Eci
	1DQQUrggSkyFY9HsslkU5VsuOTnakWU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-lNtPamxeMzWv3q6_vlQvdw-1; Fri, 09 Feb 2024 06:30:33 -0500
X-MC-Unique: lNtPamxeMzWv3q6_vlQvdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27510828CEC;
	Fri,  9 Feb 2024 11:30:33 +0000 (UTC)
Received: from localhost (unknown [10.39.193.29])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E16DC40C9444;
	Fri,  9 Feb 2024 11:30:31 +0000 (UTC)
Date: Fri, 9 Feb 2024 06:30:30 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
	gmaglione@redhat.com, virtio-fs@lists.linux.dev, vgoyal@redhat.com,
	mzxreary@0pointer.de, miklos@szeredi.hu
Subject: Re: [PATCH v2 1/3] virtiofs: forbid newlines in tags
Message-ID: <20240209113030.GA748645@fedora>
References: <20240208193212.731978-1-stefanha@redhat.com>
 <20240208193212.731978-2-stefanha@redhat.com>
 <2024020953-rebel-ooze-2162@gregkh>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Ot15W0l9JUGuqbHu"
Content-Disposition: inline
In-Reply-To: <2024020953-rebel-ooze-2162@gregkh>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2


--Ot15W0l9JUGuqbHu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 09, 2024 at 10:33:20AM +0000, Greg KH wrote:
> On Thu, Feb 08, 2024 at 02:32:09PM -0500, Stefan Hajnoczi wrote:
> > Newlines in virtiofs tags are awkward for users and potential vectors
> > for string injection attacks.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  fs/fuse/virtio_fs.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >=20
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index 5f1be1da92ce..de9a38efdf1e 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -323,6 +323,16 @@ static int virtio_fs_read_tag(struct virtio_device=
 *vdev, struct virtio_fs *fs)
> >  		return -ENOMEM;
> >  	memcpy(fs->tag, tag_buf, len);
> >  	fs->tag[len] =3D '\0';
> > +
> > +	/* While the VIRTIO specification allows any character, newlines are
> > +	 * awkward on mount(8) command-lines and cause problems in the sysfs
> > +	 * "tag" attr and uevent TAG=3D properties. Forbid them.
> > +	 */
> > +	if (strchr(fs->tag, '\n')) {
> > +		dev_err(&vdev->dev, "refusing virtiofs tag with newline character\n"=
);
>=20
> Please don't let userspace spam mthe kernel log if they are the ones
> that are setting the tags.  Just make this a debug message instead.

This check is performed while probing the device. Userspace is not
involved but I'll change it to dev_dbg() anyway.

Stefan

--Ot15W0l9JUGuqbHu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmXGDNYACgkQnKSrs4Gr
c8iXbAf/VyiMiha96Y0oqFyGBXAPhzAcjtI+pW2x8TaFqNZcy9lCfhU8Bp0EidAk
2FRcssf84hjBIo0vvmYCvYKCLltRvVoEEpWO+ANRVG6/rlZAyXfuOgx2J/PJZlmJ
DivPMxJGZXLX9WYzO3TMVbbxHFLG1ywWRXxW1qR17mkqU9ChoLgLl/NyTSnXpEv5
DEOfJTV2OxkT19wQ+XRLTqehlJrVDfoKHABB6Ikj5txkfFmQA2/TMShdihbTBjHP
3r9DtfFi44B5cjNgsXS9Kke+hILXZjVyHt7STim61XMLsIjmI/4SOCvnmtN9kzGR
jWB2ucwlHr71EXBe0pQvvwCEBru2aw==
=DDOT
-----END PGP SIGNATURE-----

--Ot15W0l9JUGuqbHu--

