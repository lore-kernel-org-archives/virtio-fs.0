Date: Thu, 16 Apr 2020 16:10:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200416201022.GD276932@redhat.com>
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
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> whitelisted set of capabilities that we require.  This improves security in
> case virtiofsd is compromised by making it hard for an attacker to gain further
> access to the system.

Hi Stefan,

Good to see this patch. We needed to limit capabilities to reduce attack
surface.

What tests have you run to make sure this current set of whitelisted
capabilities is good enough.

Vivek

> 
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

