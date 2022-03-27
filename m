Return-Path: <mkfssion@mkfssion.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=mkfssion.com; s=x; h=Content-Type:MIME-Version:Message-ID:Date:Subject:To:
 From:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ukUiKPOseGhUwFAZh+5rr6O4Xv72muF25fSzUa0qlZU=; b=RGj8pAB0S0ehNW4e3AMySUPHhB
 zLs77vxDTXB1bKE1lV4xvRaJzaeRRGVIoiJNmP5gV79od0XXoDqH0tKuSm4VgbmMq1aq5XR7jm+lC
 oGQq/CYvyYDWQYB8rl+m2z9T83SyWvGxBOD60JhqxHas015oaJ2YIX4lh/UN59UB9xAblj6oZrm27
 FqR1/g0gpqzt/Z/x3U7GsDg2DW4Kg/No4gjpRD8wT3kfat/Qv2cQo+XHVUejSMIwcECRft2QMAJkC
 qNorzsYamaxruxLAz9lwyK1i8NTK2yz8Iz8d0hCD7sbYWvR5PT8YGD3KEzIzqnCz7i8So9cOVgnbf
 RJ7d1M9g==;
From: MkfsSion <mkfssion@mkfssion.com>
Date: Sun, 27 Mar 2022 15:48:56 +0800
Message-ID: <2237527.ElGaqSPkdT@mkfssion-lpc>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4703193.GXAFRqVoOG";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
Subject: [Virtio-fs] VirtIOFS Service stop working on Windows guest when
 reading file from shared directory
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--nextPart4703193.GXAFRqVoOG
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: MkfsSion <mkfssion@mkfssion.com>
To: virtio-fs@redhat.com
Date: Sun, 27 Mar 2022 15:48:56 +0800
Message-ID: <2237527.ElGaqSPkdT@mkfssion-lpc>

Hello everyone,
	I encountered an issue when using VirtIOFS on Windows guest. Once I 
read files on guest, the VirtIOFS service stopped suddenly. I followed the 
instruction on https://virtio-fs.gitlab.io/howto-windows.html site. The 
following is the information about my setup.
	virtiofsd version: 
		mkfssion@MkfsSion-LPC ~ [1]> /usr/lib/qemu/virtiofsd -V
		virtiofsd version 6.2.0
		Copyright (c) 2003-2021 Fabrice Bellard and the QEMU 
Project developers
		using FUSE kernel interface version 7.33

        Linux version:
		Linux MkfsSion-LPC 5.10.108-1-lts510 #1 SMP Wed, 23 Mar 
2022 09:50:53 +0000 x86_64 GNU/Linux
	
	Windows guest:
		Version	Windows 10 Enterprise LTSC
		Version Number	21H2
		OS Internal Version	19044.1586
		Experience	Windows Feature Experience Pack 
120.2212.4170.0

	VirtIODriver: virtio-win-0.1.215

	Error code shown in Windows Explorer: 0x800703E3

	Debug log from VirtIOFS service after appending -d -1 -D C:
\virtiofs.log parameter: https://fars.ee/D0sr

	Host FS: btrfs

	libvirt xml:
		...
		<memoryBacking>
    			<hugepages/>
    			<source type="memfd"/>
    			<access mode="shared"/>
  		</memoryBacking>
		...
		<filesystem type="mount" accessmode="passthrough">
  		<driver type="virtiofs"/>
  		<binary path="/usr/lib/qemu/virtiofsd"/>
  		<source dir="/var/lib/libvirt/share"/>
  		<target dir="share"/>
  		<alias name="fs0"/>
  		<address type="pci" domain="0x0000" bus="0x0a" 
slot="0x00" function="0x0"/>
		</filesystem>

--nextPart4703193.GXAFRqVoOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE+IgqdcdMPhOu8s1s6KaS2Vi8XlYFAmJAFukACgkQ6KaS2Vi8
XlavBQ//fAN3qqnjeE+pU3Z0a/fHTyzHhzmQ3M8EjqXsVJLfwV6hyRrpG4tpkxsi
cK0JLPAvF7464CZ5H5EvY3WT2qIx8apo19oa7vhyOauUiEgCt5eIEqJtGR4Irgjo
WxBF6UGrQrdSjIKurlB04k+VE/lPMjhbxLLnAK0wnRD7lkszA9DvpfOrAaMKIOtf
EACODMlrz9HPc2YEOiXceHzAGoDlhOFjWaS5GKeG8BhMKYf2bndyKa7e8pY2+h0s
/LUEaCJAXQ/v3jAaBz+0YXlp9wUA+H3eSKwLnzdiakzFMDGi0+EoJvO2gboOqAxJ
+CQTM+paWEwQGFxzvRhiL/kF9hDcUd6fkTzDawEFLqVKnW8VpQZfLc/3R6DNN9Ux
znBHZvm0ukuRzf6eQNM3VgufPkPHV01vhy1Mo1e1pZHmvhtSjhuvzPaaGTCcrSxp
s8xAvu5suPwY/87uuH/oZ2UJnbjsjIbadg7EGpXJBxUYVVhGqptU8vMePXChu7vK
0TNJFshr8jaz2mRMZ+p70ZWsYQuGRrjpqkL/hpiP3N3yomyc+R/l2ZXJkTttf84i
bFbgxMJnNdMEkOgvPRl12NUBlKgqRAU5n7TG2B0796s5pC82oyLg4DGU1nM7H3xT
Bipn1E8B3tUuxnSNSqS8ZEsoLdO1UevIOFuSiVDVXcD29SLHU3I=
=qSsh
-----END PGP SIGNATURE-----

--nextPart4703193.GXAFRqVoOG--



