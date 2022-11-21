Return-Path: <thuth@redhat.com>
Message-ID: <47e0d3d8-607d-5e29-6780-c0a4364993a9@redhat.com>
Date: Mon, 21 Nov 2022 17:34:15 +0100
MIME-Version: 1.0
References: <20221121140121.1079100-1-armbru@redhat.com>
 <CAFEAcA_jnbp36Trjd3qJYzbf5-6SNNrirG7q2_-wKXkcX49ptg@mail.gmail.com>
 <7875a42b-2776-9d36-5373-78ac75cff89d@linaro.org>
 <87a64ki7zn.fsf@pond.sub.org>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <87a64ki7zn.fsf@pond.sub.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
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
To: Markus Armbruster <armbru@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, jcmvbkbc@gmail.com, berrange@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On 21/11/2022 17.32, Markus Armbruster wrote:
> Philippe Mathieu-Daudé <philmd@linaro.org> writes:
> 
>> On 21/11/22 15:36, Peter Maydell wrote:
>>> On Mon, 21 Nov 2022 at 14:03, Markus Armbruster <armbru@redhat.com> wrote:
>>>>
>>>> Tweak the semantic patch to drop redundant parenthesis around the
>>>> return expression.
>>>>
>>>> Coccinelle drops comments in hw/rdma/vmw/pvrdma_cmd.c; restored
>>>> manually.
>>>>
>>>> Coccinelle messes up vmdk_co_create(), not sure why.  Transformed
>>>> manually.
>>>>
>>>> Line breaks in target/avr/cpu.h and hw/rdma/vmw/pvrdma_cmd.c tidied up
>>>> manually.
>>>>
>>>> Whitespace in fuse_reply_iov() tidied up manually.
>>>>
>>>> checkpatch.pl complains "return of an errno should typically be -ve"
>>>> two times for hw/9pfs/9p-synth.c.  Preexisting, the patch merely makes
>>>> it visible to checkpatch.pl.
>>>>
>>>> checkpatch.pl complains "return is not a function, parentheses are not
>>>> required" three times for target/mips/tcg/dsp_helper.c.  False
>>>> positives.
>>>>
>>>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>>>
>>>>    .../user/ase/msa/bit-count/test_msa_nloc_b.c  |   9 +-
>>>>    .../user/ase/msa/bit-count/test_msa_nloc_d.c  |   9 +-
>>> [snip long list of other mips test files]
>>>
>>>>    328 files changed, 989 insertions(+), 2099 deletions(-)
>>> This patch seems to almost entirely be huge because of these
>>> mips test case files. Are they specific to QEMU or are they
>>> effectively a 3rd-party import that it doesn't make sense
>>> to make local changes to?
>>
>> They are imported and will unlikely be modified.
> 
> Not obvious to me from git-log.
> 
> Should I drop the changes to tests/tcg/mips/?

I'd say yes. At least move them to a separate patch. Otherwise reviewing 
this patch here is no fun at all.

  Thomas

