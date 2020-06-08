Date: Mon, 8 Jun 2020 15:54:50 +0200
From: =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Message-ID: <20200608135450.GA1774718@lpt>
References: <CALfysxrU1WNcWhzRUXboMSjZLsOz_J=BC1y_heye8juk+L-fSA@mail.gmail.com>
	<20200608133506.GB170885@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20200608133506.GB170885@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Boris Ebwanga <bbebwanga@gmail.com>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On a Monday in 2020, Vivek Goyal wrote:
>On Fri, Jun 05, 2020 at 11:50:06AM +0100, Boris Ebwanga wrote:
>> Hello everyone.
>>
>> It's been a while now, I am trying to use virtio-fs. Everything I do end=
 up
>> with an error.
>>
>> First I was on fedora 31 and I tried to run manually qemu with virtio-fs
>> https://virtio-fs.gitlab.io/howto-qemu.html. But I was not able to "make
>> virtiofsd".
>>
>> Then, I upgraded to fedora 32 which has virtiofsd at /usr/libexec. I
>> followed the steps describe at
>> https://libvirt.org/kbase/virtiofs.html
>> I could not modify the XML domain of my VM. The error message is "*unsup=
ported
>> configuration: unknown fs virtiofs =BB driver type".*

That is correct.

libvirt learned about the 'virtiofs' driver type in v6.2.0, Fedora 32
has 6.1.0:
https://apps.fedoraproject.org/packages/libvirt/

You can try enabling the experimental virt-preview repo to get more
recent builds of libvirt, QEMU and other virt packages:
https://fedoraproject.org/wiki/Virtualization_Preview_Repository

>
>Hi Boris,
>
>Ccing Jan Tomko. He might have toughts on this.
>
>
>>
>> I wrote to Stefan Hajnoczi <stefanha@redhat.com> describing this problem.
>> He answers with the following:
>>
>> Hi Boris,
>> > You can pass command-line options to the guest like this:
>> >
>> >   <domain type=3D'kvm' xmlns:qemu=3D'
>> > http://libvirt.org/schemas/domain/qemu/1.0'>
>> >     ...
>> >     <qemu:commandline>
>> >       <qemu:arg value=3D'-chardev'/>
>> >       <qemu:arg value=3D'socket,id=3Dchar0,path=3D/tmp/vhost-fs.sock'/>
>> >       <qemu:arg value=3D'-device'/>
>> >       <qemu:arg
>> > value=3D'vhost-user-fs-pci,chardev=3Dvirtio-fs-chardev,tag=3Dmyfs'/>
>> >     </qemu:commandline>
>> >   </domain>
>> >
>> > Note that the xmlns in the <domain> tag is required.
>> >
>> > If you pass these options manually then you need to launch virtiofsd
>> > yourself before launching the guest:
>> >
>> >   # /usr/libexec/virtiofsd --socket-path=3D/tmp/vhost-fs.sock -o
>> > source=3D/path/to/share/dir -o no_posix_lock -o xattr
>> >
>> > Hope this helps! Please email virtio-fs@redhat.com if you have any more
>> > questions, it's the virtio-fs mailing list and others will be able to
>> > participate in the discussion.
>> >
>>
>> I am still getting the same error after applying the change above.
>>
>> Can anyone help me with this ? Thank you in advance for your help.
>
>Can you attach your domain xml file here.
>
>I think you also will need to add following in <qemu:commandline> section.
>
>
>    <qemu:arg value=3D'-object'/>
>    <qemu:arg value=3D'memory-backend-file,id=3Dmem,size=3D8G,mem-path=3D/=
dev/shm,share=3Don'/>
>    <qemu:arg value=3D'-numa'/>
>    <qemu:arg value=3D'node,memdev=3Dmem'/>
>

Even with libvirt 6.1.0 that does not know virtiofs yet, the shared
memory can be specified as described on https://libvirt.org/kbase/virtiofs.=
html

Jano

>Thanks
>Vivek

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEQeJGMrnL0ADuclbP+YPwO/Mat50FAl7eQyYACgkQ+YPwO/Ma
t52egggAgpqiJsdYOAv62DciW6qX89LXwZzB5g0gbiudReG8vUI2RRw7UljKgWbz
QOC+fCWyjKoQPfNm6LXdGZaMeZiTcRuzO5i9DxhI/vu0LsAZlsklmMr//zZpGXr/
339kQC4mHiB/Oi49XzJwG7SvQNioeA4aaj+k7TTi4RykdUGsvZfrgeL6e69ly4m/
ecGnrTg2ri4kmbdoXQnqoXAkOOxIb/x8wLSiXSmAlewDC22V+NsqXTFDUmntiWdn
h3Scbef/IvnhKQjgC4DKE05YaJVh0Ul5ALfc+IN2J131x4AYJX5ow8/wh34bVMll
C9yyNnYidrEs/hAE9bsX2y227N28UQ==
=5WSV
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--

