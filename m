DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1622562911; 
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=F88dnfMxPkGPG7lAkzBxukhjXe+D8K+AEt/pFkBDNHI=;
	b=OqB3+d9nytZjeqZhk+8fxP4+q2kUzStyrkplJR2MPCxRjzIEPWanp/+5VhfCbivn
	00ihRGWk43FgYMohfXRvh7kXtTeOUN+UW2kEYNPdQX3lpufFMDJrcCPDyx5xq0itPik
	ucHyQ9WRsd0BAfSOG3vbJD2P7vAn1egOe3hFmfiu73SzXM5MpwfUDweFdmVTsXfhyNU
	CORPS57QNMBgyeBvS7pUM+OJSOUuKxztCTdeW/z6PtFfvFsHugta2vpbWUzmgTiP2C3
	ziuU4bFYUBRHXyHRQmGJOsgNB5D0NjcwUY865DKCUJaPjZpPMPa5d6me83r7l6JmDxz
	087Ve9ZzJg==
Date: Tue, 1 Jun 2021 17:55:11 +0200 (CEST)
From: tecufanujacu@tutanota.com
Message-ID: <Mb7HI6c--3-2@tutanota.com>
MIME-Version: 1.0
Content-Type: multipart/alternative; 
	boundary="----=_Part_274944_1812962147.1622562911486"
Subject: [Virtio-fs] virtiofsd: doesn't garant write access at users allowed
 by group permission
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

------=_Part_274944_1812962147.1622562911486
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello to everyone,

I'm trying virtiofsd with proxmox from few weeks and I noticed a problem, virtiofsd doesn't garant write access at users allowed by group permission.

The virtiofsd bin included in proxmox is v 7.32, but I have also tested the bins compiled from source from stable branch (v7.27) and dev branch (v7.33), and I also have tested the bin virtiofsd-rs. Always same problem.

I opened an issue on gitlab and I asked in the proxmox forum but with almost zero interaction. Seems to me that virtiofsd isn't a lot used. Someone suggested me to write in the mailinglist for these technical things and here I am.

To better make understand what problem I'm noticing I link the issue opened in the gitlab in which I have reported a lot of useful info and logs with a good formatting:
https://gitlab.com/qemu-project/qemu/-/issues/368

To me seems really strange what is happening, am I doing some error or this really is a virtiofsd bug?

------=_Part_274944_1812962147.1622562911486
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3DUTF-8=
">
  </head>
  <body>
<div style=3D"color: rgb(0, 0, 0); font-family: Cantarell; font-size: 14.66=
6666984558105px; font-style: normal; font-variant-caps: normal; font-weight=
: normal; letter-spacing: normal; orphans: auto; text-align: start; text-in=
dent: 0px; text-transform: none; white-space: normal; widows: auto; word-sp=
acing: 0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-s=
troke-width: 0px;">Hello to everyone,<br></div><div style=3D"color: rgb(0, =
0, 0); font-family: Cantarell; font-size: 14.666666984558105px; font-style:=
 normal; font-variant-caps: normal; font-weight: normal; letter-spacing: no=
rmal; orphans: auto; text-align: start; text-indent: 0px; text-transform: n=
one; white-space: normal; widows: auto; word-spacing: 0px; -webkit-tap-high=
light-color: rgba(0, 0, 0, 0.4); -webkit-text-stroke-width: 0px;"><br></div=
><div style=3D"color: rgb(0, 0, 0); font-family: Cantarell; font-size: 14.6=
66666984558105px; font-style: normal; font-variant-caps: normal; font-weigh=
t: normal; letter-spacing: normal; orphans: auto; text-align: start; text-i=
ndent: 0px; text-transform: none; white-space: normal; widows: auto; word-s=
pacing: 0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-=
stroke-width: 0px;">I'm trying virtiofsd with proxmox from few weeks and I =
noticed a problem, virtiofsd doesn't garant write access at users allowed b=
y group permission.<br><br>The virtiofsd bin included in proxmox is v 7.32,=
 but I have also tested the bins compiled from source from stable branch (v=
7.27) and dev branch (v7.33), and I also have tested the bin virtiofsd-rs. =
Always same problem.<br></div><div style=3D"color: rgb(0, 0, 0); font-famil=
y: Cantarell; font-size: 14.666666984558105px; font-style: normal; font-var=
iant-caps: normal; font-weight: normal; letter-spacing: normal; orphans: au=
to; text-align: start; text-indent: 0px; text-transform: none; white-space:=
 normal; widows: auto; word-spacing: 0px; -webkit-tap-highlight-color: rgba=
(0, 0, 0, 0.4); -webkit-text-stroke-width: 0px;"><br></div><div style=3D"co=
lor: rgb(0, 0, 0); font-family: Cantarell; font-size: 14.666666984558105px;=
 font-style: normal; font-variant-caps: normal; font-weight: normal; letter=
-spacing: normal; orphans: auto; text-align: start; text-indent: 0px; text-=
transform: none; white-space: normal; widows: auto; word-spacing: 0px; -web=
kit-tap-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-stroke-width: 0px=
;">I opened an issue on gitlab and I asked in the proxmox forum but with al=
most zero interaction. Seems to me that virtiofsd isn't a lot used. Someone=
 suggested me to write in the mailinglist for these technical things and he=
re I am.<br></div><div style=3D"color: rgb(0, 0, 0); font-family: Cantarell=
; font-size: 14.666666984558105px; font-style: normal; font-variant-caps: n=
ormal; font-weight: normal; letter-spacing: normal; orphans: auto; text-ali=
gn: start; text-indent: 0px; text-transform: none; white-space: normal; wid=
ows: auto; word-spacing: 0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0.=
4); -webkit-text-stroke-width: 0px;"><br>To better make understand what pro=
blem I'm noticing I link the issue opened in the gitlab in which I have rep=
orted a lot of useful info and logs with a good formatting:<br></div><div s=
tyle=3D"color: rgb(0, 0, 0); font-family: Cantarell; font-size: 14.66666698=
4558105px; font-style: normal; font-variant-caps: normal; font-weight: norm=
al; letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; word-spacing:=
 0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-stroke-=
width: 0px;"><a target=3D"_blank" rel=3D"noopener noreferrer" href=3D"https=
://gitlab.com/qemu-project/qemu/-/issues/368">https://gitlab.com/qemu-proje=
ct/qemu/-/issues/368</a><br></div><div style=3D"color: rgb(0, 0, 0); font-f=
amily: Cantarell; font-size: 14.666666984558105px; font-style: normal; font=
-variant-caps: normal; font-weight: normal; letter-spacing: normal; orphans=
: auto; text-align: start; text-indent: 0px; text-transform: none; white-sp=
ace: normal; widows: auto; word-spacing: 0px; -webkit-tap-highlight-color: =
rgba(0, 0, 0, 0.4); -webkit-text-stroke-width: 0px;"><br>To me seems really=
 strange what is happening, am I doing some error or this really is a virti=
ofsd bug?<br></div>  </body>
</html>

------=_Part_274944_1812962147.1622562911486--

