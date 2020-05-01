Date: Fri, 1 May 2020 19:28:57 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200501182857.GD38251@work-vm>
References: <20200416164907.244868-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416164907.244868-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> whitelisted set of capabilities that we require.  This improves security in
> case virtiofsd is compromised by making it hard for an attacker to gain further
> access to the system.

Queued.

> Stefan Hajnoczi (2):
>   virtiofsd: only retain file system capabilities
>   virtiofsd: drop all capabilities in the wait parent process
> 
>  tools/virtiofsd/passthrough_ll.c | 51 ++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> -- 
> 2.25.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

