References: <20190801151348.14947-1-msys.mizuma@gmail.com>
	<20190802153930.GB22284@stefanha-x1.localdomain>
	<20190802162239.c2vpm2mip54wjvj6@gabell>
	<da22f29b-7835-e333-f611-5cfc2f74b4cb@huawei.com>
	<5f36bf5e-d1be-2f19-1dcf-56be2fbbcb41@gmail.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D48E1DF.3030707@huawei.com>
Date: Tue, 6 Aug 2019 10:11:43 +0800
MIME-Version: 1.0
In-Reply-To: <5f36bf5e-d1be-2f19-1dcf-56be2fbbcb41@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Prevent multiply running with
 same vhost_user_socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, m.mizuma@jp.fujitsu.com

Hi Masayoshi,

On 2019/8/6 10:08, Masayoshi Mizuma wrote:
> Hi Jun,
> 
> On 8/3/19 10:48 PM, piaojun wrote:
>> Hi,
>>
>> On 2019/8/3 0:22, Masayoshi Mizuma wrote:
>>> Hi Stefan,
>>>
>>> On Fri, Aug 02, 2019 at 04:39:30PM +0100, Stefan Hajnoczi wrote:
>>>> On Thu, Aug 01, 2019 at 11:13:48AM -0400, Masayoshi Mizuma wrote:
>>>>> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>>>>>
>>>>> virtiofsd can run multiply even if the vhost_user_socket is
>>>>> same path.
>>>>>
>>>>>   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
>>>>>   [1] 244965
>>>>>   virtio_session_mount: Waiting for vhost-user socket connection...
>>>>>   ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
>>>>>   [2] 244966
>>>>>   virtio_session_mount: Waiting for vhost-user socket connection...
>>>>>   ]#
>>>>>
>>>>> The file access from the guest works because the second virtiofsd
>>>>> handles that, however, the user will get confused the situation
>>>>> and may be the cause of unexpected problem. So it's better to
>>>>> prevent the multiple running.
>>>>>
>>>>> Change unlink() of the socket to the exit of virtiofsd so that the
>>>>> latter virtiofsd can fail on bind() as EADDRINUSE.
>>>>>
>>>>> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>>>>> ---
>>>>>  contrib/virtiofsd/fuse_lowlevel.c | 1 +
>>>>>  contrib/virtiofsd/fuse_virtio.c   | 1 -
>>>>>  2 files changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> This patch makes the UNIX domain socket act similar to a pidfile or
>>>> lockfile.  Does the user need to clean up the UNIX domain socket
>>>> manually before virtiofsd can restart again after a crash?
>>>>
>>>> This can be a robustness/reliability problem because we must assume that
>>>> crashes happen and recovery should not require human intervention.
>>>>
>>>> On the other hand, there are plenty of daemons that have long-lived UNIX
>>>> domain socket paths.  How do they handle crash recovery?
>>>
>>> It's good point, thanks.
>>> I think if the socket ramains due to the former crash, then the socket
>>> should be unlinked by virtiofsd, not manualy.
>>>
>>> virtiofsd should detect whether the socket is in use by the other
>>> virtiofsd or just remains by crash.
>>> I'll try to implement that...
>>
>> Do you mean that we need handle these two situations?
>> 1. The socket in use now;
>> 2. The socket remains by the former crashed virtiofsd.
>>
>> I guess it's a little hard to distinguish one from the other, as user
>> can start up virtiofsd simultaneously. If our goal is preventing
>> multiple instances, why not using file lock to guarantee single-instance?
>>
> 
> Thank you for your comments.
> Yes, I'm trying to implement that by using file lock.
> The unix domain socket cannot be locked because the open() fails as ENXIO,
> so I'm thinking that creates a regular file corresponding the socket name,
> and locks the file when virtiofsd boots. If the lock fails, then the socket
> is in use. If the lock successes, then the socket is available.
> I'll post the v2 patch...

That sounds reasonable.

Thanks,
Jun

> 
> Thanks!
> Masa
> .
> 

