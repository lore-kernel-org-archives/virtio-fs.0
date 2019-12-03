Date: Tue, 3 Dec 2019 09:17:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191203141759.GA7810@redhat.com>
References: <20191203131423.40962-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203131423.40962-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] Convert to cap-ng
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On Tue, Dec 03, 2019 at 01:14:21PM +0000, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Hi,
>   This changes virtiofsd to use cap-ng rather than cap
> (qemu is moving in that direction).  It's a little painful
> because of an interaction with our sandboxing.
> 
> I intend to flatten the conversion into Vivek's patch that
> adds the libcap use.

It feels ugly that we store the parent process's state in a global
variable and all the threads load their state from there. At the
same time I don't have any good idea how to solve this problem given
libcap-ng relies on /proc being there. So I am fine with the patches.

Thanks
Vivek
> 
> Dave
> 
> Dr. David Alan Gilbert (2):
>   virtiofsd: cap-ng helpers
>   virtiofsd: Convert to libcap-ng
> 
>  Makefile                           |   2 +-
>  contrib/virtiofsd/Makefile.objs    |   2 -
>  contrib/virtiofsd/passthrough_ll.c | 162 +++++++++++++++++++----------
>  3 files changed, 106 insertions(+), 60 deletions(-)
> 
> -- 
> 2.23.0
> 

