DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=e7Pzzf0EUmLz1zBgBX0QpTTb1bUhT+9sx4YG3TWQFG8=;
	b=eA76Pwjd8cwhJmdvvCNZdQDhQ0lZNctXdr0XR/yxoIo/4FITu5+IkFUJubKoQ4emb3
	E1rbcn20/WDnxAXahkX14LXDj5Cstn0YLAmf3aOKUe245w2c3pJ/voqZ2JCYmbNONk8d
	bJtF5IulVUYt1yzSmOqHXj6pMoTKaGzs97228F9hx2pj9uGH9ZQFy/WwmFMQdgM7r5hW
	IKeXrDrKKiKbiL8g0be+djqeV7iB7f+OaZnRLZZANuA17CrpXUk3CPn/HSIEOu/knGRC
	lY5ZQW+pwWbFLK5GwXNuA11vNbLx49O7qKiYC+42sO5bgi1gsz4dFHFYdy2Vca7+VJwT
	CDxA==
References: <7d350903c2aa8f318f8441eaffafe10b7796d17b.camel@redhat.com>
	<20201013184026.GC142988@redhat.com>
	<20201013185808.GA164772@redhat.com>
	<c38fe9ee57c142e1cb720520b4f9b68666bcb2b8.camel@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <aa16e18d-20fb-8d84-1431-2347410f7760@gmail.com>
Date: Tue, 13 Oct 2020 14:20:58 -0500
MIME-Version: 1.0
In-Reply-To: <c38fe9ee57c142e1cb720520b4f9b68666bcb2b8.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] Unbreakable loop in fuse_fill_write_pages()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


On 10/13/20 2:12 PM, Qian Cai wrote:
> On Tue, 2020-10-13 at 14:58 -0400, Vivek Goyal wrote:
>> I am wondering if virtiofsd still alive and responding to requests? I
>> see another task which is blocked on getdents() for more than 120s.
>>
>> [10580.142571][  T348] INFO: task trinity-c36:254165 blocked for more than 123
>> +seconds.
>> [10580.143924][  T348]       Tainted: G           O	 5.9.0-next-20201013+ #2
>> [10580.145158][  T348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> +disables this message.
>> [10580.146636][  T348] task:trinity-c36     state:D stack:26704 pid:254165
>> ppid:
>> +87180 flags:0x00000004
>> [10580.148260][  T348] Call Trace:
>> [10580.148789][  T348]  __schedule+0x71d/0x1b50
>> [10580.149532][  T348]  ? __sched_text_start+0x8/0x8
>> [10580.150343][  T348]  schedule+0xbf/0x270
>> [10580.151044][  T348]  schedule_preempt_disabled+0xc/0x20
>> [10580.152006][  T348]  __mutex_lock+0x9f1/0x1360
>> [10580.152777][  T348]  ? __fdget_pos+0x9c/0xb0
>> [10580.153484][  T348]  ? mutex_lock_io_nested+0x1240/0x1240
>> [10580.154432][  T348]  ? find_held_lock+0x33/0x1c0
>> [10580.155220][  T348]  ? __fdget_pos+0x9c/0xb0
>> [10580.155934][  T348]  __fdget_pos+0x9c/0xb0
>> [10580.156660][  T348]  __x64_sys_getdents+0xff/0x230
>>
>> May be virtiofsd crashed and hence no requests are completing leading
>> to a hard lockup?
> No, it was not crashed. After I had to forcibly close the guest, the virtiofsd
> daemon will exit normally. However, I can't tell exactly if the virtiofsd daemon
> was still functioning normally. I'll enable the debug and retry to see if there
> is anything interesting.

Though it's likely not related, randomly but perhaps twice every three
days I notice when a VM is stopped, it can't be restarted because the
virtiofsd instance from the previous run hasn't exited and won't exit no
matter how long a delay absent a kill -KILL.   I'm not sure how to debug
or get info on that.


>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-f

