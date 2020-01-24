DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to;
	bh=Jz7haK87RDkIQdkyqXhBkk0VnqXZFINXBxDrlBvMDpg=;
	b=NMM07XUWw9i0oLsCcnFRK2HKuDq0hg2p0/f8sJAZGns45wzq41jusjHgJ1jGp8Trvb
	pEMXSeU1kW+tH+zRBx5ijwxDOyof+LIn+bKl3QHrFiznlBEe3au2uzoILbZb/FYZOKuf
	2/dIKabwbp5uIRsOPP8jpheQOFYM10j4ORke4bH/iGnQs3m6qDhFoWpO38Nt6Gce5Uke
	q7JcTPcxZ27EsD0BZ0dSujLkXs4y06e36dvmJxuuT4ZsVkjpeY2S6euZ55j/nb/9z45y
	nX6VJKleKjefhRsVYlIihgZamqpLXkCsaiIAjo7AFw5NOqyTWHBqdfszX7Rt3CpvuOvQ
	PZWg==
Date: Fri, 24 Jan 2020 09:30:08 -0500
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20200124143008.r66g4qztuvt7n54n@gabell>
References: <20200124112950.GA2969@work-vm>
MIME-Version: 1.0
In-Reply-To: <20200124112950.GA2969@work-vm>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] virtiofsd merged in qemu
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

On Fri, Jan 24, 2020 at 11:29:50AM +0000, Dr. David Alan Gilbert wrote:
> Hi,
>   virtiofsd just got merged upstream in qemu's git.
> Thank you to all those who have contributed code, reviewed
> and tested it!
> 
> I've updated the virtio-fs-dev tree with a tree based on latest
> qemu; it's still got the experimental DAX code in and it's got
> a few other patches that haven't gone upstream to qemu yet.
> (In particular the man page and docs need reworking a bit).
> 
> Thanks again everyone!

Excellent work, thanks!

- Masa


