From: Vitaly Kuznetsov <vkuznets@redhat.com>
In-Reply-To: <20200630145303.GB322149@redhat.com>
References: <20200625214701.GA180786@redhat.com>
	<87lfkach6o.fsf@vitty.brq.redhat.com>
	<20200626150303.GC195150@redhat.com>
	<874kqtd212.fsf@vitty.brq.redhat.com>
	<20200629220353.GC269627@redhat.com>
	<87sgecbs9w.fsf@vitty.brq.redhat.com>
	<20200630145303.GB322149@redhat.com>
Date: Tue, 30 Jun 2020 17:13:54 +0200
Message-ID: <87mu4kbn7x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [RFC PATCH] kvm,
	x86: Exit to user space in case of page fault error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, pbonzini@redhat.com, sean.j.christopherson@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jun 30, 2020 at 03:24:43PM +0200, Vitaly Kuznetsov wrote:

>> 
>> It's probably me who's missing something important here :-) but I think
>> you describe how it *should* work as I'm not seeing how we can leave the
>> loop in kvm_async_pf_task_wait_schedule() other than by 
>> "if (hlist_unhashed(&n.link)) break;" and this only happens when APF
>> completes.
>
> We don't leave loop in kvm_async_pf_task_wait_schedule(). It will happen
> before you return to user space.
>
> I have not looked too closely but I think following code path might be taken
> after aync PF has completed.
>
> __kvm_handle_async_pf()
>   idtentry_exit_cond_rcu()
>     prepare_exit_to_usermode()
>       __prepare_exit_to_usermode()
>         exit_to_usermode_loop()
> 	  do_signal()
>
> So once you have been woken up (because APF completed),

Ah, OK so we still need to complete APF and we can't kill the process
before this happens, that's what I was missing.

>  you will
> return to user space and before that you will check if there are
> pending signals and handle that signal first before user space
> gets a chance to run again and retry faulting instruction.

...

>
>> 
>> When guest receives the 'page ready' event with an error it (like for
>> every other 'page ready' event) tries to wake up the corresponding
>> process but if the process is dead already it can do in-kernel probing
>> of the GFN, this way we guarantee that the error is always injected. I'm
>> not sure if it is needed though but in case it is, this can be a
>> solution. We can add a new feature bit and only deliver errors when the
>> guest indicates that it knows what to do with them.
>
> - Process will be delivered singal after async PF completion and during
>   returning to user space. You have lost control by then.
>

So actually there's no way for kernel to know if the userspace process
managed to re-try the instruction and get the error injected or if it
was killed prior to that.

> - If you retry in kernel, we will change the context completely that
>   who was trying to access the gfn in question. We want to retain
>   the real context and retain information who was trying to access
>   gfn in question.

(Just so I understand the idea better) does the guest context matter to
the host? Or, more specifically, are we going to do anything besides
get_user_pages() which will actually analyze who triggered the access
*in the guest*?

-- 
Vitaly

