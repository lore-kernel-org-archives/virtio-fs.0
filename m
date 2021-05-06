From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  6 May 2021 14:43:02 -0400
Message-Id: <20210506184304.321645-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] virtiofs, dax: Fix couple of smatch warnings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: dan.carpenter@oracle.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org

Hi,

Dan Carpenter reported couple of smatch warning in fs/fuse/dax.c code.
These patches fix the warnings.

Thanks Dan.

Vivek

Vivek Goyal (2):
  virtiofs, dax: Fix smatch warning about loss of info during shift
  virtiofs, dax: Fixed smatch warning about ret being uninitialized

 fs/fuse/dax.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.25.4

