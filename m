Date: Fri, 2 Oct 2020 10:47:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201002144731.GA10232@redhat.com>
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

On Thu, Oct 01, 2020 at 09:12:17AM -0500, Harry G. Coin wrote:
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

IIUC, using virtio-fs saved one reboot of the host. Otherwise
one can just run keep one known good copy and run workload on=20
another copy. Once system deadlocks, reboot and compare good and
bad copy? Did I miss the point completely.

>=20
> Even if the cause of the freeze wasn't evident in the file system
> deltas, knowing there isn't corruption in the underlying fs is a big
> time saver.
>=20
> I expect when dax makes it out of the development bubble this
> configuration will be a very high performance, easy to maintain, high
> security arrangement.=A0 Much harder to 'break out' of a vm than the
> various container options.

DAX should be exciting. Looking forward to it.

One restriction right now it will put is
that don't share the directory with other clients or host. Because
if they truncate the file (which has been mapped inside guest), and
guest accesses that after truncation, then we don't have mechanism
to handle error and guest spins forever.

Trying to solve that issue in KVM but it does not seem to be a trivial
fix.

Thanks
Vivek

