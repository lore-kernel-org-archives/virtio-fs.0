Date: Thu, 29 Aug 2019 09:29:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190829132949.GA6744@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
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

On Thu, Aug 29, 2019 at 11:28:27AM +0200, Miklos Szeredi wrote:
> On Wed, Aug 21, 2019 at 7:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Hi,
> >
> > Here are the V3 patches for virtio-fs filesystem. This time I have
> > broken the patch series in two parts. This is first part which does
> > not contain DAX support. Second patch series will contain the patches
> > for DAX support.
> >
> > I have also dropped RFC tag from first patch series as we believe its
> > in good enough shape that it should get a consideration for inclusion
> > upstream.
> 
> Pushed out to
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#for-next
> 

Hi Miklos,

Compilation of virtio-fs as module fails. While it works if compiled as
non-module.

fs/fuse/virtio_fs.c: In function ‘copy_args_to_argbuf’:
fs/fuse/virtio_fs.c:255:5: error: ‘struct fuse_req’ has no member named ‘argbuf’
  req->argbuf = kmalloc(len, GFP_ATOMIC);

It can't find req->argbuf. 

I noticed that you have put ifdef around argbuf.

#ifdef CONFIG_VIRTIO_FS
        /** virtio-fs's physically contiguous buffer for in and out args */
        void *argbuf;
#endif

It should have worked. Not sure why it is not working.

Vivek

