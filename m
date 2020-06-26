Date: Fri, 26 Jun 2020 19:42:52 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200626184252.GS3087@work-vm>
References: <20200625162929.46672-1-dgilbert@redhat.com>
	<20200625162929.46672-4-dgilbert@redhat.com>
	<20200626103117.GE281902@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626103117.GE281902@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtiofsd: Allow addition or removal of
	capabilities
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Thu, Jun 25, 2020 at 05:29:29PM +0100, Dr. David Alan Gilbert (git) wrote:
> > +    /*
> > +     * The modcaps option is a colon separated list of caps,
> > +     * each preceded by either + or -.
> > +     */
> > +    while (lo->modcaps) {
> > +        capng_act_t action;
> > +        int cap;
> > +
> > +        char *next = strchr(lo->modcaps, ':');
> > +        if (next) {
> > +            *next = '\0';
> > +            next++;
> > +        }
> > +
> > +        switch (lo->modcaps[0]) {
> > +        case '+':
> > +            action = CAPNG_ADD;
> > +            break;
> > +
> > +        case '-':
> > +            action = CAPNG_DROP;
> > +            break;
> > +
> > +        default:
> > +            fuse_log(FUSE_LOG_ERR,
> > +                     "%s: Expecting '+'/'-' in modcaps but found '%c'\n",
> > +                     __func__, lo->modcaps[0]);
> > +            exit(1);
> > +        }
> > +        cap = capng_name_to_capability(lo->modcaps + 1);
> > +        if (cap < 0) {
> > +            fuse_log(FUSE_LOG_ERR, "%s: Unknown capability '%s'\n", __func__,
> > +                     lo->modcaps);
> > +            exit(1);
> > +        }
> > +        if (capng_update(action, CAPNG_PERMITTED | CAPNG_EFFECTIVE, cap)) {
> > +            fuse_log(FUSE_LOG_ERR, "%s: capng_update failed for '%s'\n",
> > +                     __func__, lo->modcaps);
> > +            exit(1);
> > +        }
> > +
> > +        lo->modcaps = next;
> 
> How about passing char *modcaps into this function so that lo->modcaps
> isn't modified by the parsing loop? That seems a bit cleaner and if we
> ever decide to free lo->modcaps it will work as expected.

Yep, can do.

Dave

> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

