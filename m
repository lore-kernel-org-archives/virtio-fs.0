Date: Thu, 1 Oct 2020 17:26:18 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201001162618.GN2807@work-vm>
References: <20200929185015.GG220516@redhat.com>
	<CAOQ4uxgMeWF_vitenBY6_N3Eu-ix92q8AO5ckDAF+SVxHTBXXw@mail.gmail.com>
	<CAJfpegtH0TruLCnG_YJ8aUBHh7k5sqN_wVEegvDPJOoDcmwLSQ@mail.gmail.com>
	<CAOQ4uxiity6zAW__Y+T=o+GHkzxo=fnVj+21Z8cRjdvFWbauRQ@mail.gmail.com>
	<dfa0dbea-7046-0852-60c6-39bc24f24314@gmail.com>
	<20201001135129.GG2807@work-vm>
	<3deb375c-e234-f83c-159f-cebdd3a1876e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3deb375c-e234-f83c-159f-cebdd3a1876e@gmail.com>
Subject: Re: [Virtio-fs] Kudos: productivity boost using virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

* Harry G. Coin (hgcoin@gmail.com) wrote:
>=20
> On 10/1/20 8:51 AM, Dr. David Alan Gilbert wrote:
> > * Harry G. Coin (hgcoin@gmail.com) wrote:
> >> Though it's likely been written before:
> >>
> >> Virtio-fs is a wonderful productivity boost in development environments
> >> in which unrelated deadlocks, crashes and hard-lockups happen.=C2=A0=
=C2=A0 Why?=C2=A0
> >> Because the underlying file system is never corrupted (though individu=
al
> >> file contents may be, the file system itself is protected).=C2=A0=C2=
=A0 For
> >> example, using btrfs' snapshot ability in the underlying file system a=
nd
> >> comparing 'before and after' crashes creates a powerful debugging tool.
> > Thanks!
> >
> > I'm curious, can you describe a bit more about how you're using it with
> > btrfs - I don't think we've had anyone describe that before.
> > (We mostly use it with overlayfs via the various container tools).
> >
> > Dave
>=20
> The 3 host chassis I've set up so far to work with this has a=A0 btrfs
> file system in a raid-1 setup.=A0 Btrfs does a good job with xattr support
> which virtio-fs can be set to use well.
>=20
> I have several vm's running on each chassis, each using virtio-fs.=A0 On
> the host, there is a sub-volume for each vm.=A0 The vms=A0 use kernel
> booting, and huge pages.=A0 So, on the bare-metal host, a simple 'btrfs su
> snapshot <vm sub volume> <snap name> generates an 'almost free' (from a
> resource perspective) look at the entire vm.=A0 Various risky experimental
> things go on in the vm, which could lead to file system corruption owing
> to deadlocks and hard freezes and race conditions.=A0 However with
> virtio-fs, when that happens, all I need to do on the host is make a
> another snapshot of the 'frozen' vm, stop the vm.=A0 Then I can compare
> the exact state of the files at the time of the freeze with the 'known
> good' versions at the snapshot time.=A0=A0 Delete the 'frozen' state
> snapshot, make a new=A0 snapshot of the known good snapshot, reboot the vm
> and the dev cycle can continue.=A0

OK, nice.

> Even if the cause of the freeze wasn't evident in the file system
> deltas, knowing there isn't corruption in the underlying fs is a big
> time saver.
>=20
> I expect when dax makes it out of the development bubble this
> configuration will be a very high performance, easy to maintain, high
> security arrangement.=A0 Much harder to 'break out' of a vm than the
> various container options.

Yeh; dealing with stuff that corrupts your install isn't fun;
thanks for the explanation!

Dave

>=20
>=20
>=20
>=20
> >> I suspect most folks involved in virtio-fs know this, but it's worth
> >> putting in the record for new folks.
> >>
> >> Harry
> >>
> >>
> >>
> >>
> >> _______________________________________________
> >> Virtio-fs mailing list
> >> Virtio-fs@redhat.com
> >> https://www.redhat.com/mailman/listinfo/virtio-fs
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

