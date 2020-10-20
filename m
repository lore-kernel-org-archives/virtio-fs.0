Date: Tue, 20 Oct 2020 12:35:30 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201020113530.GC2962@work-vm>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-6-dgilbert@redhat.com>
	<20201020100922.GF140014@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020100922.GF140014@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 5/5] tools/virtiofsd: xattr name
	mappings: Simple 'map'
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Oct 14, 2020 at 07:02:09PM +0100, Dr. David Alan Gilbert (git) wrote:
> > +static XattrMapEntry *parse_xattrmap_map(const char *rule,
> > +                                         XattrMapEntry *map,
> > +                                         size_t *nentries)
> > +{
> > +    char sep = *rule++;
> > +    const char *tmp;
> > +    char *key;
> > +    char *prefix;
> > +    XattrMapEntry tmp_entry;
> > +
> > +    /* At start of 'key' field */
> > +    tmp = strchr(rule, sep);
> 
> Missing sep == '\0' check. The strchr(3) man page says:
> 
>   The terminating null byte is considered part of the string, so that if
>   c is specified as '\0', these functions return a pointer to the
>   terminator.
> 
> So the code in this patch will eventually access beyond the end of the
> string:
> 
>   rule = tmp + 1; <-- tmp is already at the NUL terminator

Ah yes, I've got the check in the main routine but not in the _map case;
OK I'll fix that up.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

