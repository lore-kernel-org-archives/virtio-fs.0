DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
	s=selector2;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=XYfnaoyxrAbJJ6v5CuPs7OzV0PB3UIuAJqt3wR63ECc=;
	b=igNrhZw6dlj7osiieGZMdSLFTWcTF1BImIeB+dCoQCwXMxskZ+syWeApCtjdl7owtnIfhjYKluWrOrHv7gCBY4QPf+OlwqhHpZSHjLDaoYez/gyYQkPuIXaZkDbC5+9xZUuYcRi68z6IyjLGq7afNPL40SFaqiFEyRVjxzQ1EVJkZcwkxmi8xKOMk1e4RGeT/XfsMMtcp5R/jzpd+2LqKI+icliTRzc1zVg604XkfP73L6SQe96G83/tKCuYX7fTZ7Ux+KHRnlvPHAKUXs3zHXibkEAkoPnVc6qwXDQFuBFFZIjwsLm6u27hMJXfS5jApOuQyK+4aLf7/BzlLuHVKA==
From: Edward McClanahan <emcclanahan@nvidia.com>
Date: Thu, 6 May 2021 19:11:14 +0000
Message-ID: <BY5PR12MB3809AA7700A873AEF4CCEB9AC5589@BY5PR12MB3809.namprd12.prod.outlook.com>
References: <20210506185641.284821-1-dgilbert@redhat.com>,
	<20210506185641.284821-2-dgilbert@redhat.com>
In-Reply-To: <20210506185641.284821-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR12MB3809AA7700A873AEF4CCEB9AC5589BY5PR12MB3809namp_"
Subject: Re: [Virtio-fs] [PULL 01/12] virtiofsd: Fix side-effect in assert()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "groug@kaod.org" <groug@kaod.org>, "jose.carlos.venegas.munoz@intel.com" <jose.carlos.venegas.munoz@intel.com>, "ma.mandourr@gmail.com" <ma.mandourr@gmail.com>, "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>

--_000_BY5PR12MB3809AA7700A873AEF4CCEB9AC5589BY5PR12MB3809namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Very nice catch David... Countless times I've gotten bit by this one!

Get Outlook for Android<https://aka.ms/AAb9ysg>

________________________________
From: virtio-fs-bounces@redhat.com <virtio-fs-bounces@redhat.com> on behalf=
 of Dr. David Alan Gilbert (git) <dgilbert@redhat.com>
Sent: Thursday, May 6, 2021 1:56:30 PM
To: qemu-devel@nongnu.org <qemu-devel@nongnu.org>; groug@kaod.org <groug@ka=
od.org>; jose.carlos.venegas.munoz@intel.com <jose.carlos.venegas.munoz@int=
el.com>; ma.mandourr@gmail.com <ma.mandourr@gmail.com>
Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>; vgoyal@redhat.com <vgoyal@=
redhat.com>
Subject: [Virtio-fs] [PULL 01/12] virtiofsd: Fix side-effect in assert()

External email: Use caution opening links or attachments


From: Greg Kurz <groug@kaod.org>

It is bad practice to put an expression with a side-effect in
assert() because the side-effect won't happen if the code is
compiled with -DNDEBUG.

Use an intermediate variable. Consolidate this in an macro to
have proper line numbers when the assertion is hit.

virtiofsd: ../../tools/virtiofsd/passthrough_ll.c:2797: lo_getxattr:
 Assertion `fchdir_res =3D=3D 0' failed.
Aborted

  2796          /* fchdir should not fail here */
=3D>2797          FCHDIR_NOFAIL(lo->proc_self_fd);
  2798          ret =3D getxattr(procname, name, value, size);
  2799          FCHDIR_NOFAIL(lo->root.fd);

Fixes: bdfd66788349 ("virtiofsd: Fix xattr operations")
Cc: misono.tomohiro@jp.fujitsu.com
Signed-off-by: Greg Kurz <groug@kaod.org>
Message-Id: <20210409100627.451573-1-groug@kaod.org>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough=
_ll.c
index 1553d2ef45..6592f96f68 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2723,6 +2723,11 @@ static int xattr_map_server(const struct lo_data *lo=
, const char *server_name,
     return -ENODATA;
 }

+#define FCHDIR_NOFAIL(fd) do {                         \
+        int fchdir_res =3D fchdir(fd);                   \
+        assert(fchdir_res =3D=3D 0);                       \
+    } while (0)
+
 static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_nam=
e,
                         size_t size)
 {
@@ -2789,9 +2794,9 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t in=
o, const char *in_name,
         ret =3D fgetxattr(fd, name, value, size);
     } else {
         /* fchdir should not fail here */
-        assert(fchdir(lo->proc_self_fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->proc_self_fd);
         ret =3D getxattr(procname, name, value, size);
-        assert(fchdir(lo->root.fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->root.fd);
     }

     if (ret =3D=3D -1) {
@@ -2864,9 +2869,9 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t i=
no, size_t size)
         ret =3D flistxattr(fd, value, size);
     } else {
         /* fchdir should not fail here */
-        assert(fchdir(lo->proc_self_fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->proc_self_fd);
         ret =3D listxattr(procname, value, size);
-        assert(fchdir(lo->root.fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->root.fd);
     }

     if (ret =3D=3D -1) {
@@ -3000,9 +3005,9 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t in=
o, const char *in_name,
         ret =3D fsetxattr(fd, name, value, size, flags);
     } else {
         /* fchdir should not fail here */
-        assert(fchdir(lo->proc_self_fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->proc_self_fd);
         ret =3D setxattr(procname, name, value, size, flags);
-        assert(fchdir(lo->root.fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->root.fd);
     }

     saverr =3D ret =3D=3D -1 ? errno : 0;
@@ -3066,9 +3071,9 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t=
 ino, const char *in_name)
         ret =3D fremovexattr(fd, name);
     } else {
         /* fchdir should not fail here */
-        assert(fchdir(lo->proc_self_fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->proc_self_fd);
         ret =3D removexattr(procname, name);
-        assert(fchdir(lo->root.fd) =3D=3D 0);
+        FCHDIR_NOFAIL(lo->root.fd);
     }

     saverr =3D ret =3D=3D -1 ? errno : 0;
--
2.31.1

_______________________________________________
Virtio-fs mailing list
Virtio-fs@redhat.com
https://listman.redhat.com/mailman/listinfo/virtio-fs

--_000_BY5PR12MB3809AA7700A873AEF4CCEB9AC5589BY5PR12MB3809namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
</head>
<body>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Very nice catch David... Countless times I've gotten bit by this one!<span =
id=3D"ms-outlook-android-cursor"></span><br>
<br>
</div>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
<span id=3D"OutlookSignature">
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Get <a href=3D"https://aka.ms/AAb9ysg">Outlook for Android</a></div>
</span><br>
</div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> virtio-fs-bounces@red=
hat.com &lt;virtio-fs-bounces@redhat.com&gt; on behalf of Dr. David Alan Gi=
lbert (git) &lt;dgilbert@redhat.com&gt;<br>
<b>Sent:</b> Thursday, May 6, 2021 1:56:30 PM<br>
<b>To:</b> qemu-devel@nongnu.org &lt;qemu-devel@nongnu.org&gt;; groug@kaod.=
org &lt;groug@kaod.org&gt;; jose.carlos.venegas.munoz@intel.com &lt;jose.ca=
rlos.venegas.munoz@intel.com&gt;; ma.mandourr@gmail.com &lt;ma.mandourr@gma=
il.com&gt;<br>
<b>Cc:</b> virtio-fs@redhat.com &lt;virtio-fs@redhat.com&gt;; vgoyal@redhat=
.com &lt;vgoyal@redhat.com&gt;<br>
<b>Subject:</b> [Virtio-fs] [PULL 01/12] virtiofsd: Fix side-effect in asse=
rt()</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">External email: Use caution opening links or attac=
hments<br>
<br>
<br>
From: Greg Kurz &lt;groug@kaod.org&gt;<br>
<br>
It is bad practice to put an expression with a side-effect in<br>
assert() because the side-effect won't happen if the code is<br>
compiled with -DNDEBUG.<br>
<br>
Use an intermediate variable. Consolidate this in an macro to<br>
have proper line numbers when the assertion is hit.<br>
<br>
virtiofsd: ../../tools/virtiofsd/passthrough_ll.c:2797: lo_getxattr:<br>
&nbsp;Assertion `fchdir_res =3D=3D 0' failed.<br>
Aborted<br>
<br>
&nbsp; 2796&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* fchdir=
 should not fail here */<br>
=3D&gt;2797&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NO=
FAIL(lo-&gt;proc_self_fd);<br>
&nbsp; 2798&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D g=
etxattr(procname, name, value, size);<br>
&nbsp; 2799&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NO=
FAIL(lo-&gt;root.fd);<br>
<br>
Fixes: bdfd66788349 (&quot;virtiofsd: Fix xattr operations&quot;)<br>
Cc: misono.tomohiro@jp.fujitsu.com<br>
Signed-off-by: Greg Kurz &lt;groug@kaod.org&gt;<br>
Message-Id: &lt;20210409100627.451573-1-groug@kaod.org&gt;<br>
Signed-off-by: Dr. David Alan Gilbert &lt;dgilbert@redhat.com&gt;<br>
Reviewed-by: Philippe Mathieu-Daud=E9 &lt;philmd@redhat.com&gt;<br>
---<br>
&nbsp;tools/virtiofsd/passthrough_ll.c | 21 +++++++++++++--------<br>
&nbsp;1 file changed, 13 insertions(+), 8 deletions(-)<br>
<br>
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough=
_ll.c<br>
index 1553d2ef45..6592f96f68 100644<br>
--- a/tools/virtiofsd/passthrough_ll.c<br>
+++ b/tools/virtiofsd/passthrough_ll.c<br>
@@ -2723,6 +2723,11 @@ static int xattr_map_server(const struct lo_data *lo=
, const char *server_name,<br>
&nbsp;&nbsp;&nbsp;&nbsp; return -ENODATA;<br>
&nbsp;}<br>
<br>
+#define FCHDIR_NOFAIL(fd) do {&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; \<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int fchdir_res =3D fchdir(fd);&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir_res =3D=3D 0);&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \<br>
+&nbsp;&nbsp;&nbsp; } while (0)<br>
+<br>
&nbsp;static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *i=
n_name,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_=
t size)<br>
&nbsp;{<br>
@@ -2789,9 +2794,9 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t in=
o, const char *in_name,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D fgetxattr(fd, name=
, value, size);<br>
&nbsp;&nbsp;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* fchdir should not fail =
here */<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;proc_self_=
fd) =3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;proc_self_=
fd);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D getxattr(procname,=
 name, value, size);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;root.fd) =
=3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;root.fd);<=
br>
&nbsp;&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp; if (ret =3D=3D -1) {<br>
@@ -2864,9 +2869,9 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t i=
no, size_t size)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D flistxattr(fd, val=
ue, size);<br>
&nbsp;&nbsp;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* fchdir should not fail =
here */<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;proc_self_=
fd) =3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;proc_self_=
fd);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D listxattr(procname=
, value, size);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;root.fd) =
=3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;root.fd);<=
br>
&nbsp;&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp; if (ret =3D=3D -1) {<br>
@@ -3000,9 +3005,9 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t in=
o, const char *in_name,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D fsetxattr(fd, name=
, value, size, flags);<br>
&nbsp;&nbsp;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* fchdir should not fail =
here */<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;proc_self_=
fd) =3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;proc_self_=
fd);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D setxattr(procname,=
 name, value, size, flags);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;root.fd) =
=3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;root.fd);<=
br>
&nbsp;&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp; saverr =3D ret =3D=3D -1 ? errno : 0;<br>
@@ -3066,9 +3071,9 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t=
 ino, const char *in_name)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D fremovexattr(fd, n=
ame);<br>
&nbsp;&nbsp;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* fchdir should not fail =
here */<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;proc_self_=
fd) =3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;proc_self_=
fd);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D removexattr(procna=
me, name);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; assert(fchdir(lo-&gt;root.fd) =
=3D=3D 0);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FCHDIR_NOFAIL(lo-&gt;root.fd);<=
br>
&nbsp;&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp; saverr =3D ret =3D=3D -1 ? errno : 0;<br>
--<br>
2.31.1<br>
<br>
_______________________________________________<br>
Virtio-fs mailing list<br>
Virtio-fs@redhat.com<br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs">https://l=
istman.redhat.com/mailman/listinfo/virtio-fs</a><br>
</div>
</span></font></div>
</body>
</html>

--_000_BY5PR12MB3809AA7700A873AEF4CCEB9AC5589BY5PR12MB3809namp_--

