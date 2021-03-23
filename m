Date: Tue, 23 Mar 2021 10:02:56 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210323100256.1f0b43dc@bahia.lan>
In-Reply-To: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
References: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Ge, Xiongzi" <Xiongzi.Ge@netapp.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, 23 Mar 2021 01:35:58 +0000
"Ge, Xiongzi" <Xiongzi.Ge@netapp.com> wrote:

> Hello Vivek, Dr. Gilbert, and the virtio-fs team,
> 
> It seems that virtio-fs does not support live migration. Once a vm is
> configured with virtio-fs, live migration cannot be performed even it
> is not mounted on the guest. Is there any progress for this? If the

Live migration of virtio-fs is still at the early discussion stage AFAICT.
It might take time before we have something working. But in the meantime,
it seems abusive to block migration if we have a guarantee that the device
isn't servicing requests. FWIW virtio-9p only blocks migration when the
shared directory is mounted on the guest.

> shared directory is from a distributed file system like Ceph, would it
> be easier than the general case to be implemented? 
> 
> Thanks,
> Xiongzi
> 
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

