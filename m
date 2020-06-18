Date: Thu, 18 Jun 2020 17:46:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200618214646.GG3814@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] How to test virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Hi All,

I recently noticed a regression with overlayfs on top virtiofs. I thought
that it will be good to put together a small text file which explains
how to test virtiofs to ensure its sanity. We can run these tests before
merging pathces in virtiofsd or in kernel.

https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/virtio-fs-testing-requirement.txt

For now this document is in my personal repo. I can move it somewhere
else if need be.

This is still work in progress and I will update it once I have got
more testing configurations working.

Any comment or feedback is welcome.

Thanks
Vivek

