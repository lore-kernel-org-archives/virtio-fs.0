Date: Tue, 29 Sep 2020 10:01:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200929140136.GD220516@redhat.com>
References: <20200918213436.GA3520@redhat.com> <20200921153243.GK3221@work-vm>
	<20200922102531.GA2837@work-vm> <20200922174733.GD57620@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
	<20200924221023.GB132653@redhat.com>
	<20200925124139.GJ2873@work-vm>
	<20200929131753.GB220516@redhat.com>
	<CAOssrKcVNs=uiU2U1-ScowogFan8W=iw7kyTCnaz-vL8r9gLmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKcVNs=uiU2U1-ScowogFan8W=iw7kyTCnaz-vL8r9gLmw@mail.gmail.com>
Subject: Re: [Virtio-fs] virtiofs vs 9p performance(Re: tools/virtiofs:
 Multi threading seems to hurt performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

On Tue, Sep 29, 2020 at 03:49:04PM +0200, Miklos Szeredi wrote:
> On Tue, Sep 29, 2020 at 3:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > - virtiofs cache=none mode is faster than cache=auto mode for this
> >   workload.
> 
> Not sure why.  One cause could be that readahead is not perfect at
> detecting the random pattern.  Could we compare total I/O on the
> server vs. total I/O by fio?

Hi Miklos,

I will instrument virtiosd code to figure out total I/O.

One more potential issue I am staring at is refreshing the attrs on 
READ if fc->auto_inval_data is set.

fuse_cache_read_iter() {
        /*
         * In auto invalidate mode, always update attributes on read.
         * Otherwise, only update if we attempt to read past EOF (to ensure
         * i_size is up to date).
         */
        if (fc->auto_inval_data ||
            (iocb->ki_pos + iov_iter_count(to) > i_size_read(inode))) {
                int err;
                err = fuse_update_attributes(inode, iocb->ki_filp);
                if (err)
                        return err;
        }
}

Given this is a mixed READ/WRITE workload, every WRITE will invalidate
attrs. And next READ will first do GETATTR() from server (and potentially
invalidate page cache) before doing READ.

This sounds suboptimal especially from the point of view of WRITEs
done by this client itself. I mean if another client has modified
the file, then doing GETATTR after a second makes sense. But there
should be some optimization to make sure our own WRITEs don't end
up doing GETATTR and invalidate page cache (because cache contents
are still valid).

I disabled ->auto_invalid_data and that seemed to result in 8-10%
gain in performance for this workload.

Thanks
Vivek

