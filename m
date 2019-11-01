From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Fri, 1 Nov 2019 22:26:54 +0000
Message-ID: <923a5ab7b17371fe1b702717c125d89f7e76bf5b.camel@intel.com>
References: <20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
	<CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
	<ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
	<CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
	<20191016141407.GB5487@stefanha-x1.localdomain>
	<59aa4481a68fe627ee7dfa34f01f4c8f16b1e969.camel@intel.com>
	<20191016183815.GD14762@stefanha-x1.localdomain>
In-Reply-To: <20191016183815.GD14762@stefanha-x1.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5ACC29A5239B245A2687B3D706F9F56@intel.com>
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
To: "stefanha@redhat.com" <stefanha@redhat.com>, "dgilbert@redhat.com" <dgilbert@redhat.com>, "Ortiz, Samuel" <samuel.ortiz@intel.com>, "Bradford,
	Robert" <robert.bradford@intel.com>
Cc: "slp@redhat.com" <slp@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>

+Samuel
+Rob

Hi Stefan, Dave,

I had some time to get started on the virtiofsd in Rust, based on the
code from Chirantan. So basically I relied on the following Crosvm
branch (code not merged yet):
https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/1705654

>From there I have ported the code that was needed to rely on the nice
implementation from Chirantan. I had to make it fit the vm-virtio crate
from Cloud-Hypervisor (since it's not yet complete on rust-vmm), and
also the vm-memory crate from rust-vmm.

Once the porting done, I created a dedicated vhost-user-fs daemon
binary relying on the vhost_user_backend crate. I connected all the
dots together and the result is here:
https://github.com/intel/cloud-hypervisor/pull/404

I have listed the remaining tasks here: 
https://github.com/intel/cloud-hypervisor/pull/404#issue-335636924
(some can be quite big and should come as a follow up PR IMO).

I'll be in vacation next week, but if you have some time, it'd be very
nice to get everybody's feedback on this.

And of course, if you have more time to continue working on this, feel
free to reuse my branch 'vhost_user_fs_daemon' from my forked repo 
https://github.com/sboeuf/cloud-hypervisor-1.git

Thanks,
Sebastien


On Wed, 2019-10-16 at 19:38 +0100, Stefan Hajnoczi wrote:
> On Wed, Oct 16, 2019 at 04:14:25PM +0000, Boeuf, Sebastien wrote:
> > On Wed, 2019-10-16 at 15:14 +0100, Stefan Hajnoczi wrote:
> > > On Wed, Oct 16, 2019 at 03:21:52AM +0900, Chirantan Ekbote wrote:
> > > > On Wed, Oct 16, 2019 at 2:28 AM Boeuf, Sebastien
> > > > <sebastien.boeuf@intel.com> wrote:
> > > > > Thanks Dave for adding me to the loop here!
> > > > > 
> > > > > On Tue, 2019-10-15 at 17:26 +0100, Dr. David Alan Gilbert
> > > > > wrote:
> > > > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > > > On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
> > > > > > > <dgilbert@redhat.com> wrote:
> > > > > > > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > > > > > > I'm not using virtiofsd.  We have our own server for
> > > > > > > > > crosvm,
> > > > > > > > > which
> > > > > > > > > supports multiple queues.
> > > > > > > > 
> > > > > > > > Ah excellent; is that public anywhere?
> > > > > > > > 
> > > > > > > 
> > > > > > > It's currently under review here:
> > > > > > > https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/1758103
> > > > > > > 
> > > > > > > I expect to have it merged sometime this week.
> > > > > 
> > > > > Oh that's very nice to hear. We have some code from the
> > > > > cloud-
> > > > > hypervisor project where we have a vhost-user-net
> > > > > implementation
> > > > > relying on some sort of a wrapper code similar to what all
> > > > > vhost-
> > > > > user
> > > > > daemon implementations would reuse (libvhost-user kind of
> > > > > thing).
> > > > > 
> > > > > We're planning to see this wrapper code land on Rust-VMM at
> > > > > some
> > > > > point,
> > > > > which is why it would be interesting if you could rebase this
> > > > > virtio-fs
> > > > > daemon code on top of this small library. If you don't have
> > > > > the
> > > > > bandwidth, we could probably look at it if that's something
> > > > > you
> > > > > would
> > > > > be interested in.
> > > > > 
> > > > > Here is the code for the small wrapper crate:
> > > > > https://github.com/intel/cloud-hypervisor/blob/master/vhost_user_backend/src/lib.rs
> > > > > 
> > > > > And here is the vhost-user-net example using it:
> > > > > https://github.com/intel/cloud-hypervisor/blob/master/src/bin/vhost_user_net.rs
> > > > > 
> > > > 
> > > > Our virtio-fs server is not a vhost-user device (this was one
> > > > of
> > > > the
> > > > reasons we didn't want to use virtiofsd).  It currently just
> > > > runs
> > > > directly as a child process of crosvm (like all other crosvm
> > > > devices).
> > > > So unless I'm missing something I don't think there's much to
> > > > be
> > > > gained by rebasing on vhost_user_backend.
> > > 
> > > I'm also interested in porting the server over to vhost-user so
> > > that
> > > other VMMs like QEMU and cloud-hypervisor can use it.
> > 
> > Yes I agree that'd be awesome!
> > Are you planning to start working on this soon? Just asking as I
> > want
> > to avoid potential duplicated efforts :)
> 
> Not immediately.  If you are ready to work on it and make your branch
> public then we can follow along.
> 
> Stefan

