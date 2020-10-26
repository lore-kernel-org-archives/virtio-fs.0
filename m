Date: Mon, 26 Oct 2020 16:56:44 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201026165644.GA152260@work-vm>
References: <20201008103133.2722903-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008103133.2722903-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH v2] configure: add option for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org

* Misono Tomohiro (misono.tomohiro@jp.fujitsu.com) wrote:
> Currently it is unknown whether virtiofsd will be built at
> configuration time. It will be automatically built when dependency
> is met. Also, required libraries are not clear.
> 
> To make this clear, add configure option --{enable,disable}-virtiofsd.
> The default is the same as current (enabled if available) like many
> other options. When --enable-virtiofsd is given and dependency is not
> met, we get:
> 
>   ERROR: Problem encountered: virtiofsd requires libcap-ng-devel and seccomp-devel
> or
>   ERROR: Problem encountered: virtiofsd needs tools and vhost-user support
> 
> In addition, configuration summary now includes virtiofsd entry:
> 
>   build virtiofs daemon: YES/NO
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
> This patch is based on current master branch
> 
> v1 ... https://lore.kernel.org/qemu-devel/20201007092913.1524199-1-misono.tomohiro@jp.fujitsu.com/
> v1 -> v2: Update to follow the current meson build style

Queued

> 
>  configure         |  8 +++++++-
>  meson.build       |  1 +
>  meson_options.txt |  2 ++
>  tools/meson.build | 17 +++++++++++++++--
>  4 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/configure b/configure
> index 28df227db5..2bd8419b1f 100755
> --- a/configure
> +++ b/configure
> @@ -302,6 +302,7 @@ netmap="no"
>  sdl="auto"
>  sdl_image="auto"
>  virtfs=""
> +virtiofsd="auto"
>  mpath="auto"
>  vnc="enabled"
>  sparse="auto"
> @@ -1004,6 +1005,10 @@ for opt do
>    ;;
>    --enable-virtfs) virtfs="yes"
>    ;;
> +  --disable-virtiofsd) virtiofsd="disabled"
> +  ;;
> +  --enable-virtiofsd) virtiofsd="enabled"
> +  ;;
>    --disable-mpath) mpath="disabled"
>    ;;
>    --enable-mpath) mpath="enabled"
> @@ -1761,6 +1766,7 @@ disabled with --disable-FEATURE, default is enabled if available:
>    vnc-png         PNG compression for VNC server
>    cocoa           Cocoa UI (Mac OS X only)
>    virtfs          VirtFS
> +  virtiofsd       build virtiofs daemon (virtiofsd)
>    mpath           Multipath persistent reservation passthrough
>    xen             xen backend driver support
>    xen-pci-passthrough    PCI passthrough support for Xen
> @@ -7215,7 +7221,7 @@ NINJA=${ninja:-$PWD/ninjatool} $meson setup \
>  	-Dxen=$xen -Dxen_pci_passthrough=$xen_pci_passthrough -Dtcg=$tcg \
>  	-Dcocoa=$cocoa -Dmpath=$mpath -Dsdl=$sdl -Dsdl_image=$sdl_image \
>  	-Dvnc=$vnc -Dvnc_sasl=$vnc_sasl -Dvnc_jpeg=$vnc_jpeg -Dvnc_png=$vnc_png \
> -	-Dgettext=$gettext -Dxkbcommon=$xkbcommon -Du2f=$u2f \
> +	-Dgettext=$gettext -Dxkbcommon=$xkbcommon -Du2f=$u2f -Dvirtiofsd=$virtiofsd \
>  	-Dcapstone=$capstone -Dslirp=$slirp -Dfdt=$fdt \
>          $cross_arg \
>          "$PWD" "$source_path"
> diff --git a/meson.build b/meson.build
> index 17c89c87c6..a087239009 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -1843,6 +1843,7 @@ summary_info += {'Audio drivers':     config_host['CONFIG_AUDIO_DRIVERS']}
>  summary_info += {'Block whitelist (rw)': config_host['CONFIG_BDRV_RW_WHITELIST']}
>  summary_info += {'Block whitelist (ro)': config_host['CONFIG_BDRV_RO_WHITELIST']}
>  summary_info += {'VirtFS support':    config_host.has_key('CONFIG_VIRTFS')}
> +summary_info += {'build virtiofs daemon': have_virtiofsd}
>  summary_info += {'Multipath support': mpathpersist.found()}
>  summary_info += {'VNC support':       vnc.found()}
>  if vnc.found()
> diff --git a/meson_options.txt b/meson_options.txt
> index 1d3c94840a..80637ada63 100644
> --- a/meson_options.txt
> +++ b/meson_options.txt
> @@ -48,6 +48,8 @@ option('vnc_sasl', type : 'feature', value : 'auto',
>         description: 'SASL authentication for VNC server')
>  option('xkbcommon', type : 'feature', value : 'auto',
>         description: 'xkbcommon support')
> +option('virtiofsd', type: 'feature', value: 'auto',
> +       description: 'build virtiofs daemon (virtiofsd)')
>  
>  option('capstone', type: 'combo', value: 'auto',
>         choices: ['disabled', 'enabled', 'auto', 'system', 'internal'],
> diff --git a/tools/meson.build b/tools/meson.build
> index 513bd2ff4f..76bf84df52 100644
> --- a/tools/meson.build
> +++ b/tools/meson.build
> @@ -1,10 +1,23 @@
> -have_virtiofsd = (have_system and
> +have_virtiofsd = (targetos == 'linux' and
>      have_tools and
> -    'CONFIG_LINUX' in config_host and 
>      'CONFIG_SECCOMP' in config_host and
>      'CONFIG_LIBCAP_NG' in config_host and
>      'CONFIG_VHOST_USER' in config_host)
>  
> +if get_option('virtiofsd').enabled()
> +  if not have_virtiofsd
> +    if targetos != 'linux'
> +      error('virtiofsd requires Linux')
> +    elif 'CONFIG_SECCOMP' not in config_host or 'CONFIG_LIBCAP_NG' not in config_host
> +      error('virtiofsd requires libcap-ng-devel and seccomp-devel')
> +    elif not have_tools or 'CONFIG_VHOST_USER' not in config_host
> +      error('virtiofsd needs tools and vhost-user support')
> +    endif
> +  endif
> +elif get_option('virtiofsd').disabled() or not have_system
> +  have_virtiofsd = false
> +endif
> +
>  if have_virtiofsd
>    subdir('virtiofsd')
>  endif
> -- 
> 2.25.4
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

