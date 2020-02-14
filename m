Date: Fri, 14 Feb 2020 19:41:30 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200214194130.GP3283@work-vm>
References: <20200214192705.GE18654@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214192705.GE18654@redhat.com>
Subject: Re: [Virtio-fs] One virtiofs daemon per exported dir requirement
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Mrunal Patel <mpatel@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Hi,
> 
> Dan Walsh and Mrunal mentioned that one virtiofsd daemon per exported
> directory requirement sounds excessive. For container use case, they have
> atleast 2-3 more directories they need to export (secrets and /etc/host). And
> that means 3-4 virtiofsd running for each kata container. 
> 
> One option seems that bind mount all exports in one directory and export
> that directory using one virtiofsd. I am aware of atleast one problem
> with that configuraiton and that is possibility of inode number collision
> if bind mounts are coming from different devices. Not sure how many
> applications care though. Sergio is looking into solving this issue. It
> might take a while though.

I thought the bind mount setup was the normal setup seen under both Kata
and k8s?

Dave

> Any other thoughts?
> 
> Thanks
> Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

