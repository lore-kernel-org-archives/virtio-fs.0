DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=references:user-agent:from:to:cc:subject:in-reply-to:date
	:message-id:mime-version:content-transfer-encoding;
	bh=Ah63wGHHXS2VZ29vNXLvh/ioAgsrzKNIki2Ec1dc9ck=;
	b=aZIWUYOJNZoDrIhi+bGCa/oTVa2mrNySNobx7qs4C7LH1/VmmbOuIdPTbcYCKZgHcn
	VzW6o8CIMIZRTVX4mXdGi6480RMPR5ZvDKVz55Fqjb8SCezjhmcsfq8Fov4IHJQZeeX1
	KZJ9LNtztwdo6AcD4hrBJY0Jq4ywnsrajOD2UzS8qLnScC3b5Dmc5N7zYIcTQmszWtTO
	Tp3+q3uY0skDzirIpLcB/Fp6whv3L9ElKqwwP6kiNS+RfkV6A15CrApknQV/6h54l9P7
	ZzmlEJSj05QWevZoQpleREgPI7kVsKKYk7g2g9/ej4VHzYaEwS+Tb2BhITRMYxG88GBy
	bmww==
References: <20191025100152.6638-1-stefanha@redhat.com>
	<20191025100152.6638-2-stefanha@redhat.com>
	<20191026174745-mutt-send-email-mst@kernel.org>
	<20191027123623.GO4472@stefanha-x1.localdomain>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
In-reply-to: <20191027123623.GO4472@stefanha-x1.localdomain>
Date: Mon, 01 Jun 2020 11:28:44 +0100
Message-ID: <87zh9n6pwj.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC 1/3] WIP virtiofsd: import Linux <fuse.h>
	header file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com


Stefan Hajnoczi <stefanha@redhat.com> writes:

> On Sat, Oct 26, 2019 at 05:49:11PM -0400, Michael S. Tsirkin wrote:
>> On Fri, Oct 25, 2019 at 12:01:50PM +0200, Stefan Hajnoczi wrote:
>> > tests/vhost-user-fs-test.c needs fuse.h.  The private copy that
>> > virtiofsd has can be replaced with a properly imported file using
>> > update-linux-headers.sh.
>> > 
>> > TODO rerun update-linux-headers.sh with upstream kernel tree!
>> > 
>> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>> 
>> OK I would just add this with the virtiofsd patchset.
>
> Yes, I'll talk to David.

Catching up after the fact I see this didn't get merged. Was there a
reason?

-- 
Alex Bennée


