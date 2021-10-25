DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
	t=1635184360; bh=3vVtakb0CQTPIBKAOWkwdo/T9kjU717fcryZdwOcMgc=;
	h=Date:From:To:Cc:Subject:From;
	b=DEso/VgthWyAwjX43cY41hvdAWz7V2ZiU1Mj5iIw1OHj2KlFZx6jaM8/poFw5CkDt
	aO6MiwZYH5l+PzrHu+pagefXl7/9WsfmL/Rn53T8wRV4f6gYJVR9zL5qSkaimt+DV3
	EG5lhQ7lvRbq0MU+4cBXTx6MoA9OdROdWlF1VzYEyfSHJdT24/4inDuDwd9cGGYvly
	D+TrPiGypfKxl+yjMmncaNOd69ey548OjPsBnrcSA+kC/KUUKs45Fa65+ZgB5tEfxP
	0VHKkoAOQDfmVhRzV8RGjvrS09tui1EruN+cfZqZh3IQltfxPKCz+U5NTWy8AlshmS
	22nvAaTftzYCQ==
MIME-Version: 1.0
Date: Mon, 25 Oct 2021 17:52:39 +0000
From: birnenkram@posteo.de
In-Reply-To: <YXbqL6qTfi/gzOOJ@redhat.com>
References: <5e79ba8579b33e60e9670f2fd99b1c1b@posteo.de>
	<YXauFapuRuxXRR2k@redhat.com>
	<0c4d0bb990217000fe24f4a8522dcfa3@posteo.de>
	<YXbqL6qTfi/gzOOJ@redhat.com>
Message-ID: <a06f048f33a2edac78e816bfb19b5270@posteo.de>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] write permissions for Windows host on Linux guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Gal Hammer <ghammer@redhat.com>

Thanks for your suggestions. I'll let you know in case I find anything 
unexpected. The Linux (host) side will be easier to debug than the 
Windows (guest) side. Currently, SID S-1-5-0 is returned independently 
of the uid on the host.

Best regards, Michael

> If you like you can debug virtiofsd easily, put few printf statements
> and make sure correct uid/gid is being returned. May be next step is
> to debug virtiofs driver in windows and make sure it receives correct
> uid/gid. And if that works, then final step is making sure permissions
> are being mapped properly.

