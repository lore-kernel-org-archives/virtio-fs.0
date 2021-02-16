Date: Tue, 16 Feb 2021 10:57:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210216155710.GB10195@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-24-dgilbert@redhat.com>
	<20210211143542.GT247031@stefanha-x1.localdomain>
	<20210211144031.GB5014@redhat.com>
	<20210215155711.GA95852@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215155711.GA95852@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 23/24] vhost-user-fs: Implement drop
 CAP_FSETID functionality
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com, qemu-devel@nongnu.org

On Mon, Feb 15, 2021 at 03:57:11PM +0000, Stefan Hajnoczi wrote:
> On Thu, Feb 11, 2021 at 09:40:31AM -0500, Vivek Goyal wrote:
> > On Thu, Feb 11, 2021 at 02:35:42PM +0000, Stefan Hajnoczi wrote:
> > > On Tue, Feb 09, 2021 at 07:02:23PM +0000, Dr. David Alan Gilbert (git) wrote:
> > > > From: Vivek Goyal <vgoyal@redhat.com>
> > > > 
> > > > As part of slave_io message, slave can ask to do I/O on an fd. Additionally
> > > > slave can ask for dropping CAP_FSETID (if master has it) before doing I/O.
> > > > Implement functionality to drop CAP_FSETID and gain it back after the
> > > > operation.
> > > > 
> > > > This also creates a dependency on libcap-ng.
> > > 
> > > Is this patch only for the case where QEMU is running as root?
> > > 
> > 
> > Yes, it primarily is for the case where qemu is running as root, or
> > somebody managed to launch it non-root but with still having capability
> > CAP_FSETID.
> 
> Running QEMU as root is not encouraged because the security model is
> designed around the principle of least privilege (only give QEMU access
> to resources that belong to the guest).
> 
> What happens in the case where QEMU is not root? Does that mean QEMU
> will drop suid/guid bits even if the FUSE client wanted them to be
> preserved?

QEMU will drop CAP_FSETID only if vhost-user slave asked for it. There
is no notion of gaining CAP_FSETID.

IOW, yes, if qemu is running unpriviliged and does not have CAP_FSETID,
then we will end up clearing setuid bit on host. Not sure how that
problem can be fixed.

Vivek

