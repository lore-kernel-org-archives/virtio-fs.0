Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
References: <20221122134917.1217307-1-armbru@redhat.com>
 <20221122134917.1217307-2-armbru@redhat.com>
 <20221124161511.73b50353@bahia> <20221124162403.7d45f4fb@bahia>
Date: Thu, 24 Nov 2022 19:41:14 +0100
In-Reply-To: <20221124162403.7d45f4fb@bahia> (Greg Kurz's message of "Thu, 24
 Nov 2022 16:24:03 +0100")
Message-ID: <878rk019h1.fsf@pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH v2 1/2] cleanup: Tweak and re-run
 return_directly.cocci
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: qemu-devel@nongnu.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

Greg Kurz <groug@kaod.org> writes:

> On Thu, 24 Nov 2022 16:15:11 +0100
> Greg Kurz <groug@kaod.org> wrote:
>
>> On Tue, 22 Nov 2022 14:49:16 +0100
>> Markus Armbruster <armbru@redhat.com> wrote:
>> 
>> > Tweak the semantic patch to drop redundant parenthesis around the
>> > return expression.
>> > 
>> > Coccinelle drops a comment in hw/rdma/vmw/pvrdma_cmd.c; restored
>> > manually.
>> > 
>> > Coccinelle messes up vmdk_co_create(), not sure why.  Change dropped,
>> > will be done manually in the next commit.
>> > 
>> > Line breaks in target/avr/cpu.h and hw/rdma/vmw/pvrdma_cmd.c tidied up
>> > manually.
>> > 
>> > Whitespace in tools/virtiofsd/fuse_lowlevel.c tidied up manually.
>> > 
>> > checkpatch.pl complains "return of an errno should typically be -ve"
>> > two times for hw/9pfs/9p-synth.c.  Preexisting, the patch merely makes
>> > it visible to checkpatch.pl.
>> > 
>> 
>> Hi Markus,
>> 
>> Yeah these positive errno values have been sitting there since the
>> beginning. It was dead code until I hijacked the synth backend to
>> implement qtest for 9p. I didn't care much about the return value
>> of the two culprits at the time since both are passed to assert(!ret)
>> right away. For this reason, changing the sign should be easy :-)
>> 
>> I see that checkpatch.pl considers this as an error. I'll post
>> a fix. I guess you'll need to rebase on this fix for your patches
>> to pass CI.
>> 
>
> Or maybe I can fix the issues detected by coccinelle as well and
> you can just drop the 9p bits from this patch ?

Up to you!

>> Anyway, for 9p:
>> 
>> Reviewed-by: Greg Kurz <groug@kaod.org>

Thanks!
