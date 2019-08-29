Date: Thu, 29 Aug 2019 10:31:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190829143107.GB6744@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
	<20190829132949.GA6744@redhat.com>
	<CAJfpegtd-MQNbUW9YuL4xdXDkGR8K6LMHCqDG2Ppu9F_Hyk2RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtd-MQNbUW9YuL4xdXDkGR8K6LMHCqDG2Ppu9F_Hyk2RQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
 virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

On Thu, Aug 29, 2019 at 03:41:26PM +0200, Miklos Szeredi wrote:
> On Thu, Aug 29, 2019 at 3:29 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > #ifdef CONFIG_VIRTIO_FS
> >         /** virtio-fs's physically contiguous buffer for in and out args */
> >         void *argbuf;
> > #endif
> >
> > It should have worked. Not sure why it is not working.
> 
> Needs to be changed to
> 
> #if IS_ENABLED(CONFIG_VIRTIO_FS)
> 
> Pushed out fixed version.

Cool. That works. Faced another compilation error with "make allmodconfig"
config file.

  HDRINST usr/include/linux/virtio_fs.h
error: include/uapi/linux/virtio_fs.h: missing "WITH Linux-syscall-note" for SPDX-License-Identifier
make[1]: *** [scripts/Makefile.headersinst:66: usr/include/linux/virtio_fs.h] Error 1

Looks like include/uapi/linux/virtio_fs.h needs following.

-/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */

Vivek

