Date: Tue, 18 Feb 2020 18:58:31 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200218185831.GV3080@work-vm>
References: <20200214192705.GE18654@redhat.com> <20200214194130.GP3283@work-vm>
	<20200218133821.GE786556@stefanha-x1.localdomain>
	<a3880c0b-32b2-0197-822c-d78fcbfe177c@redhat.com>
	<47f62cf4-5b44-b2f0-52f3-5b889d1c3ac8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <47f62cf4-5b44-b2f0-52f3-5b889d1c3ac8@redhat.com>
Subject: Re: [Virtio-fs] One virtiofs daemon per exported dir requirement
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel Walsh <dwalsh@redhat.com>
Cc: virtio-fs@redhat.com

* Daniel Walsh (dwalsh@redhat.com) wrote:
> On 2/18/20 1:29 PM, Daniel Walsh wrote:
> > On 2/18/20 8:38 AM, Stefan Hajnoczi wrote:
> >> On Fri, Feb 14, 2020 at 07:41:30PM +0000, Dr. David Alan Gilbert wrote:
> >>> * Vivek Goyal (vgoyal@redhat.com) wrote:
> >>>> Hi,
> >>>>
> >>>> Dan Walsh and Mrunal mentioned that one virtiofsd daemon per exported
> >>>> directory requirement sounds excessive. For container use case, they=
 have
> >>>> atleast 2-3 more directories they need to export (secrets and /etc/h=
ost). And
> >>>> that means 3-4 virtiofsd running for each kata container.=20
> >>>>
> >>>> One option seems that bind mount all exports in one directory and ex=
port
> >>>> that directory using one virtiofsd. I am aware of atleast one problem
> >>>> with that configuraiton and that is possibility of inode number coll=
ision
> >>>> if bind mounts are coming from different devices. Not sure how many
> >>>> applications care though. Sergio is looking into solving this issue.=
 It
> >>>> might take a while though.
> >>> I thought the bind mount setup was the normal setup seen under both K=
ata
> >>> and k8s?
> >> Kata Containers works as follows:
> >>
> >> kata-runtime manages a bind mount directory for each sandbox VM (k8s
> >> pod) in /run/kata-containers/shared/sandboxes/$VM_ID.
> >>
> >> That directory contains the bind-mounted rootfs as well as resolv.conf
> >> and other per-container files.
> >>
> >> When volumes (podman run --volume) are present they are also
> >> bind-mounted alongside the rootfs.
> >>
> >> So kata-runtime ends up with something like this:
> >>
> >>   /run/kata-containers/shared/sandboxes/
> >>   ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385/
> >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385/
> >>           ... rootfs/
> >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-04b134d40c6255cf-hostname
> >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-62cff51b641310e5-resolv.conf
> >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-b8dedcdf0c623c40-hosts
> >>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-d181eeeb4171c3c5-myvolume/
> >>
> >> Only one virtio-fs device is used per sandbox VM.
> >>
> >> Stefan
> >>
> >> _______________________________________________
> >> Virtio-fs mailing list
> >> Virtio-fs@redhat.com
> >> https://www.redhat.com/mailman/listinfo/virtio-fs
> >
> > Also what happens if some of the volumes are mounted as read/only?=A0
> > What kind of error does the container process get when it attempts to
> > write to the volume?
> >
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
>=20
> Also need to think about the volume being mounted as noexec, nodev,
> nosuid,=A0 Does the kernel inside of the container handle this correctly?

I'd need to check, but I *think* you'll get the error propagated
directly from the errno that the daemon sees; i.e. you'll probably
get the ro-fs error when trying to write the file on the mount that's
ro.

I'm expecting it to behave like FUSE, since it's mostly the transport
level that's changed.

Dave




> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

