MIME-Version: 1.0
References: <CAJh=p+7fvS5ZJh0wK16yN1VHbKfX=1ZFfPjEx9hZpcg5hvAamw@mail.gmail.com>
In-Reply-To: <CAJh=p+7fvS5ZJh0wK16yN1VHbKfX=1ZFfPjEx9hZpcg5hvAamw@mail.gmail.com>
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 15 Dec 2021 15:15:15 +0100
Message-ID: <CAJh=p+7nfXJFJ2a+UR58nU3+iP0by_k=Xzi64Gagay3Q154tcQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000798ea905d32ff134"
Subject: Re: [Virtio-fs] [virtiofsd-rs] user namespace progress report
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

--000000000000798ea905d32ff134
Content-Type: text/plain; charset="UTF-8"

I forget to mention that I tested it with selinux disabled for both the
host and the guest.
But, I plan to test it with selinux enabled.

Just a quick summary of how to run it:

With /etc/subuid and /etc/subgid
german:100000:65536

$ podman unshare -- <virtiofsd-rs_path>/target/debug/virtiofsd-rs
--socket-path /tmp/vfsdsock --shared-dir shared/  --sandbox none &

(this is just to check the g|uid map)
$ nsenter -U -t $(pidof virtiofsd-rs)
# cat /proc/self/uid_map
         0       1000          1
         1     100000      65536

'podman unshare' always maps the user to "root" and any range which
match the user in /etc/subuid and /etc/subgid.
You can get the same result with unshare, newuidmap and newgidmap

0$ unshare -U
0$ $$
bash: 17816: command not found...

(in a different terminal)
1$ newuidmap 17816 0 1000 1
1$ newgidmap 17816 0 1000 1
1$ newuidmap 17816 1 100000 65536
1$ newgidmap 17816 1 100000 65536

(now in the first terminal)
0$ <virtiofsd-rs_path>/target/debug/virtiofsd-rs --socket-path
/tmp/vfsdsock --shared-dir shared/  --sandbox none &

We _must_ run virtiofsd-rs after making the uid/gid mapping.

In both cases, when the guest-root creates a file in the shared directory,
the real uid will be 1000 (for the uid 1 -> 100000, and so on)

With lxc-usernsexec it's a bit different, we could leave the user (german
in this case)
outside the mapping:

$ lxc-usernsexec -m b:0:100000:65536 --
<virtiofsd-rs_path>/target/debug/virtiofsd-rs --socket-path /tmp/vfsdsock
--shared-dir shared/  --sandbox none &

$ nsenter -U -t $(pidof virtiofsd-rs)
# cat /proc/self/uid_map
         0     100000      65536

Now, the guest-root will be the uid 100000.

Or if we want the same behavior that 'podman unshare'
$ lxc-usernsexec -m b:0:1000:1 -m b:1:100000:65536 --
<virtiofsd-rs_path>/target/debug/virtiofsd-rs --socket-path /tmp/vfsdsock
--shared-dir shared/  --sandbox none &

We could also select '--sandbox chroot'

Cheers,



On Wed, Dec 15, 2021 at 11:54 AM German Maglione <gmaglione@redhat.com>
wrote:

> Hi,
>
> I have been performing several tests to see if it is possible to run the
> virtiofs-rs daemon inside a user namespace. It works with both 'none' and
> 'chroot' sandbox modes. But, file handles don't work.
>
> I tested it using 'unshare', 'podman unshare' and 'lxc-usernsexec'
> (the lxc one give us more flexibility when mapping [g|u]ids)
>
> I also ran pjdfstests and only tests that run 'mknod' fails(*), expected
> when
> executed as a non-privileged user.
> (*) I've not finished checking all failed test.
>
> Next step is to get it to run in libvirt session mode.
>
> Cheers,
>
> --
> German
>


-- 
German

--000000000000798ea905d32ff134
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I forget to mention that I tested it with selinux dis=
abled for both the host and the guest.</div><div> But, I plan to test it wi=
th selinux enabled.</div><div><br></div><div>Just a quick summary of how to=
 run it:</div><div><br></div><div>With /etc/subuid and /etc/subgid</div><di=
v>german:100000:65536</div><div><br></div><div>$ podman unshare -- &lt;virt=
iofsd-rs_path&gt;/target/debug/virtiofsd-rs --socket-path /tmp/vfsdsock --s=
hared-dir shared/=C2=A0 --sandbox none &amp;</div><div><br></div><div>(this=
 is just to check the g|uid map)<br></div><div>$ nsenter -U -t $(pidof virt=
iofsd-rs)</div><div># cat /proc/self/uid_map <br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 1000 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01<b=
r>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 100000 =C2=A0 =C2=A0 =
=C2=A065536</div><div></div><div><br></div><div>&#39;podman unshare&#39; al=
ways maps the user to &quot;root&quot; and any range which</div><div> match=
 the user in /etc/subuid and /etc/subgid.</div><div>You can get the same re=
sult with unshare, newuidmap and newgidmap</div><div><br></div><div>0$ unsh=
are -U</div><div>0$ $$</div><div>bash: 17816: command not found...</div><di=
v><br></div><div>(in a different terminal)</div><div>1$ newuidmap 17816 0 1=
000 1</div><div>1$ newgidmap 17816 0 1000 1</div><div><div>1$ newuidmap 178=
16 1 100000 65536</div><div>1$ newgidmap 17816 1 100000 65536</div><div><br=
></div><div>(now in the first terminal)</div><div>0$ &lt;virtiofsd-rs_path&=
gt;/target/debug/virtiofsd-rs --socket-path /tmp/vfsdsock --shared-dir shar=
ed/=C2=A0 --sandbox none &amp;</div><div><br></div><div>We _must_ run virti=
ofsd-rs after making the uid/gid mapping.<br></div><div><br></div><div>In b=
oth cases, when the guest-root creates a file in the shared directory, the =
real uid will be 1000 (for the uid 1 -&gt; 100000, and so on)<br></div><div=
></div><div><br></div><div>With lxc-usernsexec it&#39;s a bit different, we=
 could leave the user (german in this case)</div><div> outside the mapping:=
</div><div><br></div><div>$ lxc-usernsexec -m b:0:100000:65536 -- &lt;virti=
ofsd-rs_path&gt;/target/debug/virtiofsd-rs --socket-path /tmp/vfsdsock --sh=
ared-dir shared/=C2=A0 --sandbox none &amp;</div></div><div><br></div><div>=
$ nsenter -U -t $(pidof virtiofsd-rs)</div><div><div># cat /proc/self/uid_m=
ap <br>=C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 0 =C2=A0 =C2=A0 100000 =C2=A0 =C2=
=A0 =C2=A065536</div><div><br></div><div>Now, the guest-root will be the ui=
d 100000. <br></div><div><br></div><div>Or if we want the same behavior tha=
t &#39;podman unshare&#39;</div><div>$ lxc-usernsexec -m b:0:1000:1 -m b:1:=
100000:65536 -- &lt;virtiofsd-rs_path&gt;/target/debug/virtiofsd-rs --socke=
t-path /tmp/vfsdsock --shared-dir shared/=C2=A0 --sandbox none &amp;</div><=
div><br></div></div><div>We could also select &#39;--sandbox chroot&#39;</d=
iv><div><br></div><div>Cheers,</div><div><br></div><div><br></div></div><br=
><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, D=
ec 15, 2021 at 11:54 AM German Maglione &lt;<a href=3D"mailto:gmaglione@red=
hat.com" target=3D"_blank">gmaglione@redhat.com</a>&gt; wrote:<br></div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr">Hi,<br><br>=
I have been performing several tests to see if it is possible to run the<br=
>virtiofs-rs daemon inside a user namespace. It works with both &#39;none&#=
39; and<br>&#39;chroot&#39; sandbox modes. But, file handles don&#39;t work=
.<br><br>I tested it using &#39;unshare&#39;, &#39;podman unshare&#39; and =
&#39;lxc-usernsexec&#39;<br>(the lxc one give us more flexibility when mapp=
ing [g|u]ids)<br><br>I also ran pjdfstests and only tests that run &#39;mkn=
od&#39; fails(*), expected when<br>executed as a non-privileged user.<br>(*=
) I&#39;ve not finished checking all failed test.<br><br>Next step is to ge=
t it to run in libvirt session mode.<br><br>Cheers,<br clear=3D"all"><br>--=
 <br><div dir=3D"ltr"><div dir=3D"ltr">German<br></div></div></div>
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr"><div dir=
=3D"ltr">German<br></div></div>

--000000000000798ea905d32ff134--

