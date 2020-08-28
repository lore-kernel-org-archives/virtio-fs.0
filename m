Date: Fri, 28 Aug 2020 10:39:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200828143901.GB1115001@redhat.com>
References: <20200819221956.845195-1-vgoyal@redhat.com>
	<CAJfpegv5ro-nJTsbx7DMu6=CDXnQ=dzXBRYEKxKc6Bx+Bxmobw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv5ro-nJTsbx7DMu6=CDXnQ=dzXBRYEKxKc6Bx+Bxmobw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 00/18] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vishal L Verma <vishal.l.verma@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>

On Fri, Aug 28, 2020 at 04:26:55PM +0200, Miklos Szeredi wrote:
> On Thu, Aug 20, 2020 at 12:21 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Hi All,
> >
> > This is V3 of patches. I had posted version v2 version here.
> 
> Pushed to:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#dax
> 
> Fixed a couple of minor issues, and added two patches:
> 
> 1. move dax specific code from fuse core to a separate source file
> 
> 2. move dax specific data, as well as allowing dax to be configured out
> 
> I think it would be cleaner to fold these back into the original
> series, but for now I'm just asking for comments and testing.

Thanks Miklos. I will have a look and test.

Vivek

