Date: Mon, 4 Jan 2021 16:00:13 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210104160013.GG2972@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] 'FORGET' ordering semantics (vs unlink & NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: fuse-devel@lists.sourceforge.net
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

Hi,
  On virtio-fs we're hitting a problem with NFS, where
unlinking a file in a directory and then rmdir'ing that
directory fails complaining about the directory not being empty.

The problem here is that if a file has an open fd, NFS doesn't
actually delete the file on unlink, it just renames it to
a hidden file (e.g. .nfs*******).  That open file is there because
the 'FORGET' hasn't completed yet by the time the rmdir is issued.

Question:
  a) In the FUSE protocol, are requests assumed to complete in order;
i.e.  unlink, forget, rmdir   is it required that 'forget' completes
before the rmdir is processed?
     (In virtiofs we've been processing requests, in parallel, and
have sent forgets down a separate queue to keep them out of the way).

  b) 'forget' doesn't send a reply - so the kernel can't wait for the
client to have finished it;  do we need a synchronous forget here?

  c) Has this problem been hit by any other fuse users (with NFS or otherwise)?

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

