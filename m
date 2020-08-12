Date: Wed, 12 Aug 2020 17:43:09 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200812164309.GN2810@work-vm>
References: <20200803191511.45261-1-dgilbert@redhat.com>
	<20200803191511.45261-2-dgilbert@redhat.com>
	<20200805124749.GH361702@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805124749.GH361702@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 1/3] tools/virtiofsd: xattr name mappings:
	Add option
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
> On Mon, Aug 03, 2020 at 08:15:09PM +0100, Dr. David Alan Gilbert (git) wrote:
> > diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> > index 824e713491..82b6f6d90a 100644
> > --- a/docs/tools/virtiofsd.rst
> > +++ b/docs/tools/virtiofsd.rst
> > @@ -107,6 +107,51 @@ Options
> >    performance.  ``auto`` acts similar to NFS with a 1 second metadata cache
> >    timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
> >  
> > +xattr-mapping
> > +-------------
> > +
> > +By default the name of xattr's used by the client are passe through to the host
> > +file system.  This can be a problem where either those xattr names are used
> > +by something on the host (e.g. selinux guest/host confusion) or if the
> > +virtiofsd is running in a container with restricted priviliges where it cannot
> > +access some attributes.
> > +
> > +A mapping of xattr names can be made using -o xattrmap=mapping where the ``mapping``
> > +string consists of a series of rules.
> > +
> > +Each rule starts and ends with a ':'.  The mapping stops on a matching
> > +rule.  White space may be added before and after each rule.
> > +
> > +:scope:type:key:prepend:
> > +
> > +scope= 'c' - match 'key' against a xattr name from the client
> > +            for setxattr/getxattr/removexattr
> > +       'h' - match 'prepend' against a xattr name from the host
> > +            for listxattr
> > +       both letters can be included to match both cases.
> > +
> > +type is one of:
> > +       'p' Prefixing: If 'key' matches the client then the 'prepend'
> > +           is added before the name is passed to the host.
> > +           For a host case, the prepend is tested and stripped
> > +           if matching.
> > +
> > +       'o' OK: The attribute name is OK and passed through to
> > +           the host unchanged.
> > +
> > +       'b' Bad: If a client tries to use this name it's
> > +           denied using EPERM; when the host passes an attribute
> > +           name matching it's hidden.
> > +
> > +key is a string tested as a prefix on an attribute name originating
> > +       on the client.  It maybe empty in which case a 'c' rule
> > +       will always match on client names.
> > +
> > +prepend is a string tested as a prefix on an attribute name originiating
> > +       on the host, and used as a new prefix by 'p'.  It maybe empty
> > +       in which case a 'h' rule will always match on host names.
> 
> This syntax and the documentation is hard to understand. Defining
> concrete commands instead of a single super-command would make it more
> straightforward.

Yeh I realised it was getting a bit arcane.

> Here is the functionality I've been able to extract from the
> documentation:
> 
> 1. Rewrite client xattrs
> 
>    rewrite OLD NEW -> s/^OLD/NEW/

It's not actually that flexible; it can only prepend a prefix;
conditionally on a given prefix, i.e.

   s/^OLD/NEWOLD/

it can't do a generic rewrite.  It's precisely the inverse of (4).

> 2. Allow client xattrs
> 
>    allow PREFIX -> allow if matching
> 
> 3. Deny client xattrs
> 
>    deny PREFIX -> EPERM if matching
> 
> 4. Unprefix server xattrs
> 
>    unprefix PREFIX -> s/^PREFIX//
> 
> 5. Hide server xattrs
> 
>    hide PREFIX -> skip if matching
> 
> Did I miss any functionality?

It can explicitly allow server xattrs.

What we have is 
(client, server, all) x ([un-]prefix , good, bad)

> I suggest using "client" and "server" terminology instead of "client"
> and "host".

OK; so the 'server' being the one with the underlying fs from which a
capability is read.

> Prefix syntax: xattr names are matched by prefix. The empty string
> matches all xattr names. How is ':' escaped?

I didn't bother adding any escaping code; do you think we need to
bother? I've not seen any use of an xattr pattern that uses a :  - if
I was going to suggest an easiest thing I think I'd do it like 'sed'
in making the first character be the matching character rather than
explicitly :.

> It is unclear whether 'o' terminates processing immediately. Will later
> 'p' rules still execute?

The point of 'o' and 'b' is to terminate immediately; the idea is to be
able to do something like:

    'trusted.chocolate' -> OK
    'trusted.cheese' -> BAD
    'trusted' -> prefix by user.virtiofs

so that the trusted.something is accepted and stops processing, and then
any other trusted's get prefixed.

> It is unclear whether 'o'/'b' match the original client name or the
> rewritten name after a 'p' command.

Any match terminates; so a 'p' prefixes and that's it - no other command
is processed.

I'll rework so that:
  a) I replace any single letters by an explicit name
  b) I use 'server' instead of host'

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

