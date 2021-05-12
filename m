References: <20210512125544.9536-1-mreitz@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <f8e15bb3-acf4-5260-f8c5-6425c4d21bba@redhat.com>
Date: Wed, 12 May 2021 16:37:49 +0200
MIME-Version: 1.0
In-Reply-To: <20210512125544.9536-1-mreitz@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Fwd: [PATCH 0/3] virtiofsd: Find original inode ID of
	mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

Sorry, forgot to CC the virtio-fs list.  I hope forwarding the cover 
letter is enough...

Here’s the link to the qemu-devel archive:
https://lists.nongnu.org/archive/html/qemu-devel/2021-05/msg03366.html


-------- Forwarded Message --------
Subject: [PATCH 0/3] virtiofsd: Find original inode ID of mount points
Date: Wed, 12 May 2021 14:55:41 +0200
From: Max Reitz <mreitz@redhat.com>
To: qemu-devel@nongnu.org
Copy (CC): Max Reitz <mreitz@redhat.com>, Dr . David Alan Gilbert 
<dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>

Hi,

Not announcing submounts to the guest may lead to duplicated
st_dev/st_ino combinations, because inodes on different filesystems
(different st_dev) may share the same inode ID (st_ino).  If the guest
only sees a single st_dev, those inodes will appear to have the same
st_dev/st_ino combination.

Announcing submounts is supposed to solve this problem by making the
guest report different st_dev IDs for different filesystems.

However, there is one loop hole: Submounts are implemented as
auto-mounts, meaning when the virtio-fs filesystem is mounted, the
submounts will not be mounted immediately.  In the guest, it is possible
to stat() these mount points with AT_NO_AUTOMOUNT to receive information
without mounting them, so they will then show whatever st_ino virtiofsd
passes, and the st_dev of the parent filesystem.

Unfortunately, as far as we understood, the only st_ino that virtiofsd
could inquire was the one on the submounted filesystem, i.e. the st_ino
of that FS’s root node.

Thus, we again got a collision: In said case, the guest would see st_dev
of the parent FS, but st_ino of the submounted FS.  This is very likely
to be the same st_dev/st_ino combination as the root node of the parent
FS.

For nested mount structures, this can be reproduced with `find`:
Mounting several filesystems under each other, passing everything into a
guest, mounting the root virtio-fs FS there, and then invoking `find`
would likely result in it complaining about filesystem loops and
refusing to visit the submount points.  (These loops are reported
because it takes notes of st_dev/st_ino combinations, and then reports a
loop when some combination reappears.)  This can only be fixed by
forcing all submounts to be (auto-)mounted.

What we’d need to do is report the inode ID of the mount point directory
that it has on the parent filesystem to the guest, until the submount is
auto-mounted there.  It’s just that we thought there was no way to
inquire this parent FS st_ino.

It turns out that our understand was wrong, though: There is a way,
namely readdir().  The dirent.d_ino field represents (in practice) the
st_ino of some directory entry on the directory’s filesystem, and so is
exactly the value we want to give to the guest.

Let’s do that.


Max Reitz (3):
   virtiofsd: Find original inode ID of mount points
   virtiofs_submounts.py: Do not generate ssh key
   virtiofs_submounts.py: Check `find`

  tools/virtiofsd/passthrough_ll.c              | 104 +++++++++++++++++-
  tests/acceptance/virtiofs_submounts.py        |  10 +-
  .../virtiofs_submounts.py.data/guest.sh       |  56 ++++------
  3 files changed, 122 insertions(+), 48 deletions(-)

-- 
2.31.1

