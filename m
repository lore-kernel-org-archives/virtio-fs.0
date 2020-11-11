Date: Wed, 11 Nov 2020 17:09:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201111220949.GB1577294@redhat.com>
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-4-vgoyal@redhat.com>
	<CAJfpegu=ooDmc3hT9cOe2WEUHQN=twX01xbV+YfPQPJUHFMs-g@mail.gmail.com>
	<20201106171843.GA1445528@redhat.com>
	<CAJfpegvvGL=GJX0a+cDUVhX754NibudTvHvtrBrCnk-FEnfQ6A@mail.gmail.com>
	<CAJfpegvoqBS-uXnPFkxViYanJUCi_s29bajyn1z7Vcd7owJVpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvoqBS-uXnPFkxViYanJUCi_s29bajyn1z7Vcd7owJVpg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 3/6] fuse: setattr should set
 FATTR_KILL_PRIV upon size change
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Wed, Nov 11, 2020 at 05:24:22PM +0100, Miklos Szeredi wrote:
> On Wed, Nov 11, 2020 at 2:54 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > How about FUSE_*KILL_SUIDGID (FUSE_WRITE_KILL_SUIDGID being an alias
> > for FUSE_WRITE_KILL_PRIV)?
> 
> Series pushed to #for-next with these changes.  Please take a look and test.

Thanks Miklos. I looked at the patches quickly and they look good. I am
now fixing qemu virtiofsd side and will test.

Thanks
Vivek

