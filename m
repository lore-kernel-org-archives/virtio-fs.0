Date: Thu, 30 Apr 2020 10:41:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200430144116.GD260081@redhat.com>
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm> <20200429145720.GA2835@work-vm>
	<8c73f374-fcc8-1684-b581-84a9ab501aa9@redhat.com>
	<20200430085812.GC2874@work-vm>
	<20200430135639.GA260081@redhat.com>
	<20200430142013.GI2874@work-vm>
	<20200430143425.GD2184629@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430143425.GD2184629@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>, qemu-devel@nongnu.org

On Thu, Apr 30, 2020 at 03:34:25PM +0100, Daniel P. Berrangé wrote:
> On Thu, Apr 30, 2020 at 03:20:13PM +0100, Dr. David Alan Gilbert wrote:
> > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > On Thu, Apr 30, 2020 at 09:58:12AM +0100, Dr. David Alan Gilbert wrote:
> > > [..]
> > > > > > Even without this patch, the SLAVE stuff worked so if you start the
> > > > > > daemon and *then* mount under the shared directory, the guest sees it
> > > > > > with or without this patch.
> > > > > 
> > > > > Hm, I don’t.  Do you really?
> > > > 
> > > > Yes! With your patch reverted:
> > > > 
> > > > Start virtiofsd, mount in the guest:
> > > > 
> > > > host:
> > > > # ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/home/dgilbert/virtio-fs/fs  -o log_level=warn -o no_writeback
> > > > 
> > > > guest:
> > > > # mount -t virtiofs myfs /sysroot
> > > > 
> > > > host:
> > > > # findmnt -o +PROPAGATION -N 6100
> > > > TARGET SOURCE                                                              FSTYPE OPTIONS                                                      PROPAGATION
> > > > /      /dev/mapper/fedora_dgilbert--t580-root[/home/dgilbert/virtio-fs/fs] xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,no private,slave
> > > > # mount -t tmpfs /dev/null /home/dgilbert/virtio-fs/fs/tmp
> > > > # findmnt -o +PROPAGATION -N 6100
> > > > TARGET SOURCE                                                              FSTYPE OPTIONS                                                      PROPAGATION
> > > > /      /dev/mapper/fedora_dgilbert--t580-root[/home/dgilbert/virtio-fs/fs] xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,no private,slave
> > > > └─/tmp /dev/null                                                           tmpfs  rw,relatime,seclabel                                         private,slave
> > > 
> > > Why is it showing a mount point at "/tmp". If mount point propagated, then
> > > inside guest we should see a mount point at /sysroot/tmp?
> > 
> > That findmnt is on the host.
> > 
> > > So there are two things.
> > > 
> > > A. Propagation of mount from host to virtiofsd.
> > > B. Visibility of that mount inside guest over fuse protocol (submount
> > >   functionality).
> > > 
> > > I think A works for me without any patches. But don't think B is working
> > > for me. I don't see the submount inside guest. 
> > > 
> > > > # touch /home/dgilbert/virtio-fs/fs/tmp/hello
> > > > 
> > > > guest:
> > > > # ls -l /sysroot/tmp
> > > > total 0
> > > > -rw-r--r-- 1 root root 0 Apr 30 08:50 hello
> > > 
> > > Do a "findmnt /sysroot/tmp" inside guest and see what do you see.
> > > 
> > > You will be able to see "hello" as long as virtiofsd sees the new
> > > mount point, I think. And guest does not have to see that mount point
> > > for this simple test to work.
> > 
> > Right, the guest just sees:
> > 
> > `-/sysroot                            myfs       virtiof rw,relatime
> 
> That is a good thing surely ? If I'm exporting "/sysroot" from the host,
> I want the content in "/sysroot/some/sub/mount" to be visible to the
> guest, but I don't want the guest to see "/sysroot/some/sub/mount"
> as an actual mount point. That would be leaking information about the
> host storage setup into the guest. The host admin should be free to
> re-arrange submounts in the host OS, to bring more storage space online,
> and have this be transparent to the guest OS.

If we don't see mount inside guest, we run into the possibility of inode
number collision. On host two files in shared dir can have same inode
number (if they are on two different filesystem with different device
numbers). But inside guest, we will show device number of virtiofs,
and it will look as if two files in this filesystem have same inode
number, breaking some workloads.

By propagating mounts (submounts), we can assign a unique device number
to these submounts and hence <dev,inode> number pair will become unique.

W.r.t information lea, may be we can mask some of the information in
submounts inside guest.

Thanks
Vivek

