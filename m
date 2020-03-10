DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=O+5kKx2vjd+32qtXdrToSkdcaTFfCoL0XwTHvIf1Udg=;
	b=aK5PVE29ZcX0JiUctdQKR6J4V8Ui1eAIPqRanRd0A6P1wY0Olma3AwHhrD2PySTEY1
	kZXXW4WCwVRDmSdrzbH44gRLv2dG0A/Uo2FsE583gbPAcJns18ZxYKCVeIw3hoRvR9nW
	X63aa+sKmNAHbQ4QA3pDh67PTQqXiIq2fbgVc=
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-11-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-11-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 20:29:43 +0100
Message-ID: <CAJfpegshzZB=e3npbY3h9VOLMwAgLtQ3PJSC8AupF_d3FW9few@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 10/20] fuse,
	virtiofs: Keep a list of free dax memory ranges
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
> Divide the dax memory range into fixed size ranges (2MB for now) and put
> them in a list. This will track free ranges. Once an inode requires a
> free range, we will take one from here and put it in interval-tree
> of ranges assigned to inode.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>


