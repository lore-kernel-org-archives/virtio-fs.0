References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-3-mreitz@redhat.com>
	<20200911102459.GC94280@stefanha-x1.localdomain>
	<CAJfpegvxmx995QihR+=bOcyWy0pGmxFtAJhzvw7O2k9rq9r5zA@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <a75efdcf-834c-8515-b3b7-87d4f63c888c@redhat.com>
Date: Mon, 14 Sep 2020 14:29:31 +0200
MIME-Version: 1.0
In-Reply-To: <CAJfpegvxmx995QihR+=bOcyWy0pGmxFtAJhzvw7O2k9rq9r5zA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="N79ji15RcNiB4EY2z7LqOKqJpGd3RxSMn"
Subject: Re: [Virtio-fs] [fuse-devel] [PATCH 2/9] fuse: Add
	FUSE_ATTR_SUBMOUNT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, fuse-devel <fuse-devel@lists.sourceforge.net>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N79ji15RcNiB4EY2z7LqOKqJpGd3RxSMn
Content-Type: multipart/mixed; boundary="PIo2RTn57LGhQsSXCv2DZVkWHsgR7WArY"

--PIo2RTn57LGhQsSXCv2DZVkWHsgR7WArY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11.09.20 13:07, Miklos Szeredi wrote:
> On Fri, Sep 11, 2020 at 12:25 PM Stefan Hajnoczi <stefanha@redhat.com> =
wrote:
>>
>> On Wed, Sep 09, 2020 at 08:45:56PM +0200, Max Reitz wrote:
>>> This is a flag for fuse_attr.flags that indicates that the given entr=
y
>>> resides on a different filesystem than the parent, and as such should=

>>> have a different st_dev.
>>>
>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>>> ---
>>>  include/uapi/linux/fuse.h | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
>>> index de94c11cfc3b..c034cdf8f5f4 100644
>>> --- a/include/uapi/linux/fuse.h
>>> +++ b/include/uapi/linux/fuse.h
>>> @@ -417,6 +417,13 @@ struct fuse_file_lock {
>>>   */
>>>  #define FUSE_FSYNC_FDATASYNC (1 << 0)
>>>
>>> +/**
>>> + * fuse_attr flags
>>> + *
>>> + * FUSE_ATTR_SUBMOUNT: File/directory is a submount point
>>> + */
>>> +#define FUSE_ATTR_SUBMOUNT      (1 << 0)
>>
>> If you respin, please add a little more detail here. How should client=
s
>=20
> I'm just reviewing/queuing this, so no need to respin.
>=20
>> act when this flag is detected (which FUSE messages should they send t=
o
>> deal with submounts)?
>=20
> Actually, no new messages, since the reply containing
> FUSE_ATTR_SUBMOUNT already refers to the submount root.  I'll fix the
> description.

Perhaps it=E2=80=99s still useful to note how this flag is supposed to be=

handled; i.e. that it=E2=80=99s a hint to the kernel to create an auto-mo=
unted
submount.

> And since there's no separate information for the actual mount point
> (userspace can't obtain it) AT_NO_AUTOMOUNT users become confused due
> to the dummy mountpoint becoming visible with all the wrong data.
> Maybe the fix is to force automount even with AT_NO_AUTOMOUNT.  Will
> look into that.

If that=E2=80=99s possible...  Though Dave did mention that it seems inte=
ntional
that auto-mounts aren=E2=80=99t mounted on stat, so as not to overwhelm t=
he
system on a plain ls call.

Max


--PIo2RTn57LGhQsSXCv2DZVkWHsgR7WArY--

--N79ji15RcNiB4EY2z7LqOKqJpGd3RxSMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl9fYisACgkQ9AfbAGHV
z0DqlAf/SSEyzztW4FpTMv/5sMqNBIoB6qOCpNJxYEyR/RuRriN6VwIyaAENEX8f
fVCDYsF5DrDFGqGEWxlbvvVInp+50tCHAmLAZjo1eeebWYVpFANI9jMaWaF7jDCR
nlBQFzTUGKBivehbma1cyuZH0Lp0iEZPN3elHhcsaaj3Ztr4cH+5urk68q+WbIiJ
iHgK7GG08wYRdm5D/hQIlRyTixoA2v1Z2yxUaF2k9jG7iZ8bWDFDF4wg+dU2dBNl
rA3VtVksv31uC9qp+dubqjriOgDpchMiNZ0AR57xpz0Rto8ykV+60sW/q0SRn8np
WfUlnblFXV7CAuGOUyH3cm3Ok6XI8w==
=CsY9
-----END PGP SIGNATURE-----

--N79ji15RcNiB4EY2z7LqOKqJpGd3RxSMn--

