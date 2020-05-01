Date: Fri, 1 May 2020 18:42:33 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200501174233.GA38251@work-vm>
References: <20200501140644.220940-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501140644.220940-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/2] virtiofsd: stay under fs.file-max
 sysctl limit (CVE-2020-10717)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, pjp@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> This patch series introduces the --rlimit-nofile=NUM option for setting the
> number of open files on the virtiofsd process.  This gives users and management
> tools more control over resource limits.
> 
> Previously it was possible for FUSE clients on machines with less than ~10 GB
> of RAM to exhaust the system-wide open file limit.  This is a denial of service
> attack against other processes running on the host.
> 
> This patch series updates the default RLIMIT_NOFILE calculation to take the
> fs.file-max sysctl value into account.  This solves the fs.file-max DoS.

Queued.

> Stefan Hajnoczi (2):
>   virtiofsd: add --rlimit-nofile=NUM option
>   virtiofsd: stay below fs.file-max sysctl value (CVE-2020-10717)
> 
>  tools/virtiofsd/fuse_lowlevel.h  |  1 +
>  tools/virtiofsd/helper.c         | 47 ++++++++++++++++++++++++++++++++
>  tools/virtiofsd/passthrough_ll.c | 22 ++++++---------
>  3 files changed, 56 insertions(+), 14 deletions(-)
> 
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

