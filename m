References: <20210507221527.699516-1-ckuehl@redhat.com>
	<YJpbEMePhQ88EWWR@stefanha-x1.localdomain>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <290eaac8-45d9-0bfb-94f5-9fb41e5a3e42@redhat.com>
Date: Tue, 11 May 2021 09:41:59 -0500
MIME-Version: 1.0
In-Reply-To: <YJpbEMePhQ88EWWR@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Enable multiple request queues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On 5/11/21 5:23 AM, Stefan Hajnoczi wrote:
> On Fri, May 07, 2021 at 05:15:27PM -0500, Connor Kuehl wrote:
>> @@ -1245,7 +1262,8 @@ __releases(fiq->lock)
>>  		 req->in.h.nodeid, req->in.h.len,
>>  		 fuse_len_args(req->args->out_numargs, req->args->out_args));
>>  
>> -	fsvq = &fs->vqs[queue_id];
>> +	fsvq = this_cpu_read(this_cpu_fsvq);
> 
> Please check how CPU hotplug affects this patch. If the current CPU
> doesn't have a vq because it was hotplugged, then it may be necessary to
> pick another vq.

I'll fix this in the next revision.

Thanks,

Connor

