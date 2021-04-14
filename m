From: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
Date: Wed, 14 Apr 2021 20:12:05 +0000
Message-Id: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 0/2] virtiofsd: Enable xattr if xattrmap is used
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, vgoyal@redhat.com


Using xattrmap for Kata Containers we found that xattr is should be used
or xattrmap wont work.  These patches enable xattr when -o xattrmap is
used. Also, they add help for the xattrmap  option on `virtiofsd --help` output.

Carlos Venegas (2):
  virtiofsd: Allow use "-o xattrmap" without "-o xattr"
  virtiofsd: Add help for -o xattr-mapping

 tools/virtiofsd/helper.c         | 3 +++
 tools/virtiofsd/passthrough_ll.c | 1 +
 2 files changed, 4 insertions(+)

-- 
2.25.1

