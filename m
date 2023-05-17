Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1684338768; x=1686930768;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:user-agent:from:to:cc:subject:date:message-id:reply-to;
 bh=2zgawbbiH3ZN+t5cl5i5se7wIX3B/JzZA+6PRyvIIdQ=;
 b=g5vI9spJJGk0AQg2nrDscgqmqP0hfliUsHdlmHIo3Us/3MCHru8MSL5VhuY5GT2/mq
 dRoS9rGKH+DSY0Pk6SGac+3nIrPcqrixW/J4kbvJqqzBVSCbZ8xOFTu/ib1xQ7zviDZk
 ibs2kc+8BOqHSss7aGDvVd5cDpfR14sdXJxylUPWqT/o/PqQ4hY9XSf+wHEmCaQh4q94
 FdFDSJGxvGseU3ZcQCFrHKeAwnWn++N0N3NhMWfDwCBhXlwgBEWuTh1Zzuy6AvkocsEa
 JF4hTrpK1NZCFMuLudbaFaQY4XnlK7TfXMkMNOZzzhktmkAMiz6g0Gc46Sl6Jd0zwx3/
 nMSQ==
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Wed, 17 May 2023 16:23:46 +0100
Message-ID: <87v8grlzu9.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: [Virtio-fs] Status of DAX for virtio-fs/virtiofsd?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: QEMU Developers <qemu-devel@nongnu.org>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>

Hi,

I remember from the dim and distant past (probably a KVM Forum) that one
of the touted features of virtio-fs was the ability to get memory
efficiency savings by having a direct memory mapping the host pages into
the guest address space.

AFAICT the kernel side was merged a while ago, see 22f3787 (virtiofs:
set up virtio_fs dax_device) and related. However when investigating
what would be needed to support this for Xen guests using virtio-fs we
were confused as to what else was needed.

There were some patches for the old C daemon:

  Subject: [PATCH v3 00/26] virtiofs dax patches
  Date: Wed, 28 Apr 2021 12:00:34 +0100=09[thread overview]
  Message-ID: <20210428110100.27757-1-dgilbert@redhat.com>

although they look like they were never merged and the C version of
virtiofsd has since been dropped from tools.

Looking at the supporting rust code (vhost_user/message.rs) there are a
number of additional messages:

    /// Virtio-fs draft: map file content into the window.
    FS_MAP =3D 6,
    /// Virtio-fs draft: unmap file content from the window.
    FS_UNMAP =3D 7,
    /// Virtio-fs draft: sync file content.
    FS_SYNC =3D 8,
    /// Virtio-fs draft: perform a read/write from an fd directly to GPA.
    FS_IO =3D 9,
    /// Upper bound of valid commands.
    MAX_CMD =3D 10,

that don't appear in the current canonical vhost-user reference in the
QEMU repository and the QEMU code certainly doesn't have implementations
for any of them. So I have some questions:

 * What VMM/daemon combinations has DAX been tested on?
 * Isn't it time the vhost-user spec is updated?
 * Is anyone picking up Dave's patches for the QEMU side of support?

Thanks,


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

