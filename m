Date: Thu, 29 Aug 2019 07:58:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190829115822.GA10416@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
 virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

On Thu, Aug 29, 2019 at 11:28:27AM +0200, Miklos Szeredi wrote:
> On Wed, Aug 21, 2019 at 7:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Hi,
> >
> > Here are the V3 patches for virtio-fs filesystem. This time I have
> > broken the patch series in two parts. This is first part which does
> > not contain DAX support. Second patch series will contain the patches
> > for DAX support.
> >
> > I have also dropped RFC tag from first patch series as we believe its
> > in good enough shape that it should get a consideration for inclusion
> > upstream.
> 
> Pushed out to
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#for-next
> 

Awesome.

> Major changes compared to patchset:
> 
>  - renamed to "virtiofs".  Filesystem names don't usually have
> underscore before "fs" postfix.
> 

Sound good to me.

>  - removed option parsing completely.  Virtiofs config is fixed to "-o
> rootmode=040000,user_id=0,group_id=0,allow_other,default_permissions".
> Does this sound reasonable?

These are the options we are using now and looks like they make lot of
sense for virtiofs. I guess if somebody needs a different configuration
later we can introduce option parsing and override these defaults.

> 
> There are miscellaneous changes, so needs to be thoroughly tested.

I will test these.

> 
> I think we also need something in
> "Documentation/filesystems/virtiofs.rst" which describes the design
> (how  request gets to userspace and back) and how to set up the
> server, etc...  Stefan, Vivek can you do something like that?

Sure, I will write up something and take Stefan's input as well.

Thanks
Vivek

