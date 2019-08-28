Date: Wed, 28 Aug 2019 08:27:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190828122749.GA912@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<20190821173742.24574-3-vgoyal@redhat.com>
	<CAJfpegu41FYEBfniEBPtujgLW4nC+w6_6VG2EmNi=kC8ZeNFtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu41FYEBfniEBPtujgLW4nC+w6_6VG2EmNi=kC8ZeNFtA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 02/13] fuse: Use default_file_splice_read
	for direct IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Aug 28, 2019 at 09:45:28AM +0200, Miklos Szeredi wrote:
> On Wed, Aug 21, 2019 at 7:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > From: Miklos Szeredi <mszeredi@redhat.com>
> 
> Nice patch, except I have no idea why I did this.  Splice with
> FOPEN_DIRECT_IO  seems to work fine without it.

I don't know either. I took it because it was there in one of the branches
you were doing development on.

> 
> Anyway, I'll just drop this, unless someone has an idea why it is
> actually needed.

Sure, drop this patch. If need be, we can dig it up later.

Thanks
Vivek

