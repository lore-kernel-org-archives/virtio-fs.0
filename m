References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-8-mreitz@redhat.com>
	<20200911103259.GI94280@stefanha-x1.localdomain>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <48dff621-1085-0a16-55f9-b7351debf36e@redhat.com>
Date: Mon, 21 Sep 2020 15:47:57 +0200
MIME-Version: 1.0
In-Reply-To: <20200911103259.GI94280@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Nj5B1LLACxIThNL9musrfFLCCRl9PJFJ1"
Subject: Re: [Virtio-fs] [PATCH 7/9] fuse: Split fuse_mount off of fuse_conn
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, fuse-devel@lists.sourceforge.net

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nj5B1LLACxIThNL9musrfFLCCRl9PJFJ1
Content-Type: multipart/mixed; boundary="Zlu5UMfeG0n8b7pLW7syQ1reckBBqWb6o"

--Zlu5UMfeG0n8b7pLW7syQ1reckBBqWb6o
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11.09.20 12:32, Stefan Hajnoczi wrote:
> On Wed, Sep 09, 2020 at 08:46:01PM +0200, Max Reitz wrote:
>> @@ -176,13 +177,22 @@ static ssize_t fuse_conn_congestion_threshold_wr=
ite(struct file *file,
>> =20
>>  	spin_lock(&fc->bg_lock);
>>  	fc->congestion_threshold =3D val;
>> -	if (fc->sb) {
>> +
>> +	/*
>> +	 * Get any fuse_mount belonging to this fuse_conn; s_bdi is
>> +	 * shared between all of them
>> +	 */
>> +	if (!list_empty(&fc->mounts))
>> +		first_fm =3D list_first_entry(&fc->mounts, struct fuse_mount,
>> +					    fc_entry);
> ...
>> @@ -263,14 +273,20 @@ static struct dentry *fuse_ctl_add_dentry(struct=
 dentry *parent,
>>  int fuse_ctl_add_conn(struct fuse_conn *fc)
>>  {
>>  	struct dentry *parent;
>> +	struct fuse_mount *first_fm;
>>  	char name[32];
>> =20
>>  	if (!fuse_control_sb)
>>  		return 0;
>> =20
>> +	if (list_empty(&fc->mounts))
>> +		return 0;
>> +
>> +	first_fm =3D list_first_entry(&fc->mounts, struct fuse_mount, fc_ent=
ry);
>> +	sprintf(name, "%u", first_fm->dev);
>=20
> How does locking work for struct fuse_mount? Are there any locking rule=
s
> that can be documented?

Hm.  I just hoped the largely mechanical conversion of fuse_conn to
fuse_mount would ensure nothing breaks.

There are locks protecting the superblock and fuse_conn as a whole
(which basically includes the associated fuse_mounts).  I suspect we
could get better (i.e., finer) granularity by giving each fuse_mount its
own lock, and then releasing the fuse_conn lock while we switch over to
the fuse_mount lock.

That seems bug-prone, though, and probably doesn=92t even help performanc=
e
that much.  I mean, in the most common case, you won=92t have submounts,
so each fuse_conn has exactly one fuse_mount, so having a separate lock
for the latter won=92t help.

Max


--Zlu5UMfeG0n8b7pLW7syQ1reckBBqWb6o--

--Nj5B1LLACxIThNL9musrfFLCCRl9PJFJ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl9orw0ACgkQ9AfbAGHV
z0DUSAf+KjPtXrBVymfouu75IBjd8+lRI9ROD90fx8yQz+crMa84wP/A/zGxDg10
slBHc2x6IAQYNybSPmwrdsvYeT3xUaa8GumqCbFCfvg1N6voZNM3Xyj3Kef2Rp24
ZvnBGJFwXMEfMDfVp/JIxq1P+AIRuSAzJbR00OWjUqj5OmdzgszsXoQX3sk8d3f5
PDSpWV/ZiCVysGfLnbqXZL2qaotOYjNL7wW7aXiXRoHN2CtYSHUBR5F4iFjANiYv
H3gDI6MqULjauhezN1RqeApldE1dlBj+LxaWwoo3jZVgEPDD2ScFGFNearsmx+0Z
x8fnrnAwkmbydvTOEL8xyOw8f8GwTQ==
=c2EA
-----END PGP SIGNATURE-----

--Nj5B1LLACxIThNL9musrfFLCCRl9PJFJ1--

