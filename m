Message-ID: <0e2424983d6772f24374c9f3b06295bed8327b96.camel@redhat.com>
From: Qian Cai <cai@redhat.com>
Date: Tue, 13 Oct 2020 16:10:45 -0400
In-Reply-To: <20201013195719.GD142988@redhat.com>
References: <7d350903c2aa8f318f8441eaffafe10b7796d17b.camel@redhat.com>
	<20201013184026.GC142988@redhat.com>
	<20201013185808.GA164772@redhat.com>
	<d14f6a08b4ada85289e70cbb34726fd084ccac05.camel@redhat.com>
	<20201013195719.GD142988@redhat.com>
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

On Tue, 2020-10-13 at 15:57 -0400, Vivek Goyal wrote:
> Hmm..., So how do I reproduce it. Just run trinity as root and it will
> reproduce after some time?

Only need to run it as unprivileged user after mounting virtiofs on /tmp
(trinity will need to create and use files there) as many as CPUs as possible.
Also, make sure your guest's memory usage does not exceed the host's /dev/shm
size. Otherwise, horrible things could happen.

$ trinity -C 48 --arch 64

It might get coredump or exit due to some other unrelated reasons, so just keep
retrying. It is best to apply your recent patch for the virtiofs false positive
warning first, so it won't taint the kernel which will stop the trinity. Today,
I had been able to reproduce it twice within half-hour each.



