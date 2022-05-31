Return-Path: <slp@redhat.com>
Date: Tue, 31 May 2022 12:50:50 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20220531104953.3lpjjpuxepc7wwdg@mhamilton>
References: <BY5PR14MB3893C17AAED9ECD7280AE7FD86D99@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="w4e3uddoi5xt5n7k"
Content-Disposition: inline
In-Reply-To: <BY5PR14MB3893C17AAED9ECD7280AE7FD86D99@BY5PR14MB3893.namprd14.prod.outlook.com>
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Pra.. Dew.." <linux_learner@outlook.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "gmaglione@redhat.com" <gmaglione@redhat.com>, Vivek Goyal <vgoyal@redhat.com>


--w4e3uddoi5xt5n7k
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pbfxsatzvymrrfo5"
Content-Disposition: inline


--pbfxsatzvymrrfo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2022 at 04:07:36PM +0000, Pra.. Dew.. wrote:
> Thanks for the response.  The  version of the qemu is 5.1.0 and  here is =
the comandline..
>=20
>=20
> [/usr/bin/qemu-system-test-machine test --enable-kvm -display none -mon m=
on-console,mode=3Dreadline -chardev socket,host=3D,port=3D5001,server,nowai=
t,id=3Dmon-console -device virtio-serial-device,max_ports=3D2 -device virtc=
onsole,chardev=3Dconsole,name=3Dconsole -chardev socket,host=3D,port=3D5000=
,server,nowait,id=3Dconsole -netdev tap,id=3Dtap0,ifname=3Dtap0,vhost=3Don,=
script=3Dno,downscript=3Dno -device virtio-net-device,netdev=3Dtap0 -device=
 vhost-vsock-device,guest-cid=3D4 -object rng-random,filename=3D/dev/urando=
m,id=3Drng0 -device virtio-rng-device,rng=3Drng0 -chardev socket,id=3Dchar0=
,path=3D/run/vm001-vhost-fs.sock -device vhost-user-fs-device,queue-size=3D=
2,chardev=3Dchar0,tag=3Dmyfs -object memory-backend-memfd,id=3Dmem,size=3D4=
G,share=3Don -kernel /var/lib/are/images/active/kernel.bin -dtb /var/lib/ar=
e/images/active/device-tree.dtb -device virtio-blk-device,drive=3Dwritable,=
serial=3Dwritable -drive file=3D/var/lib/are/volumes/writable.bin,if=3Dnone=
,id=3Dwritable,format=3Draw -device virtio-blk-device,drive=3Drootfs,serial=
=3Drootfs -drive file=3D/var/lib/are/images/active/rootfs/rootfs.bin,if=3Dn=
one,id=3Drootfs,format=3Draw,readonly]

Thanks for the details. I knew that we didn't support older versions,
but didn't want to reply that without explaining why.

I've just took a look, and the origin of this incompatibility is this
change in "hw/virtio/vhost-user.c":

qemu-5.1.0:

typedef struct VhostUserMemRegMsg {
    uint32_t padding;
    VhostUserMemoryRegion region;
} VhostUserMemRegMsg;

qemu-upstream (since 3009edff8192991293fe9e2b50b0d90db83c4a89):

typedef struct VhostUserMemRegMsg {
    uint64_t padding;
    VhostUserMemoryRegion region;
} VhostUserMemRegMsg;

Note how "padding" has changed from uint32_t to uint64_t.

This means we only support QEMU versions starting 5.2.0.

Regards,
Sergio.

--pbfxsatzvymrrfo5--

--w4e3uddoi5xt5n7k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmKV8wkACgkQ9GknjS8M
AjWYrhAApFLNQAsOQaGf4zITTKo0GWWFr3l/faxGhku5d4nsDZgRr7+sasHsadaE
8R1JaloTftFfbfAzcyoF8m/xFxuLextHFkGBG2UpsxP0w4pQnb6TMclXKGSHX5SI
Nz50JtppzM/2cMDObLRlMAth+a4VC2QyP6nN2KBsWkoS70CaJ/Z7c3gFNAggVv4P
WCi0PLg6wHQxr3NSS2tYi5BQxapm0eufjGpj9oKSRMfTwgE7vKK3sGPmuc4kjwyz
8Z4tR3Ekg1n0oHerH7gD9YCzU/B48BjW8GAZzMlvqRKy9yiP7kFueeENw3O65xsP
FCYUOXOD7exweNKQ/2AgSANiVd1jDsFvqLmoqhr8uUxEG387yolgG22+eNDoXu1T
syhg5fVh+reSPttfD65J3TPj5y9eg96IT2N6tNsDP6KAEGOg7x4Z6+cFwB14R5AJ
NTVIxtUJp+7iAIzxfa0vFzzIzNfg60FkzeqIf4PLPzrVDT7gcedWKrnQWybu1OUo
5ghYk2KtC1YGmeSHpXPy9fxHjRdiPo3aDE0fCggNS6JMSgG11SnTXvkH4jfC47kB
DZYvSIy0mcIBzJEeO2WFV6ReqBUSJW3JpAogPL8bjT6YR1//qmXqc/piM+b/fiON
0NTat0fmZZtcnE/8yJR31LgYowaicJwUPjkr7VvrHdESStDGCQI=
=2/kq
-----END PGP SIGNATURE-----

--w4e3uddoi5xt5n7k--
