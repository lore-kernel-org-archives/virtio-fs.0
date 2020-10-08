DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=tVltWtvuo6RKlT48rul8AcVCzWmO7VnbCvTuRpipyyM=;
	b=QDej03UwDeEBOeg9gCu2HZOlbu3pf9nRFPgDKhvOTzIVmqKy5/oHjtmCx6i8xhX60qej+cQhgTFT9VLvu6aCvCSCmlvtb40K7LeF/MTyuoYYH2s4QY2ogdTTp8uwkSwb8y2I/SCVp6wyoHf18PgEXdr8bd+QN3pCC9UlJ6Q5FVc=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Thu, 8 Oct 2020 10:13:17 +0000
Message-ID: <OSBPR01MB458244F79B20419ABCB1758DE50B0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20201007092913.1524199-1-misono.tomohiro@jp.fujitsu.com>
	<15796673-2daf-70a8-4b20-b861d4c22e62@redhat.com>
	<OSBPR01MB45820C38F613E3D38A565CCEE50B0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<20201008095505.GA2962@work-vm>
In-Reply-To: <20201008095505.GA2962@work-vm>
MIME-Version: 1.0
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] configure: add option for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "'Dr. David Alan Gilbert'" <dgilbert@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

...
> > BTW, while testing the updated patch, I noticed current master branch (as of 10/08) fails to execute virtiofsd.
> > backtrace from coredump shows:
> > #0  get_relocated_path (dir=0x560f4d2f2ef0
> > "/usr/local/var/run/virtiofsd") at ../util/cutils.c:924
> > #1  0x0000560f4baab6da in qemu_get_local_state_pathname
> (relative_pathname=relative_pathname@entry=0x560f4bac6cf1 "run/virtiofsd")
> >     at ../util/oslib-posix.c:345
> > #2  0x0000560f4baa1b09 in fv_socket_lock (se=0x560f4d2f2f20) at
> > ../tools/virtiofsd/fuse_virtio.c:865
> > #3  fv_create_listen_socket (se=0x560f4d2f2f20) at
> > ../tools/virtiofsd/fuse_virtio.c:906
> > #4  virtio_session_mount (se=0x560f4d2f2f20) at
> > ../tools/virtiofsd/fuse_virtio.c:968
> > #5  0x0000560f4ba99725 in main (argc=<optimized out>, argv=<optimized
> > out>) at ../tools/virtiofsd/passthrough_ll.c:2947
> >
> > So, this is related to:
> > https://github.com/qemu/qemu/commit/f4f5ed2cbde65acaa1bd88d00cc23fa8bf
> > 6b5ed9#diff-ae9b732998587b609c0854bae40b2fe6R924
> >
> > Adding  "qemu_init_exec_dir(argv[0]);" in virtiofs's main() seems
> > solve the problem, but is it correct fix?
> 
> Yes, I've already posted the fix for that,
>    https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg01852.html
> 

Thanks, then test is ok and I will send v2.

Regards,
Misono

> Dave
> 
> > Regards,
> > Misono
> >
> > >
> > > Thanks,
> > >
> > > Paolo
> > >
> > > > -have_virtiofsd = (have_system and
> > > > -    have_tools and
> > > > -    'CONFIG_LINUX' in config_host and
> > > > -    'CONFIG_SECCOMP' in config_host and
> > > > -    'CONFIG_LIBCAP_NG' in config_host and
> > > > -    'CONFIG_VHOST_USER' in config_host)
> > > > -
> > > > -if have_virtiofsd
> > > > +if 'CONFIG_VIRTIOFSD' in config_host
> > > >    subdir('virtiofsd')
> > > >  endif
> > > >
> >
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


