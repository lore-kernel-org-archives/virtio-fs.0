References: <5D43F688.8000607@huawei.com> <20190802105352.GF2899@work-vm>
	<20190802111034.GC30115@redhat.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <6390d190-88ac-f1f5-9151-4c70f401db14@huawei.com>
Date: Sun, 4 Aug 2019 16:18:25 +0800
MIME-Version: 1.0
In-Reply-To: <20190802111034.GC30115@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH v2] virtiofsd: fix compile
 error if 'F_OFD_GETLK' not defined
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, "Dr. David
	Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

Hi Daniel and Dave,

On 2019/8/2 19:10, Daniel P. Berrangé wrote:
> On Fri, Aug 02, 2019 at 11:53:52AM +0100, Dr. David Alan Gilbert wrote:
>> * piaojun (piaojun@huawei.com) wrote:
>>> Use F_GETLK for fcntl when F_OFD_GETLK not defined, such as kernel 3.10.
>>>
>>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>>
>>
>>> ---
>>> v2:
>>> - Use F_OFD_SETLK to replace F_OFD_GETLK in #ifdef.
>>>
>>> ---
>>>  contrib/virtiofsd/passthrough_ll.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
>>> index a81c01d..c69f2f3 100644
>>> --- a/contrib/virtiofsd/passthrough_ll.c
>>> +++ b/contrib/virtiofsd/passthrough_ll.c
>>> @@ -1780,7 +1780,11 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
>>>  		goto out;
>>>  	}
>>>
>>> +#ifdef F_OFD_GETLK
>>>  	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
>>> +#else
>>> +	ret = fcntl(plock->fd, F_GETLK, lock);
>>> +#endif
>>>  	if (ret == -1)
>>>  		saverr = errno;
>>>
>>> @@ -1831,7 +1835,11 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
>>>
>>>  	/* TODO: Is it alright to modify flock? */
>>>  	lock->l_pid = 0;
>>> +#ifdef F_OFD_SETLK
>>>  	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
>>> +#else
>>> +	ret = fcntl(plock->fd, F_GETLK, lock);
>>                                ^^^^^^^
>>
>> Typo! You've got GETLK rather than SETLK.

Yes, it's a shame for the mistake.

>>
>> But, a bigger question - does this actually work!
>> The manpage says:
>>    'If a process closes any file descriptor referring to a file, then
>>    all of the process's locks on that file are released, regardless of the
>>    file descriptor(s) on which the locks were obtained.'
>>
>> the fd we're using here came from lookup_create_plock_ctx which did
>> a new openat to get this fd; so we've already got multiple fd's
>> referring to this file; and thus I worry we're going to close
>> one of them and lose all our locks on it.
> 
> Yeah, this is what makes F_GETLK/F_SETLK such an awful thing to
> use. It is just about managable if an app is single threaded
> and the developer can examine all code paths to make sure there
> are no other open FDs referring to the same underling file.
> If code has multiple FDs open, and/or is a multithreaded app,
> F_SETLK is really fragile / error prone.
> 
> In QEMU proper, we used the fallback to F_GETLK/F_SETLK because
> we were adding locking to existing features. If we didn't have
> the fallback then we would either be breaking existing usage by
> mandating OFD locks, or leaving those users with no locking at
> all by disabling locking entirely.
> 
> For a program like virtiofsd that is brand new functionality
> we don't have to worry about breaking existing users. Thus I
> would strongly recommend we just mandate OFD locks, and entirely
> disable the build of virtiofsd if OFD is missing on the host.
> 
> RHEL-7's 3.10 kernel *does* have OFD locking as it was backported
> and QEMU in RHEL-7 already uses this. Users just need to make
> sure they have updates applied to their RHEL-7 hosts to get this.

I checked the linux kernel commit history and found that F_OFD_SETLK was
introduced at v3.15 as below:

https://github.com/torvalds/linux/commit/0d3f7a2dd2f5cf9642982515e020c1aee2cf7af6

So maybe I need update my kernel to fit this new macro, and as you said,
most users will compile virtiofsd based on new kernel, that seems not a
big deal. At last, thanks for your detailed explanation.

Thanks,
Jun

> 
> Regards,
> Daniel
> 

