Date: Wed, 11 Mar 2020 02:46:47 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20200310184640.5djxclzt6gqkq4v3@rsjd01523.et2sqa>
References: <1583270111-76859-1-git-send-email-bo.liu@linux.alibaba.com>
	<CAJfpegtFWqEAV-Jb_KoHihJ5-UpU=JkdxEg_stz6JM5OP_LXMQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegtFWqEAV-Jb_KoHihJ5-UpU=JkdxEg_stz6JM5OP_LXMQ@mail.gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] fuse: make written data persistent after
	writing
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com

On Tue, Mar 10, 2020 at 11:14:17AM +0100, Miklos Szeredi wrote:
> On Tue, Mar 3, 2020 at 10:15 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
> >
> > If this is a DSYNC write, make sure we push it to stable storage now
> > that we've written data.
> 
> If this is direct I/O then why do we need an fysnc() call?
> 
> The only thing needed should be correct setting O_DSYNC in the flags
> field of the WRITE request, and it appears to me that that is already
> being done.

Given direct IO itself doesn't guarantee FUA or FLUSH, I think we
still need such a fsync() call to make sure a FUA/FLUSH is sent after
direct IO.

thanks,
-liubo


