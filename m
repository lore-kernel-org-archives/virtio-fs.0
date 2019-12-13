DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:subject:message-id:mime-version:content-disposition;
	bh=EmRRDZ+JIDmfaXGelSzFnb4h8hykGWu86h8EiwXDG6E=;
	b=C5ep6R9eWtKLVb2f6EPxiGY7mDXSOeY3ZGZFCHgK36xup+hGdLC1xGxKS4VqZkls05
	GemO8BWsJUTHAnm2PIsSrz2IeyHzhX6ZrsH3BtcX+iPGEwKqwxvauhVI4qVrTf62KeWn
	H3i3dIBp6TDKfW5URi4GRlOZmxlU5zdstIgi5pPggEeqLbraP3FO+RdBD8Y16CrYzB2n
	NdIKok7/P/NzFivpZ7e1MpmA+Up3PYPhYprU/JSWwvoxEbK9mH9d2jrZz2gOjb8TPAed
	H7nxxEyTGqoYoNHW+syWt8y2rHabuu5++p5t4M4eOCWFONCAjMr0EpP0gtdN1ruL+emt
	+oHg==
Date: Fri, 13 Dec 2019 12:57:33 -0500
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20191213175733.txnfv6bxxf4vauzb@gabell>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Question: atime update behavior of virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hello,

Let me ask questions about atime update behavior of virtiofs.

Background:

I believe the atime update behavior of virtiofs is same as
the underlying filesystem and the atime mount option of virtiofs
is ignored.

For example, the underlying fileysystem is XFS and the atime option
is strictatime Then, mount the filesystem from the guest with noatime.

# mount -t virtiofs -o noatime myfs0 /mnt/myfs0

# cat /proc/mounts
...
myfs0 /mnt/myfs0 virtiofs rw,noatime 0 0
...

Check the atime as following script atime.h:
============
#!/bin/bash

FILE=/mnt/myfs0/foo

rm -f $FILE

echo "hello" > $FILE
stat --format=%x $FILE

sleep 10

cat $FILE > /dev/null
stat --format=%x $FILE
============

I can see the following result. The atime is updated even if the mount
option is noatime.

~]# ./atime.sh
2019-12-13 12:32:46.733024358 -0500
2019-12-13 12:32:56.752898507 -0500
~]#

Questions:

Q1. Is the atime behavior a specification for virtiofs, that means
    it's not a bug?

Q2. If Q1 is yes, I think it would be better if the atime behavior
    could be described to documents so that user can know the behavior.
    What is the appropriate document?
    - man page of virtiofsd which Dave is trying to merge?
      https://lists.gnu.org/archive/html/qemu-devel/2019-12/msg02475.html
    - man page of mount(8)?
    - The official page (https://virtio-fs.gitlab.io/)?
    - Or...?

Thanks!
Masa


