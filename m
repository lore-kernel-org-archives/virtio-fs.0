DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=z7ogThrqS4JyzdwTXDFIZWvMA6+TCHHiCxNqhuS+TBo=;
	b=Wan2aUglYtsz3oduHIRK9rRhcrAXr3Z9VB9FJx1mIvDp8GVzvKFzVmrvPLQygjXTRr+/0DYtKMDAlz+8OrJi/sQ7BJTaJtuvmXLNqsLDPdqta+ue8dvpSdtbyEf46HxwOGFS4iO8prZ2Q1Y4aoqL6k/z0tSD2AdhgkwmCLlIHfs=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Thu, 24 Oct 2019 09:05:02 +0000
Message-ID: <OSBPR01MB37837B4AB38461063F645019E56A0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] False error message when DAX cache is disabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

Hi,

I'm testing virtiofs on ARM enviroment.
Since current ARM does not support DAX, I use cache-size=0 for vhost-user-fs-pci parameter.

This results in the following error message during unmount:
```
vhost_user_fs_slave_unmap: unmap when DAX cache not present
lo_destroy: unmap during destroy failed
```

This is because lo_destroy() always calls fuse_virtio_unmap().
So, I want to fix this by not calling fuse_virtio_unmap() when cache is not used,
but is there any good way for virtiofsd to know vhost-user's cahce-size?

Thanks.
Misono

