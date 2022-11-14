Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NAm2s+uEP4b1diyhZWf0MPGS2Y2i+RzBI2nlcBy+gSc=;
 b=Egchlb991HSGg8Nk+4nR5R+Iv9N/zt0MqWauzLFUNmnlWZ3GYXuJsRUAVfL0OQ4Bv1H+
 ZTJDpWTCabqDGKEJc5Lm9K3aDEc6Ot44Da7fEks+PXF1RWvO4D9L5CF7YQkUVQbowpgq
 N7YNuCwdBcSXkNBUBK39VD4N0we0nLJjGxdwEXkI0XKvsDWVCFg3rXpbVqSqH0pE2VmP
 JiyKTwvNxVIRhasWVJXsrM0wFwnvd7cOW/NE5OM4RrdiWm2gcZ0RlsIh7BqMBkFrRDqt
 hqiSHqERjTt5SB7A0CjJbP84X+3CAfeWZien4ftrK10Lmu9/zGW7e/QgQCZOAu78q1WD PA==
Message-ID: <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
Date: Mon, 14 Nov 2022 17:18:53 +0100
MIME-Version: 1.0
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221108092308.1717426-6-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v1 5/9] hw/virtio: introduce
 virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

Am 08.11.22 um 10:23 schrieb Alex Benn=C3=A9e:
> The previous fix to virtio_device_started revealed a problem in its
> use by both the core and the device code. The core code should be able
> to handle the device "starting" while the VM isn't running to handle
> the restoration of migration state. To solve this dual use introduce a
> new helper for use by the vhost-user backends who all use it to feed a
> should_start variable.
>=20
> We can also pick up a change vhost_user_blk_set_status while we are at
> it which follows the same pattern.
>=20
> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_device_star=
ted)
> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio device)
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>

Hmmm, is this
commit 259d69c00b67c02a67f3bdbeeea71c2c0af76c35
Author:     Alex Benn=C3=A9e <alex.bennee@linaro.org>
AuthorDate: Mon Nov 7 12:14:07 2022 +0000
Commit:     Michael S. Tsirkin <mst@redhat.com>
CommitDate: Mon Nov 7 14:08:18 2022 -0500

     hw/virtio: introduce virtio_device_should_start

and older version?

This does not seem to fix the regression that I have reported.

