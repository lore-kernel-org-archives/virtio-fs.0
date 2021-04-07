DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netapp.com;
	s=selector1;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=pUzZ3Ev+uFwjs5VD3b5ZKcaknZzQQ6H4PmEjmQ0GoSQ=;
	b=Yt7rIu/QFkyWhC+V5Xab/i08L9zXWFoQ/Ty7VIgZzLy0tkoYdYaJKk9m+dnXZk0ZUy8oifDUlcsxwK4EHFYFQCq+Ibj2+YgiM5LerQH/j3l80Rr79l/t9GRNHyfKWLS7wt6OvVP7mm8fCzYJhpye/vONL6Ybp+24AppyFbS6G/LM1rwOROIc9Ca7MPA9PXdFumaLG3AC8rjFp0/dU8fSbg66r1sIBfs+4afLMx3oaa/sNUWB8+fwlOgC29k16gMyED7dzevplFCGUHHbbbt4KgWQzDPCI6Kj7DRVdxKFQCr18hZ3D5F3f098+ULTfapl5J9ebe2nZFXuhcD1n2NMgA==
From: "Ge, Xiongzi" <Xiongzi.Ge@netapp.com>
Date: Wed, 7 Apr 2021 18:05:29 +0000
Message-ID: <40D27E5F-C65A-4441-BA23-ABA6880DAA71@netapp.com>
References: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
	<YFnC9QXo6uP+2zC1@work-vm> <20210323145312.GB483930@redhat.com>
	<YFoCpIh5PCSP6gXB@work-vm>
In-Reply-To: <YFoCpIh5PCSP6gXB@work-vm>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B7403C3819DEB49868644B126CA2BF1@namprd06.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

Thanks Dr Gilbert, Vivek, Stefan, Greg!
I put together the discussion into this thread and CC qemu-devel@nongnu.org. 

Problem:
Current Virtio-FS does not support live migration.  Even when the virtiofs directory is not mounted on the guest, VM cannot do live migration. Any suggestions/interest If we want to make this work so we can still have the live migration feature for other purpose on that VM? 

If we already have a shared file system like Ceph, does this make it different? 

Thanks,
Xiongzi

---------
Stefan's reply:
The virtio-fs device holds a bunch of state, like the ino_map, dirp_map,
and the fd_map in the virtiofsd C implementation. That is the FUSE
session state that needs to be migrated in order to resume seamlessly
(without unmounting and mounting again).

If the backend is a distributed file system then it my have APIs that
make migration easier. If it's possible to re-attach to open files from
another host then that is perfect. But on the flipside if there are no
APIs for doing that then it might be impossible to reliably live
migration because some state cannot be transferred between hosts.

Max Reitz is laying the foundation for live migration by working on
open_by_handle_at(2) support. This will probably be needed in order to
transfer open files from one host to another.

It should be possible to enable live migration when the filesystem is
not mounted. That might be a good first step to enabling live migration.

------------
>From Greg Kurz:
Live migration of virtio-fs is still at the early discussion stage AFAICT.
It might take time before we have something working. But in the meantime,
it seems abusive to block migration if we have a guarantee that the device
isn't servicing requests. FWIW virtio-9p only blocks migration when the
shared directory is mounted on the guest.


﻿On 3/23/21, 11:01 AM, "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

    * Vivek Goyal (vgoyal@redhat.com) wrote:
    > On Tue, Mar 23, 2021 at 10:29:09AM +0000, Dr. David Alan Gilbert wrote:
    > > * Ge, Xiongzi (Xiongzi.Ge@netapp.com) wrote:
    > > > Hello Vivek, Dr. Gilbert, and the virtio-fs team,
    > >
    > > Hi Xiongzi,
    > >
    > > > It seems that virtio-fs does not support live migration. Once a vm
    > > > is configured with virtio-fs, live migration cannot be performed even
    > > > it is not mounted on the guest.
    > >
    > > Right.
    > >
    > > > Is there any progress for this?
    > >
    > > Max Reitz is looking at some parts of it; in particular storing file
    > > handles that can later be reopened.
    > > But there are a bunch of other parts we've not looked at yet either
    > > (like the dirty page marking around all syscalls).
    > >
    > > > If the
    > > > shared directory is from a distributed file system like Ceph, would it
    > > > be easier than the general case to be implemented?
    > >
    > > Maybe; there are some tricky semantics problems; for example, lets
    > > imagine that you open the file   'a/b/c'  on the source, and sometime
    > > after you open it, 'b' gets renamed to 'd';  when you resume on the
    > > destination you need to make sure you know how to get to that file.
    > > Depending on the filesystem semantics you might need to make that work
    > > even if 'a/b/c' had been deleted but you still had it open.
    >
    > Hi Dave,
    >
    > I am assuming that with file handles, renaming of file probably is not
    > a problem. open_by_handle_at() will still be able to find it.

    Right; although again with soemthing like CEPH you might not even need
    that if you had a virtiofs daemon that spoke direct to CEPH, you might
    be dealing with a CEPH filehandle.

    > I think real problem (as you pointed out later) is unliked file which is
    > still in use by the virtiofsd.

    Dave

    > Thanks
    > Vivek
    --
    Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK



