Date: Thu, 1 Jul 2021 09:33:42 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YN195pPX2s0PRDqK@work-vm>
References: <492294b2-b305-86f4-2c91-a2faa766d2ee@gmail.com>
MIME-Version: 1.0
In-Reply-To: <492294b2-b305-86f4-2c91-a2faa766d2ee@gmail.com>
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
> If two or more instances of virtiofsd have a common full or partially
> shared directory tree path -- how will those instances 'enforce' a
> 'compatible' xattr map lest the host+guest(s) have quite the selinux
> attribute salad?

Virtiofsd instances are independent; it's upto whatever runs the daemons
to pick the options in a sane way.

>=A0 How much does virtiofsd need to feel like nfsd...?

What does nfsd do for this?

Dave

>=20
>=20
>=20
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

