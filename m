Date: Wed, 21 Aug 2019 09:11:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190821131136.GA2304@redhat.com>
References: <5D53D882.5090803@huawei.com> <5D5A4692.9060006@huawei.com>
	<20190820153926.GC4233@redhat.com>
	<20190820175610.GD4233@redhat.com> <5D5CA2E2.9000802@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D5CA2E2.9000802@huawei.com>
Subject: Re: [Virtio-fs] [PATCH RESEND][RFC] virtiofsd: do not fall back to
 buffer io when cache=auto/always
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

On Wed, Aug 21, 2019 at 09:48:18AM +0800, piaojun wrote:
> 
> 
> On 2019/8/21 1:56, Vivek Goyal wrote:
> > On Tue, Aug 20, 2019 at 11:39:26AM -0400, Vivek Goyal wrote:
> >> On Mon, Aug 19, 2019 at 02:49:54PM +0800, piaojun wrote:
> >>> When O_DIRECT flags is set by Guest, virtiofsd will open file with
> >>> O_DIRECT, but unset 'fi->direct_io' which makes Guest go buffer io path.
> >>
> >> Where is virtiofsd unset fi->direct_io flag? All I can see is that it
> >> sets this flag if cache=none?
> >>
> > 
> > Ok, I looked at it little bit more closely and I don't think it is a
> > problem. With cache=always/auto, we don't set fi->direct_io. That means
> > server is not enforcing a direct I/O policy on client.
> > 
> > Now if client decides to direct I/O by opening file with O_DIRECT, it
> > will still take direct I/O path and call fuse_direct_IO(). Look at
> > fuse_file_aops->fuse_direct_IO().
> 
> The problem is that when Guest open with O_DIRECT, the Host won't set
> open_flags with FOPEN_DIRECT_IO if CACHE_AUTO is set. It makes Guest
> goes into fuse_cache_write_iter() rather than fuse_direct_write_iter().
> In other words, the Guest's I/O mode will be changed by virtiofsd.

I think there are two direct I/O paths. One is where server requests
that direct I/O be done on the file and in that case FOPEN_DIRECT_IO
is set.

Other case is where client initiates direct I/O and in that case
FOPEN_DIRECT_IO is not set and we take regular path which is
capable of doing both direct and buffered I/O. For example, for
reads we do following.

fuse_file_read_iter()
   fuse_cache_read_iter()
      generic_file_read_iter()
	mapping->a_ops->direct_IO() <--- (If iocb->ki_flags & IOCB_DIRECT)
	  fuse_direct_IO()

Similary for write path.

fuse_file_write_iter()
  fuse_cache_write_iter()
     generic_file_direct_write() <----- (If iocb->ki_flags & IOCB_DIRECT)
        mapping->a_ops->direct_IO()
	   fuse_direct_IO()

Can you give it a try. I don't think we have the problem what you
are describing.

> 
> You cleared my first doubt that 'fi->direct_io' and 'fi->keep_cache'
> are used to control Guest I/O mode together, and there may be different
> I/O modes between Guest and Host if I undersatnd it correctly. I admit
> this offers a more flexible config to user, but also introduces more
> complex option. Maybe we could just use *keep_cache* to handle all
> these options.
> 
> My second doubt is that *keep_cache* is used to control whether reusing
> the cache of last open(). IMO, it has nothing to do with the following
> I/O path.

FOPEN_KEEP_CACHE is already part of fuse protocol. cache=always is just
making use of that option so that cache contents are not discarded upon
next open. 

Thanks
Vivek

