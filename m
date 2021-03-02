Date: Tue, 2 Mar 2021 09:22:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210302142246.GC220334@redhat.com>
References: <20210226183357.28467-1-lhenriques@suse.de>
	<20210301163324.GC186178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301163324.GC186178@redhat.com>
Subject: Re: [Virtio-fs] [RFC PATCH] fuse: Clear SGID bit when setting mode
	in setacl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Mar 01, 2021 at 11:33:24AM -0500, Vivek Goyal wrote:
> On Fri, Feb 26, 2021 at 06:33:57PM +0000, Luis Henriques wrote:
> > Setting file permissions with POSIX ACLs (setxattr) isn't clearing the
> > setgid bit.  This seems to be CVE-2016-7097, detected by running fstest
> > generic/375 in virtiofs.  Unfortunately, when the fix for this CVE landed
> > in the kernel with commit 073931017b49 ("posix_acl: Clear SGID bit when
> > setting file permissions"), FUSE didn't had ACLs support yet.
> 
> Hi Luis,
> 
> Interesting. I did not know that "chmod" can lead to clearing of SGID
> as well. Recently we implemented FUSE_HANDLE_KILLPRIV_V2 flag which
> means that file server is responsible for clearing of SUID/SGID/caps
> as per following rules.
> 
>     - caps are always cleared on chown/write/truncate
>     - suid is always cleared on chown, while for truncate/write it is cleared
>       only if caller does not have CAP_FSETID.
>     - sgid is always cleared on chown, while for truncate/write it is cleared
>       only if caller does not have CAP_FSETID as well as file has group execute
>       permission.
> 
> And we don't have anything about "chmod" in this list. Well, I will test
> this and come back to this little later.

Looks like I did not notice the setattr_prepare() call in
fuse_do_setattr() which clears SGID in client itself and server does not
have to do anything extra. So it works.

IOW, FUSE_HANDLE_KILLPRIV_V2 will not handle this particular case and
fuse client will clear SGID on chmod, if need be.

Vivek

