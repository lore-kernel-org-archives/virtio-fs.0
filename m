Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1665480229; x=1665566629; bh=T08zuk1xu8KzcDccP5zc+
 AxU4KqbMNFGZ/gxNS/QCbc=; b=tOMFwaqGKdDqqA0Eidk9jnlRtelNrlkFhBSyc
 L0GIVia2mZkc1L/J0qoS8y6Hqe9yKutuH70I2W0hYl2A7PFT3+Cby9Oo+2wnZvAf
 oXD0yCTeXJ0XPS1jYf9SLeUKymoGpicNajrbpCkYEPt2PUkKEklyuKYYYWOcBYGM
 U+m/LOvo9oATrdoU9Exefn0CTUmHFc4JztLdf9lFf9J4o/d2/TVVXXWB9oiaI+l6
 W2QV8TaKxjFxvkKZiiNcgydfkXuenIg9PYPxEK+nbet3SRANpD9JLJhVT1lSQfu1
 T3Mms6GymqrJYJRw6GmTMR9pIbwdm34ak8f5Gl9d8xxcSn38A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1665480229; x=1665566629; bh=T08zuk1xu8KzcDccP5zc+AxU4KqbMNFGZ/g
 xNS/QCbc=; b=AdspNi+xzVMvPGSJ61F/VM1XPRiaNEv18Qa99VBewCl0Gh+reHo
 Ggdf9GZ/JOCnaLiaj/4GEpG+otf4PyvD9viAal6El+bL1ZjjfJ6uoyRrf45F0SeJ
 Of+Ah+Lelxd9o8zcTDLJjOLipnsksmglbiPQQzHl0ynBBmFtYICogSiwBmrSqIN9
 rJcIvahshSzFDfNiBj78F8YTZ1eAL2TNhl7qes5aZSk6gjCW/lT6Z2Nw/488+b89
 pzpEhNDkKNYJbhMhqPDLdUuGNouyMeeLNn1yd/8bUZCGJkK3aW+rKImaJ5ywyhVG
 dp+Xz0GSFcv8c+zs4ObCky2pUIYYCWAURow==
From: virtiofs-bot@sinrega.org
Message-Id: <86599.122101105235100364@us-mta-382.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 11 Oct 2022 09:23:54 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: [traking] Underlay NFS
 filesystem and silly rename
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This issue is just to track of the following silly-rename-related bugs:
- [Bug 2018072](https://bugzilla.redhat.com/show_bug.cgi?id=2018072) - 
  [virtiofs]NFS/xfstests generic/650 failure -.nfs000000003005d939002af3d4': Device or resource busy

- [Bug 1908490](https://bugzilla.redhat.com/show_bug.cgi?id=1908490) - 
  [Fujitsu] [virtiofs] NFS/xfstests generic/245 failure - .nfs* files

- [Bug 1990912](https://bugzilla.redhat.com/show_bug.cgi?id=1990912) - 
  [virtiofs + nfs]cannot remove '/mnt/myfs1/fsstress:xfstest generic/013
      - This only happens in the C version of virtiofsd
      
- [Bug 2127063](https://bugzilla.redhat.com/show_bug.cgi?id=2127063) - 
  [RHEL8.7] virtio-nfs generic/694 failure: rm: cannot remove '/mnt/test/694': Directory not empty

These cannot be solved in virtiofsd, the solution is to:

- that the NFS server implements OPEN4_RESULT_PRESERVE_UNLINKED, or
  server-side silly rename.
  
- or add fuse support for synchronous forgets
  
The current workaround is to run virtiofsd with `--inode-file-handles=mandatory`,
but this has its own limitations, for instance, requiring `CAP_DAC_READ_SEARCH`.


More info about silly rename:
- [Server-side silly rename](https://linux-nfs.org/wiki/index.php/Server-side_silly_rename)
- [Linux NFS FAQ](https://nfs.sourceforge.net/)
  D2. What is a "silly rename"? Why do these .nfsXXXXX files keep showing up?
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/61

