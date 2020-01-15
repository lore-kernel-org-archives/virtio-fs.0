References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
Date: Wed, 15 Jan 2020 10:37:17 +0100
MIME-Version: 1.0
In-Reply-To: <CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Cwz6biWQZvQLdYQjxUgyUvamnqLTjI13o"
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
--Cwz6biWQZvQLdYQjxUgyUvamnqLTjI13o
Content-Type: multipart/mixed; boundary="aHV1hXP23A1c0gXDr6Bik2IxqwaX228Rw"

--aHV1hXP23A1c0gXDr6Bik2IxqwaX228Rw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 14.01.20 20:24, Miklos Szeredi wrote:
> On Tue, Jan 14, 2020 at 6:13 PM Max Reitz <mreitz@redhat.com> wrote:
>> What worries me most is how to pass that object around to all FUSE
>> functions, and that they all need a new interface.
>=20
> You mean libfuse API?

Not only that, but also the FUSE kernel driver.

>> I just had a very fuzzy (and maybe stupid) idea: Maybe we could keep a=
n
>> internal vector of currently active handles and then when variable-siz=
e
>> handles are enabled, fuse_ino_t would just act as an index into that v=
ector?
>>
>> I suppose we could then use the full-size handles in all messages and
>> just hand out temporary indices to existing functions (just so we don=E2=
=80=99t
>> have to change their interface).  Server and client have their own
>> vectors, because when they communicate, only the full handles have mea=
ning.
>>
>> Or we could implement the table on top of the current system by sharin=
g
>> it between the client and server.  Whenever the server creates a
>> fuse_ino_t value, it then also creates a full-size handle, and returns=

>> both the handle and its corresponding fuse_ino_t value to the server.
>> The server can use the fuse_ino_t normally most of the time, but with =
a
>> catch: The client would be able to invalidate it.  Then the server nee=
ds
>> to obtain a new fuse_ino_t value for the existing handle.
>> (Invalidating and reacquiring a fuse_ino_t value would be new FUSE
>> operations.)
>=20
> I think you may have accidentally switched "server" and "client" in
> the above description a couple of times.

Isn=E2=80=99t the kernel (i.e., the guest) the client and virtiofsd the s=
erver?

> But if I'm reading this correctly, your idea is to keep the 64bit
> value on the interface (this could be just libfuse or both libfuse and
> the kernel API) and add new interfaces to establish and reestablish
> the mapping from (non-persistent) fuse_ino_t to (persistent) handle.

Yes.

Max


--aHV1hXP23A1c0gXDr6Bik2IxqwaX228Rw--

--Cwz6biWQZvQLdYQjxUgyUvamnqLTjI13o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4e3U0ACgkQ9AfbAGHV
z0D0Xgf/TlcZ98Q0X3wJg0qQxL3oKEckV1DK2n0ZDRTPTMY+zC7SHkw85mMKQuiA
or+tW7xZDr2bo2Uxupbc/KCyfFbh72pr7v1EKhJA4A6duCr8rrgsiHF4z/kWgCZu
+nqf3iLranEL18gO30WQ5XxEP229t9T2uwdcpBQduMYiM69+Dqby4P0Sdc70cxr+
JD9uCFmpeDBh9EjaA1iwIHa6AFoQZXrZsWiASry+sV7GAkMv1ydWve5bJq8vfQhI
5stXX0D+TaDZLXUfuZba+NK82k3iluat0eS8x+KimFV+V/8bJOpve5xSOF31JRYD
O0pXuSdxSJZXYFXkKyc+O6qpsiMdXg==
=w5d5
-----END PGP SIGNATURE-----

--Cwz6biWQZvQLdYQjxUgyUvamnqLTjI13o--

