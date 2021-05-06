Date: Thu, 6 May 2021 12:02:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210506160223.GA277745@redhat.com>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-27-dgilbert@redhat.com>
	<YJQNIPaFCJlG7ZKc@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJQNIPaFCJlG7ZKc@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 26/26] virtiofsd: Ask qemu to drop
 CAP_FSETID if client asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, May 06, 2021 at 04:37:04PM +0100, Stefan Hajnoczi wrote:
> On Wed, Apr 28, 2021 at 12:01:00PM +0100, Dr. David Alan Gilbert (git) wrote:
> > From: Vivek Goyal <vgoyal@redhat.com>
> > 
> > If qemu guest asked to drop CAP_FSETID upon write, send that info
> > to qemu in SLAVE_FS_IO message so that qemu can drop capability
> > before WRITE. This is to make sure that any setuid bit is killed
> > on fd (if there is one set).
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> I'm not sure if the QEMU FSETID patches make sense. QEMU shouldn't be
> running with FSETID because QEMU is untrusted. FSETGID would allow QEMU
> to create setgid files, thereby potentially allowing an attacker to gain
> any GID.

Sure, its not recommended to run QEMU as root, but we don't block that
either and I do regularly test with qemu running as root.

> 
> I think it's better not to implement QEMU FSETID functionality at all
> and to handle it another way.

One way could be that virtiofsd tries to clear setuid bit after I/O
has finished. But that will be non-atomic operation and it is filled
with perils as it requires virtiofsd to know what all kernel will
do if this write has been done with CAP_FSETID dropped.

> In the worst case I/O requests should just
> fail, it seems like a rare case anyway:

Is there a way for virtiofsd to know if qemu is running with CAP_FSETID
or not. If there is one, it might be reasonable to error out. If we
don't know, then we can't fail all the operations.

> I/O to a setuid/setgid file with
> a memory buffer that is not mapped in virtiofsd.

With DAX it is easily triggerable. User has to append to a setuid file
in virtiofs and this path will trigger.

I am fine with not supporting this patch but will also need a reaosonable
alternative solution.

Vivek

