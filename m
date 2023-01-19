Return-Path: <hreitz@redhat.com>
Message-ID: <9474ce49-979d-f630-5f6a-754999db573a@redhat.com>
Date: Thu, 19 Jan 2023 11:14:34 +0100
MIME-Version: 1.0
References: <20230118153833.102731-1-dgilbert@redhat.com>
 <CAJSP0QU+o-R6ZKN8R1MHoUqFwfsQmpKt6KP5hqhyFrK5HJti6w@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QU+o-R6ZKN8R1MHoUqFwfsQmpKt6KP5hqhyFrK5HJti6w@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/3] Remove C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>, "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>, Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org

On 18.01.23 16:59, Stefan Hajnoczi wrote:
> On Wed, 18 Jan 2023 at 10:40, Dr. David Alan Gilbert (git)
> <dgilbert@redhat.com> wrote:
>> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>>
>> We deprecated the C virtiofsd in commit 34deee7b6a1418f3d62a
>> in v7.0 in favour of the Rust implementation at
>>
>>    https://gitlab.com/virtio-fs/virtiofsd
>>
>> since then, the Rust version has had more development and
>> has held up well.  It's time to say goodbye to the C version
>> that got us going.
>>
>> The only thing I've not cleaned up here is
>>    tests/avocado/virtiofs_submounts.py
>>
>> which I guess needs to figure out where the virtiofsd implementation
>> is and use it; suggestions welcome.
> I see something similar in tests/avocado/avocado_qemu/__init__.py:
>
>          # If qemu-img has been built, use it, otherwise the system wide one
>          # will be used.  If none is available, the test will cancel.
>          qemu_img = os.path.join(BUILD_DIR, 'qemu-img')
>          if not os.path.exists(qemu_img):
>              qemu_img = find_command('qemu-img', False)
>          if qemu_img is False:
>              self.cancel('Could not find "qemu-img", which is required to '
>                          'create the bootable image')
>
> Maybe find_command('virtiofsd', False)?

It was supposed to be a test for virtiofsd, so it doesn’t really make 
sense to run it with the system-wide daemon, I think.

Maybe there’s some way we can move the test to the Rust repo?  I’ll take 
a look.

Hanna

