References: <20201007092913.1524199-1-misono.tomohiro@jp.fujitsu.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <15796673-2daf-70a8-4b20-b861d4c22e62@redhat.com>
Date: Wed, 7 Oct 2020 17:30:36 +0200
MIME-Version: 1.0
In-Reply-To: <20201007092913.1524199-1-misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] configure: add option for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com

On 07/10/20 11:29, Misono Tomohiro wrote:
> Currently it is unknown whether virtiofsd will be built at
> configuration time. It will be automatically built when dependency
> is met. Also, required libraries are not clear.
> 
> To make this clear, add configure option --{enable,disable}-virtiofsd.
> The default is the same as current (enabled if available) like many
> other options. When --enable-virtiofsd is given and dependency is not
> met, we get:
> 
>   ERROR: virtiofsd requires libcap-ng devel, seccomp devel, vhost user and tools support
> 
> In addition, configuration summary now includes virtiofsd entry:
> 
>   build virtiofs daemon: YES/NO
> 
> Sidenote: this patch defines CONFIG_VIRTIOFSD for config-host.mak
> to avoid duplicate dependency check in tools/meson.build.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Hi Misono,

can you please handle the option via meson_options.txt?  That is, just
pass the value (auto/enabled/disabled) through from configure to meson,
and handle the default in tools/meson.build.  The logic will be
something like this:

have_virtiofsd = (targetos == 'linux' and
    'CONFIG_SECCOMP' in config_host and
    'CONFIG_LIBCAP_NG' in config_host)

if get_option('virtiofsd').enabled()
  if not have_virtiofsd
    if targetos != 'linux'
      error('virtiofsd requires Linux')
    else
      error('virtiofsd requires libcap-ng-devel and seccomp-devel')
    endif
  endif
elif get_option('virtiofsd').disabled() or not have_tools or \
     not 'CONFIG_VHOST_USER' in config_host
  have_virtiofsd = false
endif

if have_virtiofsd
  subdir('virtiofsd')
endif

This is because, when adding the option, there are some conditions that
should disable virtiofsd by default but can be overridden with
--enable-virtiofsd.

More information on how to create a new Meson option can be found in
docs/devel/build-system.rst.

Thanks,

Paolo

> -have_virtiofsd = (have_system and
> -    have_tools and
> -    'CONFIG_LINUX' in config_host and 
> -    'CONFIG_SECCOMP' in config_host and
> -    'CONFIG_LIBCAP_NG' in config_host and
> -    'CONFIG_VHOST_USER' in config_host)
> -
> -if have_virtiofsd
> +if 'CONFIG_VIRTIOFSD' in config_host
>    subdir('virtiofsd')
>  endif
> 

