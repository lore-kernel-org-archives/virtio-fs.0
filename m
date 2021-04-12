Date: Mon, 12 Apr 2021 14:05:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210412180519.GC1199348@redhat.com>
References: <20210408175150.GA1053917@redhat.com>
 <YHSJbL8in1BhMuyu@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHSJbL8in1BhMuyu@work-vm>
Subject: Re: [Virtio-fs] [RFC] Using hard links instead of lo_inode->fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Apr 12, 2021 at 06:54:52PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > Hi All,
> > 
> > Max has been trying to solve the problem of not having to keep an O_PATH
> > fd open for every file (until inode goes away). Lot of inodes can get
> > cached in guest inode cache and soon we can hit number of max fd limit.
> > 
> > Today Christophe de Dinechin mentioned that can we maintain hardlinks
> > for these files and open these hardlinks instead whenever we need
> > lo_inode->fd.
> > 
> > So say there is a notion of "workdir" which is passed to virtiofs where
> > virtiofsd can create hardlinks. Once inode comes into existence, we
> > create this link in workdir/<file-link>. Once last reference to inode
> > is dropped, workdir/<file-link> is removed.
> > 
> > Now any operation which needs the lo_inode->fd, can do operation on
> > workdir/<file-link>.
> > 
> > How does this proposal sound. What are the issues where. Some of the
> > which came to surface during discussion with david gilbert are.
> > 
> > 1. links can't be created for directories. So this will only help with
> >   regular files. 
> > 
> > 2. There might be a performance penalty. We don't know yet.
> > 
> > 3. More overhead of managing workdir by the user/tools.
> > 
> > 
> > Anything else? Is this a viable idea even if we can implement only
> > for regular files.
> 
> The other one is that linkat(, AT_EMPTY_PATH) which can create the
> link from the existing O_PATH we have, can only be used with
> CAP_DAC_READ_SEARCH - which is a shame since otherwise it would seem to
> make life easier.

But that does not mitigate issues w.r.t submounts (links across
filesytem) and ctime updates?

So only thing this linkat(,AT_EMPTY_PATH) seems to buy is that link
source can be an fd instead of path, right? 

Vivek

