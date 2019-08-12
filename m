References: <20190809082536.56402-1-eguan@linux.alibaba.com>
	<5D4D3E0E.10609@huawei.com> <20190811132042.GB2665@desktop>
	<3d1f5a7e-fd00-2b46-994c-99d07b3c94ce@huawei.com>
	<20190811153517.GF2665@desktop>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D50CECC.4000701@huawei.com>
Date: Mon, 12 Aug 2019 10:28:28 +0800
MIME-Version: 1.0
In-Reply-To: <20190811153517.GF2665@desktop>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofsd: print log only when priority
 is high enough
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <guaneryu@gmail.com>
Cc: virtio-fs@redhat.com



On 2019/8/11 23:35, Eryu Guan wrote:
> On Sun, Aug 11, 2019 at 10:32:16PM +0800, piaojun wrote:
>>
>>
>> On 2019/8/11 21:20, Eryu Guan wrote:
>>> On Fri, Aug 09, 2019 at 05:34:06PM +0800, piaojun wrote:
>>>> Hi Eryu,
>>>>
>>>> A very big patch, and I prefer spliting into several ones.
>>>
>>> Most of the changes are replacing
>>>
>>> 	if (lo->debug)
>>> 		fuse_debug(...);
>>>
>>> to
>>> 	fuse_debug(...);
>>>
>>> But yeah, it's fine to split, one patches introduce current_log_level
>>> related code, one does the replacements.
>>
>> Sounds reasonable.
>>
>>>
>>>>
>>>> On 2019/8/9 16:25, Eryu Guan wrote:
>>>>> Introduce "-o log_level=" command line option to specify current log
>>>>> level (priority), valid values are "debug info warn err", e.g.
>>>>>
>>>>>     ./virtiofsd -o log_level=debug ...
>>>>>
>>>>> So only log priority higher than "debug" will be printed to
>>>>> stderr/syslog. And the default level is info.
>>>>>
>>>>> The "-o debug"/"-d" options are kept, and imply debug log level.
>>>>
>>>> I wonder if this will make user confused when there are two options for
>>>> debug.
>>>
>>> Forgot to mention, one reason to keep "-o debug/-d" options is try not
>>> to break existing users, e.g. kata-runtime. But I have no strong
>>> preference on this.
>>
>> Yes, compat is always important, and I have little knowledge about kata,
>> so it would be best to reach an agreement with it.
>>
>> After looking though all the fuse_log codes, I come up with a new idea
>> to do this.
>> 1. Expand the debug in struct lo_data to *log_level* which represent
>> err, warn, info and debug;
>>
>> struct lo_data {
>> 	pthread_mutex_t mutex;
>> 	int debug -> *log_level*;
> 
> I thought about this too, but that means that fuse_debug/info/warn/err
> functions should take lo_data or fuse_session as argument as well, and I
> don't think it's worth to introduce such complexity, a global log level
> would be easier. And I think it's possible & easier to add support to
> change the log level (as a global variable) when virtiofsd is running,
> e.g. on SIGHUP.

Perhaps you did not get my point, and we may just use lo_data to set
*current_log_level* once, no need always pass it.

We'd better do little harm do the origin code struct if possible.

Jun

