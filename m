Date: Fri, 21 Aug 2020 16:59:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200821205937.GC905782@redhat.com>
References: <20200724183812.19573-1-vgoyal@redhat.com>
	<20200724183812.19573-5-vgoyal@redhat.com>
	<CAJfpegu0HKSbY53GBMWSYRYc7NJab+9NAXmfp9ekzU_QCiDCQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu0HKSbY53GBMWSYRYc7NJab+9NAXmfp9ekzU_QCiDCQg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 4/5] fuse: For sending setattr in case of
	open(O_TRUNC)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Fri, Aug 21, 2020 at 05:05:16PM +0200, Miklos Szeredi wrote:
> On Fri, Jul 24, 2020 at 8:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > open(O_TRUNC) will not kill suid/sgid on server and fuse_open_in does not
> > have information if caller has CAP_FSETID or not.
> >
> > So force sending setattr() which is called after open(O_TRUNC) so that
> > server clears setuid/setgid.
> 
> I don't really like the fact that we lose atomicity if
> handle_killpriv_v2 is enabled.
> 
> Let's just add a new flag to open as well.  If a filesystem doesn't
> want to add the complexity of handling that it can still just disable
> atomic_o_trunc.

Ok, will look into adding flag to open.

Vivek

