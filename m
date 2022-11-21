Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
References: <20221121140121.1079100-1-armbru@redhat.com>
 <CAMo8BfKxve8=RKqT6S8XXy1E7hczF0VO9XXZeUpha_4xNSV6WA@mail.gmail.com>
Date: Mon, 21 Nov 2022 18:00:19 +0100
In-Reply-To: <CAMo8BfKxve8=RKqT6S8XXy1E7hczF0VO9XXZeUpha_4xNSV6WA@mail.gmail.com>
 (Max Filippov's message of "Mon, 21 Nov 2022 08:42:30 -0800")
Message-ID: <8735aci6os.fsf@pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH] cleanup: Tweak and re-run
 return_directly.cocci
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

Max Filippov <jcmvbkbc@gmail.com> writes:

> On Mon, Nov 21, 2022 at 6:01 AM Markus Armbruster <armbru@redhat.com> wrote:
>>  .../xtensa/core-dsp3400/xtensa-modules.c.inc  | 136 +++++-------------
>>  target/xtensa/core-lx106/xtensa-modules.c.inc |  16 +--
>
> These files are generated and were imported from xtensa configuration
> overlays, they're not supposed to be changed.

Will drop.  Thanks!
