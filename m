References: <20200214192705.GE18654@redhat.com> <20200214194130.GP3283@work-vm>
	<20200218133821.GE786556@stefanha-x1.localdomain>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <82515f28-bcc6-3940-fc78-7ce28d688405@redhat.com>
Date: Tue, 18 Feb 2020 13:28:22 -0500
MIME-Version: 1.0
In-Reply-To: <20200218133821.GE786556@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="aDQTOFokC6QGeYe77sA7kEOCUk28g3m4L"
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
--aDQTOFokC6QGeYe77sA7kEOCUk28g3m4L
Content-Type: multipart/mixed; boundary="ePTf706ZIfdCAioI8qSsFDQSzpYL9JNUI"

--ePTf706ZIfdCAioI8qSsFDQSzpYL9JNUI
Content-Type: multipart/alternative;
	boundary="------------54C91C20927DCBD6575568EF"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------54C91C20927DCBD6575568EF
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

Great, other then the potential for duplicate inodes, that is perfect.


--------------54C91C20927DCBD6575568EF
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
    <p>Great, other then the potential for duplicate inodes, that is
      perfect.<br>
    </p>
  </body>
</html>

--------------54C91C20927DCBD6575568EF--

--ePTf706ZIfdCAioI8qSsFDQSzpYL9JNUI--

--aDQTOFokC6QGeYe77sA7kEOCUk28g3m4L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE+re/ImQyQPB/0p5rot+QHaviwCgFAl5MLMYACgkQot+QHavi
wChmDAf/dLmI73D2Xk5VxWGe419NTl+wdbd7TYnHVrTbqBV+7uyCD7kCGKIrIk7y
xlnyADhcoA8moboL9dxkvgRsVXAIh1Kawh4r3vxNT+GDd0vArz9Y5HUIygeqV8AR
XrjZbUVbSxL6XKw3kT9w6/XgB5murZLtz6nZ8u8SlqytHwmd8S/bE3T2RqiYXpPJ
V0VMmMkeuaQ55qadv9Sqb8pySyRK6YhldIsUEQFlB5n34sbUWf9+5x3COJgv5pch
fZP0/YIm+McC3fF4bT9ZZ4Fya04bNQDpxBmQe0dFwFd75Ov2NuUQ9uc5HZnexTLQ
kFbGZItqbjGF7ROckmal9pJDGpvLHA==
=2oHq
-----END PGP SIGNATURE-----

--aDQTOFokC6QGeYe77sA7kEOCUk28g3m4L--

