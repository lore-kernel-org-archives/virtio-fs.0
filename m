Date: Fri, 14 Feb 2020 19:38:11 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200214193811.GO3283@work-vm>
References: <20200214192050.GD18654@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214192050.GD18654@redhat.com>
Subject: Re: [Virtio-fs] virtiofs on top of overlayfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, eric.ernst@intel.com, virtio-fs-list <virtio-fs@redhat.com>, Mrunal Patel <mpatel@redhat.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Hi Eric,
> 
> Was talking to Mrunal and he said you mentioned that virtiofs on top of
> overlayfs has some issues.
> 
> I can't remember any issues and thought it should just work. Would you
> remember the specific issue you faced with this configuraiton.
> 
> Have kata continaers tried using virtiofs on top overlayfs.

I know we've had it going on Kubernetes which has a pile of overlayfs;
I'm not sure how hard it's been pushed though.

Dave

> Thanks
> Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

