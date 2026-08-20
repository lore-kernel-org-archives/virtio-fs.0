Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40D8481B1
	for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 05:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787202986; cv=none; b=WCsQt3lqYxWNETXtr7zRHcxfvegUVVGg+W7Ti8NxEBtnvP209wnydUvo7x7CzgEkzWtjrX7lfqTYKETouLtX7pn3q2Iv3WeFR2gixyMAPXAD5FsTmMaQ92E88QDikmE/oZVyK0PciwYoEV8ucittcIDi/Qj9zfug6atUh67fgQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787202986; c=relaxed/simple;
	bh=v1F06riwhHCx781eU0q6/4ueT5lROpsIxl3/fWzzoSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sNwAd+BANi+W0HHyLOjNuNVbvFwwPdFzgSp+Rvg8N7dgS8/UVmYLySqkUlctrN+HG5fP/8FVIP0tYouMAF029Bi37VTgeeHlq/fi1G3EFGTAotZC6lYvi5j5GToDFr0JSNhxt26vOURYmhGodvzqCRIopAAy9IlGBYPiuA8ISNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Noupx53v; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Noupx53v"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 67K5FXPI018865
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 20 Aug 2026 14:15:33 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=rU0/NaSZSW+ptE5GcwPdHmgUY4qSm99dpqANL/CZykY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1787202934; v=1;
        b=Noupx53vV2twwFagNuE5qy2FBh49dOSiK6/fvZQ3oMSzJqQm0WwAgdJM1OHBMWgG
         CKu0CCgJxzLzraIuu4UKKbCMmSIXbj8LY4e1P7WVa5tk1AgNBD866/mUPLLu3iK1
         m2wjgdguAn19PYUa1Ia5+uljbJ8pzR+dTVzJk7PHgFCXs3GcXayVjW18Q733iV6q
         M2NQbIJWQCSySsX+U0iLJ/s/jUQl9Bbwjq21MW7qoGFrnLGizuYVSOh+gQg8fRoh
         ifKCqOQG/To682BAEZOLynkiNGbwruQ3L7f0wQCOhqIfOenQOQiUKIAzbRPBfDYK
         4+PidQEgyXthUSmNufHi1g==
Message-ID: <5d8e3d91-de60-4747-88d1-e135e3c6e7c1@rsg.ci.i.u-tokyo.ac.jp>
Date: Thu, 20 Aug 2026 14:15:33 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 04/13] hw/virtio/vhost-shadow-virtqueue: used
 callback
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Milan Zamazal <mzamazal@redhat.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
        virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        zhenwei pi <zhenwei.pi@linux.dev>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>,
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>,
        20260817233147.2867623-1-connorkite@gmail.com
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-4-948aae960abb@gmail.com>
 <b6f79ec9-7842-47ff-b210-855036712547@rsg.ci.i.u-tokyo.ac.jp>
 <CA+spn3rouMQ=yG1m2fS=vm40c-zWWMZPK+yk0K_ip5iXzLZWow@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <CA+spn3rouMQ=yG1m2fS=vm40c-zWWMZPK+yk0K_ip5iXzLZWow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/08/20 10:06, Connor Kite wrote:
> On Tue, Aug 18, 2026 at 11:23 PM Akihiko Odaki
> <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>
>>> +
>>> +                if (r < 0) {
>>> +                    /* VQ or handler is broken. Do not set guest notifier */
>>
>> This comment is extraneous. It is obvious that event_notifier_set()
>> below is not called, and it is same with the existing error path below.
>>
>> What matters here is the difference with the existing error path. Why
>> doesn't it call virtqueue_fill() nor virtqueue_flush()? They need to be
>> addressed here.
>>
>> Regards,
>> Akihiko Odaki
>>
> 
> Here, apart from not calling event_notifier_set (not notifying the
> guest), we are also not calling vhost_svq_enable_notification, so the
> device is directed not to send any more call notifications.  If the
> guest isn't receiving notifications, and the device isn't sending
> them, is there a purpose to flushing the current element?  With the
> current implementation, I'm not sure there is a path to re-enable
> calls on either the front-end or back-end, but maybe a case could be
> made that it's good hygiene to flush the known bad element?  For now,
> I will add the calls to add and flush the element

Skipping event_notifier_set() only suppresses this guest interrupt, and
disabling SVQ notifications only suppresses backend call notifications; 
it does not stop backend ring processing. The error should be propagated 
with virtio_error().

I looked into the virtqueue_fill() and virtqueue_flush() calls in the 
existing error path. The virtqueue_fill() call detaches the element and 
publishes it to the guest. Detaching the element is necessary and should 
be done in the new error path too. On the other hand, publishing the 
failed element is wrong and should not be done.

virtqueue_flush(vq, i) is still required to publish and account for the 
preceding successfully filled elements.

Regards,
Akihiko Odaki
