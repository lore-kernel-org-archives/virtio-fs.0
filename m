Date: Tue, 6 Oct 2020 15:43:38 +0200
From: Jens Freimann <jfreimann@redhat.com>
Message-ID: <20201006134338.GA49600@linux.fritz.box>
References: <20201006095826.59813-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201006095826.59813-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: avoid /proc/self/fd tempdir
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

On Tue, Oct 06, 2020 at 10:58:26AM +0100, Stefan Hajnoczi wrote:
>In order to prevent /proc/self/fd escapes a temporary directory is
>created where /proc/self/fd is bind-mounted. This doesn't work on
>read-only file systems.
>
>Avoid the temporary directory by bind-mounting /proc/self/fd over /proc.
>This does not affect other processes since we remounted / with MS_REC |
>MS_SLAVE. /proc must exist and virtiofsd does not use it so it's safe to
>do this.
>
>Path traversal can be tested with the following function:
>
>  static void test_proc_fd_escape(struct lo_data *lo)
>  {
>      int fd;
>      int level = 0;
>      ino_t last_ino = 0;
>
>      fd = lo->proc_self_fd;
>      for (;;) {
>          struct stat st;
>
>          if (fstat(fd, &st) != 0) {
>              perror("fstat");
>              return;
>          }
>          if (last_ino && st.st_ino == last_ino) {
>              fprintf(stderr, "inode number unchanged, stopping\n");
>              return;
>          }
>          last_ino = st.st_ino;
>
>          fprintf(stderr, "Level %d dev %lu ino %lu\n", level,
>                  (unsigned long)st.st_dev,
>                  (unsigned long)last_ino);
>          fd = openat(fd, "..", O_PATH | O_DIRECTORY | O_NOFOLLOW);
>          level++;
>      }
>  }
>
>Before and after this patch only Level 0 is displayed. Without
>/proc/self/fd bind-mount protection it is possible to traverse parent
>directories.
>
>Fixes: 397ae982f4df4 ("virtiofsd: jail lo->proc_self_fd")
>Cc: Miklos Szeredi <mszeredi@redhat.com>
>Cc: Jens Freimann <jfreimann@redhat.com>
>Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks Stefan, it fixes the problem we had!

Tested-by: Jens Freimann <jfreimann@redhat.com>
Reviewed-by: Jens Freimann <jfreimann@redhat.com> 

regards,
Jens 

