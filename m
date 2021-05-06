Date: Thu, 6 May 2021 11:00:05 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJO+JVvEU3BM0SWi@work-vm>
References: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
	<20210414201207.3612432-2-jose.carlos.venegas.munoz@intel.com>
	<20210416130537.2046bd26@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416130537.2046bd26@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofsd: Allow use "-o xattrmap"
 without "-o xattr"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, Carlos Venegas <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, vgoyal@redhat.com

* Greg Kurz (groug@kaod.org) wrote:
> On Wed, 14 Apr 2021 20:12:06 +0000
> Carlos Venegas <jose.carlos.venegas.munoz@intel.com> wrote:
> 
> > When -o xattrmap is used, it will not work unless xattr is enabled.
> > 
> > This patch enables xattr when -o xattrmap is used.
> > 
> > Signed-off-by: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index ddaf57305c..2337ea5a58 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -3939,6 +3939,7 @@ int main(int argc, char *argv[])
> >      }
> >  
> >      if (lo.xattrmap) {
> > +        lo.xattr = 1;
> >          parse_xattrmap(&lo);
> >      }
> >  
> 
> This seems reasonable. I'm just wondering if we should also
> add an explicit error if the user tries something silly
> like -o xattrmap=MAPPING,no_xattr instead of silently
> ignoring no_xattr...

That would be a nice addition, although I'll take this set is for now.

Dave

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

