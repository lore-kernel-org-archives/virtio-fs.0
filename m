Date: Tue, 6 Aug 2019 17:00:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190806210024.GB11513@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] Pushed latest kernel changes with dmap refcount and dax
 page ref fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

Hi Liu Bo,

I have pushed latest kernel changes to my github repo which now contains
your dmap refcount patches, dax crash fix and fixes for races w.r.t
get_user_pages().

I have also done the optimization of unammping only the range which is
being freed (instead of unmapping the whole file). But it works only
if dmap is being freed from worker thread. For inline reclaim path
it has not been done yet and more work is required there.

Please have a look and see if you find any issues.

https://github.com/rhvgoyal/linux/ tags/vivek-aug-06-2019

This patches should work with latest virtiofsd.

Thanks
Vivek

