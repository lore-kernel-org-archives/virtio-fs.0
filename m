Date: Wed, 6 Oct 2021 08:54:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YV2coMOSQCVRry8v@redhat.com>
References: <20210930143850.1188628-1-vgoyal@redhat.com>
	<20210930143850.1188628-6-vgoyal@redhat.com>
	<CAJfpeguTohOfd60+vkVMBOHEfcT4T5hTuWtE2pqCLStNTHuZFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguTohOfd60+vkVMBOHEfcT4T5hTuWtE2pqCLStNTHuZFQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 5/8] virtiofs: Add a virtqueue for
	notifications
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org

On Wed, Oct 06, 2021 at 02:46:46PM +0200, Miklos Szeredi wrote:
> On Thu, 30 Sept 2021 at 16:39, Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > @@ -34,10 +35,12 @@ static LIST_HEAD(virtio_fs_instances);
> >
> >  enum {
> >         VQ_TYPE_HIPRIO,
> > -       VQ_TYPE_REQUEST
> > +       VQ_TYPE_REQUEST,
> > +       VQ_TYPE_NOTIFY
> >  };
> >
> >  #define VQ_NAME_LEN    24
> > +#define VQ_NOTIFY_ELEMS 16     /* Number of notification elements */
> 
> Where does this number come from?

I just chose an arbitrary number. Not sure what's a good number and
how to decide that. Good thing is that its not part of the protocol
so guest should be able to change it if need be.

Stefan, do you have any thoughts on this depending on what other
virtio drivers have done w.r.t this.

Thanks
Vivek

