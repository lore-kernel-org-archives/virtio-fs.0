Date: Mon, 17 May 2021 09:08:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210517130850.GD546943@horse.lan>
References: <20210511213736.281016-1-vgoyal@redhat.com>
	<34daab90-0e71-20c1-139d-ac0e084f8ed0@redhat.com>
MIME-Version: 1.0
In-Reply-To: <34daab90-0e71-20c1-139d-ac0e084f8ed0@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 0/7] virtiofsd: Few cleanups in
 virtio_send_data_iov()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, May 13, 2021 at 03:50:33PM -0500, Connor Kuehl wrote:
> On 5/11/21 4:37 PM, Vivek Goyal wrote:
> > Hi,
> > 
> > Code in virtio_send_data_iov() little twisted and complicated. This
> > patch series just tries to simplify it a bit to make it little easier
> > to read this piece of code.
> > 
> > Thanks
> > Vivek
> > 
> > Vivek Goyal (7):
> >   virtiofsd: Check for EINTR in preadv() and retry
> >   virtiofsd: Get rid of unreachable code in read
> >   virtiofsd: Use iov_discard_front() to skip bytes
> >   virtiofsd: get rid of in_sg_left variable
> >   virtiofsd: Simplify skip byte logic
> >   virtiofsd: Check EOF before short read
> >   virtiofsd: Set req->reply_sent right after sending reply
> > 
> >  tools/virtiofsd/fuse_virtio.c | 67 +++++++++++------------------------
> >  1 file changed, 21 insertions(+), 46 deletions(-)
> > 
> 
> With the codestyle fix to appease the bot:
> 
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> 
> (For the series)

Thanks. I will fix the coding style issue and repost the patch series.

Vivek

