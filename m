Date: Tue, 20 Aug 2019 13:56:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190820175610.GD4233@redhat.com>
References: <5D53D882.5090803@huawei.com> <5D5A4692.9060006@huawei.com>
	<20190820153926.GC4233@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820153926.GC4233@redhat.com>
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

On Tue, Aug 20, 2019 at 11:39:26AM -0400, Vivek Goyal wrote:
> On Mon, Aug 19, 2019 at 02:49:54PM +0800, piaojun wrote:
> > When O_DIRECT flags is set by Guest, virtiofsd will open file with
> > O_DIRECT, but unset 'fi->direct_io' which makes Guest go buffer io path.
> 
> Where is virtiofsd unset fi->direct_io flag? All I can see is that it
> sets this flag if cache=none?
> 

Ok, I looked at it little bit more closely and I don't think it is a
problem. With cache=always/auto, we don't set fi->direct_io. That means
server is not enforcing a direct I/O policy on client.

Now if client decides to direct I/O by opening file with O_DIRECT, it
will still take direct I/O path and call fuse_direct_IO(). Look at
fuse_file_aops->fuse_direct_IO().

Thanks
Vivek

> Thanks
> Vivek
> 
> > That causes inconsistency between Guest and Host.
> > 
> > The cache option in virtiofsd should not affect the file io mode, so
> > set 'fi->direct_io' according to 'fi->flags'.
> > 
> > Signed-off-by: Jun Piao <piaojun@huawei.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index ca11764..a9c98d0 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1774,8 +1774,10 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> >  		fi->fh = fh;
> >  		err = lo_do_lookup(req, parent, name, &e);
> >  	}
> > -	if (lo->cache == CACHE_NONE)
> > +	if (fi->flags & O_DIRECT)
> >  		fi->direct_io = 1;
> > +	if (lo->cache == CACHE_NONE)
> > +		fi->keep_cache = 0;
> >  	else if (lo->cache == CACHE_ALWAYS)
> >  		fi->keep_cache = 1;
> > 
> > @@ -1982,8 +1984,11 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
> >  	}
> > 
> >  	fi->fh = fh;
> > -	if (lo->cache == CACHE_NONE)
> > +
> > +	if (fi->flags & O_DIRECT)
> >  		fi->direct_io = 1;
> > +	if (lo->cache == CACHE_NONE)
> > +		fi->keep_cache = 0;
> >  	else if (lo->cache == CACHE_ALWAYS)
> >  		fi->keep_cache = 1;
> >  	fuse_reply_open(req, fi);
> > -- 
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

