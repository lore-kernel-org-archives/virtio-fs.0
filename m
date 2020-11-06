Date: Fri, 6 Nov 2020 18:11:55 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201106181155.GR3576@work-vm>
References: <AM0PR03MB629226965B72D3808EFB8795A6EF0@AM0PR03MB6292.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR03MB629226965B72D3808EFB8795A6EF0@AM0PR03MB6292.eurprd03.prod.outlook.com>
Subject: Re: [Virtio-fs] [qemu-web PATCH v2] Add virtio-fs in OSv overview
 blog post
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Fotis Xenakis <foxen@windowslive.com>
Cc: virtio-fs@redhat.com, thuth@redhat.com, qemu-devel@nongnu.org

* Fotis Xenakis (foxen@windowslive.com) wrote:
> This post briefly goes over the main points of virtio-fs and OSv, a
> unikernel running under QEMU/KVM and taking advantage of its virtio-fs
> implementation.
> 
> Changes since v1:
> - Fixed wording and links, as suggested by Thomas Huth.
> - Added a short example of virtio-fs usage in OSv.
> 
> Signed-off-by: Fotis Xenakis <foxen@windowslive.com>

> +One central point is OSv's support for booting from virtio-fs: this enables
> +deploying a modified version or a whole new application **without rebuilding**
> +the image, just by adjusting its root file system contents on the host. Last,
> +owing to the DAX window practically providing low-overhead access to the host's
> +page cache, scalability is also expected to excel, with it being a common
> +concern due to the potentially high density of unikernels per host.

Hi Fotis,
  Since I'm not used to unikernels, I'm a little confused by this; I'd
appreciate some explanation.

  In your unikernel, does the root filesystem just contain data?  I mean
being a 'unikernel' aren't all the binaries and support all linked into
the kernel itself?

Dave
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

