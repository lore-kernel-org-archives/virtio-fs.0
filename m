Date: Thu, 1 Jul 2021 16:31:44 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YN3f4MqoiyvORI71@work-vm>
References: <492294b2-b305-86f4-2c91-a2faa766d2ee@gmail.com>
	<YN195pPX2s0PRDqK@work-vm>
	<14273048-d01f-6b7b-3094-787b79cb4a96@gmail.com>
MIME-Version: 1.0
In-Reply-To: <14273048-d01f-6b7b-3094-787b79cb4a96@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] multiple virtiofsd's + overlapping shared subtree
 -> enforced compatible xattr maps?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

* Harry G. Coin (hgcoin@gmail.com) wrote:
>=20
> On 7/1/21 3:33 AM, Dr. David Alan Gilbert wrote:
> > * Harry G. Coin (hgcoin@gmail.com) wrote:
> >> If two or more instances of virtiofsd have a common full or partially
> >> shared directory tree path -- how will those instances 'enforce' a
> >> 'compatible' xattr map lest the host+guest(s) have quite the selinux
> >> attribute salad?
> > Virtiofsd instances are independent; it's upto whatever runs the daemons
> > to pick the options in a sane way.
>=20
> While that's the current case, because the intention was to rely on the
> underlying fs to manage contention among virtiofsds: the moment
> xattrmaps happened virtiofsd entered the layer all network file system
> daemons face.=A0 Roughly speaking: a shift from one process per client to
> some IPC or threaded approach with a 'manager' process/thread that
> coordinates 'compatible' xattrmaps, acl maps, 'root squashing' etc. etc..

I really want to stick with one process per client; it makes the
security a lot easier; you never have to worry about accidentally
leaking data between clients within the process.
Now, that doesn't mean you can't have some coordination up a layer -
i.e. something that starts all the qemu's and virtiofsd's (like libvirt
etc) but that chose sane mappings.

> >> =A0 How much does virtiofsd need to feel like nfsd...?
> > What does nfsd do for this?
>=20
> A couple attempts over the last decade, the most landed in 5.9:=A0
> https://www.phoronix.com/scan.php?page=3Dnews_item&px=3DLinux-5.9-NFS-Ser=
ver-User-Xattr

So I saw that; but what I didn't see was a descriptionof what they
actually do with their xattr's; do the NFS servers just pass them
through or do they map?

Dave

>=20
>=20
>=20
>=20
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

