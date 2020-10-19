DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=IU61rKhjzfPzJqH+1xCGCRSkuJrT8mWWfaH6FNyCnc0=;
	b=DCcsaJ4MCIQoGio0fQNnl4n7RYkGwWk5sLewn/MusDeRJ72731LXKwi1x9XBT/hFT9
	DaX5oSFsB8Ghi6rL6tj+d2qrnWDhZah+uxIlk2stdAMcW3bVGyOOMXPAzCqaCqUAsaWr
	8IHJGw7jwH+T94XWhB1POqy8+I7JaUXlYtzVI=
MIME-Version: 1.0
References: <20201008085534.16070-1-stefanha@redhat.com>
In-Reply-To: <20201008085534.16070-1-stefanha@redhat.com>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Mon, 19 Oct 2020 18:43:41 +0900
Message-ID: <CAJFHJrohwGOvZax=anXZdFeuTT+uZAJ89Hu9CohgnE-tJEKTiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: add container-friendly -o
 sandbox=chroot option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: vromanso@redhat.com, qemu-devel@nongnu.org, rmohr@redhat.com, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, mpatel@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On Thu, Oct 8, 2020 at 5:55 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> virtiofsd cannot run in a container because CAP_SYS_ADMIN is required to
> create namespaces.
>

In crosvm we deal with this by also creating a user namespace, which
then allows us to create the mount, net, and pid namespaces as well.
Could that also work for virtiofsd?

