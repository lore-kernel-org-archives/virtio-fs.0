Date: Thu, 20 May 2021 19:45:13 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <YKa8SZ8s6QeKZ4XP@zeniv-ca.linux.org.uk>
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-2-groug@kaod.org>
MIME-Version: 1.0
In-Reply-To: <20210520154654.1791183-2-groug@kaod.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 1/5] fuse: Fix leak in
 fuse_dentry_automount() error path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Thu, May 20, 2021 at 05:46:50PM +0200, Greg Kurz wrote:
> Some rollback was forgotten during the addition of crossmounts.

Have you actually tested that?  Because I strongly suspect that
by that point the ownership of fc and fm is with sb and those
should be taken care of by deactivate_locked_super().

