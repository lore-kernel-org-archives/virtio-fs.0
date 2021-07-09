Date: Fri, 9 Jul 2021 16:36:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <YOizURuWJO9DYGGk@mit.edu>
References: <20210708175738.360757-1-vgoyal@redhat.com>
	<20210708175738.360757-2-vgoyal@redhat.com>
	<20210709091915.2bd4snyfjndexw2b@wittgenstein>
	<20210709152737.GA398382@redhat.com>
	<710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
MIME-Version: 1.0
In-Reply-To: <710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: gscrivan@redhat.com, jack@suse.cz, miklos@szeredi.hu, selinux@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Jul 09, 2021 at 08:34:41AM -0700, Casey Schaufler wrote:
> >> One question, do all filesystem supporting xattrs deal with setting them
> >> on symlinks/device files correctly?
> > Wrote a simple bash script to do setfattr/getfattr user.foo xattr on
> > symlink and device node on ext4, xfs and btrfs and it works fine.
> 
> How about nfs, tmpfs, overlayfs and/or some of the other less conventional
> filesystems?

As a suggestion, perhaps you could take your bash script and turn it
into an xfstests test so we can more easily test various file systems,
both now and once the commit is accepted, to look for regressions?

Cheers,

					- Ted

