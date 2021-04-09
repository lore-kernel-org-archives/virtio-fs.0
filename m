Date: Fri, 9 Apr 2021 08:59:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210409125917.GB1111800@redhat.com>
References: <20210408175150.GA1053917@redhat.com>
	<927a6729-4b5d-f323-2a05-869256ff946d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <927a6729-4b5d-f323-2a05-869256ff946d@redhat.com>
Subject: Re: [Virtio-fs] [RFC] Using hard links instead of lo_inode->fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Apr 09, 2021 at 11:53:34AM +0200, Max Reitz wrote:
> On 08.04.21 19:51, Vivek Goyal wrote:
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
> >    regular files.
> > 
> > 2. There might be a performance penalty. We don't know yet.
> > 
> > 3. More overhead of managing workdir by the user/tools.
> > 
> > 
> > Anything else? Is this a viable idea even if we can implement only
> > for regular files.
> 
> What would happen with submounts?  Wouldn’t we need a workdir per shared
> filesystem then?  (Perhaps not with bind mounts as submounts, I don’t know
> whether hard links work across all bind mounts of some FS.)

That's a good point Max. I don't think hard links can be created
across FS boundaries. So if there are submounts from other filesystems,
then there will have to be workdir on that filesystem, IIUC. Hmm..,
this sounds like a very significant limitation of this proposal.

Thanks
Vivek

