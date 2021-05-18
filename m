Date: Wed, 19 May 2021 03:00:59 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20210518190059.GB118510@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [Question] can we make dax flag per-inode
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Hi,

Currently dax mode is enabled through the mount option "dax", and it
affects all the file IO under virtiofs (Correct me if I was wrong).

My case is that there is only one virtiofs mount point in the guest,
but I don't think that dax would benefit all the files, such as some
files may only be accessed once and setupmapping+page fault overhead
is too much in such cases, thus I would like to see dax flag as a per
inode flag.

So the questions come to, a) how do we set dax flags (we can do chattr
or fuse specific flags passed from the server side), b) should it be
toggled only once?

thanks,
liubo

