Date: Mon, 1 Jul 2019 22:59:38 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190702055937.3ffpwph7anvohmxu@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] data integrity in dax mode
Reply-To: bo.liu@linux.alibaba.com
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

I have a concern about data integrity in dax mode.

For now virtio_fs_copy_from_iter() (i.e. the write direction) only
does copy_from_iter(), which doesn't enforce a clean_cache_range or
CLWB.  And even worse, virtio-fs doesn't have a dax_writepages like,
which can calls dax_writeback_mapping_range().

Correct me if I'm wrong, but did virtio-fs solve it in some way?

thanks,
-liubo

