DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=4Dq64x4DjoKFCRaWP0RmVXxQ/yypMvRHHigI32DgfmA=;
	b=IMSgfzJYgymp5J//NAnPuXmv+ttIDEmyfzo3Bl/xD5bXo890r/Y+o2KMqeTHJlcpRr
	LHhWPmBfOOouLuWuT3Uj7HRvFT2ydIXCkZaFwsKzywxSWuEKNBetWQvDVoULEZEDm03p
	tRMUsriMnv8JkVwffZVVKi89BSYtpcGRODjq8=
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-7-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-7-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 15:10:04 +0100
Message-ID: <CAJfpegvKRt6eaZHzs3e70y_c6j5q30jAir6k-hOWevWiQUOVKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 06/20] virtiofs: Provide a helper function
	for virtqueue initialization
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
> This reduces code duplication and make it little easier to read code.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>


