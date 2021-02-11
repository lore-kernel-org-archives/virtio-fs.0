Date: Thu, 11 Feb 2021 15:15:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210211201518.GA32784@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-11-dgilbert@redhat.com>
	<20210211123738.GK247031@stefanha-x1.localdomain>
	<YCVduoTmMuV4sOZF@work-vm> <20210211183020.GA29443@redhat.com>
	<YCWKjRST1AYW+//G@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCWKjRST1AYW+//G@work-vm>
Subject: Re: [Virtio-fs] [PATCH 10/24] DAX: virtiofsd: Add setup/remove
 mappings fuse commands
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, mst@redhat.com

On Thu, Feb 11, 2021 at 07:50:37PM +0000, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > On Thu, Feb 11, 2021 at 04:39:22PM +0000, Dr. David Alan Gilbert wrote:
> > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > > On Tue, Feb 09, 2021 at 07:02:10PM +0000, Dr. David Alan Gilbert (git) wrote:
> > > > > +static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
> > > > > +                             struct fuse_mbuf_iter *iter)
> > > > > +{
> > > > > +    struct fuse_removemapping_in *arg;
> > > > > +    struct fuse_removemapping_one *one;
> > > > > +
> > > > > +    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
> > > > > +    if (!arg || arg->count <= 0) {
> > > > 
> > > > arg->count is unsigned so < is tautologous.
> > > > 
> > > > > +        fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid arg %p\n", arg);
> > > > > +        fuse_reply_err(req, EINVAL);
> > > > > +        return;
> > > > > +    }
> > > > > +
> > > > > +    one = fuse_mbuf_iter_advance(iter, arg->count * sizeof(*one));
> > > > 
> > > > arg->count * sizeof(*one) is an integer overflow on 32-bit hosts. I
> > > > think we should be more defensive here since this input comes from the
> > > > guest.
> > > 
> > > OK, so I've gone with:
> > > 
> > >     if (!arg || !arg->count || 
> > >         (uint64_t)arg->count * sizeof(*one) >= SIZE_MAX) {
> > >         fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid arg %p\n", arg);
> > >         fuse_reply_err(req, EINVAL);
> > >         return;
> > 
> > If we did not want to get into unit64_t business, can we alternatively do.
> >      if (!arg || !arg->count || arg->count > SIZE_MAX/sizeof(*one)) {
> 
> I tried that and the compiler moaned that it was always false; which on
> a 64bit host it is since arg->count is uint32_t.

Hmm.... May be something like.

bool is_arg_count_valid()
{
  if (!arg->count)
      return false;

#if __WORDSIZE == 64
   return true;
#elif
  if (argc->count > SIZE_MAX/sizeof(*one))
      return false;
#fi
  return true;
}

if (!argc || !is_arg_count_valie()) {
}

Vivek

