Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1676556016; bh=LWStvpjF+X9INvQtKoyy/tfGUCKy8vkWL1oG4k796nw=;
 h=Message-Id:Date:Cc:Subject:To:From;
 b=GfiIA1g+2bPcsmFSgfvDBmzQ+TYLroVNwSknuLHbVpknZvmRbtmoUaCcQn5G9brJ9
 Gbz21x3aSEFH6B0IEMNX6dfTlxUWY2B4rQp88jPrxbY86mJGe0FbYuM8s+3S+2VYG0
 LNDDv3usSPoa44rzIahsK7qQGG/qTFMtsLqJH7tY=
From: Anton Kuchin <antonkuchin@yandex-team.ru>
Date: Thu, 16 Feb 2023 16:00:02 +0200
Message-Id: <20230216140003.1103681-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Subject: [Virtio-fs] [PATCH v2 0/1] virtio-fs: implement option for
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
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Markus Armbruster <armbru@redhat.com>, yc-core@yandex-team.ru, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>, Juan Quintela <quintela@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

v2: Use device property instead of migration capability

Anton Kuchin (1):
  vhost-user-fs: add property to allow migration

 hw/core/qdev-properties-system.c    | 10 +++++++++
 hw/virtio/vhost-user-fs.c           | 34 ++++++++++++++++++++++++++++-
 include/hw/qdev-properties-system.h |  1 +
 include/hw/virtio/vhost-user-fs.h   |  1 +
 qapi/migration.json                 | 16 ++++++++++++++
 5 files changed, 61 insertions(+), 1 deletion(-)

--=20
2.37.2

