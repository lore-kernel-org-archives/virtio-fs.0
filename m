DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netapp.com;
	s=selector1;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=vQwfE6tPkaro5Jgt1LIZZmb59nF3Rof+taUfVoNnOtg=;
	b=hfox82k25I/sLikGtkJ1f/SKuc76OJDy1UfgqXzLyu/EQhEym1mNcjzZXydW8hzdFWJpwAQ39V3zULCxAs9VoGHlhvk66SAA/3Y5Aww/rP4ZleOeqyGLQUPQEjfb3gXrXSRg97TV7+4ma+aJqOfVOXdjjS7Omwku5pzB5ueprEODfRnOKL0NwvVaM7ZrI54aB2c9A4pIUJO5SbuAdpbOBZLvyMASvXdxFnVQ5I/uebNEFukBhPlQDC3K8i+JyuCWAzDuNm+inNB3nNSzRAiEqzCusPmy6LK1d9nN3v3u5HPILhRxipe2H+tc4YEbnSFPlBuscwc8mKayYW0KvJRRWg==
From: "Ge, Xiongzi" <Xiongzi.Ge@netapp.com>
Date: Mon, 3 May 2021 12:50:56 +0000
Message-ID: <423DD084-E08F-4402-AD5A-3583117A6B4E@netapp.com>
References: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
	<YFnC9QXo6uP+2zC1@work-vm> <20210323145312.GB483930@redhat.com>
	<YFoCpIh5PCSP6gXB@work-vm>
	<40D27E5F-C65A-4441-BA23-ABA6880DAA71@netapp.com>
	<YG8tXxdyakzkyI0h@stefanha-x1.localdomain>
In-Reply-To: <YG8tXxdyakzkyI0h@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B6DDA2802A6574BB25881FF3909092F@namprd06.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, =?utf-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

Thanks, Stefan!
It seems that libvirt does not support device-attach for filesystem type device, like virtiofs. Are there any other ways to do this hot-unplugging? 

Xiongzi

﻿On 4/8/21, 12:21 PM, "Stefan Hajnoczi" <stefanha@redhat.com> wrote:

    On Wed, Apr 07, 2021 at 06:05:29PM +0000, Ge, Xiongzi wrote:
    > Thanks Dr Gilbert, Vivek, Stefan, Greg!
    > I put together the discussion into this thread and CC qemu-devel@nongnu.org. 
    > 
    > Problem:
    > Current Virtio-FS does not support live migration.  Even when the virtiofs directory is not mounted on the guest, VM cannot do live migration. Any suggestions/interest If we want to make this work so we can still have the live migration feature for other purpose on that VM? 
    > 
    > If we already have a shared file system like Ceph, does this make it different? 

    (Marc-André: I CCed you regarding D-Bus VMState, see below.)

    During the last virtio-fs call on Wednesday we discussed how to allow
    live migration when the file system is not mounted. This means live
    migration of a mounted file system still wouldn't be supported, but at
    least it would be possible to migrate when the file system is not
    mounted.

    The easiest way to do that is to hot unplug the vhost-user-fs-pci device
    so that QEMU can live migrate the VM and then hot plug the
    vhost-user-fs-pci device again after migration has completed. This
    requires either manually performing the hot plug operations or some
    automation to do this around live migration.

    A smoother approach would be for QEMU to allow live migration when the
    file system is not mounted. Unfortunately it turns out this is actually
    rather involved because virtiofsd runs as a separate process from QEMU
    and the live migration interface for vhost-user devices is currently
    pretty basic
    (https://qemu.readthedocs.io/en/latest/interop/dbus-vmstate.html). There
    is currently no way for virtiofsd to communicate with QEMU to allow/deny
    live migration depending on whether virtiofsd currently has an active
    FUSE session (mount). It might be possible to extend the D-Bus VMState
    interface and implement support for "migration blockers" as they are
    known in QEMU, but I wonder whether it's not better to just work on
    full virtio-fs live migration instead. Either task is complex and I
    wouldn't recommend it as a first contribution to virtiofsd or QEMU.

    Can you make use of the hotplug approach to live migration?

    Stefan


