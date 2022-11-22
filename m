Return-Path: <philmd@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=1cG7JjZKrDJMJiFBZz4LFWA1swu2frAZNVzdjz69N8g=;
 b=vFt++CBA+6wZ8Bc/+CrSx929SKa3a14SLbJc66HUCRCwK0uMTwXUw7yBZJxsSjjXLq
 QIlxt2snSfdPqycssCGhCOS6itQAT0ld3atsOSs+sOh9cW+FJnW4cmaL54hUu/ML1Jp0
 txqbmQxX6MRKld+o6rlckro0O/xJXs5Q1LpJIO4TfM38rMI5SVkf1ST6n4Abur98Gxpj
 +5BXEspfChP3+uPkGEBITZNTKj5VNMoeAAaU99JE/EgbIeTgZt0qeP59hwlL485DQg2P
 MifhBtCWXe+JSEimVzyxYJcQqrl2WP81AMLvC5Q97MiMosUppkDXWJgEBlxc2/x7R9v2
 Ywyg==
Message-ID: <506afd42-89ab-cc6a-42d7-4544244f8672@linaro.org>
Date: Tue, 22 Nov 2022 16:03:02 +0100
MIME-Version: 1.0
References: <20221121140121.1079100-1-armbru@redhat.com>
 <CAMo8BfKxve8=RKqT6S8XXy1E7hczF0VO9XXZeUpha_4xNSV6WA@mail.gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <CAMo8BfKxve8=RKqT6S8XXy1E7hczF0VO9XXZeUpha_4xNSV6WA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
To: Max Filippov <jcmvbkbc@gmail.com>, Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, fam@euphon.net, kwolf@redhat.com, hreitz@redhat.com, groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com

On 21/11/22 17:42, Max Filippov wrote:
> On Mon, Nov 21, 2022 at 6:01 AM Markus Armbruster <armbru@redhat.com> wrote:
>>   .../xtensa/core-dsp3400/xtensa-modules.c.inc  | 136 +++++-------------
>>   target/xtensa/core-lx106/xtensa-modules.c.inc |  16 +--
> 
> These files are generated and were imported from xtensa configuration
> overlays, they're not supposed to be changed.

Tools can get the repository file list using 'git ls-files', which
itself support file pattern exclusion [*].

We can create i.e. 'scripts/imported-files.txt' with:

   linux-headers/
   target/hexagon/imported/
   target/xtensa/core*
   tests/tcg/mips/user/

Then use 'git ls-files --exclude-from=scripts/imported-files.txt' ...

[*] 
https://git-scm.com/docs/git-ls-files#Documentation/git-ls-files.txt---exclude-fromltfilegt

