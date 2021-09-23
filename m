From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Thu, 23 Sep 2021 17:35:43 +0800
Message-Id: <20210923093545.81512-1-jefflexu@linux.alibaba.com>
In-Reply-To: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
References: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd PATCH v5 0/2] virtiofsd: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

changes since v4:
- decide whether DAX shall be enabled or not solely depending on file
  size (DAX is disabled for files smaller than 32KB)
- negotiation during FUSE_INIT is droped
- drop support for .ioctl() for passthrough

changes since v2/v3:
Patch 4 in v2 is incomplete by mistake and it will fail to be compiled.
I had ever sent a seperate patch 4 of v3. Now I send the whole complete
set in v4. Except for this, there's no other diferrence.


Jeffle Xu (2):
  virtiofsd: add FUSE_ATTR_DAX to fuse protocol
  virtiofsd: support per-file DAX

 include/standard-headers/linux/fuse.h |  1 +
 tools/virtiofsd/passthrough_ll.c      | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

-- 
2.27.0

