DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:autocrypt:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=xs57zfQITNQLpmb1D/mHKW4/vwbMCoE1SxDnZfjvVfg=;
	b=YkM8JNqMYxd4CbBNTUaEBrfxYev+1ZgizfXRSyYpkSh4EJQHF1Aj2PuFQWupM/ed0G
	C3KSqzKj8ElnlXfKxp2RFlbkhVkAGj4riMKqX5YHPIpXE8kvLDiEur2e/Ba0etnrIU5s
	PkCPIoPPLHtIs3kFvK3Cc28ZVwxNOSw7DPAGfVi1A52YNtoezYaa96ebEQ5EYtIddOK9
	YbWEkFMTm05i7M6GoPSaPapvKi3C8j/8CoqCALtQYPeypX7LaQKlYSpSfRWWyUmIPmHj
	RXhZ56Nlao2qErFJP9Ghq3JSuF94F3RLbrLgvat1srtmGA3N0dAjSVsZmCrkdjbL4AWf
	jKaQ==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <a14cfa52-f1bc-b31e-5f85-ab207c1689a0@gmail.com>
Date: Thu, 17 Sep 2020 12:40:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: [Virtio-fs] Can libvirt parse virtiofsd -o writeback?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Is there any libvirt xml parser rev that knows about how to set
virtiofsd -o writeback?

Thanks

Harry Coin


