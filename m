From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 23 Aug 2019 16:02:43 +0100
Message-Id: <20190823150245.17246-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] Remove implicit lock knowledge from
	lo_destroy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

This comes from a comment by Vivek on an earlier review of lo_destroy
fixes.  In this pair I split unref_inode into a locked and unlocked
version and use the unlocked version in lo_destroy with an outer lock.
Note this does move the lo_inode_put inside the lock, but I don't
think that's an issue.

Dr. David Alan Gilbert (2):
  virtiofsd: Rename unref_inode to indicate lock
  virtiofsd: Convert lo_destroy to take the lo->mutex lock itself

 contrib/virtiofsd/passthrough_ll.c | 45 ++++++++++++++++--------------
 1 file changed, 24 insertions(+), 21 deletions(-)

-- 
2.21.0

