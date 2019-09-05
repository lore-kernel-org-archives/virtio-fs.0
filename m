Date: Thu, 5 Sep 2019 11:23:11 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190905102311.GI2700@work-vm>
References: <20190905082947.6633-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905082947.6633-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH RESEND 0/2] virtiofsd: use "fuse_log.h" APIs
 instead of <err.h>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> warn(3), warnx(3), err(3), and errx(3) print to stderr even when the --syslog
> option was given.  In this case messages to stderr are likely to be lost and
> this makes troubleshooting hard.  Use "fuse_log.h" APIs instead of <err.h>.
> 
> Stefan Hajnoczi (2):
>   virtiofsd: replace warn(3) and warnx(3) with fuse_warning()
>   virtiofsd: replace err(3) and errx(3) with fuse_err()
> 
>  contrib/virtiofsd/passthrough_ll.c | 143 ++++++++++++++++++-----------
>  contrib/virtiofsd/seccomp.c        |  15 ++-
>  2 files changed, 99 insertions(+), 59 deletions(-)

Thanks, I've added these to my world; although I'll probably squash them
down heavily into the original commits.

Dave

> -- 
> 2.21.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

