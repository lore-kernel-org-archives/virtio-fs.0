Date: Mon, 7 Feb 2022 13:05:16 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YgEZDOcFr80tZGWd@redhat.com>
References: <20220202193935.268777-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220202193935.268777-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v5 0/9] virtiofsd: Add support for file
 security context at file creation
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Feb 02, 2022 at 02:39:26PM -0500, Vivek Goyal wrote:
> Hi,
> 
> This is V5 of the patches. I posted V4 here.
> 
> https://listman.redhat.com/archives/virtio-fs/2022-January/msg00041.html
> 
> These will allow us to support SELinux with virtiofs. This will send
> SELinux context at file creation to server and server can set it on
> file.

I've not entirely figured it out from the code, so easier for me
to ask...

How is the SELinux labelled stored on the host side ? It is stored
directly in the security.* xattr namespace, or is is subject to
xattr remapping that virtiofsd already supports.

Storing directly means virtiofsd has to run in an essentially
unconfined context, to let it do arbitrary  changes on security.*
xattrs without being blocked by SELinux) and has risk that guest
initiated changes can open holes in the host confinement if
the exported FS is generally visible to processes on the host.


Using remapping lets virtiofsd be strictly isolated by SELinux
policy on the host, and ensures that guest context changes
can't open up holes in the host.

Both are valid use cases, so I'd ultimately expect us to want
to support both, but my preference for a "default" behaviour
would be remapping.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

