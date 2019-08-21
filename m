DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=7IdfeL+bhdQzklb6aM/oj9f2MwCZiCaT4KRcg2BlRE8=;
	b=EbhrkHjw9fqPJlrCESTskxVmhy8Y2RGa9emItIhYuBl1E2Xbsa5ZSZ+g2x/tHfz6d+
	Li4dA12TcvJuktQikE5qi9eXNr3qWveYBLJ7x+sbQTe2AiO8wjQJQbWmQalWS/PS8itu
	U3+80YNaD9WVIHRPEEFNlrpFCL+ons/qN5XrMc5cvdGdAU/6jjmPB4DJ0AUJCurF2oDD
	xgTrJewC1c4080dBaWFEoTzPewBRlB1PSX1fJP8XWZnr4NCb8+xQI67t2OcHpbakTE6c
	rXBCiPYJ9bAg1ENH2DEWW8fJhaO0TlV5mD3ZGEk5GUn85hAswlGNsDagBaBiCeeUzTZW
	N8wQ==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Wed, 21 Aug 2019 00:40:11 -0400
Message-Id: <20190821044014.26369-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH v2 0/3] virtio-fs: Add some tracepoints
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

  cat-4491         [006] .... 72.414799: virtio_fs_request_dispatched:
      opcode FUSE_READ unique 0x13b30 nodeid 0x2 in.len 80 flags
      ISREPLY|WAITING|SENT notify 1
  kworker/0:12-448 [000] .... 72.414807: virtio_fs_request_done:
      opcode FUSE_READ unique 0x13b30 nodeid 0x2 in.len 80 flags
      ISREPLY|WAITING

Changelog:
 From v1:
 - Move the tracepoints in spin_lock(&fsvq->lock)'ed area to prevent
   use after free the request.

 From RFC:
 - Change the string and the file name from virtiofs to virtio_fs.
 - Separate the fuse macros to the other file to get useful for
   generic fuse trace.

Masayoshi Mizuma (3):
  fuse: add some macros for ftrace
  virtio-fs: add ftrace events
  virtio-fs: add tracepoints

 fs/fuse/virtio_fs.c                |  23 +++++
 include/trace/events/fuse_common.h |  67 +++++++++++++++
 include/trace/events/virtio_fs.h   | 131 +++++++++++++++++++++++++++++
 3 files changed, 221 insertions(+)
 create mode 100644 include/trace/events/fuse_common.h
 create mode 100644 include/trace/events/virtio_fs.h

-- 
2.18.1

