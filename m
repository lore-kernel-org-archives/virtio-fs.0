References: <20201007092913.1524199-1-misono.tomohiro@jp.fujitsu.com>
	<15796673-2daf-70a8-4b20-b861d4c22e62@redhat.com>
	<OSBPR01MB45820C38F613E3D38A565CCEE50B0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0cab3544-b9c3-ae8f-3a9d-62d026d062e6@redhat.com>
Date: Thu, 8 Oct 2020 12:43:54 +0200
MIME-Version: 1.0
In-Reply-To: <OSBPR01MB45820C38F613E3D38A565CCEE50B0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
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
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On 08/10/20 11:17, misono.tomohiro@fujitsu.com wrote:
> Hi Paolo
> 
> Thanks a lot for the clear explanation. I will update the patch to follow the meson style.
> I realized virtiofsd actually needs tools (i.e. "--disable-tools --enable-virtiofsd"
> does not work with above meson.build) since virtiofsd requires libvhost_user which will
> be built ony when tools are built. So, I will keep the current dependency check (except 'have_system').

I'm thinking the behavior for --disable-tools --enable-virtiofsd would
be confusing.  Therefore, another possibility is not introducing
--enable-virtiofsd.  Instead, you can reuse --enable-vhost-user-fs:

- --enable-vhost-user-fs will fail if tools are enabled and cap-ng or
seccomp are unavailable

- --enable-vhost-user-fs --disable-tools will not look for cap-ng or
seccomp, because then the flag only controls inclusion of vhost-user-fs
in the emulators

- if "--enable-vhost-user-fs" is not specified and tools are enabled,
vhost-user-fs will only be included in the emulators if cap-ng and
seccomp are available

- if "--enable-vhost-user-fs" is not specified, tools are enabled and
cap-ng/seccomp are unavilable, vhost-user-fs will not be included in the
emulators either

- if "--enable-vhost-user-fs" is not specified but tools are not
enabled, configure will not check if cap-ng or seccomp.

In this case reusing most of your previous patch, and not moving
everything to meson, is totally okay.  I don't want you to impose more
transition work.

Paolo

