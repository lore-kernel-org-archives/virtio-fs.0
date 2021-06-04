DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sub-pop.net
	; s=mythic-beasts-k1; h=To:Subject:From:Date;
	bh=98UQVKVyO5Lu6TRgFiQPTT4lZfrZU+xy4DkG6i2QXYc=;
	b=vwSSue9apDmuwl1+WCTgPdUVBq
	T8acsgTwM9HGdZXiEF5enP6vaSwvQP3OlSMTHGSqaOpZadJYCNUfjQryBbGX7bbQ+w07AY9ZPoq+B
	miVLT1l6nuAxDCOeROP6+pZPhCOCldNhZ6xbBqTnBA9GMDk97LxK/nHrz0/vJhlphyVgoiBBIcfFS
	aFdAvBxAmml51vvKYkRaGzjPMq/rUOvQWvKnuFF3bJ/vJMkBbDdGKPyrK0b5BQiPBtQfjrIoMP+L6
	gYfCq8TmoVLiN07W5Rd0XuaA0DyBro694bclxreceos2wV617g2X0sRUQaUYVAZ+CB5Bg1quBr/l7
	yEN1TdBQ==
Date: Thu, 03 Jun 2021 20:56:46 -0400
From: Link Dupont <link@sub-pop.net>
Message-Id: <MYJ5UQ.562L1XU7LNSJ3@sub-pop.net>
In-Reply-To: <YLksUpVCCovgUAtq@work-vm>
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, libvirt-users@redhat.com

On Thu, Jun 3 2021 at 08:24:02 PM +0100, Dr. David Alan Gilbert 
<dgilbert@redhat.com> wrote:
> (I'm not sure el7 had 9p either??)

Oh drat. I'm conflating my issues. I have an EL7 guest that is having a 
similar problem, except the guest sees the files as type nfs_t. I guess 
the symptoms are the same, but the solutions won't necessarily. Let me 
try and scale these down to reproducible scenarios.


