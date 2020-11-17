From: Haotian Li <lihaotian9@huawei.com>
Message-ID: <5ae3557a-0b87-e6c0-be41-8441026c400c@huawei.com>
Date: Tue, 17 Nov 2020 17:01:25 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [Question] How to deal D state on request_wait_answer?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: miklos@szeredi.hu, mszeredi@redhat.com, virtio-fs@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com, linux-kernel@vger.kernel.org

Hi
    We recently detected a bug in virtiofs.  Here, we created a
virtual machine as guest with Qemu and virtiofsd. We mounted
virtiofs on guest, for example /home/virtiofs. Then we killed
the virtiofsd in host and accessed /home/virtiofs in guest later.
This casued a process with D state which could not be killed.
The stack of the process as following:
      wait_event_interruptible
[<0>] request_wait_answer+0x9d/0x210 [fuse]
[<0>] __fuse_request_send+0x75/0x80 [fuse]
[<0>] fuse_simple_request+0x164/0x270 [fuse]
[<0>] fuse_do_getattr+0xd5/0x2a0 [fuse]
[<0>] vfs_statx+0x89/0xe0
[<0>] __do_sys_newstat+0x39/0x70
[<0>] do_syscall_64+0x55/0x1c0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    We have no idea to deal with the bug. Here, we have some
question about that:
    1. Why not use timeout mechanism?
    2. If timeout mechanism is used, the process will enter
 wait_event after wait_event_interruptible_timeout?

