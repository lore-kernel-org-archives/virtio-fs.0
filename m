Date: Fri, 20 Dec 2019 10:46:34 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20191220024634.GA59346@e18g06458.et15sqa>
References: <20191218092258.76554-1-eguan@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20191218092258.76554-1-eguan@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: sync FUSE_DESTROY with session
	destroy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qingming.su@linux.alibaba.com

On Wed, Dec 18, 2019 at 05:22:58PM +0800, Eryu Guan wrote:
> Normally on guest shutdown, guest umounts virtiofs (FUSE_DESTROY) and
> waits for umount to return then cleans up virtio device.
> 
> But if guest gets killed, for whatever reason, right after sending
> FUSE_DESTROY, it's possible that virtiofsd cleans up session and virtio
> dev first, then fv_queue_worker() wants to send reply to guest and hits
> abort() in fuse_send_msg(), because fuse_lowlevel_is_virtio() returns
> false.
> 
> Fix it by acquiring se->init_rwlock first in fuse_session_destroy() to
> wait for inflight FUSE_DESTROY to be completed, then clean up session
> and virtio dev.
> 
> Reported-by: Qingming Su <qingming.su@linux.alibaba.com>
> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>

Please ignore it for now, use-after-free is still possible. We need to
make sure all fv_queue_thread()s and fv_queue_worker()s exit before
virtio_loop() returns. I'll send a v2 patch.

Thanks,
Eryu


