Date: Tue, 23 Mar 2021 10:53:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210323145312.GB483930@redhat.com>
References: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
	<YFnC9QXo6uP+2zC1@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFnC9QXo6uP+2zC1@work-vm>
Subject: Re: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "Ge,
	Xiongzi" <Xiongzi.Ge@netapp.com>

On Tue, Mar 23, 2021 at 10:29:09AM +0000, Dr. David Alan Gilbert wrote:
> * Ge, Xiongzi (Xiongzi.Ge@netapp.com) wrote:
> > Hello Vivek, Dr. Gilbert, and the virtio-fs team,
> 
> Hi Xiongzi,
> 
> > It seems that virtio-fs does not support live migration. Once a vm
> > is configured with virtio-fs, live migration cannot be performed even
> > it is not mounted on the guest.
> 
> Right.
> 
> > Is there any progress for this?
> 
> Max Reitz is looking at some parts of it; in particular storing file
> handles that can later be reopened.
> But there are a bunch of other parts we've not looked at yet either
> (like the dirty page marking around all syscalls).
> 
> > If the
> > shared directory is from a distributed file system like Ceph, would it
> > be easier than the general case to be implemented?
> 
> Maybe; there are some tricky semantics problems; for example, lets
> imagine that you open the file   'a/b/c'  on the source, and sometime
> after you open it, 'b' gets renamed to 'd';  when you resume on the
> destination you need to make sure you know how to get to that file.
> Depending on the filesystem semantics you might need to make that work
> even if 'a/b/c' had been deleted but you still had it open.

Hi Dave,

I am assuming that with file handles, renaming of file probably is not
a problem. open_by_handle_at() will still be able to find it.

I think real problem (as you pointed out later) is unliked file which is
still in use by the virtiofsd.

Thanks
Vivek

