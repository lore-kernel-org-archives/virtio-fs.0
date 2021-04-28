References: <20210428144813.417170-1-philmd@redhat.com>
	<20210428144813.417170-3-philmd@redhat.com>
	<e06f3f24-9ff2-bf3c-91c4-178af60c6c59@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <160e4c85-e8c0-304d-7151-1040f8d310ba@redhat.com>
Date: Wed, 28 Apr 2021 19:56:35 +0200
MIME-Version: 1.0
In-Reply-To: <e06f3f24-9ff2-bf3c-91c4-178af60c6c59@linaro.org>
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

On 4/28/21 6:38 PM, Richard Henderson wrote:
> On 4/28/21 7:48 AM, Philippe Mathieu-Daudé wrote:
>> diff --git a/util/meson.build b/util/meson.build
>> index 510765cde46..c2eda2d1374 100644
>> --- a/util/meson.build
>> +++ b/util/meson.build
>> @@ -59,12 +59,10 @@
>>     util_ss.add(files('aiocb.c', 'async.c', 'aio-wait.c'))
>>     util_ss.add(files('base64.c'))
>>     util_ss.add(files('buffer.c'))
>> -  util_ss.add(files('bufferiszero.c'))
>>    
>> util_ss.add(files('coroutine-@0@.c'.format(config_host['CONFIG_COROUTINE_BACKEND'])))
>>
>>     util_ss.add(files('hbitmap.c'))
>> -  util_ss.add(files('hexdump.c'))
>>     util_ss.add(files('iova-tree.c'))
>> -  util_ss.add(files('iov.c', 'qemu-sockets.c', 'uri.c'))
>> +  util_ss.add(files('qemu-sockets.c', 'uri.c'))
>>     util_ss.add(files('lockcnt.c'))
>>     util_ss.add(files('main-loop.c'))
>>     util_ss.add(files('nvdimm-utils.c'))
>> @@ -83,3 +81,9 @@
>>                                           if_false:
>> files('filemonitor-stub.c'))
>>     util_ss.add(when: 'CONFIG_LINUX', if_true: files('vfio-helpers.c'))
>>   endif
>> +
>> +if have_block or config_host.has_key('CONFIG_VHOST_USER_FS')
>> +  util_ss.add(files('hexdump.c'))
>> +  util_ss.add(files('bufferiszero.c'))
>> +  util_ss.add(files('iov.c'))
>> +endif
> 
> Isn't util a static library, built once?  Why are we avoiding building
> these unconditionally?  Surely symbols will be included in any linked
> binaries only as needed.

Yes, in this case built once for $ configure
--target-list=i386-linux-user --disable-tools --enable-virtiofsd.

Are you suggesting to remove the 'if have_block' check? This makes build
a the files pointlessly for user-mode-only builds...

