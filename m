DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=8UjLDVxuRdTxa+CZhgvCb62UfDHpnO31awh1SfpMwAY=;
	b=sDqWpTdyaQL4f+ta445Nr/5xOzeQfQN26xQmV8G9ZaRgU9T3y9pla84T3pn5/kwJnd
	5Hq+OgQ71zL1GckJ0SJOR/xHRTV9ByBSLe+BvQlG8xgcjoCzD4b7RkmYzqmmzaMpo1e0
	OlSctSg0Ax8JW7Dhd8KjewRWx9YAbqTb1JB9n0y2xM9N0ZeciNqcFf9+asg0FpfmXAb0
	NTOD9p3ELtzlH1IIjXsLOHr6Zr7ino9aZw/w5V0j3Giv6kj6drSDSbk3+kBJIrlEx909
	SqJ4Rnw87S1L1i4EfoeFnOjsZ4ayn6QX50GpK8ZaZtS/pdV/NlnQtMUQAg3MoZUxv1Qz
	+wtQ==
References: <a14cfa52-f1bc-b31e-5f85-ab207c1689a0@gmail.com>
	<20200918185548.GS2816@work-vm>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <1b3d3efe-b3b8-1711-4993-956e88da9b7d@gmail.com>
Date: Fri, 18 Sep 2020 14:06:11 -0500
MIME-Version: 1.0
In-Reply-To: <20200918185548.GS2816@work-vm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Can libvirt parse virtiofsd -o writeback?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com


On 9/18/20 1:55 PM, Dr. David Alan Gilbert wrote:
> * Harry G. Coin (hgcoin@gmail.com) wrote:
>> Is there any libvirt xml parser rev that knows about how to set
>> virtiofsd -o writeback?
> I don't think so ; the docs say:
> https://libvirt.org/formatdomain.html#filesystems
> says:
>
>  binary
>
>     The optional binary element can tune the options for virtiofsd. All
>     of the following attributes and elements are optional. The attribute
>     path can be used to override the path to the daemon. Attribute xattr
>     enables the use of filesystem extended attributes. Caching can be
>     tuned via the cache element, possible mode values being none and
>     always. Locking can be controlled via the lock element - attributes
>     posix and flock both accepting values on or off. ( Since 6.2.0 )
>
>
> Hmm, I've never tried the -o writeback; have you found it beneficial?
>
> Dave

Jury is still out.  Writeback without dax (which is unavailable outside
the high-interest bubble) subjectively seems to help a bit.  I have
managed to get a kernel boot going with generic environments, calls for
some hacking of initramfs, and most of the instructions about kernel
command line content is wrong on the info page.

Here's how folks can try writeback without having to cook up a dev
environment:

The paths below are for debian/ubuntu style distos, the rhel/centos
paths differ a bit.   I don't have the SELinux equivalent to the
apparmor glue.

Libvirt xml:

...

<filesystem type="mount" accessmode="passthrough">
  <driver type="virtiofs" queue="1024"/>
  <binary path="/usr/local/sbin/custom_virtiofsd" xattr="on">
    <lock posix="off" flock="on"/>
  </binary>

cat >  /usr/local/sbin/custom_virtiofsd
#!/bin/bash
#Provide a way to add arguments libvirt doesn't know about.
set -o allexport
/usr/lib/qemu/virtiofsd $@ -o writeback

and

cat > /etc/apparmor.d/local/usr.sbin.libvirtd
/usr/local/sbin/custom_virtiofsd rux,


>
>> Thanks
>>
>> Harry Coin
>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs


