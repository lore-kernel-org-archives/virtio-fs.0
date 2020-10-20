Date: Tue, 20 Oct 2020 10:40:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201020144041.GC380917@redhat.com>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-5-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014180209.49299-5-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 4/5] tools/virtiofsd: xattr name mapping
	examples
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Oct 14, 2020 at 07:02:08PM +0100, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Add a few examples of xattrmaps to the documentation.
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  docs/tools/virtiofsd.rst | 50 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> index a3a120da2f..5cb64612ed 100644
> --- a/docs/tools/virtiofsd.rst
> +++ b/docs/tools/virtiofsd.rst
> @@ -163,6 +163,56 @@ in which case a 'server' rule will always match on all names from
>  the server.
>  
>  
> +xattr-mapping Examples
> +----------------------
> +
> +1) Prefix all attributes with 'user.virtiofs.'
> +
> +::
> +
> +-o xattrmap=":prefix:all::user.virtiofs.::bad:all:::"
> +

Staring at rule.

":bad:all:::"

and trying to map this to ":type:scope:key:prepend:"

type==bad
scope==all
key==""
prepend==""

> +
> +This uses two rules, using : as the field separator;
> +the first rule prefixes and strips 'user.virtiofs.',
> +the second rule hides any non-prefixed attributes that
> +the host set.

What is non-prefixed xattr in this context. If client sends
"security.selinux", is prefixed or non-prefixed.

Documentation in first patch said.

+- 'bad' - If a client tries to use this name it's
+  denied using EPERM; when the server passes an attribute
+  name matching it's hidden.

I am not sure which xattr name will be blocked if key=="" and prepend==""

> +
> +2) Prefix 'trusted.' attributes, allow others through
> +
> +::
> +
> +   "/prefix/all/trusted./user.virtiofs./
> +    /bad/server//trusted./
> +    /bad/client/user.virtiofs.//
> +    /ok/all///"
> +
> +
> +Here there are four rules, using / as the field
> +separator, and also demonstrating that new lines can
> +be included between rules.
> +The first rule is the prefixing of 'trusted.' and
> +stripping of 'user.virtiofs.'.

So this is bidrectional rule, right. For setxattr(), "trusted."
will be replaced with "user.virtiofs" and for listxattr(),
server will replace user.virtiofs with trusted. ?

> +The second rule hides unprefixed 'trusted.' attributes
> +on the host.

If host has "trusted.*", we are not hiding it and as per first
rule we are converting it to "user.virtiofs.trusted.*", right?
So why this second rule is needed.

> +The third rule stops a guest from explicitly setting
> +the 'user.viritofs.' path directly.
> +Finally, the fourth rule lets all remaining attributes
> +through.

So If I don't specify third rule, and client does
setxattr(user.virtiofs.*), it will simply be a passthrough?

Thanks
Vivek

> +
> +3) Hide 'security.' attributes, and allow everything else
> +
> +::
> +
> +    "/bad/all/security./security./
> +     /ok/all///'
> +
> +The first rule combines what could be separate client and server
> +rules into a single 'all' rule, matching 'security.' in either
> +client arguments or lists returned from the host.  This stops
> +the client seeing any 'security.' attributes on the server and
> +stops it setting any.
> +
>  Examples
>  --------
>  
> -- 
> 2.28.0
> 

