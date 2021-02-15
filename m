Date: Mon, 15 Feb 2021 15:52:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210215205221.GB3331@redhat.com>
References: <87r1llk28a.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1llk28a.fsf@suse.de>
Subject: Re: [Virtio-fs] Question on ACLs support in virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: virtio-fs@redhat.com, Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Feb 12, 2021 at 10:30:13AM +0000, Luis Henriques wrote:
> Hi!
> 
> I've recently executed the generic fstests on virtiofs and decided to have
> a closer look at generic/099 failure.  In a nutshell, here's the sequence
> of commands that reproduce that failure:
> 
> # umask 0
> # mkdir acldir
> # chacl -b "u::rwx,g::rwx,o::rwx" "u::r-x,g::r--,o::---" acldir
> # touch acldir/file1
> # umask 722
> # touch acldir/file2
> # ls -l acldir
> total 0
> -r--r----- 1 root root 0 Feb 12 10:04 file1
> ----r----- 1 root root 0 Feb 12 10:05 file2
> 
> The failure is that setting umask to 722 shouldn't affect the new file2
> because acldir has a default ACL (from umask(2): "... if the parent
> directory has a default ACL (see acl(5)), the umask is ignored...").
> 
> So... I tried to have look at the code, and initially I thought that the
> problem was in (kernel) function fuse_create_open(), where we have this:
> 
> 	if (!fm->fc->dont_mask)
> 		mode &= ~current_umask();
> 
> but then I went down the rabbit hole, into the user-space code, and
> couldn't reach a conclusion.  Maybe the issue is that there's in fact no
> support for this POSIX ACLs in virtiofs/FUSE?  Any ideas?

Hi,

[ CC Miklos and linux-fsdevel ]

I debugged into this a little. There are many knobs and it is little
confusing that what are right set of fixes. 

So what's happening in this case is that fc->dont_mask is not set. That
means fuse client is modifying mode using umask. First time you
touch file, umask is 0, so there is no modification. But next time,
you set umask to 722, and fuse modifies mode before sending file
create request to server. virtiofs server is already running with
umask 0, so it does not touch the mode.

So that means, that in case of default acl, fuse client should not
be modifying mode using umask. But question is when should fuse
skip applying umask.

I see that fuse always sets SB_POSIXACL. That means VFS is not
going to apply umask and all the umask handling is with-in fuse.

sb->s_flags |= SB_POSIXACL;

Currently fuse sets fc->dont_mask in two conditions.

- If the caller mounted with flag MS_POSIXACL, then fc->dont_mask is set.
- If fuse server opted in for option FUSE_DONT_MASK, then fc->dont_mask
  is set. 

I see that for virtiofs, both the conditions are not true out of the
box. In fact looks like ACL support is not fully enabled, because
I don't see fuse server opting in for FUSE_POSIX_ACL.

I suspect that we probably should provide an option in virtiofsd to
enable/disable acl support.

Setting FUSE_DONT_MASK is tricky. If we leave it to fuse, that means
fuse will have to query acl to figure out if default acl is set or
not on parent dir. And that data could be stale and there could be
races w.r.t setting acls from other client.

If we do set FUSE_DONT_MASK, that means in file creation path virtiofsd
server will have to switch its umask to one provided in request. Given
its a per process property, we will have to have some locks to make
sure other create requests are not progressing in parallel. And that
hope host does the right thing. That is apply umask if parent dir does
not have default acl otherwise apply umask (as set by virtiofsd process).

Miklos, does above sound reasonable. You might have more thoughts on
how to handle this best in fuse/virtiofs.

Vivek

