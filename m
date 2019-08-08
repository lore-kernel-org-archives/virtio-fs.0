Date: Wed, 7 Aug 2019 20:23:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190808002305.GB24807@redhat.com>
References: <20190807212610.GG18557@redhat.com>
	<1E91073893EF8F498411079ED374F912460D57A6@ORSMSX115.amr.corp.intel.com>
	<1E91073893EF8F498411079ED374F912460D57F0@ORSMSX115.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1E91073893EF8F498411079ED374F912460D57F0@ORSMSX115.amr.corp.intel.com>
Subject: Re: [Virtio-fs] Rebased kernel patches to 5.3-rc kernel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Wed, Aug 07, 2019 at 11:23:35PM +0000, Boeuf, Sebastien wrote:
> Hi Vivek, I just tried the new kernel and I run into issues with my VMM.
> When I try to mount from inside the guest with the following command:
> # mount -t virtio_fs /dev/null mount_dir/ -o tag=myfs,rootmode=040000,user_id=0,group_id=0,dax
> 
> I realized the mount command changed into this:
> mount -t virtio_fs myfs mount_dir/ -o rootmode=040000,user_id=0,group_id=0,dax

Hi Sebastien,

Adding virtio-fs list back. I think its a good idea to keep conversation
on list, just in case others face similar issues.

> 
> It'd be nice to update it from the official documentation.

Yes it will be nice to update doc.

Stefan, can you please take care of updating docs. We will have to mention
for 4.19 kernel syntax is different and for latest kernel syntax is
different.

> 
> Now, when I try to read from my files, I get nothing. I see the mmap happening,
> but the output of `cat` is empty.
> Can you think of anything that changed that could affect the mapping?

For me it works. Which virtiofsd are you using. I am using virtio-fs-dev
branch of qemu.

https://gitlab.com/virtio-fs/qemu/commits/virtio-fs-dev

If it still does not work, try disabling dax and see if it helps.

Thanks
Vivek

