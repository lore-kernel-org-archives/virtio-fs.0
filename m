Date: Wed, 20 Jan 2021 10:45:01 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210120104501.GB2930@work-vm>
References: <20210119221849.GC77840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119221849.GC77840@redhat.com>
Subject: Re: [Virtio-fs] What are libvhost-user locking requirements
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: gkurz@redhat.com, johannes.berg@intel.com, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, marcandre.lureau@redhat.com

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Hi,
> 
> Current virtiofsd code uses libvhost-user and I am assuming virtiofsd-rs
> uses it too. I am wondering what are the locking requirements for
> this library.

No, virtiofsd-rs uses the rust crate: https://github.com/rust-vmm/vhost-user-backend
I guess that's where they get their dose of 'Fearless concurrency'

> Looking at it it does not look like thread safe. Well parts of of kind
> of look thread safe. For example, David Gilbert introduced a slave_mutex
> to control reading/writeing on slave_fd. But dev->slave_fd can be modified
> vu_set_slave_req_fd() without any locks. Similiarly _vu_queue_notify()
> uses dev->slave_fd but  does not take any lock. May be these are just
> bugs and we can take slave_mutex in those paths so not a big deal.

That would be my assumption; I don't think libvhost-user really thought
about it much.

> But this library does not talk about locking at all. Of course there
> are many shared data structures like "struct VuDev" and helpers which
> access this structure. Is client supposed to provide locking and
> make sure not more than one thread is calling into the library
> at one point of time.

I don't think it's defined.

> But in virtiofsd I see that we seem to be in mixed mode. In some cases
> we are holding ->vu_dispatch_rwlock in read-only mode. So that will
> allow multipler threads to call into library for one queue.

I think that lock is really protecting against the queue management
actions on vhost-user remapping the queue conflicting with things
operating on the queue.

> In other places like lo_setupmapping() and lo_removemapping(), we are
> not holding ->vu_dispatch_rwlock() at all and simply call into
> library vu_fs_cache_request(VHOST_USER_SLAVE_FS_MAP/...). So multiple
> threads can call in. I think precisely for this use case dev->slave_mutex
> has been introduced in library.

Note that those calls don't actually read/write interact on the queue
itself; so I don't *think* they need the vu_dispatch_rwlock.

> So few queries.
> 
> - what's the locking model needed to use libvhost-user. Is there one? 

I don't think it really had one.

> - Is it ok to selectively add locking for some data structures in
>   libvhost-user. As slave_mutex has been added. So user will have to
>   go through the code to figure out which paths can be called without
>   locks and which paths can't be.

Well it certainly needed something added; hence why I added slave_mutex,
but the slave_mutex is mostly separate from the actual queue processing,
and actually rarely used.

> /me is confused and trying to wrap my head around the locking requirements
> while using libvhost-user.

It's not well defined at all.

Dave

> 
> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

