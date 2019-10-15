From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Tue, 15 Oct 2019 17:28:10 +0000
Message-ID: <ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
References: <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
	<CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
	<20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
	<CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
In-Reply-To: <20191015162634.GI3073@work-vm>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D495077FC0F604F944E3F61C81D47A3@intel.com>
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
To: "dgilbert@redhat.com" <dgilbert@redhat.com>, "slp@redhat.com" <slp@redhat.com>, "chirantan@chromium.org" <chirantan@chromium.org>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>

Thanks Dave for adding me to the loop here!

On Tue, 2019-10-15 at 17:26 +0100, Dr. David Alan Gilbert wrote:
> * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
> > <dgilbert@redhat.com> wrote:
> > > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > > I'm not using virtiofsd.  We have our own server for crosvm,
> > > > which
> > > > supports multiple queues.
> > > 
> > > Ah excellent; is that public anywhere?
> > > 
> > 
> > It's currently under review here:
> > https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/1758103
> > 
> > I expect to have it merged sometime this week.

Oh that's very nice to hear. We have some code from the cloud-
hypervisor project where we have a vhost-user-net implementation
relying on some sort of a wrapper code similar to what all vhost-user
daemon implementations would reuse (libvhost-user kind of thing).

We're planning to see this wrapper code land on Rust-VMM at some point,
which is why it would be interesting if you could rebase this virtio-fs 
daemon code on top of this small library. If you don't have the
bandwidth, we could probably look at it if that's something you would
be interested in.

Here is the code for the small wrapper crate: 
https://github.com/intel/cloud-hypervisor/blob/master/vhost_user_backend/src/lib.rs

And here is the vhost-user-net example using it:
https://github.com/intel/cloud-hypervisor/blob/master/src/bin/vhost_user_net.rs

Thanks,
Sebastien

> 
> Very nice; copying in Seb and Sergio.
> 
> I'll try and have a look through that.
> 
> Dave
> 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

