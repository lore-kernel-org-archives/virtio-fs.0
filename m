DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alxu.ca; s=default;
	t=1611244334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=hwusA5u2Bv03DQWiw/c6bTo7Qi3VBtEU4lc3gAbI9eY=;
	b=oekxjd5dpyKb11J/oyvxyzhVOVLncAKUT52ZZnyiUnl82AxZWrr/L3pDQkAF2Z+9cZMNku
	jYdMCEwqAmvL2/EqzT02kA8PxSik9QYV58fB9pDI0169e0H5JPSgUJgE/LVsVP3y6RMKFY
	G+MXerc/RHRUke+y8pdacfnVgNKZ4ihdk60RoPZsEKoIccTnEhhOZQesdcYwlWFg8ZsvJU
	F+L3dkQSrzqr307ahO/YzZE/njwCaNPGaBMiH4VFthi17RL6Ya4w5SeZUu5Bgnho3/4SGI
	InZ+lreIfLpEPMLraYLYxLcn48x4pnZIWnpM/9i6nRMLhMP/SUk7xLDEgoYihg==
Date: Thu, 21 Jan 2021 10:52:10 -0500
From: Alex Xu <alex@alxu.ca>
References: <20210121144429.58885-1-stefanha@redhat.com>
	<f5fc73e5-334e-c1ef-3982-227715efc26b@redhat.com>
In-Reply-To: <f5fc73e5-334e-c1ef-3982-227715efc26b@redhat.com>
MIME-Version: 1.0
Message-Id: <1611243688.4854bsewsj.none@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: prevent opening of special files
 (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>, qemu-devel@nongnu.org
Cc: P J P <ppandit@redhat.com>, virtio-fs@redhat.com, vgoyal@redhat.com

Excerpts from Laszlo Ersek's message of January 21, 2021 10:32 am:
> Assuming a benign / trusted guest, is there going to be an override for
> this?
> 
> Asked differently -- if we don't want to set up a separate block device
> on the host, to contain the filesystem that is mounted as the shared
> directory, can unionfs (?) / overlayfs be used to re-mount an existent
> host-side directory as the shared directory, but with
> "noexec,nosuid,nodev" *bolted-on*?
> 
> If people have to create separate block devices (on the host side) for
> innocent use cases such as running tests in a trusted guest, that's not
> going to qualify as "usability progress" relative to having a qcow2 (or
> raw) image file.
> 
> "nodev,nosuid" is kind of a no-brainer for any host-side *data* volume
> anyway (such as the one underlying "/home", even), so I don't see those
> options as a challenge. But "noexec" is different.
> 
> Thanks,
> Laszlo

On Linux, there are two types of mount options: per-superblock, and 
per-point. Most filesystem-specific options are per-superblock, and 
apply to all mounts of that device. noexec, nosuid, and nodev are 
per-mount options, and apply individually to each mount, bind or 
otherwise, of a given device. Bind mounts copy the parent per-mount 
options, but can be individually altered. Note also that it is not 
required to create a new location for a bind mount.

For example, invoking:

mount --bind -o noexec,nosuid,nodev /var/lib/vms/source1 /var/lib/vms/source1

would effectively secure a source directory. This can also be inserted 
in /etc/fstab, such as:

/var/lib/vms/source1 /var/lib/vms/source1 none bind,noexec,nosuid,nodev 0 0

Note that, as explained in Stefan's initial email, this hides any 
submounts below source. Each of those must be individually protected, 
either by initially mounting with the security options or by creating a 
new bind mount as above. Although these cases should be infrequent, they 
are common enough that Stefan and I think that they should be supported, 
or at the very least not silently behave in unexpected or insecure ways.

Additionally, while it's possible to use overlayfs for this purpose, 
it's overkill, and as far as I understand, doesn't solve the problem of 
hiding sub-mounts.

Regards,
Alex.


