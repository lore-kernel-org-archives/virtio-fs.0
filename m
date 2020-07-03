Date: Fri, 3 Jul 2020 13:06:18 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200703120618.GA36813@work-vm>
References: <20200629115420.98443-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629115420.98443-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtiofsd capability changes and
	addition
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

* Dr. David Alan Gilbert (git) (dgilbert@redhat.com) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Hi,
>   This is a set of changes relating to the capability restirctions
> introduced in virtiofsd back in a59feb483b8.
>  
> The first one is a potentially important fix; the missing terminator
> could mean extra capabilities are added based on junk on the stack;
> although that's not been seen in practice.
>  
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Queued

> 
> v2
>   Pass a copy of the parameter list into setup_capabilities
> 
> Dr. David Alan Gilbert (3):
>   virtiofsd: Terminate capability list
>   virtiofsd: Check capability calls
>   virtiofsd: Allow addition or removal of capabilities
> 
>  docs/tools/virtiofsd.rst         |  5 +++
>  tools/virtiofsd/helper.c         |  2 +
>  tools/virtiofsd/passthrough_ll.c | 71 +++++++++++++++++++++++++++++---
>  3 files changed, 73 insertions(+), 5 deletions(-)
> 
> -- 
> 2.26.2
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

