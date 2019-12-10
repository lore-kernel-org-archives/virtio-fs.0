From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:18 -0300
Message-Id: <20191210145119.329731-5-farosas@linux.ibm.com>
In-Reply-To: <20191210145119.329731-1-farosas@linux.ibm.com>
References: <20191210145119.329731-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/5] build-rootfs: Download latest config.guess
	for blogbench
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Blogbench has an outdated config.guess which does not recognize the
ppc64le platform. Download the latest one.

https://www.gnu.org/software/gettext/manual/html_node/config_002eguess.html

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 build-rootfs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/build-rootfs.sh b/build-rootfs.sh
index 3b109a8..470973e 100755
--- a/build-rootfs.sh
+++ b/build-rootfs.sh
@@ -36,5 +36,5 @@ fi
 install -D -m 0755 run-test-in-guest.sh "$PWD/rootfs/root/"
 install -D -m 0644 run-test.service "$PWD/rootfs/etc/systemd/system/"
 run_in_rootfs /bin/bash -c "cd /root && git clone https://github.com/pjd/pjdfstest && cd pjdfstest && autoreconf -ifs && ./configure && make pjdfstest"
-run_in_rootfs /bin/bash -c "cd /root && wget -O blogbench-1.1.tar.gz https://download.pureftpd.org/pub/blogbench/blogbench-1.1.tar.gz && tar xf blogbench-1.1.tar.gz && cd blogbench-1.1 && ./configure && make"
+run_in_rootfs /bin/bash -c "cd /root && wget -O blogbench-1.1.tar.gz https://download.pureftpd.org/pub/blogbench/blogbench-1.1.tar.gz && tar xf blogbench-1.1.tar.gz && cd blogbench-1.1 && wget -O config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && ./configure && make"
 tar cJf rootfs.tar.xz rootfs
-- 
2.23.0


