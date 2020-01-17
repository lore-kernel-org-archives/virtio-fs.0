References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<20200115120118.GC163546@stefanha-x1.localdomain>
	<d5546de3-e02b-ccee-fa63-1889250d0738@redhat.com>
	<20200116203210.GE25291@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <0f54f8fc-63c7-f92a-850e-09d3ba5fa0dc@redhat.com>
Date: Fri, 17 Jan 2020 19:13:26 +0100
MIME-Version: 1.0
In-Reply-To: <20200116203210.GE25291@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="JkJg6beeL50J02hhGTeiUpDgo0VKh2cQX"
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JkJg6beeL50J02hhGTeiUpDgo0VKh2cQX
Content-Type: multipart/mixed; boundary="aNSUMPFYJv7ncAzvaHtqnAzFUAlYOI52g"

--aNSUMPFYJv7ncAzvaHtqnAzFUAlYOI52g
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 16.01.20 21:32, Vivek Goyal wrote:
> On Wed, Jan 15, 2020 at 02:00:27PM +0100, Max Reitz wrote:
>> On 15.01.20 13:01, Stefan Hajnoczi wrote:
>>> On Tue, Jan 14, 2020 at 08:24:51PM +0100, Miklos Szeredi wrote:
>>>> On Tue, Jan 14, 2020 at 6:13 PM Max Reitz <mreitz@redhat.com> wrote:=

>>>>> What worries me most is how to pass that object around to all FUSE
>>>>> functions, and that they all need a new interface.
>>>>
>>>> You mean libfuse API?
>>>>
>>>>> I just had a very fuzzy (and maybe stupid) idea: Maybe we could kee=
p an
>>>>> internal vector of currently active handles and then when variable-=
size
>>>>> handles are enabled, fuse_ino_t would just act as an index into tha=
t vector?
>>>>>
>>>>> I suppose we could then use the full-size handles in all messages a=
nd
>>>>> just hand out temporary indices to existing functions (just so we d=
on=E2=80=99t
>>>>> have to change their interface).  Server and client have their own
>>>>> vectors, because when they communicate, only the full handles have =
meaning.
>>>>>
>>>>> Or we could implement the table on top of the current system by sha=
ring
>>>>> it between the client and server.  Whenever the server creates a
>>>>> fuse_ino_t value, it then also creates a full-size handle, and retu=
rns
>>>>> both the handle and its corresponding fuse_ino_t value to the serve=
r.
>>>>> The server can use the fuse_ino_t normally most of the time, but wi=
th a
>>>>> catch: The client would be able to invalidate it.  Then the server =
needs
>>>>> to obtain a new fuse_ino_t value for the existing handle.
>>>>> (Invalidating and reacquiring a fuse_ino_t value would be new FUSE
>>>>> operations.)
>>>>
>>>> I think you may have accidentally switched "server" and "client" in
>>>> the above description a couple of times.
>>>>
>>>> But if I'm reading this correctly, your idea is to keep the 64bit
>>>> value on the interface (this could be just libfuse or both libfuse a=
nd
>>>> the kernel API) and add new interfaces to establish and reestablish
>>>> the mapping from (non-persistent) fuse_ino_t to (persistent) handle.=

>>>
>>> I'm not sure I understand Max's idea.
>>>
>>> Miklos, I think you're saying keep fuse_ino_t semantics unchanged (no=
t
>>> persistent, can be reused after the last reference is dropped) and ad=
d a
>>> separate struct export_operations-style FUSE API to map fuse_ino_t <-=
>
>>> struct file_handle.
>>
>> Yes, that=E2=80=99d be the idea.
>>
>>> We'd need to use submounts to avoid st_ino collisions in that case.
>>
>> Yes, because that idea wouldn=E2=80=99t solve the st_ino problem.  (On=
ly
>> persistent fuse_ino_t values would solve it.  This proposal is exactly=

>> the opposite, we want them to be absolutely not persistent.)
>>
>> So we=E2=80=99d still want submounts with separate st_devs and pass th=
rough
>> st_ino from the host.
>=20
> I am not sure I understand whole of the discussion. Here is my
> understanding. Please correct me if I got it wrong.
>=20
> So we seem to have two main problems.
>=20
> - st_inode number collision as seen by user space in case of multiple
>   submounts at host in directory being exported. And solution for this
>   seems to be supporting submounts where st_dev is reported from
>   submount in guest and st_ino is passthrough from host.
>=20
> - Being able have a persistent handle for inode on host. This will allo=
w
>   us to support export API on virtiofs and also allow server to trim
>   cache despite the fact that client still has reference to that inode.=


It would also allow us to migrate virtiofsd, as long as the destination
can make sense of the existing handles.

Trimming the cache wasn=E2=80=99t really a problem AFAIU, but with the ri=
ght
solution to the problem we can address that, too, yes.

As I wrote, I see three problems: (1) Inode collision, (2)
migrateability, (3) passing persistent file handles to the client.

> IIUC, first one is more pressing for us and second one can wait. Have
> I got it right?

It was my impression that file handles were more pressing in practice,
but I don=E2=80=99t know.  I=E2=80=99m currently trying to solve them all=
 in one package.

> Having said that, I don't know how complex it is to support submounts
> and what are other implications.

As far as I=E2=80=99ve seen so far, it=E2=80=99s conceptually rather simp=
le, the devil=E2=80=99s
just in the details.  (It=E2=80=99s easy to do a submount, the question i=
s how
we can make that submount then use a relative base directory as its root.=
)

Max


--aNSUMPFYJv7ncAzvaHtqnAzFUAlYOI52g--

--JkJg6beeL50J02hhGTeiUpDgo0VKh2cQX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4h+UcACgkQ9AfbAGHV
z0B3iwgAqDgo5d6lMOlMGIomP7UCq3Dnt1HSrkXUdXpMKNrljyRVks4at7UQUWyt
a2uz1oc2Gq+QuqIoGrhkIVKZ0Ja2GrydGAIy5fMXG9U0u+KM1Z3xPuFFpQmd5Svi
IvyMNbdkGGb41ujIita0KGr10Xx1JqboJXfP1GcQIVnzOn9pLFytQ7wozGEbVkqs
Cg/AmMAOciDKw6ULagv57B1JqepVr8q1DiJ2RxKkNQLo+SIZLZgoW9Ffzy/7pUbB
fbTOGL/DRlX6z68TvpnJTCzKCAgquInxKyBXpO4ARMfzwpKF/5OfvTlrMEOrno1e
iLKYbc7SdWt0NZJcdHDpP6amlNioCg==
=BqOr
-----END PGP SIGNATURE-----

--JkJg6beeL50J02hhGTeiUpDgo0VKh2cQX--

