From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
Date: Sat, 24 Aug 2019 13:09:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] basic questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

Hi,

(1) The howto document at <https://virtio-fs.gitlab.io/howto-qemu.html>
contains the following snippet:

> force use of memory sharable with the fuse daemon.
>
>   -m 4G,maxmem=4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem

Why is the "maxmem" property necessary? It's not larger than the
(implicit) "size" property of "-m", and I don't think memory hotplug is
relevant here.

(2) what is the "fuse daemon"? Is that a reference to "virtiofsd"?

(3) Why is a NUMA node necessary, with a memory backend file explicitly
allocated under /dev/shm?

Will the virtio-fs device model exchange such references, over the
socket, with virtiofsd, that point into shared memory?

(4) Couldn't we point mem-path to a normal (host disk based) directory?

Performance aside, that should put less pressure on host RAM, and
otherwise work the same. Is that correct?

(5) Is the shared memory area necessary for the most basic virtio-fs
usage?

(6) I seem to recall that virtio-fs allows guests to notice if files
have changed since they last looked.

Is that functionality tied to "ireg" daemon, and to the "versiontable"
property added in commit 8fb5b17bea63 ("virtio-fs: Allow mapping of meta
data version table", 2019-08-23)?

(7) Are guests required to access the virtio-fs device at the PCI level
-- such as an MMIO region -- in order to observe async file changes, or
is this functionality available purely at the virtio communication level
(i.e., transport-independently)?

It doesn't seem to be explained at
<https://stefanha.github.io/virtio/virtio-fs.html>.

Thanks!
Laszlo

