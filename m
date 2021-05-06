Date: Thu, 6 May 2021 16:52:33 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJQQwcVgMiUWLQ5c@work-vm>
References: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
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
To: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Carlos Venegas (jose.carlos.venegas.munoz@intel.com) wrote:
> 
> Using xattrmap for Kata Containers we found that xattr is should be used
> or xattrmap wont work.  These patches enable xattr when -o xattrmap is
> used. Also, they add help for the xattrmap  option on `virtiofsd --help` output.

Queued.  You might like to submit some more patches to give the error
that Greg was suggesting and/or update some docs.

Dave

> Carlos Venegas (2):
>   virtiofsd: Allow use "-o xattrmap" without "-o xattr"
>   virtiofsd: Add help for -o xattr-mapping
> 
>  tools/virtiofsd/helper.c         | 3 +++
>  tools/virtiofsd/passthrough_ll.c | 1 +
>  2 files changed, 4 insertions(+)
> 
> -- 
> 2.25.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

