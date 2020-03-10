DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=OYU1wxb/ge5DirIWwK28AnywpJQY3e/U9vYLjiccLeo=;
	b=VUMeVtRyDXOmmJAxS6+A2yYelERcpsMobnU+K+HXqAre31LWH5Ybg9m1IevwykOAC8
	LuhKNNqsEpPoC+7agcvG1rpEStM2V2YpmRpy+BjS+BXwOrIaMeNotiWCXzqWdLczA50g
	BSV6AlSgpI8eO6i/dsioSkintiC6wBXLVK/So=
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-8-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-8-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 15:12:51 +0100
Message-ID: <CAJfpeguxR2mR53BHEaSQUq2dN6mUVQHMVCoECrCX1F6x38M-0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 07/20] fuse: Get rid of no_mount_options
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-nvdimm@lists.01.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> This option was introduced so that for virtio_fs we don't show any mounts
> options fuse_show_options(). Because we don't offer any of these options
> to be controlled by mounter.
>
> Very soon we are planning to introduce option "dax" which mounter should
> be able to specify. And no_mount_options does not work anymore. What
> we need is a per mount option specific flag so that fileystem can
> specify which options to show.
>
> Add few such flags to control the behavior in more fine grained manner
> and get rid of no_mount_options.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>


