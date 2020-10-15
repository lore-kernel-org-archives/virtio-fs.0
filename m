Message-ID: <df388727036a6ad85d5ad23f44da5420dda49b4d.camel@lca.pw>
From: Qian Cai <cai@lca.pw>
Date: Thu, 15 Oct 2020 09:18:36 -0400
In-Reply-To: <20201013184026.GC142988@redhat.com>
References: <7d350903c2aa8f318f8441eaffafe10b7796d17b.camel@redhat.com>
	<20201013184026.GC142988@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Unbreakable loop in fuse_fill_write_pages()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org

On Tue, 2020-10-13 at 14:40 -0400, Vivek Goyal wrote:
> > == the thread is stuck in the loop ==
> > [10813.290694] task:trinity-c33     state:D stack:25888 pid:254219 ppid:
> > 87180
> > flags:0x00004004
> > [10813.292671] Call Trace:
> > [10813.293379]  __schedule+0x71d/0x1b50
> > [10813.294182]  ? __sched_text_start+0x8/0x8
> > [10813.295146]  ? mark_held_locks+0xb0/0x110
> > [10813.296117]  schedule+0xbf/0x270
> > [10813.296782]  ? __lock_page_killable+0x276/0x830
> > [10813.297867]  io_schedule+0x17/0x60
> > [10813.298772]  __lock_page_killable+0x33b/0x830
> 
> This seems to suggest that filemap_fault() is blocked on page lock and
> is sleeping. For some reason it never wakes up. Not sure why.
> 
> And this will be called from.
> 
> fuse_fill_write_pages()
>    iov_iter_fault_in_readable()
> 
> So fuse code will take inode_lock() and then looks like same process
> is sleeping waiting on page lock. And rest of the processes get blocked
> behind inode lock.
> 
> If we are woken up (while waiting on page lock), we should make forward
> progress. Question is what page it is and why the entity which is
> holding lock is not releasing lock.

FYI, it was mentioned that this is likely a deadlock in FUSE:

https://lore.kernel.org/linux-fsdevel/CAHk-=wh9Eu-gNHzqgfvUAAiO=vJ+pWnzxkv+tX55xhGPFy+cOw@mail.gmail.com/



