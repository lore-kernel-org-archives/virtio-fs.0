References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<20200115120118.GC163546@stefanha-x1.localdomain>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <d5546de3-e02b-ccee-fa63-1889250d0738@redhat.com>
Date: Wed, 15 Jan 2020 14:00:27 +0100
MIME-Version: 1.0
In-Reply-To: <20200115120118.GC163546@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="BzgtmwDInVOCSdpH651TkTT8b9kTAlHYB"
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BzgtmwDInVOCSdpH651TkTT8b9kTAlHYB
Content-Type: multipart/mixed; boundary="Cnf1LvteSEvkx3hD2dWnSxqhCeBOelfm2"

--Cnf1LvteSEvkx3hD2dWnSxqhCeBOelfm2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.01.20 13:01, Stefan Hajnoczi wrote:
> On Tue, Jan 14, 2020 at 08:24:51PM +0100, Miklos Szeredi wrote:
>> On Tue, Jan 14, 2020 at 6:13 PM Max Reitz <mreitz@redhat.com> wrote:
>>> What worries me most is how to pass that object around to all FUSE
>>> functions, and that they all need a new interface.
>>
>> You mean libfuse API?
>>
>>> I just had a very fuzzy (and maybe stupid) idea: Maybe we could keep =
an
>>> internal vector of currently active handles and then when variable-si=
ze
>>> handles are enabled, fuse_ino_t would just act as an index into that =
vector?
>>>
>>> I suppose we could then use the full-size handles in all messages and=

>>> just hand out temporary indices to existing functions (just so we don=
=E2=80=99t
>>> have to change their interface).  Server and client have their own
>>> vectors, because when they communicate, only the full handles have me=
aning.
>>>
>>> Or we could implement the table on top of the current system by shari=
ng
>>> it between the client and server.  Whenever the server creates a
>>> fuse_ino_t value, it then also creates a full-size handle, and return=
s
>>> both the handle and its corresponding fuse_ino_t value to the server.=

>>> The server can use the fuse_ino_t normally most of the time, but with=
 a
>>> catch: The client would be able to invalidate it.  Then the server ne=
eds
>>> to obtain a new fuse_ino_t value for the existing handle.
>>> (Invalidating and reacquiring a fuse_ino_t value would be new FUSE
>>> operations.)
>>
>> I think you may have accidentally switched "server" and "client" in
>> the above description a couple of times.
>>
>> But if I'm reading this correctly, your idea is to keep the 64bit
>> value on the interface (this could be just libfuse or both libfuse and=

>> the kernel API) and add new interfaces to establish and reestablish
>> the mapping from (non-persistent) fuse_ino_t to (persistent) handle.
>=20
> I'm not sure I understand Max's idea.
>=20
> Miklos, I think you're saying keep fuse_ino_t semantics unchanged (not
> persistent, can be reused after the last reference is dropped) and add =
a
> separate struct export_operations-style FUSE API to map fuse_ino_t <->
> struct file_handle.

Yes, that=E2=80=99d be the idea.

> We'd need to use submounts to avoid st_ino collisions in that case.

Yes, because that idea wouldn=E2=80=99t solve the st_ino problem.  (Only
persistent fuse_ino_t values would solve it.  This proposal is exactly
the opposite, we want them to be absolutely not persistent.)

So we=E2=80=99d still want submounts with separate st_devs and pass throu=
gh
st_ino from the host.

> I like this approach because it requires no persistent state or extra
> in-memory data structures (if struct file_handle is cryptographically
> signed).
>=20
> My biggest concern is that submounts may be complex to implement or
> introduce problems (e.g. users see the submounts and get EBUSY when
> unmounting the original directory).

I=E2=80=99m not quite sure what you mean, but as far as I saw so far you =
can
auto-unmount submounts when the root is unmounted.

Max


--Cnf1LvteSEvkx3hD2dWnSxqhCeBOelfm2--

--BzgtmwDInVOCSdpH651TkTT8b9kTAlHYB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4fDOwACgkQ9AfbAGHV
z0BY/gf/bZzDPpioRebppLc3NEtylDniw7yjEhFkKUYtpXkaPMeU21dJd6NmLZ/N
5PeIMqv/z2vM30L23lzbSxn+CcLeROS5ztmygUm9iHMahwUvZIvukbL69dRq5PH4
UPjQt0xtSRwheguWRqK3vcVIhMXLEUcwEWqQNFqaQ0HrzGWnoCWkaRn8McNILlS+
mh/NWc+SKYNNjKIyy99K+BF8naqiEcunv+1vxOdQzK9u/+aIp3kwiuRJT4mWjXgE
49OPievvqga3TJ3K7IObu8GEGj3BNZgW0m+7VHbL4LIgl3tVNFTK6i6hCVkFbteA
uX5Q92bJWAE2mZiuS2rXXBTSBdca1Q==
=teaF
-----END PGP SIGNATURE-----

--BzgtmwDInVOCSdpH651TkTT8b9kTAlHYB--

