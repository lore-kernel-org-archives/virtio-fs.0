Date: Tue, 19 Jan 2021 17:18:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210119221849.GC77840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] What are libvhost-user locking requirements
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org
Cc: gkurz@redhat.com, johannes.berg@intel.com, marcandre.lureau@redhat.com

Hi,

Current virtiofsd code uses libvhost-user and I am assuming virtiofsd-rs
uses it too. I am wondering what are the locking requirements for
this library.

Looking at it it does not look like thread safe. Well parts of of kind
of look thread safe. For example, David Gilbert introduced a slave_mutex
to control reading/writeing on slave_fd. But dev->slave_fd can be modified
vu_set_slave_req_fd() without any locks. Similiarly _vu_queue_notify()
uses dev->slave_fd but  does not take any lock. May be these are just
bugs and we can take slave_mutex in those paths so not a big deal.

But this library does not talk about locking at all. Of course there
are many shared data structures like "struct VuDev" and helpers which
access this structure. Is client supposed to provide locking and
make sure not more than one thread is calling into the library
at one point of time.

But in virtiofsd I see that we seem to be in mixed mode. In some cases
we are holding ->vu_dispatch_rwlock in read-only mode. So that will
allow multipler threads to call into library for one queue.

In other places like lo_setupmapping() and lo_removemapping(), we are
not holding ->vu_dispatch_rwlock() at all and simply call into
library vu_fs_cache_request(VHOST_USER_SLAVE_FS_MAP/...). So multiple
threads can call in. I think precisely for this use case dev->slave_mutex
has been introduced in library.

So few queries.

- what's the locking model needed to use libvhost-user. Is there one? 

- Is it ok to selectively add locking for some data structures in
  libvhost-user. As slave_mutex has been added. So user will have to
  go through the code to figure out which paths can be called without
  locks and which paths can't be.

/me is confused and trying to wrap my head around the locking requirements
while using libvhost-user.

Vivek

