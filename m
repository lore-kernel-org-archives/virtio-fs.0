Date: Thu, 16 Jan 2020 15:32:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200116203210.GE25291@redhat.com>
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<20200115120118.GC163546@stefanha-x1.localdomain>
	<d5546de3-e02b-ccee-fa63-1889250d0738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5546de3-e02b-ccee-fa63-1889250d0738@redhat.com>
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Wed, Jan 15, 2020 at 02:00:27PM +0100, Max Reitz wrote:
> On 15.01.20 13:01, Stefan Hajnoczi wrote:
> > On Tue, Jan 14, 2020 at 08:24:51PM +0100, Miklos Szeredi wrote:
> >> On Tue, Jan 14, 2020 at 6:13 PM Max Reitz <mreitz@redhat.com> wrote:
> >>> What worries me most is how to pass that object around to all FUSE
> >>> functions, and that they all need a new interface.
> >>
> >> You mean libfuse API?
> >>
> >>> I just had a very fuzzy (and maybe stupid) idea: Maybe we could keep an
> >>> internal vector of currently active handles and then when variable-size
> >>> handles are enabled, fuse_ino_t would just act as an index into that vector?
> >>>
> >>> I suppose we could then use the full-size handles in all messages and
> >>> just hand out temporary indices to existing functions (just so we don’t
> >>> have to change their interface).  Server and client have their own
> >>> vectors, because when they communicate, only the full handles have meaning.
> >>>
> >>> Or we could implement the table on top of the current system by sharing
> >>> it between the client and server.  Whenever the server creates a
> >>> fuse_ino_t value, it then also creates a full-size handle, and returns
> >>> both the handle and its corresponding fuse_ino_t value to the server.
> >>> The server can use the fuse_ino_t normally most of the time, but with a
> >>> catch: The client would be able to invalidate it.  Then the server needs
> >>> to obtain a new fuse_ino_t value for the existing handle.
> >>> (Invalidating and reacquiring a fuse_ino_t value would be new FUSE
> >>> operations.)
> >>
> >> I think you may have accidentally switched "server" and "client" in
> >> the above description a couple of times.
> >>
> >> But if I'm reading this correctly, your idea is to keep the 64bit
> >> value on the interface (this could be just libfuse or both libfuse and
> >> the kernel API) and add new interfaces to establish and reestablish
> >> the mapping from (non-persistent) fuse_ino_t to (persistent) handle.
> > 
> > I'm not sure I understand Max's idea.
> > 
> > Miklos, I think you're saying keep fuse_ino_t semantics unchanged (not
> > persistent, can be reused after the last reference is dropped) and add a
> > separate struct export_operations-style FUSE API to map fuse_ino_t <->
> > struct file_handle.
> 
> Yes, that’d be the idea.
> 
> > We'd need to use submounts to avoid st_ino collisions in that case.
> 
> Yes, because that idea wouldn’t solve the st_ino problem.  (Only
> persistent fuse_ino_t values would solve it.  This proposal is exactly
> the opposite, we want them to be absolutely not persistent.)
> 
> So we’d still want submounts with separate st_devs and pass through
> st_ino from the host.

I am not sure I understand whole of the discussion. Here is my
understanding. Please correct me if I got it wrong.

So we seem to have two main problems.

- st_inode number collision as seen by user space in case of multiple
  submounts at host in directory being exported. And solution for this
  seems to be supporting submounts where st_dev is reported from
  submount in guest and st_ino is passthrough from host.

- Being able have a persistent handle for inode on host. This will allow
  us to support export API on virtiofs and also allow server to trim
  cache despite the fact that client still has reference to that inode.

IIUC, first one is more pressing for us and second one can wait. Have
I got it right?

Having said that, I don't know how complex it is to support submounts
and what are other implications.

Thanks
Vivek

