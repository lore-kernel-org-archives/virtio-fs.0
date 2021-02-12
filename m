From: Luis Henriques <lhenriques@suse.de>
Date: Fri, 12 Feb 2021 10:30:13 +0000
Message-ID: <87r1llk28a.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [Virtio-fs] Question on ACLs support in virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi!

I've recently executed the generic fstests on virtiofs and decided to have
a closer look at generic/099 failure.  In a nutshell, here's the sequence
of commands that reproduce that failure:

# umask 0
# mkdir acldir
# chacl -b "u::rwx,g::rwx,o::rwx" "u::r-x,g::r--,o::---" acldir
# touch acldir/file1
# umask 722
# touch acldir/file2
# ls -l acldir
total 0
-r--r----- 1 root root 0 Feb 12 10:04 file1
----r----- 1 root root 0 Feb 12 10:05 file2

The failure is that setting umask to 722 shouldn't affect the new file2
because acldir has a default ACL (from umask(2): "... if the parent
directory has a default ACL (see acl(5)), the umask is ignored...").

So... I tried to have look at the code, and initially I thought that the
problem was in (kernel) function fuse_create_open(), where we have this:

	if (!fm->fc->dont_mask)
		mode &= ~current_umask();

but then I went down the rabbit hole, into the user-space code, and
couldn't reach a conclusion.  Maybe the issue is that there's in fact no
support for this POSIX ACLs in virtiofs/FUSE?  Any ideas?

Cheers,
-- 
Luis

