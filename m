Date: Mon, 21 Jun 2021 10:35:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210621143511.GA1394463@redhat.com>
References: <20210621062657.3641879-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621062657.3641879-1-hch@lst.de>
Subject: Re: [Virtio-fs] support booting of arbitrary non-blockdevice file
	systems v2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

On Mon, Jun 21, 2021 at 08:26:55AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds support to boot off arbitrary non-blockdevice root file
> systems, based off an earlier patch from Vivek.
> 
> Chances since v1:
>  - don't try to mount every registered file system if none is specified
>  - fix various null pointer dereferences when certain kernel paramters are
>    not set
>  - general refactoring.

Thanks Christoph. This version looks good to me. I tested both with
virtiofs and 9p and it works for me.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

