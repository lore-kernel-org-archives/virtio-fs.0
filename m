DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=zEbWfjaOVj3dewzcSpxl8BMXMoQ1qUb2Fcj3v8Wx7d4=;
	b=qykZMkdyW98kIy2JHQw/+t9NYu+TFzu51BiCXV8w4GQWpXv25Anjk/2sa4eYXz9pwi
	7s2SlS6UQPb4ZLeTImkK5mNlfjGN+AI/7/XR+WgLNhZbQC71F07UfNEZ3gYVtzRue3mX
	Smy2c2e0IVckDFaALk04Dpj9jfvjgB9jpJWQE9r+4eaIZJi5+6TzaSRbVB1FLEVRtlGX
	2eDRn1dL8AxXcxs+buuHJbbh4JpXYstTzJtuvZmJ3k64DyLFmzCRSuVFT44Sp50J6Rin
	Jlo8S0aLj/Ylapf187UNuLVJFS5GQd6IFrfL+oU1AZW+2Le2+MwUJhtOjWP/7ewyqnps
	hdrA==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Mon, 29 Jul 2019 17:34:29 -0400
Message-Id: <20190729213431.10821-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH 0/2][RFC] virtio-fs: Add some tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

This patch series introduce some tracepoints. It will be
useful to debug the I/O request flow.

New trace events:

  - virtiofs_request_dispatched
  - virtiofs_request_done
  - virtiofs_hiprio_request_dispatched
  - virtiofs_hiprio_request_done

Above trace events is added to the following functions as
the tracepoints:

  - virtio_fs_enqueue_req
  - virtio_fs_requests_done_work
  - virtio_fs_hiprio_dispatch_work
  - virtio_fs_hiprio_done_work

Example of the trace record:

  cat-1420       [002] .... 34.687462: virtiofs_request_dispatched: opcode
      FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING|SENT
      notify 1
  kworker/4:1-67 [004] .... 34.687531: virtiofs_request_done: opcode FUSE_READ
      unique 0x1a nodeid 0x2 in.len 80 flags ISREPLY|WAITING

Masayoshi Mizuma (2):
  add ftrace events
  add tracepoints

 fs/fuse/virtio_fs.c             |  21 ++++
 include/trace/events/virtiofs.h | 195 ++++++++++++++++++++++++++++++++
 2 files changed, 216 insertions(+)
 create mode 100644 include/trace/events/virtiofs.h

-- 
2.18.1

