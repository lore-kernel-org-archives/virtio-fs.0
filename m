DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:user-agent:in-reply-to:references:mime-version
	:content-transfer-encoding:subject:to:cc:from:message-id;
	bh=2A8Gvcs0ZfBxXhdP9NS8gJ1322/gHycBfScmYscfDVg=;
	b=Z/JNzSkxJZgQ3/zqMdnteiuzSfe/kFSi74VQQ5XIbChEe8wEdnFWPO+4XJUOds4vX5
	YRfkllSNPPB3Jo0OXwgaiIKWRHfJUhZHQsbffMET1gc2ykBOwEyM6LrSD/z1S+1u17lc
	rvbvHVAgliDWM9Q2Sp8S5a7BcqIrCD75zcqX53BkuUk/axDfg7Gz2iSYov02kS6iHO14
	kmB++/T7qLc/8VOnaiGyn+t/36tCeHbnUQGbhGWtihvHcAmGknfacrDwcS085y9ixr92
	FubDmMqyB4f8U02nbUk2rYgQZh4EEb+EODOcrugioKjBn+wgqQ3azKr0IR9pvfwXMEHl
	hE4A==
Date: Sat, 12 Dec 2020 00:39:08 -0600
In-Reply-To: <20201211110522.GB3380@work-vm>
References: <20201207183021.22752-1-vgoyal@redhat.com>
	<20201207183021.22752-4-vgoyal@redhat.com>
	<20201210200303.GN3629@work-vm>
	<20201210200931.GA185111@redhat.com>
	<97a0de57-8422-2fdc-e16e-0d6f133f615c@gmail.com>
	<20201211110522.GB3380@work-vm>
MIME-Version: 1.0
From: Harry Coin <hgcoin@gmail.com>
Message-ID: <0E76031D-6231-40E8-A5CF-1829177BA5C7@gmail.com>
Content-Type: multipart/alternative;
	boundary="----YPVLCBTHDUOMGBKH79PEI6PNN1EFZM"
Subject: Re: [Virtio-fs] ceph + freeipa ubuntu/fedora common small bug
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, lersek@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

------YPVLCBTHDUOMGBKH79PEI6PNN1EFZM
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

It's the latest ubuntu and fedora distros.


On December 11, 2020 5:05:22 AM CST, "Dr. David Alan Gilbert" <dgilbert@red=
hat.com> wrote:
>* Harry G. Coin (hgcoin@gmail.com) wrote:
>> FYI.=C3=82=C2=A0 Same thing we saw on Fedora installing freeipa, this on=
 ubuntu
>> with ceph.=C3=82=C2=A0 Identical bitmask report.
>>=20
>> ...
>>=20
>> Fixing /var/run/ceph ownership....done
>>=20
>> Cannot set file attribute for '/var/log/journal', value=3D0x00800000,
>> mask=3D0x00800000, ignoring: Function not implemented
>>=20
>> Cannot set file attribute for
>> '/var/log/journal/fd007229322043ad8778c214d19ed3ac',
>value=3D0x00800000,
>> mask=3D0x00800000, ignoring: Function not implemented
>
>This looks like it comes out of systemd's  src/tmpfiles/tmpfiles.c:
>
>        r =3D chattr_fd(procfs_fd, f, item->attribute_mask, NULL);
>        if (r < 0)
>log_full_errno(IN_SET(r, -ENOTTY, -EOPNOTSUPP) ? LOG_DEBUG :
>LOG_WARNING,
>                               r,
>"Cannot set file attribute for '%s', value=3D0x%08x, mask=3D0x%08x,
>ignoring: %m",
>                    path, item->attribute_value, item->attribute_mask);
>
>and it's chattr_fd is in it's src/basic/chattr-util.c
>which is using FS_IOC_GET/SETFLAGS, which seems to be an older
>way of doing things.
>
>Now, is that supposed to promote itself to a newer call or is it OK?
>
>Dave
>
>> ...
>>=20
>> Host has xattrs on, btrfs.
>>=20
>>=20
>>=20
>--=20
>Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

--=20
Sent from my Android device with K-9 Mail. Please excuse my brevity.
------YPVLCBTHDUOMGBKH79PEI6PNN1EFZM
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body>It's the latest ubuntu and fedora distros.<br><br>=
<br><div class=3D"gmail_quote">On December 11, 2020 5:05:22 AM CST, "Dr. Da=
vid Alan Gilbert" &lt;dgilbert@redhat.com&gt; wrote:<blockquote class=3D"gm=
ail_quote" style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(2=
04, 204, 204); padding-left: 1ex;">
<pre class=3D"k9mail">* Harry G. Coin (hgcoin@gmail.com) wrote:<br><blockqu=
ote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0.8ex; border-left: =
1px solid #729fcf; padding-left: 1ex;">FYI.=C3=82&nbsp; Same thing we saw o=
n Fedora installing freeipa, this on ubuntu<br>with ceph.=C3=82&nbsp; Ident=
ical bitmask report.<br><br>...<br><br>Fixing /var/run/ceph ownership....do=
ne<br><br>Cannot set file attribute for '/var/log/journal', value=3D0x00800=
000,<br>mask=3D0x00800000, ignoring: Function not implemented<br><br>Cannot=
 set file attribute for<br>'/var/log/journal/fd007229322043ad8778c214d19ed3=
ac', value=3D0x00800000,<br>mask=3D0x00800000, ignoring: Function not imple=
mented<br></blockquote><br>This looks like it comes out of systemd's  src/t=
mpfiles/tmpfiles.c:<br><br>        r =3D chattr_fd(procfs_fd, f, item-&gt;a=
ttribute_mask, NULL);<br>        if (r &lt; 0)<br>                log_full_=
errno(IN_SET(r, -ENOTTY, -EOPNOTSUPP) ? LOG_DEBUG : LOG_WARNING,<br>       =
                        r,<br>                               "Cannot set fi=
le attribute for '%s', value=3D0x%08x, mask=3D0x%08x, ignoring: %m",<br>   =
                            path, item-&gt;attribute_value, item-&gt;attrib=
ute_mask);<br><br>and it's chattr_fd is in it's src/basic/chattr-util.c<br>=
which is using FS_IOC_GET/SETFLAGS, which seems to be an older<br>way of do=
ing things.<br><br>Now, is that supposed to promote itself to a newer call =
or is it OK?<br><br>Dave<br><br><blockquote class=3D"gmail_quote" style=3D"=
margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1e=
x;">...<br><br>Host has xattrs on, btrfs.<br><br><br><br></blockquote>-- <b=
r>Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK<br><br></pr=
e></blockquote></div><br>-- <br>Sent from my Android device with K-9 Mail. =
Please excuse my brevity.</body></html>
------YPVLCBTHDUOMGBKH79PEI6PNN1EFZM--

