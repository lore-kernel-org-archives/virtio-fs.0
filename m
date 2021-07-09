MIME-Version: 1.0
References: <20210708175738.360757-1-vgoyal@redhat.com>
	<20210708175738.360757-2-vgoyal@redhat.com>
	<20210709091915.2bd4snyfjndexw2b@wittgenstein>
	<20210709152737.GA398382@redhat.com>
	<710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
	<20210709175947.GB398382@redhat.com>
In-Reply-To: <20210709175947.GB398382@redhat.com>
From: Bruce Fields <bfields@redhat.com>
Date: Fri, 9 Jul 2021 16:10:16 -0400
Message-ID: <CAPL3RVGKg4G5qiiHo7KYPcsWWgeoW=qNPOSQpd3Sv329jrWrLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2 1/1] xattr: Allow user.* xattr on symlink
	and special files
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: gscrivan@redhat.com, tytso@mit.edu, miklos@szeredi.hu, selinux@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, Casey Schaufler <casey@schaufler-ca.com>, jack@suse.cz, Christian Brauner <christian.brauner@ubuntu.com>, casey.schaufler@intel.com

On Fri, Jul 9, 2021 at 1:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> nfs seems to have some issues.

I'm not sure what the expected behavior is for nfs.  All I have for
now is some generic troubleshooting ideas, sorry:

> - I can set user.foo xattr on symlink and query it back using xattr name.
>
>   getfattr -h -n user.foo foo-link.txt
>
>   But when I try to dump all xattrs on this file, user.foo is being
>   filtered out it looks like. Not sure why.

Logging into the server and seeing what's set there could help confirm
whether it's the client or server that's at fault.  (Or watching the
traffic in wireshark; there are GET/SET/LISTXATTR ops that should be
easy to spot.)

> - I can't set "user.foo" xattr on a device node on nfs and I get
>   "Permission denied". I am assuming nfs server is returning this.

Wireshark should tell you whether it's the server or client doing that.

The RFC is https://datatracker.ietf.org/doc/html/rfc8276, and I don't
see any explicit statement about what the server should do in the case
of symlinks or device nodes, but I do see "Any regular file or
directory may have a set of extended attributes", so that was clearly
the assumption.  Also, NFS4ERR_WRONG_TYPE is listed as a possible
error return for the xattr ops.  But on a quick skim I don't see any
explicit checks in the nfsd code, so I *think* it's just relying on
the vfs for any file type checks.

--b.

