Date: Wed, 18 Aug 2021 12:58:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YR08KnP8cO8LjKY7@redhat.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRut5sioYfc2M1p7@redhat.com>
	<6043c0b8-0ff1-2e11-0dd0-e23f9ff6b952@linux.alibaba.com>
	<CAJfpegv01k5hEyJ3LPDWJoqB+vL8hwTan9dLu1pkkD0xoRuFzw@mail.gmail.com>
	<1100b711-012d-d68b-7078-20eea6fa4bab@linux.alibaba.com>
	<CAJfpegsdX1H_=ZMORA-9YiBGdszG0WVmAjFY2QSZPa0iLUEjXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsdX1H_=ZMORA-9YiBGdszG0WVmAjFY2QSZPa0iLUEjXw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, JeffleXu <jefflexu@linux.alibaba.com>

On Wed, Aug 18, 2021 at 07:08:24AM +0200, Miklos Szeredi wrote:
> On Wed, 18 Aug 2021 at 05:40, JeffleXu <jefflexu@linux.alibaba.com> wrote:
> 
> > I'm not sure if I fully understand your idea. Then in this case, host
> > daemon only prepares 4KB while guest thinks that the whole DAX window
> > (e.g., 2MB) has been fully mapped. Then when guest really accesses the
> > remained part (2MB - 4KB), page fault is triggered, and now host daemon
> > is responsible for downloading the remained part?
> 
> Yes.  Mapping an area just means setting up the page tables, it does
> not result in actual data transfer.

But daemon will not get the page fault (its the host kernel which
will handle it). And host kernel does not know that file chunk 
needs to be downloaded.

- Either we somehow figure out user fault handling and somehow
  qemu/virtiofsd get to handle the page fault then they can
  download file.

- Or we download the 2MB chunk at the FUSE_SETUPMAPPING time so
  that later kernel fault can handle it.

Am I missing something.

Vivek

