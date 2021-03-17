Date: Wed, 17 Mar 2021 09:19:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210317131906.GB324911@redhat.com>
References: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
	<CAOssrKcY7o_LOabLiy+86LFZ1aQdqq8EOaM=qjRqHKGUqRup6w@mail.gmail.com>
	<2d94bc7c-e999-44b1-7813-6269cbfcf54e@redhat.com>
	<CAOssrKeVf-8pNyFuyVpTTUZbMaU9N8E-Q3-p7xfa=gsmQYk-1A@mail.gmail.com>
	<2622824d-5f59-0d4a-635b-4257ee7cab3c@redhat.com>
	<CAOssrKdn-RkxK4DjRy_36se=oE4edL3Yq5FsY3SknV-cYEY9Jg@mail.gmail.com>
	<fc44b1ac-6b9a-14c5-42f5-f7fc50fbfb74@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc44b1ac-6b9a-14c5-42f5-f7fc50fbfb74@redhat.com>
Subject: Re: [Virtio-fs] Securing file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, Mar 16, 2021 at 06:28:24PM +0100, Max Reitz wrote:
> On 08.03.21 15:50, Miklos Szeredi wrote:
> > On Mon, Mar 8, 2021 at 2:39 PM Max Reitz <mreitz@redhat.com> wrote:
> > 
> > > Admittedly I’m not yet at the point where I feel comfortable doing
> > > changes to the kernel at all, so if you have the time, I’d appreciate
> > > it.  (If you don’t really have the time, I could try my hand first and
> > > then we’d see.)
> > 
> > I'd hate to context switch away from the fuse leases to the kernel
> > crypto, so it would have to wait some time...
> > 
> > But I've attached an incomplete patch that just missing the crypto
> > bits and testing.
> > 
> > Would you mind having a go at it?
> 
> Thanks, I’ll look into the crypto stuff and have a go.  (Sorry for the
> delay...)
> 
> I’d still prefer a service process instead of putting this in the kernel,
> but let’s see how complicated it would be.  I suppose one problem with
> putting it into a service process is that doing so wouldn’t help with
> containers: If containers don’t allow CAP_DAC_READ_SEARCH, we I suppose
> it’ll be difficult to give it even to such a service process.
> 
> One thing that also needs to be solved is how to specify a persistent key.
> I suppose the idea in your patch is to generate a random key for every new
> process, but we would need a persistent key.  With a service process, it
> could be configured by the user to use a specific key, or perhaps it has
> kind of small database and virtiofsd selects its persistent key by a hash of
> it or some other ID that it has received from the service process.
> 
> I don’t know how you’d go making the kernel store persistent keys, though.

Is it possible to load persistent key from user space into a keyring
using keyctl. 

Vivek

> 
> Max
> 
> > > So AFAIU you want to put this in the kernel so we can get rid of needing
> > > the capability, because when you can only open handles that were
> > > previously generated for you, there wouldn’t be a security problem, right?
> > 
> > Something like that.
> > 
> > > But what about cases where a file is made inaccessible to some process
> > > between generating the handle and later opening it?  E.g. in
> > > /path/to/file, the “to” directory is changed to go-x (and the current
> > > user is not the owner), so opening /path/to/file wouldn’t be possible by
> > > path anymore.  Sure, if the FD remained open, you could still open the
> > > file anyway; but I consider it different in semantics.  (E.g. you could
> > > check that there are no processes that have “file” open anymore, and so
> > > you could assume that it’s now inaccessible.)
> > 
> > That could be a concern, yes.   Requiring CAP_DAC_READ_SEARCH in the
> > current user namespace, as my template patch does, might mitigate
> > those worries somewhat.
> > 
> > Thanks,
> > Miklos
> > 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

