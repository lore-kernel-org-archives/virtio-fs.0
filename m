Date: Fri, 4 Mar 2022 14:56:57 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20220304145657.3a5fdec4@bahia>
In-Reply-To: <YiIB8XnpQPqktxWG@redhat.com>
References: <20220303171323.580712-1-groug@kaod.org>
	<YiIB8XnpQPqktxWG@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Support FUSE_SYNCFS on
 unannounced submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com

On Fri, 4 Mar 2022 07:11:29 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Mar 03, 2022 at 06:13:21PM +0100, Greg Kurz wrote:
> > This is the current patches I have : one to track submounts
> > and the other to call syncfs() on them. Tested on simple
> > cases only.
> > 
> > I won't be able to work on this anymore, so I'm posting for the
> > records. Anyone is welcome to pick it up as there won't be a v2
> > from my side.
> 
> Thanks Greg. Hopefully somebody else will be able to pick it up.
> 
> What are TODO items to take this patch series to completion.
> 

Compared to the previous try, this basically tracks submount inodes
in a dedicated hash to avoid browsing through all inodes at sync
time.

Given the limited time I had to spend on this, it certainly
requires some more thinking and testing around corner cases.
Since C virtiofsd is being deprecated, I don't think it's
worth investing much in supporting all possible scenarios.
Maybe add sanity checks and proper error handling for things
that would obviously break.

Cheers,

--
Greg

> Vivek
> 
> > 
> > Cheers,
> > 
> > --
> > Greg
> > 
> > Greg Kurz (2):
> >   virtiofsd: Track submounts
> >   virtiofsd: Support FUSE_SYNCFS on unannounced submounts
> > 
> >  tools/virtiofsd/passthrough_ll.c | 61 ++++++++++++++++++++++++++++----
> >  1 file changed, 55 insertions(+), 6 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 
> > 
> 

