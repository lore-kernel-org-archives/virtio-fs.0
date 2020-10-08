Date: Thu, 8 Oct 2020 10:55:05 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201008095505.GA2962@work-vm>
References: <20201007092913.1524199-1-misono.tomohiro@jp.fujitsu.com>
	<15796673-2daf-70a8-4b20-b861d4c22e62@redhat.com>
	<OSBPR01MB45820C38F613E3D38A565CCEE50B0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB45820C38F613E3D38A565CCEE50B0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH] configure: add option for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

* misono.tomohiro@fujitsu.com (misono.tomohiro@fujitsu.com) wrote:
> > On 07/10/20 11:29, Misono Tomohiro wrote:
> > > Currently it is unknown whether virtiofsd will be built at
> > > configuration time. It will be automatically built when dependency is
> > > met. Also, required libraries are not clear.
> > >
> > > To make this clear, add configure option --{enable,disable}-virtiofsd.
> > > The default is the same as current (enabled if available) like many
> > > other options. When --enable-virtiofsd is given and dependency is not
> > > met, we get:
> > >
> > >   ERROR: virtiofsd requires libcap-ng devel, seccomp devel, vhost user
> > > and tools support
> > >
> > > In addition, configuration summary now includes virtiofsd entry:
> > >
> > >   build virtiofs daemon: YES/NO
> > >
> > > Sidenote: this patch defines CONFIG_VIRTIOFSD for config-host.mak to
> > > avoid duplicate dependency check in tools/meson.build.
> > >
> > > Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> > 
> > Hi Misono,
> > 
> > can you please handle the option via meson_options.txt?  That is, just pass the value (auto/enabled/disabled) through
> > from configure to meson, and handle the default in tools/meson.build.  The logic will be something like this:
> > 
> > have_virtiofsd = (targetos == 'linux' and
> >     'CONFIG_SECCOMP' in config_host and
> >     'CONFIG_LIBCAP_NG' in config_host)
> > 
> > if get_option('virtiofsd').enabled()
> >   if not have_virtiofsd
> >     if targetos != 'linux'
> >       error('virtiofsd requires Linux')
> >     else
> >       error('virtiofsd requires libcap-ng-devel and seccomp-devel')
> >     endif
> >   endif
> > elif get_option('virtiofsd').disabled() or not have_tools or \
> >      not 'CONFIG_VHOST_USER' in config_host
> >   have_virtiofsd = false
> > endif
> > 
> > if have_virtiofsd
> >   subdir('virtiofsd')
> > endif
> > 
> > This is because, when adding the option, there are some conditions that should disable virtiofsd by default but can be
> > overridden with --enable-virtiofsd.
> > 
> > More information on how to create a new Meson option can be found in docs/devel/build-system.rst.
> 
> Hi Paolo
> 
> Thanks a lot for the clear explanation. I will update the patch to follow the meson style.
> I realized virtiofsd actually needs tools (i.e. "--disable-tools --enable-virtiofsd"
> does not work with above meson.build) since virtiofsd requires libvhost_user which will
> be built ony when tools are built. So, I will keep the current dependency check (except 'have_system').
> 
> BTW, while testing the updated patch, I noticed current master branch (as of 10/08) fails to execute virtiofsd.
> backtrace from coredump shows:
> #0  get_relocated_path (dir=0x560f4d2f2ef0 "/usr/local/var/run/virtiofsd") at ../util/cutils.c:924
> #1  0x0000560f4baab6da in qemu_get_local_state_pathname (relative_pathname=relative_pathname@entry=0x560f4bac6cf1 "run/virtiofsd")
>     at ../util/oslib-posix.c:345
> #2  0x0000560f4baa1b09 in fv_socket_lock (se=0x560f4d2f2f20) at ../tools/virtiofsd/fuse_virtio.c:865
> #3  fv_create_listen_socket (se=0x560f4d2f2f20) at ../tools/virtiofsd/fuse_virtio.c:906
> #4  virtio_session_mount (se=0x560f4d2f2f20) at ../tools/virtiofsd/fuse_virtio.c:968
> #5  0x0000560f4ba99725 in main (argc=<optimized out>, argv=<optimized out>) at ../tools/virtiofsd/passthrough_ll.c:2947
> 
> So, this is related to: https://github.com/qemu/qemu/commit/f4f5ed2cbde65acaa1bd88d00cc23fa8bf6b5ed9#diff-ae9b732998587b609c0854bae40b2fe6R924
> 
> Adding  "qemu_init_exec_dir(argv[0]);" in virtiofs's main() seems solve the problem, 
> but is it correct fix?

Yes, I've already posted the fix for that,
   https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg01852.html

Dave

> Regards,
> Misono
> 
> > 
> > Thanks,
> > 
> > Paolo
> > 
> > > -have_virtiofsd = (have_system and
> > > -    have_tools and
> > > -    'CONFIG_LINUX' in config_host and
> > > -    'CONFIG_SECCOMP' in config_host and
> > > -    'CONFIG_LIBCAP_NG' in config_host and
> > > -    'CONFIG_VHOST_USER' in config_host)
> > > -
> > > -if have_virtiofsd
> > > +if 'CONFIG_VIRTIOFSD' in config_host
> > >    subdir('virtiofsd')
> > >  endif
> > >
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

