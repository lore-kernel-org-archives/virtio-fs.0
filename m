Date: Tue, 6 Oct 2020 09:06:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201006130638.GA5306@redhat.com>
References: <5ea77e9f6cb8c2db43b09fbd4158ab2d8c066a0a.camel@redhat.com>
	<a2810c3a656115fab85fc173186f3e2c02a98182.camel@redhat.com>
	<20201004143119.GA58616@redhat.com>
	<20201006090427.GA41482@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006090427.GA41482@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] virtiofs: WARN_ON(out_sgs + in_sgs != total_sgs)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Qian Cai <cai@redhat.com>, linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Oct 06, 2020 at 10:04:27AM +0100, Stefan Hajnoczi wrote:
> On Sun, Oct 04, 2020 at 10:31:19AM -0400, Vivek Goyal wrote:
> > On Fri, Oct 02, 2020 at 10:44:37PM -0400, Qian Cai wrote:
> > > On Fri, 2020-10-02 at 12:28 -0400, Qian Cai wrote:
> > > > Running some fuzzing on virtiofs from a non-privileged user could trigger a
> > > > warning in virtio_fs_enqueue_req():
> > > > 
> > > > WARN_ON(out_sgs + in_sgs != total_sgs);
> > > 
> > > Okay, I can reproduce this after running for a few hours:
> > > 
> > > out_sgs = 3, in_sgs = 2, total_sgs = 6
> > 
> > Thanks. I can also reproduce it simply by calling.
> > 
> > ioctl(fd, 0x5a004000, buf);
> > 
> > I think following WARN_ON() is not correct.
> > 
> > WARN_ON(out_sgs + in_sgs != total_sgs)
> > 
> > toal_sgs should actually be max sgs. It looks at ap->num_pages and
> > counts one sg for each page. And it assumes that same number of
> > pages will be used both for input and output.
> > 
> > But there are no such guarantees. With above ioctl() call, I noticed
> > we are using 2 pages for input (out_sgs) and one page for output (in_sgs).
> > 
> > So out_sgs=4, in_sgs=3 and total_sgs=8 and warning triggers.
> > 
> > I think total sgs is actually max number of sgs and warning
> > should probably be.
> > 
> > WARN_ON(out_sgs + in_sgs >  total_sgs)
> > 
> > Stefan, WDYT?
> 
> It should be possible to calculate total_sgs precisely (not a maximum).
> Treating it as a maximum could hide bugs.

I thought about calculating total_sgs as well. Then became little lazy.
I will redo the patch and then calculate total_sgs precisely.

> 
> Maybe sg_count_fuse_req() should count in_args/out_args[numargs -
> 1].size pages instead of adding ap->num_pages.

That should work, I guess. Will try.

Vivek
> 
> Do you have the details of struct fuse_req and struct fuse_args_pages
> fields for the ioctl in question?

> 
> Thanks,
> Stefan


