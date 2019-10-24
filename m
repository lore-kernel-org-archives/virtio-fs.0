Date: Thu, 24 Oct 2019 18:13:34 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191024171334.GN2877@work-vm>
References: <OSBPR01MB37837B4AB38461063F645019E56A0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB37837B4AB38461063F645019E56A0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
Subject: Re: [Virtio-fs] False error message when DAX cache is disabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

* misono.tomohiro@fujitsu.com (misono.tomohiro@fujitsu.com) wrote:
> Hi,

Hi Misono,

> I'm testing virtiofs on ARM enviroment.
> Since current ARM does not support DAX, I use cache-size=0 for vhost-user-fs-pci parameter.
> 
> This results in the following error message during unmount:
> ```
> vhost_user_fs_slave_unmap: unmap when DAX cache not present
> lo_destroy: unmap during destroy failed
> ```

Thanks for reporting this,

> This is because lo_destroy() always calls fuse_virtio_unmap().
> So, I want to fix this by not calling fuse_virtio_unmap() when cache is not used,
> but is there any good way for virtiofsd to know vhost-user's cahce-size?

Unfortunately not; that's why I used the special ~0 as a 'unmap all'.
It feels easier to fix the qemu side to be happy unmapping everything
when everything is actually nothing :-)

Does the following (build tested only) patch fix it:

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 6cacdb24b0..07a04d9b21 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -92,10 +92,6 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev, VhostUserFSSlaveMsg *s
         return -1;
     }
     size_t cache_size = fs->conf.cache_size;
-    if (!cache_size) {
-        fprintf(stderr, "%s: unmap when DAX cache not present\n", __func__);
-        return (uint64_t)-1;
-    }
     void *cache_host = memory_region_get_ram_ptr(&fs->cache);
 
     unsigned int i;
@@ -106,13 +102,19 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev, VhostUserFSSlaveMsg *s
      */
     for (i = 0; i < VHOST_USER_FS_SLAVE_ENTRIES; i++) {
         void *ptr;
+        if (sm->len[i] == ~(uint64_t)0) {
+            /* Special case meaning the whole arena */
+            sm->len[i] = cache_size;
+        }
+
         if (sm->len[i] == 0) {
             continue;
         }
 
-        if (sm->len[i] == ~(uint64_t)0) {
-            /* Special case meaning the whole arena */
-            sm->len[i] = cache_size;
+        if (!cache_size) {
+            fprintf(stderr, "%s: unmap when DAX cache not present\n", __func__);
+            res = -1;
+            break;
         }
 
         if ((sm->c_offset[i] + sm->len[i]) < sm->len[i] ||


> Thanks.
> Misono
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

