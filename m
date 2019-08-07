Date: Wed, 7 Aug 2019 17:26:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190807212610.GG18557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] Rebased kernel patches to 5.3-rc kernel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>
Cc: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>

Hi All,

I have rebased virtio_fs kernel patches to 5.3-rc kernel and pushed it to my
github repo.

https://github.com/rhvgoyal/linux/commits/vivek-5.3-aug-07-2019

This compiles and passes basic tests. It needs more testing though.

It needs one patch in virtiofsd to change bit position of MAP_ALIGNMENT
flag. I posted a patch for that.

Give it a try and let us know if you face issues.

Thanks
Vivek

