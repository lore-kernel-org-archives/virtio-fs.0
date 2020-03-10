DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=yHUlshbt0krVyNx6H5AQrYmBp/rsTRhM/TkVqLTK1cA=;
	b=DWyZY+fN2f5GWPycqc6nfqGuuLyjg3vxp56EkljIp4CFmK4rlXVcYb7WGIIrBmtWz9
	NR+EjtBnZDRvDuMV/aRpSTLTMaQIfWG4nIPbzPJwAM0W39llvBvEuEw3xVXPour1P6cG
	OnrgRxf5sAH77uw+c4f2x0E2WfazdfWrmdTjM=
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-9-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-9-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 15:16:53 +0100
Message-ID: <CAJfpegsY1LBe85-Dx49LwM9TOrHE0aQq1CAtZQdYr4pYn5tBbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 08/20] fuse,
	virtiofs: Add a mount option to enable dax
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
> Add a mount option to allow using dax with virtio_fs.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>


