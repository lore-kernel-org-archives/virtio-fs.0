DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=43SZmp+vV8Sn7GE9PjnhjxxvuNGsA7FckBZzSlZ2a3A=;
	b=TfaRUWxgqzFbKktIb4Hqt920WExOCG8A/B8G6G3gHeQdfzhyhPlBj3W4n4wmXPXo1h
	H3SXSQKn6gjCRj/BO/qLLXhzfMro01CW6pGmfkXR1hG/J0BdHRaNCAoaEamtlVc5Ix0p
	j6FQdh1QoUTYwtEnyVXcm96qmYLTqaCg0ZJ2U=
MIME-Version: 1.0
References: <20200807195526.426056-1-vgoyal@redhat.com>
In-Reply-To: <20200807195526.426056-1-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 10 Aug 2020 09:29:47 +0200
Message-ID: <CAJfpegtboe-XssmqrcvsJm1R0FBP8fYFrTMv5cuBhfmebiGfQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2 00/20] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-kernel@vger.kernel.org

On Fri, Aug 7, 2020 at 9:55 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>

> Most of the changes are limited to fuse/virtiofs. There are couple
> of changes needed in generic dax infrastructure and couple of changes
> in virtio to be able to access shared memory region.

So what's the plan for merging the different subsystems?  I can take
all that into the fuse tree, but would need ACKs from the respective
maintainers.

Thanks,
Miklos

