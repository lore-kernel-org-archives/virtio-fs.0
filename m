DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to;
	bh=YG0L3wKn++d3omIZATisPGrSaErh2+D0JznHzkSGAbs=;
	b=gPw20euKQEntdSSq980HfBz/7xR14S15dAZcXCRYDXhJ1D/+/0Zy7pE28+Pv4iaqc4
	t42xvHAx0HIElKjhfQbqbnflTKl8WICRYI59EkruKVkcXR5rkiusjX+RNcwz8MIp1XTv
	2GyQ4zmEmRfPEwQPOrrEABaK6tzMZkgK4ClOdyO67fiUwWgejggpAtQX6fumRhdKmmEs
	YMva1EbCficPcenU6hDkiLAng2YQKmfkamEQAbcDXvda1vkub3KoWtOgilHGHiYW1weU
	Z7ZX9cEwF4ezXJTZZ3KB0LQeXjJBFEXbD/thL67N+ApJNfJ+w+2z16JGCXvkkI9LWn+O
	zGfg==
Date: Sat, 4 Jul 2020 14:46:25 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20200704184625.4tivbyaiwnfzdz5z@gabell>
References: <CALjEBWSmL_1s8n4WEMQS9_6At2B24sXysEkiWiUA867hcLbD5g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjEBWSmL_1s8n4WEMQS9_6At2B24sXysEkiWiUA867hcLbD5g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] Mount error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: David Lomas <dl3@pale-eds.co.uk>
Cc: virtio-fs@redhat.com

On Thu, Jul 02, 2020 at 04:20:15PM +0100, David Lomas wrote:
> I've compiled and installed kernel 5.7, and have virtiofs mostly working,
> but I'm still being caught by something which leads to an error. I've
> defined the filesystem on the host like this:
> 
> <filesystem type='mount' accessmode='passthrough'>
>   <driver type='virtiofs'/>
>   <binary path='/usr/libexec/virtiofsd'/>
>   <source dir='/data/hosts/VMHOSTNAME/users'/>
>   <target dir='users'/>
>   <address type='pci' domain='0x0000' bus='0x00' slot='0x09'
> function='0x0'/>
> </filesystem>
> 
> and on the host I've put this in /etc/fstab:
> 
> users           /appdata/users            virtiofs
> 
> On boot, the /appdata/users folder is correctly mounted, but if I ever try
> to manually unmount / remount, or if I boot up without an entry in
> /etc/fstab and try to mount manually with something like:
> 
> # mount -t virtiofs users /appdata/users
> 
> I get this rather opaque error:
> 
> mount: /appdata/users : wrong fs type, bad option, bad superblock on /
> appdata/users, missing codepage or helper program, or other error.
> 
> Are there more options I should be specifying which for some reason aren't
> needed on boot?

Hi David,

If 'users' directory is in the current directory, the mount command will fail.

  # ls
  users
  # mount -t virtiofs --source users /mnt/users
  mount: /mnt/users: wrong fs type, bad option, bad superblock on /mnt/users, missing codepage or helper program, or other error.
  #

That's because the mount command handles the full path of 'users' as the
first argument for mount() system call like as:

  # strace -emount mount -t virtiofs users /mnt/users
  mount("/mnt/users", "/mnt/users", "virtiofs", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
  mount: /mnt/users: wrong fs type, bad option, bad superblock on /mnt/users, missing codepage or helper program, or other error.
  +++ exited with 32 +++
  # 

I'm not sure mount command has an option to avoid that, but probably
you can avoid the failure to change current directory.

Thanks,
Masa

