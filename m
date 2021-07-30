Date: Fri, 30 Jul 2021 08:24:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YQPvcilZ09yByXb5@redhat.com>
References: <20210714202321.59729-1-vgoyal@redhat.com>
	<20210714202321.59729-4-vgoyal@redhat.com>
	<YQNOY9H/6mJMWRNN@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQNOY9H/6mJMWRNN@zeniv-ca.linux.org.uk>
Subject: Re: [Virtio-fs] [PATCH v3 3/3] fs: simplify get_filesystem_list /
 get_all_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de

On Fri, Jul 30, 2021 at 12:57:07AM +0000, Al Viro wrote:
> On Wed, Jul 14, 2021 at 04:23:21PM -0400, Vivek Goyal wrote:
> 
> > +static int __init split_fs_names(char *page, char *names)
> >  {
> > +	int count = 0;
> > +	char *p = page;
> >  
> > +	strcpy(p, root_fs_names);
> > +	while (*p++) {
> > +		if (p[-1] == ',')
> > +			p[-1] = '\0';
> >  	}
> > +	*p = '\0';
> > +
> > +	for (p = page; *p; p += strlen(p)+1)
> > +		count++;
> >  
> > +	return count;
> >  }
> 
> Ummm....  The last part makes no sense - it counts '\0' in the array
> pointed to be page, until the first double '\0' in there.  All of
> which had been put there by the loop immediately prior to that one...

I want split_fs_names() to replace ',' with space as well as return
number of null terminated strings found. So first loop just replaces
',' with '\0' and second loop counts number of strings.

Previously split_fs_names() was only replacing ',' with '\0'. Now
we are changing the semantics and returning number of strings
left in the buffer after the replacement.

I initilaly thought that if I can manage it with single loop but
there were quite a few corner cases. So I decided to use two
loops instead. One for replacement and one for counting.

> 
> Incidentally, it treats stray ,, in root_fs_names as termination;
> is that intentional?

Just trying to keep the existing behavior. Existing get_fs_names(), also
replaces all instances of ',' with '\0'. So if there are two consecutive,
',', that will result in two consecutive '\0' and caller will view
it as end of buffer. 

IOW, rootfsnames=foo,,bar will effectively be treated as "rootfsname=foo".

That's the current behavior and I did not try to improve on it just
keeps on increasing the size of patches. That's probably an improvement
for some other day if somebody cares.

Thanks
Vivek

