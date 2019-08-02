Date: Fri, 2 Aug 2019 16:39:30 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190802153930.GB22284@stefanha-x1.localdomain>
References: <20190801151348.14947-1-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801151348.14947-1-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Prevent multiply running with
 same vhost_user_socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

On Thu, Aug 01, 2019 at 11:13:48AM -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> virtiofsd can run multiply even if the vhost_user_socket is
> same path.
> 
>   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
>   [1] 244965
>   virtio_session_mount: Waiting for vhost-user socket connection...
>   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
>   [2] 244966
>   virtio_session_mount: Waiting for vhost-user socket connection...
>   ]#
> 
> The file access from the guest works because the second virtiofsd
> handles that, however, the user will get confused the situation
> and may be the cause of unexpected problem. So it's better to
> prevent the multiple running.
> 
> Change unlink() of the socket to the exit of virtiofsd so that the
> latter virtiofsd can fail on bind() as EADDRINUSE.
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  contrib/virtiofsd/fuse_lowlevel.c | 1 +
>  contrib/virtiofsd/fuse_virtio.c   | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)

This patch makes the UNIX domain socket act similar to a pidfile or
lockfile.  Does the user need to clean up the UNIX domain socket
manually before virtiofsd can restart again after a crash?

This can be a robustness/reliability problem because we must assume that
crashes happen and recovery should not require human intervention.

On the other hand, there are plenty of daemons that have long-lived UNIX
domain socket paths.  How do they handle crash recovery?

Stefan

