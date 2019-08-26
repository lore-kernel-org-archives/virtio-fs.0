Date: Mon, 26 Aug 2019 17:35:36 +0200
From: Cornelia Huck <cohuck@redhat.com>
Message-ID: <20190826173536.1ced9da7.cohuck@redhat.com>
In-Reply-To: <20190823175657.12085-3-dgilbert@redhat.com>
References: <20190823175657.12085-1-dgilbert@redhat.com>
	<20190823175657.12085-3-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH v2 2/2] virtio: add
 vhost-user-fs-pci device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

On Fri, 23 Aug 2019 18:56:57 +0100
"Dr. David Alan Gilbert (git)" <dgilbert@redhat.com> wrote:

> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Add the PCI version of vhost-user-fs.
> 
> Launch QEMU like this:
> 
>   qemu -chardev socket,path=/tmp/vhost-fs.sock,id=chr0
>        -device x-vhost-user-fs-pci,tag=myfs,chardev=chr0
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  hw/virtio/Makefile.objs       |  1 +
>  hw/virtio/vhost-user-fs-pci.c | 85 +++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
>  create mode 100644 hw/virtio/vhost-user-fs-pci.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

I still need to try and send out that patch wiring it up for ccw...

