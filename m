Date: Thu, 11 Nov 2021 15:33:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YY1+EYQOXNn0HgVu@redhat.com>
References: <20211102052604.59462-1-jefflexu@linux.alibaba.com>
	<20211102052604.59462-7-jefflexu@linux.alibaba.com>
	<CAJfpegvfQbA32HjqWv9-Ds04W7Qs2idTOP7w5_NvKS_n=0Td7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvfQbA32HjqWv9-Ds04W7Qs2idTOP7w5_NvKS_n=0Td7Q@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v7 6/7] fuse: mark inode DONT_CACHE when per
 inode DAX hint changes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

On Wed, Nov 10, 2021 at 04:50:25PM +0100, Miklos Szeredi wrote:
> On Tue, 2 Nov 2021 at 06:26, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> >
> > When the per inode DAX hint changes while the file is still *opened*, it
> > is quite complicated and maybe fragile to dynamically change the DAX
> > state.
> >
> > Hence mark the inode and corresponding dentries as DONE_CACHE once the
> > per inode DAX hint changes, so that the inode instance will be evicted
> > and freed as soon as possible once the file is closed and the last
> > reference to the inode is put. And then when the file gets reopened next
> > time, the new instantiated inode will reflect the new DAX state.
> >
> > In summary, when the per inode DAX hint changes for an *opened* file, the
> > DAX state of the file won't be updated until this file is closed and
> > reopened later.
> 
> This patch does nothing, since fuse already uses .drop_inode =
> generic_delete_inode, which is has the same effect as setting
> I_DONTCACHE, at least in the fuse case (inode should never be dirty at
> eviction).   In fact it may be cleaner to set I_DONTCACHE
> unconditionally and remove the .drop_inode callback setting.

I thought idea was to drop dentry and not cache it which in turn
will drop dentry's reference on inode and lead to cleanup of inode.

Otherwise dentry might remain cached and which in-turn will keep
inode in cache. Am I missing something.

Thanks
Vivek

