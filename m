References: <20200214192705.GE18654@redhat.com> <20200214194130.GP3283@work-vm>
	<20200218133821.GE786556@stefanha-x1.localdomain>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <a3880c0b-32b2-0197-822c-d78fcbfe177c@redhat.com>
Date: Tue, 18 Feb 2020 13:29:20 -0500
MIME-Version: 1.0
In-Reply-To: <20200218133821.GE786556@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ppLPUrenIc1RXB7sediKwkujSHjffcTwN"
Subject: Re: [Virtio-fs] One virtiofs daemon per exported dir requirement
Reply-To: dwalsh@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ppLPUrenIc1RXB7sediKwkujSHjffcTwN
Content-Type: multipart/mixed; boundary="wlIKDCmalsZ63qqLblA6uSGGOGBereOoz"

--wlIKDCmalsZ63qqLblA6uSGGOGBereOoz
Content-Type: multipart/alternative;
	boundary="------------CF4768AB4A0756E8375CEA87"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CF4768AB4A0756E8375CEA87
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/18/20 8:38 AM, Stefan Hajnoczi wrote:
> On Fri, Feb 14, 2020 at 07:41:30PM +0000, Dr. David Alan Gilbert wrote:=

>> * Vivek Goyal (vgoyal@redhat.com) wrote:
>>> Hi,
>>>
>>> Dan Walsh and Mrunal mentioned that one virtiofsd daemon per exported=

>>> directory requirement sounds excessive. For container use case, they =
have
>>> atleast 2-3 more directories they need to export (secrets and /etc/ho=
st). And
>>> that means 3-4 virtiofsd running for each kata container.=20
>>>
>>> One option seems that bind mount all exports in one directory and exp=
ort
>>> that directory using one virtiofsd. I am aware of atleast one problem=

>>> with that configuraiton and that is possibility of inode number colli=
sion
>>> if bind mounts are coming from different devices. Not sure how many
>>> applications care though. Sergio is looking into solving this issue. =
It
>>> might take a while though.
>> I thought the bind mount setup was the normal setup seen under both Ka=
ta
>> and k8s?
> Kata Containers works as follows:
>
> kata-runtime manages a bind mount directory for each sandbox VM (k8s
> pod) in /run/kata-containers/shared/sandboxes/$VM_ID.
>
> That directory contains the bind-mounted rootfs as well as resolv.conf
> and other per-container files.
>
> When volumes (podman run --volume) are present they are also
> bind-mounted alongside the rootfs.
>
> So kata-runtime ends up with something like this:
>
>   /run/kata-containers/shared/sandboxes/
>   ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385/=

>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268=
385/
>           ... rootfs/
>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268=
385-04b134d40c6255cf-hostname
>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268=
385-62cff51b641310e5-resolv.conf
>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268=
385-b8dedcdf0c623c40-hosts
>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268=
385-d181eeeb4171c3c5-myvolume/
>
> Only one virtio-fs device is used per sandbox VM.
>
> Stefan
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

Also what happens if some of the volumes are mounted as read/only?=A0 Wha=
t
kind of error does the container process get when it attempts to write
to the volume?


--------------CF4768AB4A0756E8375CEA87
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html;
      charset=3Dwindows-1252">
  </head>
  <body>
    <div class=3D"moz-cite-prefix">On 2/18/20 8:38 AM, Stefan Hajnoczi
      wrote:<br>
    </div>
    <blockquote type=3D"cite"
      cite=3D"mid:20200218133821.GE786556@stefanha-x1.localdomain">
      <pre class=3D"moz-quote-pre" wrap=3D"">On Fri, Feb 14, 2020 at 07:4=
1:30PM +0000, Dr. David Alan Gilbert wrote:
</pre>
      <blockquote type=3D"cite">
        <pre class=3D"moz-quote-pre" wrap=3D"">* Vivek Goyal (<a class=3D=
"moz-txt-link-abbreviated" href=3D"mailto:vgoyal@redhat.com">vgoyal@redha=
t.com</a>) wrote:
</pre>
        <blockquote type=3D"cite">
          <pre class=3D"moz-quote-pre" wrap=3D"">Hi,

Dan Walsh and Mrunal mentioned that one virtiofsd daemon per exported
directory requirement sounds excessive. For container use case, they have=

atleast 2-3 more directories they need to export (secrets and /etc/host).=
 And
that means 3-4 virtiofsd running for each kata container.=20

One option seems that bind mount all exports in one directory and export
that directory using one virtiofsd. I am aware of atleast one problem
with that configuraiton and that is possibility of inode number collision=

if bind mounts are coming from different devices. Not sure how many
applications care though. Sergio is looking into solving this issue. It
might take a while though.
</pre>
        </blockquote>
        <pre class=3D"moz-quote-pre" wrap=3D"">
I thought the bind mount setup was the normal setup seen under both Kata
and k8s?
</pre>
      </blockquote>
      <pre class=3D"moz-quote-pre" wrap=3D"">
Kata Containers works as follows:

kata-runtime manages a bind mount directory for each sandbox VM (k8s
pod) in /run/kata-containers/shared/sandboxes/$VM_ID.

That directory contains the bind-mounted rootfs as well as resolv.conf
and other per-container files.

When volumes (podman run --volume) are present they are also
bind-mounted alongside the rootfs.

So kata-runtime ends up with something like this:

  /run/kata-containers/shared/sandboxes/
  ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385/
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026838=
5/
          ... rootfs/
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026838=
5-04b134d40c6255cf-hostname
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026838=
5-62cff51b641310e5-resolv.conf
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026838=
5-b8dedcdf0c623c40-hosts
      ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026838=
5-d181eeeb4171c3c5-myvolume/

Only one virtio-fs device is used per sandbox VM.

Stefan
</pre>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <pre class=3D"moz-quote-pre" wrap=3D"">____________________________=
___________________
Virtio-fs mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:Virtio-fs@redhat.com=
">Virtio-fs@redhat.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.redhat.com/mailman=
/listinfo/virtio-fs">https://www.redhat.com/mailman/listinfo/virtio-fs</a=
>
</pre>
    </blockquote>
    <p>Also what happens if some of the volumes are mounted as
      read/only?=A0 What kind of error does the container process get whe=
n
      it attempts to write to the volume?<br>
    </p>
  </body>
</html>

--------------CF4768AB4A0756E8375CEA87--

--wlIKDCmalsZ63qqLblA6uSGGOGBereOoz--

--ppLPUrenIc1RXB7sediKwkujSHjffcTwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE+re/ImQyQPB/0p5rot+QHaviwCgFAl5MLQAACgkQot+QHavi
wCghRQf+Iesokzg03tf92Mnds1Yji4YStiN+stPjK1tZj/2WHs28HJ/2vCp7JP8q
TX5VxWtwJPbqQgFOD4scRT22ROkjhgxm2LcOhph6iZBxshWJJBQTv5KU7QqkfiWs
6qM4PbeqIUIY3BxDZoN4WPLnEDlwHZotjv86+fL8kkFSq/++/DJ+vu/dDDQAP/eU
nk8aYH3ChZOJqrXwf6V3lhgH55Yf1F0bmCEaDF2ZqmwO1q2xU1redMpGfLF/mINL
tvBvrhA4oEMQezNSDkFyAdykvTXEwgiCz8YYxLS2+YoX02b2HQUoCHACjdSKhRZD
TcDBftf7ga2e3trNbSL7iU11s9YVxQ==
=07pU
-----END PGP SIGNATURE-----

--ppLPUrenIc1RXB7sediKwkujSHjffcTwN--

