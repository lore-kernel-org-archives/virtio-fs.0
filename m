MIME-Version: 1.0
In-Reply-To: <20191213110224.GE1180977@stefanha-x1.localdomain>
From: "Gong Su" <gongsu@us.ibm.com>
Date: Fri, 13 Dec 2019 10:44:13 -0500
References: <OFEFF035BA.8C1142AF-ON002584CE.006405E7-852584CE.0067F3AB@notes.na.collabserv.com>
	<20191213110224.GE1180977@stefanha-x1.localdomain>
Message-Id: <OFD300B2CA.8613FC01-ON002584CF.00557762-852584CF.0056723F@notes.na.collabserv.com>
Content-Type: multipart/related; 
	Boundary="0__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2"
Subject: Re: [Virtio-fs] virtio-fs on zLinux (s390x)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>

--0__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2
Content-type: multipart/alternative; 
	Boundary="1__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2"

--1__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2
Content-Transfer-Encoding: quoted-printable
Content-type: text/plain; charset=WINDOWS-1252


Hi Stefan, I believe s390 does support vhost-user. I can bring up a guest
with virtio-fs specific options:

-chardev socket,id=3Dchar0,path=3D/tmp/vhostqemu  \
-device vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,tag=3Dmyfs \
-object memory-backend-file,id=3Dmem,size=3D8G,mem-path=3D/dev/shm,share=3D=
on

but leave out the -numa option. I can see virtiofsd is getting messages
(with -o debug option) when the guest boots up. But of course if I try to
mount inside the guest nothing happens.



From:=09Stefan Hajnoczi <stefanha@redhat.com>
To:=09Gong Su <gongsu@us.ibm.com>
Cc:=09virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>
Date:=0912/13/2019 06:02 AM
Subject:=09[EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)



On Thu, Dec 12, 2019 at 01:55:25PM -0500, Gong Su wrote:
> Basically, I'm trying to see if I can get virtio-fs to work on zLinux.
> Following the instructions on https://virtio-fs.gitlab.io/howto-qemu.html
I
> was able to compile all the pieces but when I tried to run qemu I
realized
> that it needs -numa option which isn't supported on s390x yet.

Does s390 support vhost-user?

virtio-fs is implemented as a vhost-user device so this is a
requirement.  Shared memory is a vhost-user requirement and that's where
the -numa command-line option dependency comes from.

Stefan
[attachment "signature.asc" deleted by Gong Su/Watson/IBM]


--1__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2
Content-Transfer-Encoding: quoted-printable
Content-type: text/html; charset=WINDOWS-1252
Content-Disposition: inline

<html><body><p><font size=3D"2">Hi Stefan, I believe s390 does support vhos=
t-user. I can bring up a guest with virtio-fs specific options:</font><br><=
br><font size=3D"2">-chardev socket,id=3Dchar0,path=3D/tmp/vhostqemu  \</fo=
nt><br><font size=3D"2">-device vhost-user-fs-pci,queue-size=3D1024,chardev=
=3Dchar0,tag=3Dmyfs \</font><br><font size=3D"2">-object memory-backend-fil=
e,id=3Dmem,size=3D8G,mem-path=3D/dev/shm,share=3Don</font><br><br><font siz=
e=3D"2">but leave out the -numa option. I can see virtiofsd is getting mess=
ages (with -o debug option) when the guest boots up. But of course if I try=
 to mount inside the guest nothing happens.</font><br><br><img width=3D"16"=
 height=3D"16" src=3D"cid:1__=3D8FBB0E5CDFC6F1F28f9e8a93df938690918c8FB@" b=
order=3D"0" alt=3D"Inactive hide details for Stefan Hajnoczi ---12/13/2019 =
06:02:53 AM---On Thu, Dec 12, 2019 at 01:55:25PM -0500, Gong Su wrote: "><f=
ont size=3D"2" color=3D"#424282">Stefan Hajnoczi ---12/13/2019 06:02:53 AM-=
--On Thu, Dec 12, 2019 at 01:55:25PM -0500, Gong Su wrote: &gt; Basically, =
I'm trying to see if I can get</font><br><br><font size=3D"2" color=3D"#5F5=
F5F">From:        </font><font size=3D"2">Stefan Hajnoczi &lt;stefanha@redh=
at.com&gt;</font><br><font size=3D"2" color=3D"#5F5F5F">To:        </font><=
font size=3D"2">Gong Su &lt;gongsu@us.ibm.com&gt;</font><br><font size=3D"2=
" color=3D"#5F5F5F">Cc:        </font><font size=3D"2">virtio-fs@redhat.com=
, Cornelia Huck &lt;cohuck@redhat.com&gt;</font><br><font size=3D"2" color=
=3D"#5F5F5F">Date:        </font><font size=3D"2">12/13/2019 06:02 AM</font=
><br><font size=3D"2" color=3D"#5F5F5F">Subject:        </font><font size=
=3D"2">[EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)</font><br><hr=
 width=3D"100%" size=3D"2" align=3D"left" noshade style=3D"color:#8091A5; "=
><br><br><br><tt><font size=3D"2">On Thu, Dec 12, 2019 at 01:55:25PM -0500,=
 Gong Su wrote:<br>&gt; Basically, I'm trying to see if I can get virtio-fs=
 to work on zLinux.<br>&gt; Following the instructions on </font></tt><tt><=
font size=3D"2"><a href=3D"https://virtio-fs.gitlab.io/howto-qemu.html">htt=
ps://virtio-fs.gitlab.io/howto-qemu.html</a></font></tt><tt><font size=3D"2=
">&nbsp;I<br>&gt; was able to compile all the pieces but when I tried to ru=
n qemu I realized<br>&gt; that it needs -numa option which isn't supported =
on s390x yet.<br><br>Does s390 support vhost-user?<br><br>virtio-fs is impl=
emented as a vhost-user device so this is a<br>requirement. &nbsp;Shared me=
mory is a vhost-user requirement and that's where<br>the -numa command-line=
 option dependency comes from.<br><br>Stefan<br>[attachment &quot;signature=
.asc&quot; deleted by Gong Su/Watson/IBM] </font></tt><br><br><BR>
</body></html>

--1__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2--

--0__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2
Content-type: image/gif; 
	name="graycol.gif"
Content-Disposition: inline; filename="graycol.gif"
Content-ID: <1__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FB@>
Content-Transfer-Encoding: base64

R0lGODlhEAAQAKECAMzMzAAAAP///wAAACH5BAEAAAIALAAAAAAQABAAAAIXlI+py+0PopwxUbpu
ZRfKZ2zgSJbmSRYAIf4fT3B0aW1pemVkIGJ5IFVsZWFkIFNtYXJ0U2F2ZXIhAAA7
--0__=8FBB0E5CDFC6F1F28f9e8a93df938690918c8FBB0E5CDFC6F1F2--

