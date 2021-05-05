From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Wed,  5 May 2021 11:36:55 +0100
Message-Id: <20210505103702.521457-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/7] replace all use of strftime() with
	g_date_time_format()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <laurent@vivier.eu>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Brad Smith <brad@comstyle.com>

The GDateTime APIs provided by GLib avoid portability pitfalls, such
as some platforms where 'struct timeval.tv_sec' field is still 'long'
instead of 'time_t'. When combined with automatic cleanup, GDateTime
often results in simpler code too.

Daniel P. Berrangé (7):
  migration: use GDateTime for formatting timestamp in snapshot names
  block: use GDateTime for formatting timestamp when dumping snapshot
    info
  net/rocker: use GDateTime for formatting timestamp in debug messages
  usb/dev-mtp: use GDateTime for formatting timestamp for objects
  io: use GDateTime for formatting timestamp for websock headers
  linux-user: use GDateTime for formatting timestamp for core file
  virtiofsd: use GDateTime for formatting timestamp for debug messages

 block/qapi.c                     | 11 ++++------
 hw/net/rocker/rocker.h           | 11 +++-------
 hw/usb/dev-mtp.c                 |  9 +++-----
 io/channel-websock.c             | 10 ++-------
 linux-user/elfload.c             | 36 ++++++++------------------------
 migration/savevm.c               | 13 +++++-------
 tools/virtiofsd/passthrough_ll.c | 25 ++++------------------
 7 files changed, 30 insertions(+), 85 deletions(-)

-- 
2.31.1


