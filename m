Date: Mon, 1 Nov 2021 09:18:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YX/pPpb3OwCVdIx1@redhat.com>
References: <20211011030938.109206-1-jefflexu@linux.alibaba.com>
	<20211011030938.109206-6-jefflexu@linux.alibaba.com>
	<YXBX0flS4CocXyDk@redhat.com>
	<526d3ccc-72ab-ddfe-404b-33667a19583e@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526d3ccc-72ab-ddfe-404b-33667a19583e@linux.alibaba.com>
Subject: Re: [Virtio-fs] [virtiofsd PATCH v6 5/6] virtiofsd: implement file
 size based dax policy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: JeffleXu <jefflexu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hu

On Mon, Nov 01, 2021 at 04:59:20PM +0800, JeffleXu wrote:
> 
> 
> On 10/21/21 1:54 AM, Vivek Goyal wrote:
> > On Mon, Oct 11, 2021 at 11:09:37AM +0800, Jeffle Xu wrote:
> >> When DAX window is fully utilized and needs to be expanded to avoid the
> >> performance fluctuation triggered by DAX window recaliming, it may not
> >> be wise to allocate DAX window for files with size smaller than some
> >> specific point, considering from the perspective of reducing memory
> >> overhead.
> >>
> >> To maintain one DAX window chunk (e.g., 2MB in size), 32KB
> >> (512 * 64 bytes) memory footprint will be consumed for page descriptors
> >> inside guest. Thus it'd better disable DAX for those files smaller than
> >> 32KB, to reduce the demand for DAX window and thus avoid the unworthy
> >> memory overhead.
> >>
> >> Thus only flag the file with FUSE_ATTR_DAX when the file size is greater
> >> than 32 KB. The guest will enable DAX only for those files flagged with
> >> FUSE_ATTR_DAX, when virtiofs is mounted with '-o dax=inode'.
> >>
> >> To be noted that both FUSE_LOOKUP and FUSE_READDIRPLUS are affected, and
> >> will convey FUSE_ATTR_DAX flag to the guest.
> >>
> >> This policy will be used when '-o dax=server' option is specified for
> >> virtiofsd.
> > 
> > So enabling DAX based on size is just one type of policy. Tomorrow one
> > could think of enabling DAX on some other attribute. So only enable it
> > for non-executable files etc. 
> > 
> > We could be more specific and define a policy say "-o dax=filesize". This
> > will allow defining other policies easily later. 
> > 
> > But problem with this option is that defining more complex policies
> > will be hard. Say I want to enable DAX on non-executable files which
> > have size greater than 32K. Being able to combine multiple policies
> > will be easy if we implement separate options/knobs to control them
> > and that will allow turning on multiple policies together.
> > 
> > Say, -o dax_size_threshold=1MB -o dax_no_exec_file
> > 
> > So I guess a generic "-o dax=server" is not a bad idea. As of now this
> > will implement a default size based policy of 32K size. But one can add
> > options later to tweak this.
> > 
> 
> The reason why I originally use the 'dax=server' name is that, I want to
> emphasize that it's a heuristic strategy implemented by virtiofsd
> itself. But now I realized that the input of virtiofsd is all various
> kinds of file attributes, e.g. filesize, persistent inode flags, file
> type, etc, and so "dax=attr" name is also a vague name in this degree.
> 
> Now I prefer "dax=filesize" and "dax=xflag", which shall be more clear
> to users at the first glance. The former allows DAX for those smaller
> than 32KB, while the latter queries the persistent DAX inode flag and
> allows DAX accordingly.
> 
> w.r.t. the complex policy you described, e.g. 'non-executable files
> which have size greater than 32K', indeed we may need more option knobs
> then, maybe "dax=filesize|xflag" need to be transformed to
> "dax_filesize" and "dax_xflag"? But one problem of this multiple option
> knob design is that, it may be meaningless to specify "dax_filesize" and
> "dax_xflag" at the same time.
> 
> In a summary, personally I prefer "dax=filesize" and "dax=xflag" so far,
> and we can tweak this, e.g. expand to multiple option knobs, if it's
> really needed later.

Agreed that more complex policy knobs can come later. Say one wants
to enable dax on every file except file smaller than 32K and on executable
files. Then we could probaby extend syntax to "dax=filesize,no_exec".

I like "dax=filesize". Little concerned about "dax=xflag" as xflag is
pretty generic for all kind of flags. How about "dax=inode" instead. This
is also generic, but atleast matches kernel mount option. Alternatively,
how about "dax=xflag_dax".

May be "dax=inode" will be more intuitive as kernel already has defined
semantics for this.

Thanks
Vivek

