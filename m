Date: Mon, 8 Jun 2020 09:35:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200608133506.GB170885@redhat.com>
References: <CALfysxrU1WNcWhzRUXboMSjZLsOz_J=BC1y_heye8juk+L-fSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CALfysxrU1WNcWhzRUXboMSjZLsOz_J=BC1y_heye8juk+L-fSA@mail.gmail.com>
Subject: Re: [Virtio-fs] How to setup virtiofs for file sharing between host
 and VM
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Boris Ebwanga <bbebwanga@gmail.com>
Cc: virtio-fs@redhat.com

On Fri, Jun 05, 2020 at 11:50:06AM +0100, Boris Ebwanga wrote:
> Hello everyone.
>=20
> It's been a while now, I am trying to use virtio-fs. Everything I do end =
up
> with an error.
>=20
> First I was on fedora 31 and I tried to run manually qemu with virtio-fs
> https://virtio-fs.gitlab.io/howto-qemu.html. But I was not able to "make
> virtiofsd".
>=20
> Then, I upgraded to fedora 32 which has virtiofsd at /usr/libexec. I
> followed the steps describe at
> https://libvirt.org/kbase/virtiofs.html
> I could not modify the XML domain of my VM. The error message is "*unsupp=
orted
> configuration: unknown fs virtiofs =BB driver type".*

Hi Boris,

Ccing Jan Tomko. He might have toughts on this.


>=20
> I wrote to Stefan Hajnoczi <stefanha@redhat.com> describing this problem.
> He answers with the following:
>=20
> Hi Boris,
> > You can pass command-line options to the guest like this:
> >
> >   <domain type=3D'kvm' xmlns:qemu=3D'
> > http://libvirt.org/schemas/domain/qemu/1.0'>
> >     ...
> >     <qemu:commandline>
> >       <qemu:arg value=3D'-chardev'/>
> >       <qemu:arg value=3D'socket,id=3Dchar0,path=3D/tmp/vhost-fs.sock'/>
> >       <qemu:arg value=3D'-device'/>
> >       <qemu:arg
> > value=3D'vhost-user-fs-pci,chardev=3Dvirtio-fs-chardev,tag=3Dmyfs'/>
> >     </qemu:commandline>
> >   </domain>
> >
> > Note that the xmlns in the <domain> tag is required.
> >
> > If you pass these options manually then you need to launch virtiofsd
> > yourself before launching the guest:
> >
> >   # /usr/libexec/virtiofsd --socket-path=3D/tmp/vhost-fs.sock -o
> > source=3D/path/to/share/dir -o no_posix_lock -o xattr
> >
> > Hope this helps! Please email virtio-fs@redhat.com if you have any more
> > questions, it's the virtio-fs mailing list and others will be able to
> > participate in the discussion.
> >
>=20
> I am still getting the same error after applying the change above.
>=20
> Can anyone help me with this ? Thank you in advance for your help.

Can you attach your domain xml file here.

I think you also will need to add following in <qemu:commandline> section.


    <qemu:arg value=3D'-object'/>
    <qemu:arg value=3D'memory-backend-file,id=3Dmem,size=3D8G,mem-path=3D/d=
ev/shm,share=3Don'/>
    <qemu:arg value=3D'-numa'/>
    <qemu:arg value=3D'node,memdev=3Dmem'/>

Thanks
Vivek

