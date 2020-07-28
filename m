References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728153219.GC21660@stefanha-x1.localdomain>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <c5b15243-200b-fa17-27b5-1b27dbddbe6d@redhat.com>
Date: Tue, 28 Jul 2020 15:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <20200728153219.GC21660@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="7d5MUWo1b1wuTpcomcKBEn4YNTtHxYDiS"
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
 and print an error
Reply-To: dwalsh@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, Roman Mohr <rmohr@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "mpatel@redhat.com" <mpatel@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7d5MUWo1b1wuTpcomcKBEn4YNTtHxYDiS
Content-Type: multipart/mixed; boundary="JVfEqeD0nAxJkdjLPi5gMzABaO9fQnUzz"

--JVfEqeD0nAxJkdjLPi5gMzABaO9fQnUzz
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

On 7/28/20 11:32, Stefan Hajnoczi wrote:
> On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
>> On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
>> misono.tomohiro@fujitsu.com> wrote:
>>
>>>> Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print=
 an
>>> error
>>>> An assertion failure is raised during request processing if
>>>> unshare(CLONE_FS) fails. Implement a probe at startup so the problem=
 can
>>>> be detected right away.
>>>>
>>>> Unfortunately Docker/Moby does not include unshare in the seccomp.js=
on
>>>> list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always
>>>> include unshare (e.g. podman is unaffected):
>>>>
>>> https://raw.githubusercontent.com/seccomp/containers-golang/master/se=
ccomp.json
>>>> Use "docker run --security-opt seccomp=3Dpath/to/seccomp.json ..." i=
f the
>>>> default seccomp.json is missing unshare.
>>> Hi, sorry for a bit late.
>>>
>>> unshare() was added to fix xattr problem:
>>>
>>> https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491=
663cfcc#
>>> In theory we don't need to call unshare if xattr is disabled, but it =
is
>>> hard to get to know
>>> if xattr is enabled or disabled in fv_queue_worker(), right?
>>>
>>>
>> In kubevirt we want to run virtiofsd in containers. We would already n=
ot
>> have xattr support for e.g. overlayfs in the VM after this patch serie=
s (an
>> acceptable con at least for us right now).
>> If we can get rid of the unshare (and potentially of needing root) tha=
t
>> would be great. We always assume that everything which we run in conta=
iners
>> should work for cri-o and docker.
> Root is required to access files with any uid/gid.
>
> Dave Gilbert is working on xattr support without CAP_SYS_ADMIN. He may
> be able to find a way to drop unshare (at least in containers).
>
>> "Just" pointing docker to a different seccomp.json file is something w=
hich
>> k8s users/admin in many cases can't do.
> There is a Moby PR to change the default seccomp.json file here but it'=
s
> unclear if it will be merged:
> https://github.com/moby/moby/pull/41244
>
> Stefan

Why not try Podman?



--JVfEqeD0nAxJkdjLPi5gMzABaO9fQnUzz--

--7d5MUWo1b1wuTpcomcKBEn4YNTtHxYDiS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE+re/ImQyQPB/0p5rot+QHaviwCgFAl8geU0ACgkQot+QHavi
wCgSQggAmSFjOf2uO/6spzwFOUt/cUM1s5pmBtCQt4ZTh6mVbuNZpWKJON9k0mBH
g1y4nZt0kbzH9Mo8Rqmk+/+CbzWMAYlUeAwHSPOXkvErUZQE9oa1Ihs+VjDyd5m8
IWGaJI736purFTQ/tND0erl5KFrUYBzsGTPA+1MFSZJZkZ8PCAkE0/9VkDqjKmXM
g1X4zYKStlmzMhUJ4FL1xnDIpbwiHe4eBVvdJVGUlckaWX6tJWeQBexO+YCzvvMb
BA1pUOIw0E6i3RfCLjhfE8IL1DRCYl1bGW1XNIZ4hdci24tSDhSETAzZMVT+5LYP
LkUkQutB/JSOAWJ2UCN9K8N0N8Fc9Q==
=FTqT
-----END PGP SIGNATURE-----

--7d5MUWo1b1wuTpcomcKBEn4YNTtHxYDiS--

