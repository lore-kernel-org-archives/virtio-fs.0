Date: Tue, 15 Oct 2019 17:26:34 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191015162634.GI3073@work-vm>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>, sebastien.boeuf@intel.com, slp@redhat.com
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>

* Chirantan Ekbote (chirantan@chromium.org) wrote:
> On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > >
> > > I'm not using virtiofsd.  We have our own server for crosvm, which
> > > supports multiple queues.
> >
> > Ah excellent; is that public anywhere?
> >
> 
> It's currently under review here:
> https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/1758103
> 
> I expect to have it merged sometime this week.

Very nice; copying in Seb and Sergio.

I'll try and have a look through that.

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

