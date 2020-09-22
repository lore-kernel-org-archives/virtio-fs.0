DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0la+NjqOspuYNFekbQHmZdYeJ/vAjkgTC2efPzMN2FI=;
	b=oZkDdTCnD0YA6UlQCZOdKL1o6Snt49DpVTtDbTUtiNUB2ibOzVFtkhfZYws5Q+uTyj
	wXwLH8g7BAQg9kiy9OdkW2tr+4O1AoenLldp1JfhnJaMSy84vDWemPA3wM7uKuv0J6M5
	wy7O2ia4ODWZEjj3lbSv67qtxbjt4ChMTVhU4=
MIME-Version: 1.0
References: <20200916161737.38028-1-vgoyal@redhat.com>
	<20200916161737.38028-5-vgoyal@redhat.com>
In-Reply-To: <20200916161737.38028-5-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Sep 2020 15:56:47 +0200
Message-ID: <CAJfpegsncAteUfTAHAttwyVQmhGoK7FCeO_z+xcB_4QkYZEzsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2 4/6] fuse: Kill suid/sgid using ATTR_MODE
	if it is not truncate
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

On Wed, Sep 16, 2020 at 6:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> But if this is non-truncate setattr then server will not kill suid/sgid.
> So continue to send ATTR_MODE to kill suid/sgid for non-truncate setattr,
> even if ->handle_killpriv_v2 is enabled.

Sending ATTR_MODE doesn't make sense, since that is racy.   The
refresh-recalculate makes the race window narrower, but it doesn't
eliminate it.

I think I suggested sending write synchronously if suid/sgid/caps are
set.  Do you see a problem with this?

Does this affect anything other than cached writes?

Thanks,
Miklos

