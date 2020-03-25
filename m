References: <cb5bc383-a669-ebaa-3919-a5f860e10a52@redhat.com>
	<20200323184309.GE3017@work-vm>
	<1c152d0a-cd7c-9474-708b-fa825e97cd4a@redhat.com>
	<20200324195230.GH2645@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <d289c560-dad7-1bb0-b0f2-a69f7bc09d35@redhat.com>
Date: Wed, 25 Mar 2020 10:49:52 +0100
MIME-Version: 1.0
In-Reply-To: <20200324195230.GH2645@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="o0t4zGSVikFFeamzruGXKlfmP9BlXT1hZ"
Subject: Re: [Virtio-fs] xfstest generic/503 hangs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o0t4zGSVikFFeamzruGXKlfmP9BlXT1hZ
Content-Type: multipart/mixed; boundary="fWy6TvGuqXSNvVBQdzO4utTsvUFcZEyJx"

--fWy6TvGuqXSNvVBQdzO4utTsvUFcZEyJx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24.03.20 20:52, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> On 23.03.20 19:43, Dr. David Alan Gilbert wrote:
>>> * Max Reitz (mreitz@redhat.com) wrote:
>>>> Hi,
>>>>
>>>> I have this bug report here:
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1813885
>>>>
>>>> And I=E2=80=99m afraid I=E2=80=99m not really making progress on deb=
ugging it, so I was
>>>> wondering whether any of you might have some insights.
>>>>
>>>> The problem is that the generic/503 xfstest hangs on virtio-fs.  Now=
, I
>>>> don=E2=80=99t know how the reporter got that test to run in the firs=
t place,
>>>> because for me, it requires fcollapse and fzero, which as far as I c=
an
>>>> tell are currently not supported for virtio-fs.
>>>>
>>>> So I first had to disable those requirements, and then let the helpe=
r
>>>> program (src/t_mmap_collision.c) not test those operations.
>>>>
>>>> Then, the test hangs.  What I could find out so far is that the hang=

>>>> occurs in src/t_mmap_collision.c=E2=80=99s truncate_down_fn() (run t=
hrough
>>>> run_test(&truncate_down_fn), namely in one of the pread()s.  I can a=
lso
>>>> see that some of the pread()s before fail with EFAULT.
>>>>
>>>> A bit more context: t_mmap_collision.c opens a test file twice (I th=
ink
>>>> the idea is that you open it once on an FS with DAX, and once withou=
t,
>>>> but AFAIU it should work either way).  For the relevant test, it mma=
p()s
>>>> the DAX FD, truncates it, then fallocates it to increase the size ag=
ain.
>>>>  Then it reads from the non-DAX FD.
>>>
>>> Can you just confirm where the DAX is happening here?  As I read that=
 bz
>>> entry it's using the qemu which doesn't have DAX code yet.
>>
>> I actually don=E2=80=99t know whether it really uses DAX.  When I say =
=E2=80=9CDAX=E2=80=9D here
>> (and =E2=80=9Cdax_fd=E2=80=9D), I mean it in the spirit of the test, w=
hich tries to open
>> a file once with DAX and once without.  But it isn=E2=80=99t like it v=
erifies
>> that the first instance actually uses DAX.
>>
>> So I think it rather likely that it doesn=E2=80=99t use DAX, and just =
two FDs
>> for a single file concurrently.
>=20
> OK, I don't think DAX is really involved.
>=20
> Does Liu Bo's:=20
> https://www.redhat.com/archives/virtio-fs/2020-March/msg00074.html
>=20
> help?

No, unfortunately it doesn=E2=80=99t.

(I tried it last week, I was looking for patches that might be related;
the only other thing I tried was
https://www.redhat.com/archives/virtio-fs/2020-March/msg00002.html)

Max


--fWy6TvGuqXSNvVBQdzO4utTsvUFcZEyJx--

--o0t4zGSVikFFeamzruGXKlfmP9BlXT1hZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl57KUEACgkQ9AfbAGHV
z0BvFwf/Uoyk2tJ6QJKx5F1sC88X6T22gX8XNkqY+rdgFcwLU9jacaQD+S/pGN9W
QzkfKCInF2NP7XqCrS68n2FEpgKWT4fsGv5H9hSNf5ugI/Ah9X7F0srTO/nNJ3K8
UIKOZ26tBi80TjUCOzKGPU7NQ0nrgtr4bWbQLVwqKwcJ32KdevjL+0deVbR0aZo9
ZDPD+YZRr+UJZe87U/l5nbNZPwrXI7LYfSR4JC9c0ye+h1Vi6Vt6k92Z3Ln3GA4c
W4zlNIwnMVN3Te16H6HVzanrRGt1MvyUT0uNK9ySo6KCTMQhQH9OM9G/v+5R7y4N
uupXLUxSSsLiF0FK11sYvqLBMh64qA==
=9AJ6
-----END PGP SIGNATURE-----

--o0t4zGSVikFFeamzruGXKlfmP9BlXT1hZ--

