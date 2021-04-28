References: <20210428144813.417170-1-philmd@redhat.com>
	<20210428144813.417170-2-philmd@redhat.com>
	<15dbfc38-f0ba-65f1-382c-3ce5b961f108@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <e2f18183-2b7d-f7c1-b1a2-e624950c7627@redhat.com>
Date: Wed, 28 Apr 2021 20:00:15 +0200
MIME-Version: 1.0
In-Reply-To: <15dbfc38-f0ba-65f1-382c-3ce5b961f108@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/2] meson: Check for seccomp/cap-ng
 libraries if virtiofsd is enabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, virtio-fs@redhat.com, Mahmoud Mandour <ma.mandourr@gmail.com>

On 4/28/21 6:34 PM, Richard Henderson wrote:
> On 4/28/21 7:48 AM, Philippe Mathieu-Daudé wrote:
>>   seccomp = not_found
>> -if not get_option('seccomp').auto() or have_system or have_tools
>> +if not get_option('seccomp').auto() or have_system or have_tools or
>> not get_option('virtiofsd').auto()
>>     seccomp = dependency('libseccomp', version: '>=2.3.0',
>>                          required: get_option('seccomp'),
>>                          method: 'pkg-config', kwargs: static_kwargs)
> 
> This construct is wrong, both before and after, as I read it.
> 
> not get_option(foo).auto() is true for both enabled and disabled.  If
> disabled, why are we examining the dependency?  If auto, if we have all
> of the dependencies we want to enable the feature -- if we don't probe
> for the dependency, how can we enable it?
> 
> This error seems to be offset by the OR have_* tests, for which the
> logic also seems off.
> 
> I think the test should have been
> 
>   if (have_system or have_tools) and

Yes but virtiofsd is not a tool... It is a standalone binary.
Maybe have_system is the culprit here:

  have_system = have_system or target.endswith('-softmmu')

We should somewhere add:

  have_system = have_system or something('virtiofsd')

However I wonder if we aren't going to build many objects
that are irrelevant for virtiofsd.

>      (not get_option('seccomp').disabled() or
>       not get_option('virtiofsd').disabled())
> 
> Then we need to combine the required: argument, probably like
> 
>   required: get_option('seccomp').enabled() or
>             get_option('virtiofsd').enabled()
> 
> 
> r~
> 

