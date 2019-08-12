Date: Mon, 12 Aug 2019 08:48:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190812124818.GA19506@redhat.com>
References: <20190809192708.GA2431@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809192708.GA2431@redhat.com>
Subject: Re: [Virtio-fs] Vivek's Status (Week starting 5th August, 2019)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

Oops, posted to wrong list. Please ignore.

Vivek

On Fri, Aug 09, 2019 at 03:27:08PM -0400, Vivek Goyal wrote:
> virtio_fs
> =========
> - Fixed bunch of issues and rebased virtio_fs patches to 5.3-rc kernel
>   and pushed to private branch.
> 
>   https://github.com/rhvgoyal/linux/commits/vivek-5.3-aug-07-2019
> 
> - Took care of some of the issues Liu Bo pointed in virtio_fs.
> 
>   https://github.com/rhvgoyal/linux/commit/0434504ec11dc2b884939b32d6dde6c9c92def94
>   https://github.com/rhvgoyal/linux/commit/127e2551f263a0cc7c6a4f18cbbd55693dfee4d9
> 
> - Reviwed ftrace event patch for virtio_fs.
> 
>   https://www.redhat.com/archives/virtio-fs/2019-August/msg00072.html
> 
> - Bunch of other activity on virtio-fs list.
> 
>   https://www.redhat.com/archives/virtio-fs/2019-August/msg00103.html
>   https://www.redhat.com/archives/virtio-fs/2019-August/msg00080.html
>   https://www.redhat.com/archives/virtio-fs/2019-August/msg00074.html
>   https://www.redhat.com/archives/virtio-fs/2019-August/msg00054.html
>   https://www.redhat.com/archives/virtio-fs/2019-August/msg00044.html
> 
> Containers + Overlayfs
> ======================
> - Spent some time debugging the overlayfs issue Dan Walsh pointed to where
>   mounter does not have CAP_DAC_OVERRIDE and then chmod fails.
> 
>   https://github.com/containers/libpod/issues/3684#issuecomment-519574675
> 
> - Looked into the issue of overlayfs not working on top of virtio-fs.
> 
>   https://github.com/kata-containers/runtime/issues/1888#issuecomment-518259095 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

