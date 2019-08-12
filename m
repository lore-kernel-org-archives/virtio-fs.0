DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=kbf6z6doASWsA/pz9P7o8Emrmc7QSHbokl2FNz2NUgA=;
	b=KtXYjXeF4iz+JCljlEVcduksDHEVmDHtZDwqLmnSRD7G3vxuNPpRum35Fq3aUgEX+E
	6kPLkmko1oFrV19gb1nQ1klX2vz4rxIrUKAS2T2Lmg+6u41q1hzyz90Pyz3GarGcN9qO
	0K/uPW05EU0iq/Hq7S1yK61sqZg3b0eDeEPPYTY954COgHs8C7k84VU3oCDgv9VFUq/c
	ES64LfqMHM5+CpvC+pgMKHt1GsSLzAb4jFNi0iDSshku5DiOedBUSevln3VqX0OoHiwy
	d3z2/ZUkoF0Pk++PLQwABskjobnbPDUmFScbZEfIFLrq6zMaPDLI67HkGdwH+a/tbWqd
	iuag==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Mon, 12 Aug 2019 17:04:52 -0400
Message-Id: <20190812210455.12540-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH 0/3] virtio-fs: Add some tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

This patch series introduce some tracepoints. It will be
useful to debug the I/O request flow.

New trace events:

  - virtio_fs_request_dispatched
  - virtio_fs_request_done
  - virtio_fs_hiprio_request_dispatched
  - virtio_fs_hiprio_request_done

Above trace events is added to the following functions as
the tracepoints:

  - virtio_fs_enqueue_req
  - virtio_fs_requests_done_work
  - virtio_fs_hiprio_dispatch_work
  - virtio_fs_hiprio_done_work

Example of the trace record:

  cat-1432        [006] .... 37.592694: virtio_fs_request_dispatched:
      opcode FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags
      ISREPLY|WAITING|SENT notify 1
  kworker/4:1-103 [004] .... 37.592809: virtio_fs_request_done:
      opcode FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags
      ISREPLY|WAITING

Changelog:
 From RFC:
 - Change the string and the file name from virtiofs to virtio_fs.
 - Separate the fuse macros to the other file to get useful for
   generic fuse trace.

Masayoshi Mizuma (3):
  fuse: add some macros for ftrace
  virtio-fs: add ftrace events
  virtio-fs: add tracepoints

 fs/fuse/virtio_fs.c                |  21 +++++
 include/trace/events/fuse_common.h |  67 +++++++++++++++
 include/trace/events/virtio_fs.h   | 131 +++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+)
 create mode 100644 include/trace/events/fuse_common.h
 create mode 100644 include/trace/events/virtio_fs.h

-- 
2.18.1

