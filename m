Date: Tue, 17 Aug 2021 11:19:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRvTmIjt/WAl/UOP@redhat.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRuCHvhICtTzMK04@work-vm>
	<CAJfpegvM+S5Xru3Yfc88C64mecvco=f99y-TajQBDfkLD-S8zQ@mail.gmail.com>
	<0896b1f6-c8c4-6071-c05b-a333c6cccacd@linux.alibaba.com>
	<CAJfpeguA3zeJq-HJUVZHv4nNybqFezkzPNhcWmj0n5+i7YpW4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguA3zeJq-HJUVZHv4nNybqFezkzPNhcWmj0n5+i7YpW4Q@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, JeffleXu <jefflexu@linux.alibaba.com>

On Tue, Aug 17, 2021 at 04:11:14PM +0200, Miklos Szeredi wrote:

[..]
> > As for virtiofs, Dr. David Alan Gilbert has mentioned that various files
> > may compete for limited DAX window resource.
> >
> > Besides, supporting DAX for small files can be expensive. Small files
> > can consume DAX window resource rapidly, and if small files are accessed
> > only once, the cost of mmap/munmap on host can not be ignored.
> 
> That's a good point.   Maybe we should disable DAX for file sizes much
> smaller than the chunk size?

This indeed seems like a valid concern. 2MB chunk size will consume
512 struct page entries. If an entry is 64 bytes in size, then that's
32K RAM used to access 4K bytes of file. Does not sound like good usage
of resources.

If we end up selectively disabling dax based on file size, two things
come to me mind.

- Will be good if it is users can opt-in for this behavior. There
  might be a class of users who always want to enable dax on all
  files.

- Secondly, we will have to figure out how to do it safely in the
  event of shared filesystem where file size can change suddenly.
  Will need to make sure change from dax to no-dax and vice-versa
  is safe w.r.t page cache and other paths.

Thanks
Vivek

