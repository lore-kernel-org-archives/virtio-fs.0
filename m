From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 30 Oct 2019 11:07:16 -0400
Message-Id: <20191030150719.29048-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] virtiofs: Small Cleanups for 5.5
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, vgoyal@redhat.com, virtualization@lists.linux-foundation.org

Hi Miklos,

Here are few small cleanups for virtiofs for 5.5. I had received some
comments from Michael Tsirkin on original virtiofs patches and these
cleanups are result of these comments.

Thanks
Vivek

Vivek Goyal (3):
  virtiofs: Use a common function to send forget
  virtiofs: Do not send forget request "struct list_head" element
  virtiofs: Use completions while waiting for queue to be drained

 fs/fuse/virtio_fs.c | 204 ++++++++++++++++++++++----------------------
 1 file changed, 103 insertions(+), 101 deletions(-)

-- 
2.20.1

