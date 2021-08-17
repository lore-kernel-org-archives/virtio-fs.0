References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-10-mreitz@redhat.com>
	<YRF2xjwSKOiqB/Al@redhat.com>
	<df64553c-c03d-076a-bcef-bec8554977a4@redhat.com>
	<YRKZ415xrDtcYaQR@redhat.com>
	<4a74bbbd-92f6-a7d1-0c8d-fa8b121b9643@redhat.com>
	<YRKh/fbBntF+GfS8@redhat.com>
	<6e943ee0-dcb3-6812-3a0b-eb2b72b503ad@redhat.com>
	<YRrALRGy2cROwsP9@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
Message-ID: <89b416e7-c0ca-7831-da13-683e8a74b7ae@redhat.com>
Date: Tue, 17 Aug 2021 10:27:16 +0200
MIME-Version: 1.0
In-Reply-To: <YRrALRGy2cROwsP9@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 09/10] virtiofsd: Optionally fill
	lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

On 16.08.21 21:44, Vivek Goyal wrote:
> On Wed, Aug 11, 2021 at 08:41:18AM +0200, Hanna Reitz wrote:
>
> [..]
>>>> But given the inotify complications, there’s really a good reason we should
>>>> use mountinfo.
>>>>
>>>>>> It’s a bit tricky because our sandboxing prevents easy access to mountinfo,
>>>>>> but if that’s the only way...
>>>>> yes. We already have lo->proc_self_fd. Maybe we need to keep
>>>>> /proc/self/mountinfo open in lo->proc_self_mountinfo. I am assuming
>>>>> that any mount table changes will still be visible despite the fact
>>>>> I have fd open (and don't have to open new fd to notice new mount/unmount
>>>>> changes).
>>>> Well, yes, that was my idea.  Unfortunately, I wasn’t quite successful yet;
>>>> when I tried keeping the fd open, reading from it would just return 0
>>>> bytes.  Perhaps that’s because we bind-mount /proc/self/fd to /proc so that
>>>> nothing else in /proc is visible. Perhaps we need to bind-mount
>>>> /proc/self/mountinfo into /proc/self/fd before that...
>>> Or perhaps open /proc/self/mountinfo and save fd in lo->proc_mountinfo
>>> before /proc/self/fd is bind mounted on /proc?
>> Yes, I tried that, and then reading would just return 0 bytes.
> Hi Hanna,
>
> I tried this simple patch and I can read /proc/self/mountinfo before
> bind mounting /proc/self/fd and after bind mounting /proc/self/fd. Am
> I missing something.

Yes, but I tried reading it in the main loop (where we’d actually need 
it).  It looks like the umount2(".", MNT_DETACH) in setup_mounts() 
breaks it.

Hanna

