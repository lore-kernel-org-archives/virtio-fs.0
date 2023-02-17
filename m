Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1676653256; bh=LuJa1XzVC5XRjGw6Q/jAedR9HRkgws8FREB9qNB2VwA=;
 h=Message-Id:Date:Cc:Subject:To:From;
 b=TNqkLEW6+0v5DyAoC9l82UgXKxWEJ97eYAB/nDG1gNzsu3TPzGqG+BiSIugsGsks7
 bo62YqzU+OtI+YEf2KUEJsMDPjV75aStv3WOPhFXGb+LOwbY+tUGH9V1lG+Wm1nEbu
 MgbMgHAnsBcBWA2INFI+PMg0pWYPaPax+iboFYUw=
From: Anton Kuchin <antonkuchin@yandex-team.ru>
Date: Fri, 17 Feb 2023 19:00:37 +0200
Message-Id: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Subject: [Virtio-fs] [PATCH v3 0/1] virtio-fs: implement option for
 stateless migration.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

v3:
 - Remove migration_type from migration stream
 - Use enum type for migration_type
 - Get rid of useless cast
 - Fix typos
 - Reword commit message

v2:
 - Use device property instead of migration capability

Anton Kuchin (1):
  vhost-user-fs: add migration type property

 hw/core/qdev-properties-system.c    | 10 +++++++++
 hw/virtio/vhost-user-fs.c           | 32 ++++++++++++++++++++++++++++-
 include/hw/qdev-properties-system.h |  1 +
 include/hw/virtio/vhost-user-fs.h   |  2 ++
 qapi/migration.json                 | 16 +++++++++++++++
 5 files changed, 60 insertions(+), 1 deletion(-)

--=20
2.37.2

