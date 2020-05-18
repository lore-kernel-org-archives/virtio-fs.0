Date: Mon, 18 May 2020 08:37:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200518123737.GA268933@redhat.com>
References: <VI1PR03MB438360F20BFF32EC2AE5ACCEA6BF0@VI1PR03MB4383.eurprd03.prod.outlook.com>
	<20200515034814.GB49087@rsjd01523.et2sqa>
	<VI1PR03MB4383EAFC7403141AB2278802A6BD0@VI1PR03MB4383.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR03MB4383EAFC7403141AB2278802A6BD0@VI1PR03MB4383.eurprd03.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH] Fix file descriptor passed for setupmapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Fotis Xenakis <foxen@windowslive.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Fri, May 15, 2020 at 04:50:31PM +0000, Fotis Xenakis wrote:
> From: Liu Bo <bo.liu@linux.alibaba.com>
> Sent: Friday, May 15, 2020 06:48
> To: Fotis Xenakis <foxen@windowslive.com>
> Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
> Subject: Re: [Virtio-fs] [PATCH] Fix file descriptor passed for setupmapping
> 
> On Wed, May 13, 2020 at 07:33:56PM +0300, Fotis Xenakis wrote:
> > Currently, during FUSE_SETUPMAPPING, virtiofsd passes the wrong file
> > descriptor for the file to mmap() to QEMU (specifically, it passes the
> > file handle as requested from the guest).
> >
> > This fixes it, using lo_fi_fd() to map the file handle to the right file
> > descriptor on the host.
> >
> 
> Looks good, guest has been setting fi as NULL though.
> As far as I can see, this function is only called from [1], which passes fi as NULL only when the file handle passed from the guest is (uint64_t)-1. In my testing this was never the case though.

Hi Fotis,

Do you know what's different about your setup. This has been working for
me so clearly I am seeing fi as NULL. 

Vivek

