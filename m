From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Thu, 8 Aug 2019 05:01:58 +0000
Message-ID: <22afcc67ede15da63905665ae0bd8a7ca8757226.camel@intel.com>
References: <20190807212610.GG18557@redhat.com>
	<1E91073893EF8F498411079ED374F912460D57A6@ORSMSX115.amr.corp.intel.com>
	<1E91073893EF8F498411079ED374F912460D57F0@ORSMSX115.amr.corp.intel.com>
	<20190808002305.GB24807@redhat.com>
In-Reply-To: <20190808002305.GB24807@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <611F35BA94E3804D996E4C2BB6C7610C@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Rebased kernel patches to 5.3-rc kernel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "vgoyal@redhat.com" <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

Hi Vivek,

On Wed, 2019-08-07 at 20:23 -0400, Vivek Goyal wrote:
> On Wed, Aug 07, 2019 at 11:23:35PM +0000, Boeuf, Sebastien wrote:
> > Hi Vivek, I just tried the new kernel and I run into issues with my
> > VMM.
> > When I try to mount from inside the guest with the following
> > command:
> > # mount -t virtio_fs /dev/null mount_dir/ -o
> > tag=myfs,rootmode=040000,user_id=0,group_id=0,dax
> > 
> > I realized the mount command changed into this:
> > mount -t virtio_fs myfs mount_dir/ -o
> > rootmode=040000,user_id=0,group_id=0,dax
> 
> Hi Sebastien,
> 
> Adding virtio-fs list back. I think its a good idea to keep
> conversation
> on list, just in case others face similar issues.

Oh yes sorry about that.

> 
> > 
> > It'd be nice to update it from the official documentation.
> 
> Yes it will be nice to update doc.

:)

> 
> Stefan, can you please take care of updating docs. We will have to
> mention
> for 4.19 kernel syntax is different and for latest kernel syntax is
> different.
> 
> > 
> > Now, when I try to read from my files, I get nothing. I see the
> > mmap happening,
> > but the output of `cat` is empty.
> > Can you think of anything that changed that could affect the
> > mapping?
> 
> For me it works. Which virtiofsd are you using. I am using virtio-fs-
> dev
> branch of qemu.
> 
> https://gitlab.com/virtio-fs/qemu/commits/virtio-fs-dev
> 
> If it still does not work, try disabling dax and see if it helps.

Yes I'm using the same branch as you. I got it working eventually. I
was ignoring the flags passed by virtiofsd to do the mmap and it caused
the mmap to fail since I was trying to mmap R/W when virtiofsd was
telling me to do RO.

Anyway, I confirm it's all working now :)

Thanks,
Sebastien
> 
> Thanks
> Vivek

