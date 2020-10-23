Date: Fri, 23 Oct 2020 16:04:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201023150429.GF3038@work-vm>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-3-dgilbert@redhat.com>
	<20201022152853.GC512900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022152853.GC512900@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 2/5] tools/virtiofsd: xattr name
 mappings: Map client xattr names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Wed, Oct 14, 2020 at 07:02:06PM +0100, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > Map xattr names originating at the client; from get/set/remove xattr.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 101 ++++++++++++++++++++++++++++++-
> >  1 file changed, 98 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index f5a33014f9..57ebe17ed6 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -2183,20 +2183,80 @@ static XattrMapEntry *parse_xattrmap(struct lo_data *lo)
> >      return res;
> >  }
> >  
> > -static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
> > +/*
> > + * For use with getxattr/setxattr/removexattr, where the client
> > + * gives us a name and we may need to choose a different one.
> > + * Allocates a buffer for the result placing it in *out_name.
> > + *   If there's no change then *out_name is not set.
> > + * Returns 0 on success
> > + * Can return -EPERM to indicate we block a given attribute
> > + *   (in which case out_name is not allocated)
> > + * Can return -ENOMEM to indicate out_name couldn't be allocated.
> > + */
> > +static int xattr_map_client(const struct lo_data *lo, const char *client_name,
> > +                            char **out_name)
> > +{
> > +    const XattrMapEntry *cur_entry;
> > +
> > +    for (cur_entry = lo->xattr_map_list; ; cur_entry++) {
> > +        if ((cur_entry->flags & XATTR_MAP_FLAG_CLIENT) &&
> > +            (strstart(client_name, cur_entry->key, NULL))) {
> > +            if (cur_entry->flags & XATTR_MAP_FLAG_END_BAD) {
> > +                return -EPERM;
> > +            }
> > +            if (cur_entry->flags & XATTR_MAP_FLAG_END_OK) {
> > +                /* Unmodified name */
> > +                return 0;
> > +            }
> > +            if (cur_entry->flags & XATTR_MAP_FLAG_PREFIX) {
> 
> I am wondering why do have "END" substring in BAD and OK flags while
> we don't have one in PREFIX flag. IOW, why not simply call these
> flags as XATTR_MAP_FLAG_OK and XATTR_MAP_FLAG_BAD respectively.

OK, the END_'s have gone.

> > +                *out_name = g_try_malloc(strlen(client_name) +
> > +                                         strlen(cur_entry->prepend) + 1);
> 
> Should we check for cur_entry->prepend to be NULL before we try to
> allocate out_name. One could say.
> 
> "prefix:client:trusted.::". In that case we are not supposed to prefix
> anything?

We shouldn't need to do the NULL check; cur_entry->prepend should = ""
in that case, not NULL.

Dave


> > +                if (!*out_name) {
> > +                    return -ENOMEM;
> > +                }
> > +                sprintf(*out_name, "%s%s", cur_entry->prepend, client_name);
> > +                return 0;
> > +            }
> > +        }
> > +    }
> > +
> > +    /* Shouldn't get here - rules should have an END_* */
> > +    abort();
> > +}
> 
> Thanks
> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

