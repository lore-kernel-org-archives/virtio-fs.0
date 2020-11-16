DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605526040; 
	s=20191117-8ozv; d=jwatt.org; i=jwatt@jwatt.org;
	h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=1746; bh=WZT5DO7Q9U1IxeCrO0qnOdEIQ/Cl2tLWDqoFewHRPEw=;
	b=mFAb8QZUlY6fQ5VdkaElhpbkA1RflwmKdja9LxycSqOJwagDsNRUh9S3sJ1FXgNq
	xSYUuN2nsHwUqK0FiINcvn6hu5Nx77HIsX7TLsuGOH6qlqOtPwcF+h75qHY0sUzWuT9
	1lp45LzPWKWRsr9aBSfHV8XvOD6fP2oCGLTUKz5kk2ZX6rkQjzgSfxGG5rmib3nAJwu
	cOkMs7Mroesdc6PbpXR90L2sdDb3KUL85OCFtJyFtIeCTxLtO0YlhIe+36RWsKJuyBz
	soo2IFcPgYKvhwewVYbL8MIwRW9YA/np1tobagrte8HiG29itH2+2oirHh9iYAInXYd
	YFDHT7+8Cw==
From: Jonathan Watt <jwatt@jwatt.org>
Message-ID: <951c3359-f820-5c61-aa05-3419916761dc@jwatt.org>
Date: Mon, 16 Nov 2020 11:27:16 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] Issues with the virtio-fs Windows how-to (unexpected
 read-only file system)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hello list,

Thank you all for your work on virtio-fs. It's a very exciting step forward!

Like others[1], I've encountered the issue where virtio-fs mounted file systems
are unexpectedly read-only/inaccessible on Windows.

I worked through the Windows how-to page[2], but the "Installing the virtio-fs
service" instructions at the bottom did not work for me, as written. The
instructions are to set the new `VirtioFsSvc` service to depend on both
`WinFsp.Launcher` and `VirtioFsDrv`. However, like others, I found that the new
service would not run since `VirtioFsDrv` does not appear to exist (be a service).

After opening `regedit`, opening the key:

  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VirtioFsSvc

removing `VirtioFsDrv` from the value of `DependsOnService`, and then restarting
the `VirtioFsSvc` service, the file system shared via virtio-fs appeared at
'Z:\' and worked as expected. However, this only works until the Windows VM is
rebooted.

On rebooting the Windows VM, the shared file system becomes read-only and its
sub-directories cannot be opened. Manually restarting the `VirtioFsSvc` service
gets the share working again (until next reboot). This seems to indicate that
`VirtioFsSvc` is running too early, and that it really does need to wait for
*something* else to be ready before starting.

I suppose the first question is what is `VirtioFsDrv` and where is it supposed
to come from? Are there steps missing from the Windows how-to or has the name of
this service changed?

-Jonathan

1. For example, the comments starting here:
https://github.com/virtio-win/kvm-guest-drivers-windows/issues/473#issuecomment-658379853

2. https://virtio-fs.gitlab.io/howto-windows.html

