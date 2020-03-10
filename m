DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=676hlAi9nQvJqPNZ6R7D8KQCs7ZMaZyVMWv6FGrNSog=;
	b=BlCyZg3qAzKRX5Es9ctA1azKKf+fCW18+Z3+RK9WV/bkETeslBQeWcDJHakZv3N75m
	A6xAk+tgOsrscdsv7V5kr5AAIdlxfsdJAjtkbuQYXis/pP7Ia8QDfP0Vckn4/arnS5uG
	m2flT5Fwl10Vbx1mKDKvXEHME5GPc47vE9KVI=
MIME-Version: 1.0
References: <1583270111-76859-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1583270111-76859-1-git-send-email-bo.liu@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 11:14:17 +0100
Message-ID: <CAJfpegtFWqEAV-Jb_KoHihJ5-UpU=JkdxEg_stz6JM5OP_LXMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] fuse: make written data persistent after
	writing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com

On Tue, Mar 3, 2020 at 10:15 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
>
> If this is a DSYNC write, make sure we push it to stable storage now
> that we've written data.

If this is direct I/O then why do we need an fysnc() call?

The only thing needed should be correct setting O_DSYNC in the flags
field of the WRITE request, and it appears to me that that is already
being done.

Thanks,
Miklos


