Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oEtgV5A5TQgE6miITdvQ7MIFydv0OPph3dJHEqU8bmI=;
 b=uOgBskCVZg9n55V0rrV6AwGbi6KYB+Zjwy/RAS1VzBHB1CPgbO1smZSJ6F3x6KLPFi
 iG5EkB2DZE2c1j7p/Cbybm/baVTv73fp9gnIzYLc0iPG4bHr5G91ONHCMO3elQPj/+7H
 ySNPWP4wvfGsKwnKOQnUnm41oDYkyv7hLZn/6O+yzxa6ZzlEYkFhBhKaL2LYnpu/o3t7
 yKtkb0DcWT0XgyIZHvkVRngEUaoGJ/Pat3iX+WIJc09GqFii2vQf6ZrZG8aAFuriYsyo
 Nm1Hv/Dj1MELElDTz/afjUSH/EOeiJCdgWW9czm3ISUwJZMJnYnmQ2aXsd3UjhjWBKts
 qeWg==
References: <20230118153833.102731-1-dgilbert@redhat.com>
 <CAJSP0QU+o-R6ZKN8R1MHoUqFwfsQmpKt6KP5hqhyFrK5HJti6w@mail.gmail.com>
 <9474ce49-979d-f630-5f6a-754999db573a@redhat.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Thu, 19 Jan 2023 14:56:38 +0000
In-reply-to: <9474ce49-979d-f630-5f6a-754999db573a@redhat.com>
Message-ID: <871qnqzi5c.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 0/3] Remove C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>, Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com


Hanna Czenczek <hreitz@redhat.com> writes:

> On 18.01.23 16:59, Stefan Hajnoczi wrote:
>> On Wed, 18 Jan 2023 at 10:40, Dr. David Alan Gilbert (git)
>> <dgilbert@redhat.com> wrote:
>>> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>>>
>>> We deprecated the C virtiofsd in commit 34deee7b6a1418f3d62a
>>> in v7.0 in favour of the Rust implementation at
>>>
>>>    https://gitlab.com/virtio-fs/virtiofsd
>>>
>>> since then, the Rust version has had more development and
>>> has held up well.  It's time to say goodbye to the C version
>>> that got us going.
>>>
>>> The only thing I've not cleaned up here is
>>>    tests/avocado/virtiofs_submounts.py
>>>
>>> which I guess needs to figure out where the virtiofsd implementation
>>> is and use it; suggestions welcome.
>> I see something similar in tests/avocado/avocado_qemu/__init__.py:
>>
>>          # If qemu-img has been built, use it, otherwise the system wide=
 one
>>          # will be used.  If none is available, the test will cancel.
>>          qemu_img =3D os.path.join(BUILD_DIR, 'qemu-img')
>>          if not os.path.exists(qemu_img):
>>              qemu_img =3D find_command('qemu-img', False)
>>          if qemu_img is False:
>>              self.cancel('Could not find "qemu-img", which is required t=
o '
>>                          'create the bootable image')
>>
>> Maybe find_command('virtiofsd', False)?
>
> It was supposed to be a test for virtiofsd, so it doesn=E2=80=99t really =
make
> sense to run it with the system-wide daemon, I think.
>
> Maybe there=E2=80=99s some way we can move the test to the Rust repo?=C2=
=A0 I=E2=80=99ll
> take a look.

Do you want to use cargo to install the daemons? If so could we make the
support generic enough so we could also start using the vhost-device
daemons for tests?

>
> Hanna


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

