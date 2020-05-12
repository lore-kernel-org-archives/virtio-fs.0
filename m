Date: Tue, 12 May 2020 10:06:51 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20200512020651.GX47669@e18g06458.et15sqa>
References: <1588778444-28375-1-git-send-email-eguan@linux.alibaba.com>
	<CAJfpegsivYq68FjSxAGnszcPJBrJrYG5Gojsc8T+PKup0Cm8fw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegsivYq68FjSxAGnszcPJBrJrYG5Gojsc8T+PKup0Cm8fw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH RFC] fuse: invalidate inode attr in
	writeback cache mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Mon, May 11, 2020 at 03:06:08PM +0200, Miklos Szeredi wrote:
> On Wed, May 6, 2020 at 5:21 PM Eryu Guan <eguan@linux.alibaba.com> wrote:
> >
> > Under writeback mode, inode->i_blocks is not updated, making utils like
> > du read st.blocks as 0.
> >
> > For example, when using virtiofs (cache=always & nondax mode) with
> > writeback_cache enabled, writing a new file and check its disk usage
> > with du, du reports 0 usage.
> 
> Hmm... invalidating the attribute might also yield the wrong result as
> the server may not have received the WRITE request that modifies the
> underlying file.

That's true, I open-write a file then sleep without closing it, and
check file's st_blocks in another terminal, the usage is 0, and remains
0 even after the file is closed, because the wrong attr is cached.

> 
> Invalidating attributes at the end of fuse_flush() definitely makes
> sense, though.

du also reports 0 if I didn't close the file, but I got correct
st_blocks when it's closed.

> 
> If we wanted 100% correct behavior, we'd need to flush WRITE requests
> before each GETATTR request.  That might be a performance bottleneck,
> though.
> 
> So first I'd just try doing the invalidation from fuse_flush().

Sure, will send v2 soon.

> 
> Thanks,
> Miklos

Thanks for the review!

Eryu

