References: <cb5bc383-a669-ebaa-3919-a5f860e10a52@redhat.com>
	<20200323184309.GE3017@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <1c152d0a-cd7c-9474-708b-fa825e97cd4a@redhat.com>
Date: Tue, 24 Mar 2020 18:30:57 +0100
MIME-Version: 1.0
In-Reply-To: <20200323184309.GE3017@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="LrR0kDoCE24khglv8PbSNJBvbl19c276J"
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
--LrR0kDoCE24khglv8PbSNJBvbl19c276J
Content-Type: multipart/mixed; boundary="FZn9hZIyfIts6u5P6Se8sIlqNQ6bkRVcM"

--FZn9hZIyfIts6u5P6Se8sIlqNQ6bkRVcM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23.03.20 19:43, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> Hi,
>>
>> I have this bug report here:
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1813885
>>
>> And I=E2=80=99m afraid I=E2=80=99m not really making progress on debug=
ging it, so I was
>> wondering whether any of you might have some insights.
>>
>> The problem is that the generic/503 xfstest hangs on virtio-fs.  Now, =
I
>> don=E2=80=99t know how the reporter got that test to run in the first =
place,
>> because for me, it requires fcollapse and fzero, which as far as I can=

>> tell are currently not supported for virtio-fs.
>>
>> So I first had to disable those requirements, and then let the helper
>> program (src/t_mmap_collision.c) not test those operations.
>>
>> Then, the test hangs.  What I could find out so far is that the hang
>> occurs in src/t_mmap_collision.c=E2=80=99s truncate_down_fn() (run thr=
ough
>> run_test(&truncate_down_fn), namely in one of the pread()s.  I can als=
o
>> see that some of the pread()s before fail with EFAULT.
>>
>> A bit more context: t_mmap_collision.c opens a test file twice (I thin=
k
>> the idea is that you open it once on an FS with DAX, and once without,=

>> but AFAIU it should work either way).  For the relevant test, it mmap(=
)s
>> the DAX FD, truncates it, then fallocates it to increase the size agai=
n.
>>  Then it reads from the non-DAX FD.
>=20
> Can you just confirm where the DAX is happening here?  As I read that b=
z
> entry it's using the qemu which doesn't have DAX code yet.

I actually don=E2=80=99t know whether it really uses DAX.  When I say =E2=
=80=9CDAX=E2=80=9D here
(and =E2=80=9Cdax_fd=E2=80=9D), I mean it in the spirit of the test, whic=
h tries to open
a file once with DAX and once without.  But it isn=E2=80=99t like it veri=
fies
that the first instance actually uses DAX.

So I think it rather likely that it doesn=E2=80=99t use DAX, and just two=
 FDs
for a single file concurrently.

Max


--FZn9hZIyfIts6u5P6Se8sIlqNQ6bkRVcM--

--LrR0kDoCE24khglv8PbSNJBvbl19c276J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl56Q9EACgkQ9AfbAGHV
z0A8Wwf9G9PFY24EI0A5Q75rT4WQBUX7UnlwnzOOUuB5zwRA6v4R/y89f3P3qeBk
A4so6NOg60bQiluiYbXNX4NbpasOJJ77m5bI1CG1c9biuQo4uV8AXlTz70NGpU07
AHKmRsDkSKfyzfw6gHlwZS1uHkEt0Y6vj6KriLWfWOKXp/lw+etQuEQzxktZIKYa
7mfr+3GcLrtOkmoCYfis169LpqEW2mC+7JWJcgTUH6eZW/X/M8G/kchOT7rF6pG1
KHUbLlt239sOAfnIhbONeTcYxGyLCdPrgu6fS6QqOzr8HwuUQeaNqr/2pGAg+rko
8R8THlCtxw2HkV/EF5tzjGohyR2oQQ==
=9o76
-----END PGP SIGNATURE-----

--LrR0kDoCE24khglv8PbSNJBvbl19c276J--

