Date: Tue, 13 Oct 2020 14:58:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201013185808.GA164772@redhat.com>
References: <7d350903c2aa8f318f8441eaffafe10b7796d17b.camel@redhat.com>
	<20201013184026.GC142988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013184026.GC142988@redhat.com>
Subject: Re: [Virtio-fs] Unbreakable loop in fuse_fill_write_pages()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Qian Cai <cai@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org

On Tue, Oct 13, 2020 at 02:40:26PM -0400, Vivek Goyal wrote:
> On Tue, Oct 13, 2020 at 01:11:05PM -0400, Qian Cai wrote:
> > Running some fuzzing on virtiofs with an unprivileged user on today's linux-next 
> > could trigger soft-lockups below.
> > 
> > # virtiofsd --socket-path=/tmp/vhostqemu -o source=$TESTDIR -o cache=always -o no_posix_lock
> > 
> > Basically, everything was blocking on inode_lock(inode) because one thread
> > (trinity-c33) was holding it but stuck in the loop in fuse_fill_write_pages()
> > and unable to exit for more than 10 minutes before I executed sysrq-t.
> > Afterwards, the systems was totally unresponsive:
> > 
> > kernel:NMI watchdog: Watchdog detected hard LOCKUP on cpu 8
> > 
> > To exit the loop, it needs,
> > 
> > iov_iter_advance(ii, tmp) to set "tmp" to non-zero for each iteration.
> > 
> > and
> > 
> > 	} while (iov_iter_count(ii) && count < fc->max_write &&
> > 		 ap->num_pages < max_pages && offset == 0);
> > 
> > == the thread is stuck in the loop ==
> > [10813.290694] task:trinity-c33     state:D stack:25888 pid:254219 ppid: 87180
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

I am wondering if virtiofsd still alive and responding to requests? I
see another task which is blocked on getdents() for more than 120s.

[10580.142571][  T348] INFO: task trinity-c36:254165 blocked for more than 123
+seconds.
[10580.143924][  T348]       Tainted: G           O	 5.9.0-next-20201013+ #2
[10580.145158][  T348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
+disables this message.
[10580.146636][  T348] task:trinity-c36     state:D stack:26704 pid:254165 ppid:
+87180 flags:0x00000004
[10580.148260][  T348] Call Trace:
[10580.148789][  T348]  __schedule+0x71d/0x1b50
[10580.149532][  T348]  ? __sched_text_start+0x8/0x8
[10580.150343][  T348]  schedule+0xbf/0x270
[10580.151044][  T348]  schedule_preempt_disabled+0xc/0x20
[10580.152006][  T348]  __mutex_lock+0x9f1/0x1360
[10580.152777][  T348]  ? __fdget_pos+0x9c/0xb0
[10580.153484][  T348]  ? mutex_lock_io_nested+0x1240/0x1240
[10580.154432][  T348]  ? find_held_lock+0x33/0x1c0
[10580.155220][  T348]  ? __fdget_pos+0x9c/0xb0
[10580.155934][  T348]  __fdget_pos+0x9c/0xb0
[10580.156660][  T348]  __x64_sys_getdents+0xff/0x230

May be virtiofsd crashed and hence no requests are completing leading
to a hard lockup?

Vivek

