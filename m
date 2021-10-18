Date: Mon, 18 Oct 2021 14:08:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YW24Aoj6/boyYyj3@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 00/12] virtiofsd: Allow using file
 handles instead of O_PATH FDs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Reitz <hreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Sep 16, 2021 at 10:40:33AM +0200, Hanna Reitz wrote:

[..]
> Second, I’ve renamed the TempFd objects to reflect what kind of FDs they
> contain; i.e. they’re no longer called “inode_fd” or “dir_fd”, but
> “path_fd”, “rw_fd”, or “dir_path_fd” instead.

This change is really helpful. Makes it easier to read code and figure
out which fd we are referring to.

Vivek

