Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=XTZt6pIHyRBd2fUozQ3lvY4ZxtLulVzZXH6aT7zVlvs=;
 b=qs7DoOJgWsQljHUfr8MSwP98c7dtZCFT1ao+oUBxKh8TJlKtELgU3qUPutyy8aytgN
 HUfTpsUe5NNejAP/kbteKrr6uiCuoGanriUkKDScizESwbOtG9xAGCWN/TZdUeH5ckkS
 MDQXqjf9zT+mhqMts06P5HE3/ozZYsoc75MGJFqQeH79gy0AfXT8hfGlNpaNAPVXLcc0
 OttOHzXYbmZXfBaEE7plkTmBkCh3W/Q0SyrY9QsURzFQ5t7cqnh960ZVyJyt+NmQa14r
 xUj1DBRW9N2DEM60fer/3hQlKufGc2sXXAcs+Opd5utuOolF0ifw27KhavCpiRzeircQ
 b5DA==
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 14 Nov 2022 16:43:47 +0000
In-reply-to: <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
Message-ID: <8735albi3h.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan
 Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>


Christian Borntraeger <borntraeger@linux.ibm.com> writes:

> Am 08.11.22 um 10:23 schrieb Alex Benn=C3=A9e:
>> The previous fix to virtio_device_started revealed a problem in its
>> use by both the core and the device code. The core code should be able
>> to handle the device "starting" while the VM isn't running to handle
>> the restoration of migration state. To solve this dual use introduce a
>> new helper for use by the vhost-user backends who all use it to feed a
>> should_start variable.
>> We can also pick up a change vhost_user_blk_set_status while we are
>> at
>> it which follows the same pattern.
>> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to
>> virtio_device_started)
>> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio device=
)
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>
> Hmmm, is this
> commit 259d69c00b67c02a67f3bdbeeea71c2c0af76c35
> Author:     Alex Benn=C3=A9e <alex.bennee@linaro.org>
> AuthorDate: Mon Nov 7 12:14:07 2022 +0000
> Commit:     Michael S. Tsirkin <mst@redhat.com>
> CommitDate: Mon Nov 7 14:08:18 2022 -0500
>
>     hw/virtio: introduce virtio_device_should_start
>
> and older version?

Only missing the additional Fixes line MST suggested in the review. I
should have made it clearer in the --- comment.

Which test is failing?

--=20
Alex Benn=C3=A9e

