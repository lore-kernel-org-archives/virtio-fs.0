Date: Tue, 8 Feb 2022 08:59:38 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YgIw+juiHLCXEhNn@redhat.com>
References: <20220202193935.268777-1-vgoyal@redhat.com>
	<YgEZDOcFr80tZGWd@redhat.com> <YgGM6pA2sXEAMa3a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgGM6pA2sXEAMa3a@redhat.com>
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

On Mon, Feb 07, 2022 at 04:19:38PM -0500, Vivek Goyal wrote:
> On Mon, Feb 07, 2022 at 01:05:16PM +0000, Daniel P. Berrangé wrote:
> > On Wed, Feb 02, 2022 at 02:39:26PM -0500, Vivek Goyal wrote:
> > > Hi,
> > > 
> > > This is V5 of the patches. I posted V4 here.
> > > 
> > > https://listman.redhat.com/archives/virtio-fs/2022-January/msg00041.html
> > > 
> > > These will allow us to support SELinux with virtiofs. This will send
> > > SELinux context at file creation to server and server can set it on
> > > file.
> > 
> > I've not entirely figured it out from the code, so easier for me
> > to ask...
> > 
> > How is the SELinux labelled stored on the host side ? It is stored
> > directly in the security.* xattr namespace,
> 
> [ CC Dan Walsh ]
> 
> I just tried to test the mode where I don't do xattr remapping and try
> to set /proc/pid/attr/fscreate with the context I want to set. It will
> set security.selinux xattr on host.
> 
> But write to /proc/pid/attr/fscreate fails if host does not recognize
> the label sent by guest. I am running virtiofsd with unconfined_t but
> it still fails because guest is trying to create a file with
> "test_filesystem_filetranscon_t" and host does not recognize this
> label. Seeing following in audit logs.
> 
> type=SELINUX_ERR msg=audit(1644268262.666:8111): op=fscreate invalid_context="unconfined_u:object_r:test_filesystem_filetranscon_t:s0"

Yes, that's to be expected if the host policy doesn't know about the
label that the guest is using.

IOW, non-mapping case is only useful if you have a very good match
between host + guest OS policy. This could be useful for an app
like Kata because their guest is not a full OS, it is something
special purpose and tightly controlled.

> So if we don't remap xattrs and host has SELinux enabled, then it probably
> work in very limited circumstances where host and guest policies don't
> conflict. I guess its like running fedora 34 guest on fedora 34 host. 
> I suspect that this will see very limited use. Though I have put the
> code in for the sake of completeness.

For general purpose guest OS virtualization remapping is going to be
effectuively mandatory.  The non-mapped case only usable when you tightly
control the guest OS packages from the host.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

