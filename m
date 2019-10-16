From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Wed, 16 Oct 2019 16:14:25 +0000
Message-ID: <59aa4481a68fe627ee7dfa34f01f4c8f16b1e969.camel@intel.com>
References: <20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
	<CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
	<ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
	<CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
	<20191016141407.GB5487@stefanha-x1.localdomain>
In-Reply-To: <20191016141407.GB5487@stefanha-x1.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C0ADF5D3E530B469E9786E883ECEDD4@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "stefanha@redhat.com" <stefanha@redhat.com>, "chirantan@chromium.org" <chirantan@chromium.org>
Cc: "slp@redhat.com" <slp@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>

On Wed, 2019-10-16 at 15:14 +0100, Stefan Hajnoczi wrote:
> On Wed, Oct 16, 2019 at 03:21:52AM +0900, Chirantan Ekbote wrote:
> > On Wed, Oct 16, 2019 at 2:28 AM Boeuf, Sebastien
> > <sebastien.boeuf@intel.com> wrote:
> > > Thanks Dave for adding me to the loop here!
> > > 
> > > On Tue, 2019-10-15 at 17:26 +0100, Dr. David Alan Gilbert wrote:
> > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
> > > > > <dgilbert@redhat.com> wrote:
> > > > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > > > I'm not using virtiofsd.  We have our own server for
> > > > > > > crosvm,
> > > > > > > which
> > > > > > > supports multiple queues.
> > > > > > 
> > > > > > Ah excellent; is that public anywhere?
> > > > > > 
> > > > > 
> > > > > It's currently under review here:
> > > > > https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/1758103
> > > > > 
> > > > > I expect to have it merged sometime this week.
> > > 
> > > Oh that's very nice to hear. We have some code from the cloud-
> > > hypervisor project where we have a vhost-user-net implementation
> > > relying on some sort of a wrapper code similar to what all vhost-
> > > user
> > > daemon implementations would reuse (libvhost-user kind of thing).
> > > 
> > > We're planning to see this wrapper code land on Rust-VMM at some
> > > point,
> > > which is why it would be interesting if you could rebase this
> > > virtio-fs
> > > daemon code on top of this small library. If you don't have the
> > > bandwidth, we could probably look at it if that's something you
> > > would
> > > be interested in.
> > > 
> > > Here is the code for the small wrapper crate:
> > > https://github.com/intel/cloud-hypervisor/blob/master/vhost_user_backend/src/lib.rs
> > > 
> > > And here is the vhost-user-net example using it:
> > > https://github.com/intel/cloud-hypervisor/blob/master/src/bin/vhost_user_net.rs
> > > 
> > 
> > Our virtio-fs server is not a vhost-user device (this was one of
> > the
> > reasons we didn't want to use virtiofsd).  It currently just runs
> > directly as a child process of crosvm (like all other crosvm
> > devices).
> > So unless I'm missing something I don't think there's much to be
> > gained by rebasing on vhost_user_backend.
> 
> I'm also interested in porting the server over to vhost-user so that
> other VMMs like QEMU and cloud-hypervisor can use it.

Yes I agree that'd be awesome!
Are you planning to start working on this soon? Just asking as I want
to avoid potential duplicated efforts :)

Thanks,
Sebastien
> 
> From a quick look at the code last night, here are things that were
> not
> carried over from virtiofsd:
>  * DAX is not supported
>  * The FUSE protocol version is a bit dated, e.g. copy_file_range()
> is
>    not supported.
>  * Requests are processed synchronously for each virtqueue and
> therefore
>    performance is limited.  The server won't saturate the queue depth
>    supported by the host kernel and hardware.
> 
> Have I missed anything?  Otherwise it looks quite close to
> passthrough_ll.c.
> 
> Stefan

