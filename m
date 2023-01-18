Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=HNIuzBbmfJiba+TQQy2P1Uiwnz+w92eoi9av9goU/bA=;
 b=SRCA1b20ixAcPSUMl6vr/y9fQ30Gl9SQgj5CD5Tj0E9QQCowk/LOUAfxMJKl9evjqd
 PmDDrEyOfDYD2+sInTjrxUfw6iY7mI04DFhbCt5ql2pAp8DIPV8LXoFUAZS8qy4miJuu
 Au8DNOYZCgwmEIyS9c0M8bJTZA8FDqCZ8ViwX2WnklZyF/tL56UKbQ9IebSHitphocZO
 5tz+uWk/TdkhQAM8tQw94662DxAOcGdjLaQ40jgLUamTEq0sfEi5wj/vIers70DxmqBw
 P24yvQQFtHXGIo+xE0oLcE26zMml1RA2iew+P1hi7VQRZtjTlv3hHJrpVTAfgGac/56g
 WBrQ==
MIME-Version: 1.0
References: <20230118153833.102731-1-dgilbert@redhat.com>
In-Reply-To: <20230118153833.102731-1-dgilbert@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 18 Jan 2023 10:59:30 -0500
Message-ID: <CAJSP0QU+o-R6ZKN8R1MHoUqFwfsQmpKt6KP5hqhyFrK5HJti6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 0/3] Remove C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>, Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, hczenczek@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org

On Wed, 18 Jan 2023 at 10:40, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> We deprecated the C virtiofsd in commit 34deee7b6a1418f3d62a
> in v7.0 in favour of the Rust implementation at
>
>   https://gitlab.com/virtio-fs/virtiofsd
>
> since then, the Rust version has had more development and
> has held up well.  It's time to say goodbye to the C version
> that got us going.
>
> The only thing I've not cleaned up here is
>   tests/avocado/virtiofs_submounts.py
>
> which I guess needs to figure out where the virtiofsd implementation
> is and use it; suggestions welcome.

I see something similar in tests/avocado/avocado_qemu/__init__.py:

        # If qemu-img has been built, use it, otherwise the system wide one
        # will be used.  If none is available, the test will cancel.
        qemu_img = os.path.join(BUILD_DIR, 'qemu-img')
        if not os.path.exists(qemu_img):
            qemu_img = find_command('qemu-img', False)
        if qemu_img is False:
            self.cancel('Could not find "qemu-img", which is required to '
                        'create the bootable image')

Maybe find_command('virtiofsd', False)?

Stefan

