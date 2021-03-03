Date: Wed, 3 Mar 2021 13:20:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210303182027.GA3793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] Query about announce_submounts and ro/rw mounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>

Hi Max,

I was playing with "announce_submounts". I have a read-only bind mounted
mount point in shared directory. Inside guest, when I step into that
directory, I see that a mount point got created but its "rw" and not "ro".

Is that intentional. Can we send property of mount also to guest when
notifying guest about mount point.

Does it make sense? I guess then next problem will be what if mount
changes back to "rw" and how to we propagate to guest. IIUC, we will
probably need monitor it and send notifications. Or notice this chagne
on next lookup.

Thanks
Vivek

