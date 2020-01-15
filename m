From: Max Reitz <mreitz@redhat.com>
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
Message-ID: <9bdd4cb6-916e-cc29-775f-8ff4f92c4e0a@redhat.com>
Date: Wed, 15 Jan 2020 10:39:01 +0100
MIME-Version: 1.0
In-Reply-To: <19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="6KmEOVgCJ9E5KB7VhKnxuyZTIBrBfYzz8"
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6KmEOVgCJ9E5KB7VhKnxuyZTIBrBfYzz8
Content-Type: multipart/mixed; boundary="qnu52nXXhtnlpXQVem7BBraIEtBgtmjw4"

--qnu52nXXhtnlpXQVem7BBraIEtBgtmjw4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.01.20 10:37, Max Reitz wrote:

[...]

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
>=20
> Isn=E2=80=99t the kernel (i.e., the guest) the client and virtiofsd the=
 server?

Oh, er, yes.  So I started to get it wrong after =E2=80=9Creturns both th=
e
handle...=E2=80=9D.  Sorry. O:-)

Max


--qnu52nXXhtnlpXQVem7BBraIEtBgtmjw4--

--6KmEOVgCJ9E5KB7VhKnxuyZTIBrBfYzz8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4e3bYACgkQ9AfbAGHV
z0CZHQf/Rl2F2z/kU0zHi3WfZv8B6gC0iYunIhfFdBTLuNSWuA6Zf7tTthTYyyXp
OKnPPub8327FvWbjpoVS5Ci1Bj5ImSBeULn3wSAIaj93xzkn25gMVIWYhDyzwHxd
tLJ5adtw33iOAUUfAI9xsomVRKq/KdLaWJgiX7pPuPvfQhb3B440cwpfDNgZ6lNA
H04q6F0Th3zh5aJAV5kiVNn92cb3Y9/dk8XB7SES4iQssSZZxPtdmGbF3RSYH7oT
CxBQreD2j8rzKwwHCk7IFK3m2vZWZ+2d/MD1O8CUT3XygrD1hiB5lyyEJdUrTNdh
JX5+nbCTRmEsZ5fvdXBV1ZkW9O1QBQ==
=0Acz
-----END PGP SIGNATURE-----

--6KmEOVgCJ9E5KB7VhKnxuyZTIBrBfYzz8--

