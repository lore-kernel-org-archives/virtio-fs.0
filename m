DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=UQ0FvqEsvwhOk1J4aJRozU/5FhgB0VGKiDGGsG4//rw=;
	b=Ab9CSnmhQzkZR/cpBXjY3+uocCQDKvCeWJ2Wz00b5LoSap8nsI6+fmijNjeHlg0Z4n
	XCBY1dzAwTmXk3uzdZyJb7E3tXsC8yIyupAoqpzh0wcwN7/xFU5rPWLSAD00ZPbzMXCn
	jFWc8TRG18Ru05TR7exOajo3NUy4zOdPTOVhU=
MIME-Version: 1.0
References: <20210127112131.308451-1-stefanha@redhat.com>
	<20210128184416.4dbdd23b@bahia.lan>
	<20210201171440.GA180539@stefanha-x1.localdomain>
	<20210201182215.GA221556@stefanha-x1.localdomain>
In-Reply-To: <20210201182215.GA221556@stefanha-x1.localdomain>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Sat, 6 Feb 2021 00:29:11 +0900
Message-ID: <CAJFHJrq9Miy91T1fmb9iSTYya7U7kwPNpX3y9pvL2JHW=eav=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: prevent opening of special
 files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, P J P <ppandit@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Feb 2, 2021 at 3:22 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> Hi Chirantan,
> I wanted to bring this CVE to your attention because the discussion has
> revealed a number of other issues (not necessarily security issues) in
> virtiofsd that may also be present in other virtio-fs daemon
> implementations.
>

Hi Stefan,

Thanks for the heads up.  I'm going to summarize the thread just to
make sure I understood correctly.

The CVE seems to be that the virtio-fs daemon allows opening special
files and the short-term fix is to detect and block this in the
daemon.  The long term fix is to mount the data with
nosuid,nodev,noexec.  I think crosvm's virtio-fs also doesn't check
the file type before opening it but chrome os has mounted all stateful
data as nosuid,nodev,noexec as long as I can remember so I think we
got lucky there.  It's probably still worth adding the check to the
server.

The other issue is that there is a race between when an entry is
created and when we look it up by name where it may be modified and
replaced by an external process.  While I can see how this can be
fixed for files, it seems like there's no choice for directories.
It's not like mkdirat returns an fd for the newly created directory.
Though, it seems like every process is affected by this.  I guess if
you wanted to be really paranoid you could do something like mkdtemp,
get an fd, and then rename to the real name.

Did I miss anything?

Thanks,
Chirantan

