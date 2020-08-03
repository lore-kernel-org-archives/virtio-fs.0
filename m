Date: Mon, 3 Aug 2020 09:57:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200803135715.GA233053@redhat.com>
References: <20200730194736.173994-1-vgoyal@redhat.com>
	<20200730194736.173994-5-vgoyal@redhat.com>
	<20200803095459.GD244853@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803095459.GD244853@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v2 4/5] virtiofsd: Open lo->source while
 setting up root in sandbox=NONE mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: berrange@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com

On Mon, Aug 03, 2020 at 10:54:59AM +0100, Stefan Hajnoczi wrote:
> On Thu, Jul 30, 2020 at 03:47:35PM -0400, Vivek Goyal wrote:
> > In sandbox=NONE mode, lo->source points to the directory which is being
> > exported. We have not done any chroot()/pivot_root(). So open lo->source.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index 76ef891105..a6fa816b6c 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -3209,7 +3209,10 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
> >      int fd, res;
> >      struct stat stat;
> >  
> > -    fd = open("/", O_PATH);
> > +    if (lo->sandbox == SANDBOX_NONE)
> > +        fd = open(lo->source, O_PATH);
> > +    else
> > +        fd = open("/", O_PATH);
> 
> Up until now virtiofsd has been able to assume that path traversal has
> the shared directory as "/".
> 
> Now this is no longer true and it is necessary to audit all syscalls
> that take path arguments. They must ensure that:
> 1. Path components are safe (no ".." or "/" allowed)
> 2. Symlinks are not followed.

This code does not change the path client is passing in and we are
already doing the checks on passed in paths/names. So existing checks
should work even for this case, isn't it?

lo_lookup() {
    if (strchr(name, '/')) {
        fuse_reply_err(req, EINVAL);
        return;
    }
}

lo_do_lookup() {
    /* Do not allow escaping root directory */
    if (dir == &lo->root && strcmp(name, "..") == 0) {
        name = ".";
    }
}

> 
> Did you audit all syscalls made by passthrough_ll.c?
> 
> virtiofsd still needs to restrict the client to the shared directory for
> two reasons:
> 1. The guest may not be trusted. An unprivileged sandbox=none mount can
>    be used with a malicious guest.
> 2. If accidental escapes are possible then the guest could accidentally
>    corrupt or delete files outside the shared directory.

Even if escape is possible, its no different than a malicious user
application running. Given sandbox=none can be used in case of
unpriviliged mode, that means user app can only affect files owned by
that user.

Given we are not doing chroot()/pivot_root(), key question will be
what additional path we are enabling using which one can escape
out of this shared directory.

Having said that, In case of unpriviliged mode, it feels that chroot()
is more of a nice to have kind of functionality. Even if guest manages
to break out of shared directory, impact is equivalent to user running a
malicious app directly. 

If doing chroot/pivot_root is must, then we need additional capabilities.
And that probably means we need to launch virtiofsd in a user namespace
with required caps. And that will fall back into the territory of
running virtiofsd in a user namespace. That indeed is an important
use case which needs to be solved.

Thanks
Vivek

