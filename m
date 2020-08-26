Date: Wed, 26 Aug 2020 15:53:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200826195311.GB1043442@redhat.com>
References: <20200819221956.845195-1-vgoyal@redhat.com>
	<20200819221956.845195-12-vgoyal@redhat.com>
	<CAJfpegsgHE0MkZLFgE4yrZXO5ThDxCj85-PjizrXPRC2CceT1g@mail.gmail.com>
	<20200826155142.GA1043442@redhat.com>
	<20200826173408.GA11480@stefanha-x1.localdomain>
	<20200826191711.GF3932@work-vm>
	<CAJfpegvqZUXsvbWg8K-xosNR+RVwRm2KH+S9mKs6n6Sv65s+Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvqZUXsvbWg8K-xosNR+RVwRm2KH+S9mKs6n6Sv65s+Qg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 11/18] fuse: implement FUSE_INIT
	map_alignment field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Wed, Aug 26, 2020 at 09:26:29PM +0200, Miklos Szeredi wrote:
> On Wed, Aug 26, 2020 at 9:17 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> 
> > Agreed, because there's not much that the server can do about it if the
> > client would like a smaller granularity - the servers granularity might
> > be dictated by it's mmap/pagesize/filesystem.  If the client wants a
> > larger granularity that's it's choice when it sends the setupmapping
> > calls.
> 
> What bothers me is that the server now comes with the built in 2MiB
> granularity (obviously much larger than actually needed).
> 
> What if at some point we'd want to reduce that somewhat in the client?
>   Yeah, we can't.   Maybe this is not a kernel problem after all, the
> proper thing would be to fix the server to actually send something
> meaningful.

Hi Miklos,

Current implementation of virtiofsd reports this map alignment as
PAGE_SIZE.

        /* This constraint comes from mmap(2) and munmap(2) */
        outarg.map_alignment = ffsl(sysconf(_SC_PAGE_SIZE)) - 1;

Which should be 4K on x86. 

And that means if client wants it can drop to dax mapping size as
small as 4K and still meeting alignment constratints. Just that by
default we have chosen 2MB as of now fearing there might be too
many small mmap() calls on host and we will hit various limits.

Thanks
Vivek

