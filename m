DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=anthonyrabbito-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:from:date:message-id:subject:to;
	bh=1igxOc0LPRrRWSa/VLr346MnGO9KtEg0ED5dx3+I9aQ=;
	b=j/9MyIEnJAUtSaN9IJRJZvfPH7kWg+YvaiTaXotQCqMJ3GvbXcconduVSPDYxic8t/
	VrXrEmVxIjly8TBadci2n6q2Xu7B74GMyGJhDVsCO3mzR/quWeKJrkaAPfLqOcm3FOzd
	ono/MXmBIFlQ4xscSwCzVfBQXF2TZ4E+Ug6NBi77KwcqxHKARCHHgYAb1z3xhHs5agzr
	ZCGIMebHXNKJTnqNbwWpKIrUVL5Py8qAo3YJIodUfQX4gAhypNo4oLlHBrYhRJnfFEmQ
	pQRbmCDu+v+yX0DdjLFuINdJZ44araA5B4XZU+llAmTuhCoVjZ0tcbes59B7i479gKlR
	UNbA==
MIME-Version: 1.0
From: Anthony J Rabbito <hello@anthonyrabbito.com>
Date: Thu, 8 Apr 2021 20:36:37 -0400
Message-ID: <CABpfLih7gTh8a=SYtFT4hGo03K3cnCmAK-+FUXC8X9MhLBwfzg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000f5335f05bf7f5b0c"
Subject: [Virtio-fs] Compiling virtio-fs/qemu on Mac
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--000000000000f5335f05bf7f5b0c
Content-Type: text/plain; charset="UTF-8"

Hi All,
I'm having some trouble getting virt9p built with Qemu on Darwin. Given
that virtio-fs is progressing nicely i'm wondering if anyone has had any
success building for Darwin?
Looking to build a podman machine with shared directories.
Thanks,
Anthony Rabbito

--000000000000f5335f05bf7f5b0c
Content-Type: text/html; charset="UTF-8"

<div dir="ltr"><div>Hi All,</div><div>
</div><div>I&#39;m having some trouble getting virt9p built with Qemu on Darwin. Given that virtio-fs is progressing nicely i&#39;m wondering if anyone has had any success building for Darwin?</div><div>
</div><div>Looking to build a podman machine with shared directories.</div><div>
</div><div>Thanks,</div><div>Anthony Rabbito</div></div>

--000000000000f5335f05bf7f5b0c--

