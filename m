DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=TYKPTufiMBAMoTNCgDN7PLKKjOS7TYvnr9DjmBNmXfM=;
	b=FaUxUnjKb0N9Xw2K3ckURq7XBP2BC7VSd74QmXqnGlHpmfsTcG0/cbq0wjQ72NwmtM
	/XRHgHj1rfJMGI+1Wj3VNHM4uo0IrKuS9FTep4/wvrAttKznUFlA2UZIfJWJPZoJ06Ei
	s2yVxWhOI+28JDFT+R83RAGBwXVvIqe78CshI=
MIME-Version: 1.0
References: <20200819221956.845195-1-vgoyal@redhat.com>
	<20200819221956.845195-12-vgoyal@redhat.com>
	<CAJfpegsgHE0MkZLFgE4yrZXO5ThDxCj85-PjizrXPRC2CceT1g@mail.gmail.com>
	<20200826155142.GA1043442@redhat.com>
	<20200826173408.GA11480@stefanha-x1.localdomain>
	<20200826191711.GF3932@work-vm>
In-Reply-To: <20200826191711.GF3932@work-vm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Aug 2020 21:26:29 +0200
Message-ID: <CAJfpegvqZUXsvbWg8K-xosNR+RVwRm2KH+S9mKs6n6Sv65s+Qg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 11/18] fuse: implement FUSE_INIT
	map_alignment field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Aug 26, 2020 at 9:17 PM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:

> Agreed, because there's not much that the server can do about it if the
> client would like a smaller granularity - the servers granularity might
> be dictated by it's mmap/pagesize/filesystem.  If the client wants a
> larger granularity that's it's choice when it sends the setupmapping
> calls.

What bothers me is that the server now comes with the built in 2MiB
granularity (obviously much larger than actually needed).

What if at some point we'd want to reduce that somewhat in the client?
  Yeah, we can't.   Maybe this is not a kernel problem after all, the
proper thing would be to fix the server to actually send something
meaningful.

Thanks,
Miklos

