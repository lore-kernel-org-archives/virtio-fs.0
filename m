Date: Fri, 11 Dec 2020 11:05:22 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201211110522.GB3380@work-vm>
References: <20201207183021.22752-1-vgoyal@redhat.com>
	<20201207183021.22752-4-vgoyal@redhat.com>
	<20201210200303.GN3629@work-vm>
	<20201210200931.GA185111@redhat.com>
	<97a0de57-8422-2fdc-e16e-0d6f133f615c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <97a0de57-8422-2fdc-e16e-0d6f133f615c@gmail.com>
Subject: Re: [Virtio-fs] ceph + freeipa ubuntu/fedora common small bug
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com, lersek@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Harry G. Coin (hgcoin@gmail.com) wrote:
> FYI.=A0 Same thing we saw on Fedora installing freeipa, this on ubuntu
> with ceph.=A0 Identical bitmask report.
>=20
> ...
>=20
> Fixing /var/run/ceph ownership....done
>=20
> Cannot set file attribute for '/var/log/journal', value=3D0x00800000,
> mask=3D0x00800000, ignoring: Function not implemented
>=20
> Cannot set file attribute for
> '/var/log/journal/fd007229322043ad8778c214d19ed3ac', value=3D0x00800000,
> mask=3D0x00800000, ignoring: Function not implemented

This looks like it comes out of systemd's  src/tmpfiles/tmpfiles.c:

        r =3D chattr_fd(procfs_fd, f, item->attribute_mask, NULL);
        if (r < 0)
                log_full_errno(IN_SET(r, -ENOTTY, -EOPNOTSUPP) ? LOG_DEBUG =
: LOG_WARNING,
                               r,
                               "Cannot set file attribute for '%s', value=
=3D0x%08x, mask=3D0x%08x, ignoring: %m",
                               path, item->attribute_value, item->attribute=
_mask);

and it's chattr_fd is in it's src/basic/chattr-util.c
which is using FS_IOC_GET/SETFLAGS, which seems to be an older
way of doing things.

Now, is that supposed to promote itself to a newer call or is it OK?

Dave

> ...
>=20
> Host has xattrs on, btrfs.
>=20
>=20
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

