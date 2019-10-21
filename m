Date: Mon, 21 Oct 2019 16:04:14 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191021150414.GD5837@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Upstreaming virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi,
  I've started upstreaming virtiofsd to qemu's contrib directory;
my first set (
https://lists.gnu.org/archive/html/qemu-devel/2019-10/msg05200.html )
is a minimal base set of patches that mounts and basically works - it
has none of the security work, the performance or many of the fixes.

In parallel with responding to any comments on that set, I'll be
working up the security set to be sent next; then performance and then
fixes.

Note, some of the patches that many of you have sent have been squashed
into other patches; I've kept a signed off (with something like 'fixes
from' or similar).  Many of the patches have been reformatted a bit.

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

