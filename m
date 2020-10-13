Message-ID: <d14f6a08b4ada85289e70cbb34726fd084ccac05.camel@redhat.com>
From: Qian Cai <cai@redhat.com>
Date: Tue, 13 Oct 2020 15:53:19 -0400
In-Reply-To: <20201013185808.GA164772@redhat.com>
References: <7d350903c2aa8f318f8441eaffafe10b7796d17b.camel@redhat.com>
	<20201013184026.GC142988@redhat.com>
	<20201013185808.GA164772@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org

On Tue, 2020-10-13 at 14:58 -0400, Vivek Goyal wrote:

> I am wondering if virtiofsd still alive and responding to requests? I
> see another task which is blocked on getdents() for more than 120s.
> 
> [10580.142571][  T348] INFO: task trinity-c36:254165 blocked for more than 123
> +seconds.
> [10580.143924][  T348]       Tainted: G           O	 5.9.0-next-20201013+ #2
> [10580.145158][  T348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> +disables this message.
> [10580.146636][  T348] task:trinity-c36     state:D stack:26704 pid:254165
> ppid:
> +87180 flags:0x00000004
> [10580.148260][  T348] Call Trace:
> [10580.148789][  T348]  __schedule+0x71d/0x1b50
> [10580.149532][  T348]  ? __sched_text_start+0x8/0x8
> [10580.150343][  T348]  schedule+0xbf/0x270
> [10580.151044][  T348]  schedule_preempt_disabled+0xc/0x20
> [10580.152006][  T348]  __mutex_lock+0x9f1/0x1360
> [10580.152777][  T348]  ? __fdget_pos+0x9c/0xb0
> [10580.153484][  T348]  ? mutex_lock_io_nested+0x1240/0x1240
> [10580.154432][  T348]  ? find_held_lock+0x33/0x1c0
> [10580.155220][  T348]  ? __fdget_pos+0x9c/0xb0
> [10580.155934][  T348]  __fdget_pos+0x9c/0xb0
> [10580.156660][  T348]  __x64_sys_getdents+0xff/0x230
> 
> May be virtiofsd crashed and hence no requests are completing leading
> to a hard lockup?
Virtiofsd is still working. Once this happened, I manually create a file on the
guest (in virtiofs) and then I can see the content of it from the host.

