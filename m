DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
	s=selector2;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=2tUvsKt722yN2Il69KSTSLryUhhV+dq6WnzAEJFFO0w=;
	b=sv+bri00VGKcGRFF2kvKQBdUxuolSm0boJR75RUthFddaLW88DFPICrQu93RkO3uz14MxP4p0N/iJHt3RZveC3/yARr5/FP4X4AMCjJIl3KdqFa9+1jLW70Nq4D9QkdmQnM2WrKW5tUhKgfoR3MbF/SMLmGPkyuKARoK4QsVrR1tND8PVPbbxdxkPjC+IM2z1UbLyHFRwBkaFJyIqFngJwBIyhZc2UMs1JRw5g3RexI8syZX80fB3v4aS+Xc+iqQ7QRfmMpRVf9ctF3nFCp2cqM/CEs4PLQdpVUEqj+DHlNJ6ChoPRscd3XTKqV4sQwZ0q5CDLCL0LGOFmFqDWmsuA==
From: Edward McClanahan <emcclanahan@nvidia.com>
Date: Fri, 7 May 2021 21:14:54 +0000
Message-ID: <BY5PR12MB3809FCC8174D1FF664762209C5579@BY5PR12MB3809.namprd12.prod.outlook.com>
References: <20210507185909.GA40951@redhat.com>
In-Reply-To: <20210507185909.GA40951@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR12MB3809FCC8174D1FF664762209C5579BY5PR12MB3809namp_"
Subject: Re: [Virtio-fs] Few queries about virtiofsd read implementation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

--_000_BY5PR12MB3809FCC8174D1FF664762209C5579BY5PR12MB3809namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I concur... Client usermode code is required to deal with ret < requested l=
ength... In this case, the requested length being the sum of the lengths of=
 each iov segment.

There are two cases where this can occure:
1) the offset+Len > file size, and
2) the process intercepted an EINTR before all requested data became availa=
ble

For file systems, we don't deal with #2...but we .just deal with #1.

Get Outlook for Android<https://aka.ms/AAb9ysg>
________________________________
From: virtio-fs-bounces@redhat.com <virtio-fs-bounces@redhat.com> on behalf=
 of Vivek Goyal <vgoyal@redhat.com>
Sent: Friday, May 7, 2021 1:59:09 PM
To: Dr. David Alan Gilbert <dgilbert@redhat.com>; Stefan Hajnoczi <stefanha=
@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>
Subject: [Virtio-fs] Few queries about virtiofsd read implementation

External email: Use caution opening links or attachments


Hi David/Stefan,

I am browsing through the code of read requests (FUSE_READ) in virtiofsd
(and in virtiofs) and I have few questions. You folks probably know the
answers.

1. virtio_send_data_iov(), reads the data from file into the scatter list.
  Some of the code looks strange.

  We seem to be retrying read if we read less number of bytes than what
  client asked for. I am wondering shoudl this really be our
  responsibility or client should deal with it. I am assuming that client
  should be ready to deal with less number of bytes read.

  So what was the thought process behind retrying.

          if (ret < len && ret) {
            fuse_log(FUSE_LOG_DEBUG, "%s: ret < len\n", __func__);
            /* Skip over this much next time around */
            skip_size =3D ret;
            buf->buf[0].pos +=3D ret;
            len -=3D ret;

            /* Lets do another read */
            continue;
        }

- After this we have code where if number of bytes read are not same
  as we expect to, then we return EIO.

          if (ret !=3D len) {
            fuse_log(FUSE_LOG_DEBUG, "%s: ret!=3Dlen\n", __func__);
            ret =3D EIO;
            free(in_sg_cpy);
            goto err;
        }

  When do we hit this. IIUC, preadv() will return.

  A. Either number of bytes we expected (no issues)
  B. 0 in case of EOF (We break out of loop and just return to client with
                      number of bytes we have read so far).
  C. <0 (This is error case and we return error to client)
  D. X bytes which is less than len.

To handle D we have code to retry. So when do we hit the above if
condition where "ret !=3Dlen). Is this a dead code. Or I missed something.

2. When client sent FUSE_READ, we put pointer to pages into sglist. IIUC,
   we put pointer to "struct page *" and not actual page. So who converts
   these struct page pointer to memory belong to page.

   sg_init_fuse_pages() {
        sg_set_page(&sg[i], pages[i], this_len, page_descs[i].offset);
   }

3. Who converts guest memory address (when) into qemu process address which=
 is
   accessible by virtiofsd.

Thanks
Vivek

_______________________________________________
Virtio-fs mailing list
Virtio-fs@redhat.com
https://listman.redhat.com/mailman/listinfo/virtio-fs


--_000_BY5PR12MB3809FCC8174D1FF664762209C5579BY5PR12MB3809namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div style=3D"color: rgb(33, 33, 33); background-color: rgb(255, 255, 255);=
" dir=3D"auto">
I concur... Client usermode code is required to deal with ret &lt; requeste=
d length... In this case, the requested length being the sum of the lengths=
 of each iov segment.</div>
<div style=3D"color: rgb(33, 33, 33); background-color: rgb(255, 255, 255);=
" dir=3D"auto">
<br>
</div>
<div style=3D"color: rgb(33, 33, 33); background-color: rgb(255, 255, 255);=
" dir=3D"auto">
There are two cases where this can occure:</div>
<div style=3D"color: rgb(33, 33, 33); background-color: rgb(255, 255, 255);=
" dir=3D"auto">
1) the offset+Len &gt; file size, and</div>
<div style=3D"color: rgb(33, 33, 33); background-color: rgb(255, 255, 255);=
" dir=3D"auto">
2) the process intercepted an EINTR before all requested data became availa=
ble</div>
<div style=3D"color: rgb(33, 33, 33); background-color: rgb(255, 255, 255);=
" dir=3D"auto">
<br>
</div>
<div style=3D"color: rgb(33, 33, 33); background-color: rgb(255, 255, 255);=
" dir=3D"auto">
For file systems, we don't deal with #2...but we .just deal with #1.</div>
<div id=3D"ms-outlook-mobile-signature">
<div><br>
</div>
Get <a href=3D"https://aka.ms/AAb9ysg">Outlook for Android</a></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> virtio-fs-bounces@red=
hat.com &lt;virtio-fs-bounces@redhat.com&gt; on behalf of Vivek Goyal &lt;v=
goyal@redhat.com&gt;<br>
<b>Sent:</b> Friday, May 7, 2021 1:59:09 PM<br>
<b>To:</b> Dr. David Alan Gilbert &lt;dgilbert@redhat.com&gt;; Stefan Hajno=
czi &lt;stefanha@redhat.com&gt;<br>
<b>Cc:</b> virtio-fs-list &lt;virtio-fs@redhat.com&gt;<br>
<b>Subject:</b> [Virtio-fs] Few queries about virtiofsd read implementation=
</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">External email: Use caution opening links or attac=
hments<br>
<br>
<br>
Hi David/Stefan,<br>
<br>
I am browsing through the code of read requests (FUSE_READ) in virtiofsd<br=
>
(and in virtiofs) and I have few questions. You folks probably know the<br>
answers.<br>
<br>
1. virtio_send_data_iov(), reads the data from file into the scatter list.<=
br>
&nbsp; Some of the code looks strange.<br>
<br>
&nbsp; We seem to be retrying read if we read less number of bytes than wha=
t<br>
&nbsp; client asked for. I am wondering shoudl this really be our<br>
&nbsp; responsibility or client should deal with it. I am assuming that cli=
ent<br>
&nbsp; should be ready to deal with less number of bytes read.<br>
<br>
&nbsp; So what was the thought process behind retrying.<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ret &lt; len &am=
p;&amp; ret) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fuse_log=
(FUSE_LOG_DEBUG, &quot;%s: ret &lt; len\n&quot;, __func__);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Skip =
over this much next time around */<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; skip_siz=
e =3D ret;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; buf-&gt;=
buf[0].pos +=3D ret;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; len -=3D=
 ret;<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Lets =
do another read */<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue=
;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
<br>
- After this we have code where if number of bytes read are not same<br>
&nbsp; as we expect to, then we return EIO.<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ret !=3D len) {<=
br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fuse_log=
(FUSE_LOG_DEBUG, &quot;%s: ret!=3Dlen\n&quot;, __func__);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D =
EIO;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free(in_=
sg_cpy);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto err=
;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp; When do we hit this. IIUC, preadv() will return.<br>
<br>
&nbsp; A. Either number of bytes we expected (no issues)<br>
&nbsp; B. 0 in case of EOF (We break out of loop and just return to client =
with<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; number of bytes we have=
 read so far).<br>
&nbsp; C. &lt;0 (This is error case and we return error to client)<br>
&nbsp; D. X bytes which is less than len.<br>
<br>
To handle D we have code to retry. So when do we hit the above if<br>
condition where &quot;ret !=3Dlen). Is this a dead code. Or I missed someth=
ing.<br>
<br>
2. When client sent FUSE_READ, we put pointer to pages into sglist. IIUC,<b=
r>
&nbsp;&nbsp; we put pointer to &quot;struct page *&quot; and not actual pag=
e. So who converts<br>
&nbsp;&nbsp; these struct page pointer to memory belong to page.<br>
<br>
&nbsp;&nbsp; sg_init_fuse_pages() {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sg_set_page(&amp;sg[i], pages[i]=
, this_len, page_descs[i].offset);<br>
&nbsp;&nbsp; }<br>
<br>
3. Who converts guest memory address (when) into qemu process address which=
 is<br>
&nbsp;&nbsp; accessible by virtiofsd.<br>
<br>
Thanks<br>
Vivek<br>
<br>
_______________________________________________<br>
Virtio-fs mailing list<br>
Virtio-fs@redhat.com<br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs">https://l=
istman.redhat.com/mailman/listinfo/virtio-fs</a><br>
<br>
</div>
</span></font></div>
</body>
</html>

--_000_BY5PR12MB3809FCC8174D1FF664762209C5579BY5PR12MB3809namp_--

