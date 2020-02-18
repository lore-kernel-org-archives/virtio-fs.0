References: <20200214192705.GE18654@redhat.com> <20200214194130.GP3283@work-vm>
	<20200218133821.GE786556@stefanha-x1.localdomain>
	<a3880c0b-32b2-0197-822c-d78fcbfe177c@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <47f62cf4-5b44-b2f0-52f3-5b889d1c3ac8@redhat.com>
Date: Tue, 18 Feb 2020 13:32:32 -0500
MIME-Version: 1.0
In-Reply-To: <a3880c0b-32b2-0197-822c-d78fcbfe177c@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="noH14dvQOnYCBPle6PL5kKAifj1mvHr60"
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
--noH14dvQOnYCBPle6PL5kKAifj1mvHr60
Content-Type: multipart/mixed; boundary="U5y82qbU4wRK08PsRBqU9Iu5xiVA9E4OO"

--U5y82qbU4wRK08PsRBqU9Iu5xiVA9E4OO
Content-Type: multipart/alternative;
	boundary="------------697C86A58D3DA150DA41C25A"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------697C86A58D3DA150DA41C25A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/18/20 1:29 PM, Daniel Walsh wrote:
> On 2/18/20 8:38 AM, Stefan Hajnoczi wrote:
>> On Fri, Feb 14, 2020 at 07:41:30PM +0000, Dr. David Alan Gilbert wrote=
:
>>> * Vivek Goyal (vgoyal@redhat.com) wrote:
>>>> Hi,
>>>>
>>>> Dan Walsh and Mrunal mentioned that one virtiofsd daemon per exporte=
d
>>>> directory requirement sounds excessive. For container use case, they=
 have
>>>> atleast 2-3 more directories they need to export (secrets and /etc/h=
ost). And
>>>> that means 3-4 virtiofsd running for each kata container.=20
>>>>
>>>> One option seems that bind mount all exports in one directory and ex=
port
>>>> that directory using one virtiofsd. I am aware of atleast one proble=
m
>>>> with that configuraiton and that is possibility of inode number coll=
ision
>>>> if bind mounts are coming from different devices. Not sure how many
>>>> applications care though. Sergio is looking into solving this issue.=
 It
>>>> might take a while though.
>>> I thought the bind mount setup was the normal setup seen under both K=
ata
>>> and k8s?
>> Kata Containers works as follows:
>>
>> kata-runtime manages a bind mount directory for each sandbox VM (k8s
>> pod) in /run/kata-containers/shared/sandboxes/$VM_ID.
>>
>> That directory contains the bind-mounted rootfs as well as resolv.conf=

>> and other per-container files.
>>
>> When volumes (podman run --volume) are present they are also
>> bind-mounted alongside the rootfs.
>>
>> So kata-runtime ends up with something like this:
>>
>>   /run/kata-containers/shared/sandboxes/
>>   ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d9310268385=
/
>>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385/
>>           ... rootfs/
>>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-04b134d40c6255cf-hostname
>>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-62cff51b641310e5-resolv.conf
>>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-b8dedcdf0c623c40-hosts
>>       ... 61c192ae0e7154b6c8ffce6b13c4c5108d6dfe419a508f99ed381d931026=
8385-d181eeeb4171c3c5-myvolume/
>>
>> Only one virtio-fs device is used per sandbox VM.
>>
>> Stefan
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs
>
> Also what happens if some of the volumes are mounted as read/only?=A0
> What kind of error does the container process get when it attempts to
> write to the volume?
>
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

Also need to think about the volume being mounted as noexec, nodev,
nosuid,=A0 Does the kernel inside of the container handle this correctly?=



--------------697C86A58D3DA150DA41C25A
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html;
      charset=3Dwindows-1252">
  </head>
  <body>
    <div class=3D"moz-cite-prefix">On 2/18/20 1:29 PM, Daniel Walsh wrote=
:<br>
    </div>
    <blockquote type=3D"cite"
      cite=3D"mid:a3880c0b-32b2-0197-822c-d78fcbfe177c@redhat.com">
      <meta http-equiv=3D"Content-Type" content=3D"text/html;
        charset=3Dwindows-1252">
      <div class=3D"moz-cite-prefix">On 2/18/20 8:38 AM, Stefan Hajnoczi
        wrote:<br>
      </div>
      <blockquote type=3D"cite"
        cite=3D"mid:20200218133821.GE786556@stefanha-x1.localdomain">
        <pre class=3D"moz-quote-pre" wrap=3D"">On Fri, Feb 14, 2020 at 07=
:41:30PM +0000, Dr. David Alan Gilbert wrote:
</pre>
        <blockquote type=3D"cite">
          <pre class=3D"moz-quote-pre" wrap=3D"">* Vivek Goyal (<a class=3D=
"moz-txt-link-abbreviated" href=3D"mailto:vgoyal@redhat.com" moz-do-not-s=
end=3D"true">vgoyal@redhat.com</a>) wrote:
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
          <pre class=3D"moz-quote-pre" wrap=3D"">I thought the bind mount=
 setup was the normal setup seen under both Kata
and k8s?
</pre>
        </blockquote>
        <pre class=3D"moz-quote-pre" wrap=3D"">Kata Containers works as f=
ollows:

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
        <pre class=3D"moz-quote-pre" wrap=3D"">__________________________=
_____________________
Virtio-fs mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:Virtio-fs@redhat.com=
" moz-do-not-send=3D"true">Virtio-fs@redhat.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.redhat.com/mailman=
/listinfo/virtio-fs" moz-do-not-send=3D"true">https://www.redhat.com/mail=
man/listinfo/virtio-fs</a>
</pre>
      </blockquote>
      <p>Also what happens if some of the volumes are mounted as
        read/only?=A0 What kind of error does the container process get
        when it attempts to write to the volume?<br>
      </p>
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
    <p>Also need to think about the volume being mounted as noexec,
      nodev, nosuid,=A0 Does the kernel inside of the container handle
      this correctly?<br>
    </p>
  </body>
</html>

--------------697C86A58D3DA150DA41C25A--

--U5y82qbU4wRK08PsRBqU9Iu5xiVA9E4OO--

--noH14dvQOnYCBPle6PL5kKAifj1mvHr60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE+re/ImQyQPB/0p5rot+QHaviwCgFAl5MLcEACgkQot+QHavi
wCiVnAf/fKkYm2WqhVRVNbfRxAKc5V6mKRfolhKEAc5oA3FcbEGktHLkywTSkAYZ
0V3e/Vt9n58LFijxWJj366y+OvghPTz/J5h5dSHyVN5G1lw897LhXcKDa0iHS/sj
eiSM2RLyZ2H+ANPRvpwhw/aMR5oClfXG7gJzIKPRN0domcP46yv7Z7GrnDSnRzso
sXUUFCzxc/Oc/YXJ5XVPC0U5eW2SX0hyGMUN9P1FNQrJaS/9TJK+HBzEQq6k+efJ
d6MjkdK+Ht9/K3QUtfsqZa5+rb3KXvkXadfTA5kcRNOTjeEEygEOTlCVf9tqNhto
OAIhHGkyM/rnAP/FKSts84z2EawqSg==
=R82L
-----END PGP SIGNATURE-----

--noH14dvQOnYCBPle6PL5kKAifj1mvHr60--

