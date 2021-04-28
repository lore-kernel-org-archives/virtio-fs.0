References: <20210428144813.417170-1-philmd@redhat.com>
	<20210428144813.417170-3-philmd@redhat.com>
	<e06f3f24-9ff2-bf3c-91c4-178af60c6c59@linaro.org>
	<160e4c85-e8c0-304d-7151-1040f8d310ba@redhat.com>
	<a4dabeaf-4df8-2779-f028-3d135fe84bef@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <3e3fabf2-9fed-6d15-51b3-eb0c284852ac@redhat.com>
Date: Wed, 28 Apr 2021 21:34:18 +0200
MIME-Version: 1.0
In-Reply-To: <a4dabeaf-4df8-2779-f028-3d135fe84bef@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/2] util/meson: Build
 iov/hexdump/buffer_is_zero with virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>

On 4/28/21 9:24 PM, Richard Henderson wrote:
> On 4/28/21 10:56 AM, Philippe Mathieu-Daudé wrote:
>> Are you suggesting to remove the 'if have_block' check? This makes build
>> a the files pointlessly for user-mode-only builds...
> 
> But since the objects are not included in the binary, I don't care.
> 
> The build system is already too complex, and building a couple of extra
> small files makes only milliseconds of difference.

Maybe for libqemuutil.a (this does make a difference with the Python
QAPI generated files - another series).

I'll wait if we get to a consensus about what exactly is virtiofsd,
then revisit this series.

Thanks!

Phil.

