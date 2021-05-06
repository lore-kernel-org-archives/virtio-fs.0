From: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>
Date: Thu, 6 May 2021 15:55:42 +0000
Message-ID: <f89d4c8297ba422c924c7d4c16a77402@intel.com>
References: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
	<YJQQwcVgMiUWLQ5c@work-vm>
In-Reply-To: <YJQQwcVgMiUWLQ5c@work-vm>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Enable xattr if xattrmap is
	used
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "vgoyal@redhat.com" <vgoyal@redhat.com>

Thank you both for the suggestions, I had not took a look recently, I will check today in my afternoon.

Cheers.

> -----Original Message-----
> From: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Sent: Thursday, May 6, 2021 10:53 AM
> To: Venegas Munoz, Jose Carlos <jose.carlos.venegas.munoz@intel.com>
> Cc: virtio-fs@redhat.com; qemu-devel@nongnu.org; vgoyal@redhat.com
> Subject: Re: [PATCH 0/2] virtiofsd: Enable xattr if xattrmap is used
> 
> * Carlos Venegas (jose.carlos.venegas.munoz@intel.com) wrote:
> >
> > Using xattrmap for Kata Containers we found that xattr is should be
> > used or xattrmap wont work.  These patches enable xattr when -o
> > xattrmap is used. Also, they add help for the xattrmap  option on `virtiofsd -
> -help` output.
> 
> Queued.  You might like to submit some more patches to give the error that
> Greg was suggesting and/or update some docs.
> 
> Dave
> 
> > Carlos Venegas (2):
> >   virtiofsd: Allow use "-o xattrmap" without "-o xattr"
> >   virtiofsd: Add help for -o xattr-mapping
> >
> >  tools/virtiofsd/helper.c         | 3 +++
> >  tools/virtiofsd/passthrough_ll.c | 1 +
> >  2 files changed, 4 insertions(+)
> >
> > --
> > 2.25.1
> >
> >
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


