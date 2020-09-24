References: <20200909184603.263700-1-mreitz@redhat.com>
	<CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
	<e87d7603-100b-173a-07c6-3ef4c2400e94@redhat.com>
	<CAJfpegt-BOG7Xz4Xyy4OEnK+2EPGQ61e4qk7WBKUVjQN4yAiSw@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <5249b6e0-597a-ce62-0e44-ac3e2398842c@redhat.com>
Date: Thu, 24 Sep 2020 10:10:34 +0200
MIME-Version: 1.0
In-Reply-To: <CAJfpegt-BOG7Xz4Xyy4OEnK+2EPGQ61e4qk7WBKUVjQN4yAiSw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="cNDt6dOXQnVcD5vIjar3figBlfoCHr0Ym"
Subject: Re: [Virtio-fs] [fuse-devel] [PATCH 0/9] fuse: Mirror virtio-fs
	submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, fuse-devel <fuse-devel@lists.sourceforge.net>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cNDt6dOXQnVcD5vIjar3figBlfoCHr0Ym
Content-Type: multipart/mixed; boundary="8mMWuWRk0sCeoBY5cE1BLtRJmvADU5CQX"

--8mMWuWRk0sCeoBY5cE1BLtRJmvADU5CQX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23.09.20 19:15, Miklos Szeredi wrote:
> On Wed, Sep 23, 2020 at 5:45 PM Max Reitz <mreitz@redhat.com> wrote:
>>
>> On 18.09.20 17:25, Miklos Szeredi wrote:
>>> Pushed an updated version to fuse.git#submounts.
>>>
>>> Also attached incremental patch (against rebase of
>>> virtiofs-submounts-v2 on fuse.git#for-next).
>>>
>>> Changes:
>>>
>>>  1) rebased on top of DAX patches
>>>  2) fixed CUSE
>>>  3) added locking for fc->mounts list
>>>  4) dissociate lifetime of fc from lifetime of root mount
>>>  5) do not hash mountpoint inodes
>>>  6) add FUSE_SUBMOUNTS init flag (replaces FUSE_ATTR_FLAGS but
>>> slightly different usage)
>>>  7) various cleanups
>>>
>>> Note, the effect of 5 can only be observed if the same directory is
>>> bind mounted into multiple places:
>>>
>>> HOST:
>>> cd /mnt
>>> mkdir 1 2
>>> mount --bind /dev/shm 1
>>> mount --bind /dev/shm 2
>>>
>>> GUEST:
>>> mount -t virtiofs mnt /mnt
>>> cd /mnt/1
>>> ls ../2
>>> /bin/pwd
>>>
>>> If the mountpoint is hashed, then the "ls ../2" will basically result=

>>> in /mnt/1 inode being moved to /mnt/2, which is not what we want.  I
>>> don't think there's any negative side effect of the mountpoint being
>>> unhashed, but this is a bit subtle.
>>>
>>>
>>> On the server side, keying on just st_ino/st_dev is a really crude wa=
y
>>> of mapping out mounts.  Take this example:
>>>
>>> HOST:
>>> cd /mnt
>>> mkdir 1
>>> mount --bind /dev/shm 1
>>> cd 1
>>> mkdir 2
>>> mount --bind /mnt 2
>>> ls /mnt/1/2/1
>>>
>>> GUEST:
>>> mount -t virtiofs mnt /mnt
>>> ls /mnt/1/2/1
>>> 2
>>> ls /mnt/1/2/1/2/1/2/1/
>>> 2
>>>
>>> So what we really need is keying on mount ID as well.
>>>
>>> Attaching an incremental patch to do that.  Needs v5.8 kernel on host=

>>> to actually make a difference, but commit fa2fcf4f1df1 ("statx: add
>>> mount ID") is trivial to backport to any kernel that has statx.
>>>
>>> Please review and test.  If there are no major issues, this should be=

>>> good to go for v5.10.
>>
>> As for the virtiofsd patch, I wonder about:
>>
>>> #if 0 && defined(HAVE_STATX) && STATX_MNT_ID
>>
>> Shouldn=E2=80=99t the 0 not be there?  And should STATX_MNT_ID be wrap=
ped in
>> defined()?
>=20
> Right, that was left there from testing.
>=20
>> Furthermore I wonder why you have removed the parent_dev logic.  With
>> your patch, FUSE_ATTR_SUBMOUNT can be announced only by those function=
s
>> that invoke lo_do_lookup().  Is it OK to do so only there, and not eve=
ry
>> time a fuse_attr is returned (be it as part of fuse_entry_out, as by
>> lo_link(), or directly by lo_getattr())?
>=20
> No, object creation never results in a mounted object.  If the newly
> created object is mounted on at a later time, the revalidate logic
> will take care of that.

So lo_getattr() is not an issue either, because all mount operations
will be handled by the revalidate logic?

Max


--8mMWuWRk0sCeoBY5cE1BLtRJmvADU5CQX--

--cNDt6dOXQnVcD5vIjar3figBlfoCHr0Ym
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl9sVHoACgkQ9AfbAGHV
z0BSYQf/frFHxlyegWaw5QXsl8vykX0xjmu0GRUTAbqBPluLjeCLJIIJNkR1NiSB
KGEmYUV0d+o8/I85NzpDMY4k67FCVOKSHn6rPmQw+q9LCoO7YdISTLzK7EIFhVvW
MkzuKJ+q1/NdMXPuxXFEeTSe56gKbyyx764FHrPqYLInLNevsigUvDj9PwS1EOyc
MhiHadnWSvi8e9t1gDZS0TpMkafq5hgKeLHf7BNyRtNkFT1wqbCRSic7foNrIfR1
UaOSgT9YGmqZP6+sJDfzzJNpBu5DxGxVqFgmsE7Fkj9tFDEJ5rL7koDoj7ytmutX
EOjJ42hXDk7cAwZ28Uai7+dgGmyrsg==
=u7cH
-----END PGP SIGNATURE-----

--cNDt6dOXQnVcD5vIjar3figBlfoCHr0Ym--

