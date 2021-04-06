Date: Tue, 6 Apr 2021 13:16:05 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YGxRBQebSJJCX/46@work-vm>
References: <20210401145845.78445-1-dgilbert@redhat.com>
	<041f5453-cd97-e31f-2855-7083ba6614fc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <041f5453-cd97-e31f-2855-7083ba6614fc@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix security.capability
	comparison
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Connor Kuehl (ckuehl@redhat.com) wrote:
> On 4/1/21 9:58 AM, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > My security fix for the security.capability remap has a silly early
> > segfault in a simple case where there is an xattrmapping but it doesn't
> > remap the securty.capability.
> 
> s/securty/security

Queued, with that typo fixed

> > 
> > Fixes: e586edcb41054 ("virtiofs: drop remapped security.capability xattr as needed")
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> 
> > ---
> >   tools/virtiofsd/passthrough_ll.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index b144320e48..1553d2ef45 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -2636,7 +2636,8 @@ static void parse_xattrmap(struct lo_data *lo)
> >                   strerror(ret));
> >           exit(1);
> >       }
> > -    if (!strcmp(lo->xattr_security_capability, "security.capability")) {
> > +    if (!lo->xattr_security_capability ||
> > +        !strcmp(lo->xattr_security_capability, "security.capability")) {
> >           /* 1-1 mapping, don't need to do anything */
> >           free(lo->xattr_security_capability);
> >           lo->xattr_security_capability = NULL;
> > 
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

