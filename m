References: <20200909184028.262297-1-mreitz@redhat.com>
	<20200909184028.262297-8-mreitz@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <7dacc660-4a4d-43a3-c264-11bbae223b31@redhat.com>
Date: Thu, 10 Sep 2020 07:23:18 +0200
MIME-Version: 1.0
In-Reply-To: <20200909184028.262297-8-mreitz@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH 7/8] tests/acceptance/boot_linux: Accept SSH
	pubkey
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

On 9/9/20 8:40 PM, Max Reitz wrote:
> Let download_cloudinit() take an optional pubkey, which subclasses of
> BootLinux can pass through setUp().
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

> ---
>  tests/acceptance/boot_linux.py | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/acceptance/boot_linux.py b/tests/acceptance/boot_linux.py
> index 0055dc7cee..ad997c3f2e 100644
> --- a/tests/acceptance/boot_linux.py
> +++ b/tests/acceptance/boot_linux.py
> @@ -57,7 +57,7 @@ class BootLinuxBase(Test):
>              self.cancel('Failed to download/prepare boot image')
>          return boot.path
>  
> -    def download_cloudinit(self):
> +    def download_cloudinit(self, ssh_pubkey=None):
>          self.log.info('Preparing cloudinit image')
>          try:
>              cloudinit_iso = os.path.join(self.workdir, 'cloudinit.iso')
> @@ -67,7 +67,8 @@ class BootLinuxBase(Test):
>                            password='password',
>                            # QEMU's hard coded usermode router address
>                            phone_home_host='10.0.2.2',
> -                          phone_home_port=self.phone_home_port)
> +                          phone_home_port=self.phone_home_port,
> +                          authorized_key=ssh_pubkey)
>          except Exception:
>              self.cancel('Failed to prepared cloudinit image')
>          return cloudinit_iso
> @@ -80,19 +81,19 @@ class BootLinux(BootLinuxBase):
>      timeout = 900
>      chksum = None
>  
> -    def setUp(self):
> +    def setUp(self, ssh_pubkey=None):
>          super(BootLinux, self).setUp()
>          self.vm.add_args('-smp', '2')
>          self.vm.add_args('-m', '1024')
>          self.prepare_boot()
> -        self.prepare_cloudinit()
> +        self.prepare_cloudinit(ssh_pubkey)
>  
>      def prepare_boot(self):
>          path = self.download_boot()
>          self.vm.add_args('-drive', 'file=%s' % path)
>  
> -    def prepare_cloudinit(self):
> -        cloudinit_iso = self.download_cloudinit()
> +    def prepare_cloudinit(self, ssh_pubkey=None):
> +        cloudinit_iso = self.download_cloudinit(ssh_pubkey)
>          self.vm.add_args('-drive', 'file=%s,format=raw' % cloudinit_iso)
>  
>      def launch_and_wait(self):
> 

