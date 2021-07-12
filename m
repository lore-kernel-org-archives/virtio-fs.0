Date: Mon, 12 Jul 2021 13:50:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210712175032.GB502004@redhat.com>
References: <20210708175738.360757-1-vgoyal@redhat.com>
	<20210708175738.360757-2-vgoyal@redhat.com>
	<20210709091915.2bd4snyfjndexw2b@wittgenstein>
	<20210709152737.GA398382@redhat.com>
	<710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
	<YOizURuWJO9DYGGk@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOizURuWJO9DYGGk@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: gscrivan@redhat.com, jack@suse.cz, miklos@szeredi.hu, selinux@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, Casey Schaufler <casey@schaufler-ca.com>, Christian Brauner <christian.brauner@ubuntu.com>, casey.schaufler@intel.com

On Fri, Jul 09, 2021 at 04:36:33PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 09, 2021 at 08:34:41AM -0700, Casey Schaufler wrote:
> > >> One question, do all filesystem supporting xattrs deal with setting them
> > >> on symlinks/device files correctly?
> > > Wrote a simple bash script to do setfattr/getfattr user.foo xattr on
> > > symlink and device node on ext4, xfs and btrfs and it works fine.
> > 
> > How about nfs, tmpfs, overlayfs and/or some of the other less conventional
> > filesystems?
> 
> As a suggestion, perhaps you could take your bash script and turn it
> into an xfstests test so we can more easily test various file systems,
> both now and once the commit is accepted, to look for regressions?

Sounds good. I see there is already an xattr test (generic/062) which
is broken after my patch. Current test expects that user.* xattrs will
fail on symlink/special device.

I will probably have to query kernel version and modify test so that
expect failure before a certain version and success otherwise.

Thanks
Vivek

