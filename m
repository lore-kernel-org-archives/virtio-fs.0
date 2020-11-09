Date: Mon, 9 Nov 2020 09:39:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201109143942.GB1479853@redhat.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
	<20201109100218.GD3024@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109100218.GD3024@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Use --thread-pool-size=0 to mean
 no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

On Mon, Nov 09, 2020 at 10:02:18AM +0000, Dr. David Alan Gilbert wrote:

[..]
> > Given in my tests, most of the workload benefited from
> > --thread-pool-size=0, may be this can be the default and user can
> > opt-in for a thread pool (--thread-pool-size=64) once it is known
> > that a particular workload benefits from it.
> > 
> > David, Stefan, WDYT?
> 
> I think having the option makes sense; the default I'm not sure about;

Ok, for now we can probably just introduce this option. And if further
test results prove it to be faster for most of the people, then we
can consider switching the default.

Vivek

