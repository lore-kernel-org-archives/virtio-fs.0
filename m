References: <cb5bc383-a669-ebaa-3919-a5f860e10a52@redhat.com>
	<20200323184022.6uzdg2twl3ntwhdg@rsjd01523.et2sqa>
	<20200323191217.lh7kl7lhfsedbeya@rsjd01523.et2sqa>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <4437fc09-8e0a-b89e-be65-9d98cfb54be4@redhat.com>
Date: Tue, 24 Mar 2020 18:32:27 +0100
MIME-Version: 1.0
In-Reply-To: <20200323191217.lh7kl7lhfsedbeya@rsjd01523.et2sqa>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="MPrrUBUyinKiztDaCKG2i5OVLwx8WhXEl"
Subject: Re: [Virtio-fs] xfstest generic/503 hangs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: bo.liu@linux.alibaba.com
Cc: virtio-fs-list <virtio-fs@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MPrrUBUyinKiztDaCKG2i5OVLwx8WhXEl
Content-Type: multipart/mixed; boundary="RdQ6M1XIByamkBdCsfUMEZ9h8k89wmAwR"

--RdQ6M1XIByamkBdCsfUMEZ9h8k89wmAwR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23.03.20 20:12, Liu Bo wrote:
> On Tue, Mar 24, 2020 at 02:40:23AM +0800, Liu Bo wrote:
>> On Mon, Mar 23, 2020 at 07:18:57PM +0100, Max Reitz wrote:
>>> Hi,
>>>
>>> I have this bug report here:
>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1813885
>>>
>>> And I=E2=80=99m afraid I=E2=80=99m not really making progress on debu=
gging it, so I was
>>> wondering whether any of you might have some insights.
>>>
>>> The problem is that the generic/503 xfstest hangs on virtio-fs.  Now,=
 I
>>> don=E2=80=99t know how the reporter got that test to run in the first=
 place,
>>> because for me, it requires fcollapse and fzero, which as far as I ca=
n
>>> tell are currently not supported for virtio-fs.
>>>
>>> So I first had to disable those requirements, and then let the helper=

>>> program (src/t_mmap_collision.c) not test those operations.
>>>
>>> Then, the test hangs.  What I could find out so far is that the hang
>>> occurs in src/t_mmap_collision.c=E2=80=99s truncate_down_fn() (run th=
rough
>>> run_test(&truncate_down_fn), namely in one of the pread()s.  I can al=
so
>>> see that some of the pread()s before fail with EFAULT.
>>>
>>> A bit more context: t_mmap_collision.c opens a test file twice (I thi=
nk
>>> the idea is that you open it once on an FS with DAX, and once without=
,
>>> but AFAIU it should work either way).  For the relevant test, it mmap=
()s
>>> the DAX FD, truncates it, then fallocates it to increase the size aga=
in.
>>>  Then it reads from the non-DAX FD.
>>>
>>> It does all of that in two threads simultaneously for a second.
>>>
>>> The EFAULT seems to come from the guest kernel.  I don=E2=80=99t see =
virtiofsd
>>> returning an error anywhere.  I don=E2=80=99t know where it comes fro=
m exactly,
>>> only that when I replace all occurrences of =E2=80=9CEFAULT=E2=80=9D =
by e.g. =E2=80=9CEBADSLT=E2=80=9D
>>> in mm/, the test crashes instead of hanging, so I take that to mean t=
hat
>>> the error comes from something in mm/ (which I suppose isn=E2=80=99t =
too
>>> unexpected).
>>>
>>> The test passes if running the test function in a single thread inste=
ad
>>> of two, or if you use a separate TEST_DEV and SCRATCH_DEV =E2=80=93 b=
ut in the
>>> latter case, you really have two separate files, so the test becomes
>>> rather moot (AFAIU).
>>>
>>> The fact that truncate_down_fn() uses fallocate() seems irrelevant.
>>> When you replace it by ftruncate() (i.e. the dax_fd is just first
>>> truncated to 0, and then truncated back to @file_size), the test fail=
s
>>> in the same way.  So maybe there is some interaction between the
>>> ftruncate() and a concurrent pread()?  But where does the EFAULT come=
 from?
>>>
>>> Does anyone have any spontaneous ideas? :/
>>>
>>
>> When it comes to "hang", I guess it's a similar problem of guest dax
>> reading while host truncates the file,

That does sound similar...

>> this can be verify by the hang
>> stack, did it hang at dax_iomap_actor() -> dax_copy_to_iter()?
>>
>> I think we did use fuse_break_layout() to avoid pinned blocks being
>> truncated underneath in this kind of mmap problems, but seems it
>> doesn't work as expected.
>=20
> I spoke too quickly, the stack in bz is not about dax hang I described =
above.

=2E..but then maybe not. :-/

Max


--RdQ6M1XIByamkBdCsfUMEZ9h8k89wmAwR--

--MPrrUBUyinKiztDaCKG2i5OVLwx8WhXEl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl56RCsACgkQ9AfbAGHV
z0DYqQgApKcWFM3gRuMaT9+DRJhfALqxUG1yEUmol7N5Gaqygv2EDTl5DRpke6b7
idGcNHQoyaO6lQMxYBj/zoas4xBIcL/heR/J8hZeqwQ1/EV0zPGQbeNZ80KW0sjA
HFmjqP28JtXwR6+d0ztNzNLiIZsysaHseUfLsMsvT3hiKAiPd+Tw1oxpdY0N/dEO
5ZSkGtXXDk1ha0PK8+4KUAemckvcapII+U1Q4HqPSMjHsgj9ZvuOE3LwuXWRWq+N
sONAfMJ4UxlssnbNSKhvWwENAeaYd1ke0yJXKWTvJlIODyreRAxkyDZa6zLkeTEr
9jm1ncwQlZSgaqEtireJ9IQuRmnp7w==
=XGnd
-----END PGP SIGNATURE-----

--MPrrUBUyinKiztDaCKG2i5OVLwx8WhXEl--

