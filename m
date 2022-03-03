From: Greg Kurz <groug@kaod.org>
Date: Thu,  3 Mar 2022 18:13:21 +0100
Message-Id: <20220303171323.580712-1-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] virtiofsd: Support FUSE_SYNCFS on
	unannounced submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

This is the current patches I have : one to track submounts
and the other to call syncfs() on them. Tested on simple
cases only.

I won't be able to work on this anymore, so I'm posting for the
records. Anyone is welcome to pick it up as there won't be a v2
from my side.

Cheers,

--
Greg

Greg Kurz (2):
  virtiofsd: Track submounts
  virtiofsd: Support FUSE_SYNCFS on unannounced submounts

 tools/virtiofsd/passthrough_ll.c | 61 ++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 6 deletions(-)

-- 
2.34.1


