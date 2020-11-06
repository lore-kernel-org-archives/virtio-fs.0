DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=sxqVLa3iciqPLgCG+JwX1CHkcPF2gNhZXkGpXNNWzqI=;
	b=iAgDYvkBrhl4CMU3P9ur27IlYwOJCc4vApoUuHrs99MpyhdVw0SZ5rmcOzqUBTJl4j
	JnqRJxTOnYOX05Sb/afsRtaDDhpZt0WPeFuzsStMIIfnfLt1S7PT0trtzbWfFBagCxbE
	3/cX38U0+NVDf3cx1ZzBfE6xivZfHrCfanNhE=
MIME-Version: 1.0
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-4-vgoyal@redhat.com>
In-Reply-To: <20201009181512.65496-4-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Nov 2020 15:39:29 +0100
Message-ID: <CAJfpegu=ooDmc3hT9cOe2WEUHQN=twX01xbV+YfPQPJUHFMs-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 3/6] fuse: setattr should set
	FATTR_KILL_PRIV upon size change
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Fri, Oct 9, 2020 at 8:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> If fc->handle_killpriv_v2 is enabled, we expect file server to clear
> suid/sgid/security.capbility upon chown/truncate/write as appropriate.
>
> Upon truncate (ATTR_SIZE), suid/sgid is cleared only if caller does
> not have CAP_FSETID. File server does not know whether caller has
> CAP_FSETID or not. Hence set FATTR_KILL_PRIV upon truncate to let
> file server know that caller does not have CAP_FSETID and it should
> kill suid/sgid as appropriate.
>
> We don't have to send this information for chown (ATTR_UID/ATTR_GID)
> as that always clears suid/sgid irrespective of capabilities of
> calling process.

I'm  undecided on this.   Would it hurt to set it on chown?  That
might make the logic in some servers simpler, no?

What would be the drawback of setting FATTR_KILL_PRIV for chown as well?

Thanks,
Miklos

