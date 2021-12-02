Message-ID: <ec0c3568-e22f-f7c7-c6fb-ca8b1f221407@redhat.com>
Date: Thu, 2 Dec 2021 18:52:17 +0100
MIME-Version: 1.0
References: <CAJh=p+6o8_2UekwO0nQ8+sjcgpcEzGhFrTsiTjN4n72R3vNAGw@mail.gmail.com>
	<Yafy7hF56oPn9h4/@redhat.com>
	<CAJh=p+6RYEHVCVdqFg8+zZJ=bBy_De7v=-mCqa5k5_g0qih1gg@mail.gmail.com>
	<YajrnsEFa+Zkcke3@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
In-Reply-To: <YajrnsEFa+Zkcke3@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [virtiofsd][virtiofsd-rs] unlink an openfile over
	NFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, German Maglione <gmaglione@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On 02.12.21 16:51, Vivek Goyal wrote:
> On Thu, Dec 02, 2021 at 04:03:20PM +0100, German Maglione wrote:
>> On Wed, Dec 1, 2021 at 11:10 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>>> On Wed, Dec 01, 2021 at 01:06:23PM +0100, German Maglione wrote:
>>>> Hi,
>>>>
>>>> I was working on [1] (related to [2]), and I saw that both versions
>>>> (C and rust) of virtiofsd make the NFs client to "silly rename" an open
>>>> file that were unlinked, because we keep each file open as O_PATH in the
>>>> lo_do_lookup/do_lookup function. David pointed me to this problem, and I
>>>> confirmed that this is the case.
>>>>
>>>> This fires the silly rename in the nfs client. I'm talking with
>>>> Bruce Fields (nfs team) to see how to move the silly rename functionality
>>>> to the nfs server and outside the directory tree [4], to avoid having
>>>> non-really-empty
>>>> dirs full of .nfsxxx files. But it is not an easy task.
>>>> Also, this will not solve some potential issues with the resource usage:
>>>> disk space and open file limits (I hit this limit a couple of times
>>> during
>>>> my
>>>> tests). And, in some cases could be worst, more than one guest sharing
>>> the
>>>> same
>>>> exported dir, one guest just 'ls' or 'find' while the other 'rm' some
>>> files.
>>>> (The 'find' command will open all files, btw)
>>>>
>>>> Vivek, I saw in [5] that you mentioned that this could be fixed
>>> introducing
>>>> synchronous, could you elaborate a bit or point me to some code?
>>> Hi German,
>>>
>>> Right now forget messages are asynchronous. They are sent to server and
>>> client does not wait for any reply. That means when unlink() returns,
>>> it is possible that a FORGET message is in progress and has not finished
>>> yet.
>>>
>>> Idea behind synchronous FORGET messages is that it will generate a reply
>>> and client will wait for it. Given inode on server should be gone,
>>> I am not sure how much sense does it make. But anyway conceputaully
>>> that's the idea. If we want for FORGET message to finish, that will
>>> mean that O_PATH fd opened by virtiofsd is closed and we will not
>>> have NFS silly rename issue (atleast due to virtiofsd). If virtiofs
>>> client has file open, then issue will still happen.
>>>
>>> I think using file handles in virtiofsd_rs (--inode-file-handles) is
>>> a reasonable solution for this problem. Trying to add synchronous
>>> FORGET might be overkill.
>>>
>>>
>> Hi Vivek,
>>
>> Yes, as you said the solution is using --inode-file-hanldes, turns out
>> the problem was the --inode-file-handles failed silently when
>> choosing a sandbox other than namespace (now fixed by Hanna).
>>
>> So now the thing is, what we do if it fails? Hanna posted an Issue about
>> that:
>> "[RFE] Reporting failure to generate file handles".
> My take from the beginning has been that if file handle generation fails,
> then report it back to user (instead of falling back to O_PATH fd
> silently). That way user atleast knows that file handles can't be used.

I remember that we had a discussion about whether to introduce a 
mandatory mode where this would be the behavior.  I thought we agreed 
that a best-effort mode always made sense, for example for the situation 
you describe below, where you have mixed filesystems, with some perhaps 
supporting file handles, and others not.

As for a mandatory mode, I couldn’t imagine how exactly it would be 
useful, though.  I think my argument was: “What would a user do after 
launching virtiofsd with file handles forced on, and then noticing they 
don’t work?”  And I still don’t really know, even though I’m proposing 
such a mode in said virtiofsd-rs gitlab issue for the NFS case.  I 
suppose the answer is, check every configuration and find out why it 
doesn’t work; but you don’t need a mandatory file handle mode for this, 
logging errors whenever we need to fall back to O_PATH FDs would be 
completely sufficient.

(I’m mostly proposing it for NFS, because non-working file handles are 
something that seems likely to cause other problems later. Emitting a 
warning would technically be completely fine in order to inform the user 
of this, but I feel like in this case it’d be better to nag them even more.)

> If file handles can't be generated due to lack of resources in system,
> then error should be returned to caller as well.
>
>> There is any problem to use file handles as default?
> It gives CAP_DAC_READ_SEARCH in init_user_ns. So enabling it by default
> might not be desirable. Especially given the fact that we want to move
> towards user namespaces and run virtiofsd with least priviliges. So
> I will think user needs to enable it if they need it.
>
>> I mean without
>> --inode-file-handles so let them fail and force the user to use something
>> like
>> --no-file-handles/--force-no-file-handles with a warning.
> If we were to enable it by default, we probably should test if file
> handles are supported on shared dir. If yes, then enable it by default
> otherwise continue to use O_PATH fd. But this will be mode switch for
> the whole shared filesystem.
>
> I think given we have notion of submounts and some of the submounted
> filesystems might not support file handles, so key question will be
> what do we do here. Do we return error in this case or fallback to
> O_PATH fd for that submount. If we stick to our design philosophy,
> then I would say return error. But some people might object because
> they might want a mode where there is mix of filesystems in shared
> dir and they want to use file handles where supported. So I am sitting
> on the fence on this one.

I think at this point I prefer making --inode-file-handles take an 
optional argument:
- no: Default, don’t use file handles.
- best-effort: Try to generate file handles, fall back to FDs on error.
- mandatory: Always use file handles, return errors to the guest.

And then let the user choose.

(We could definitely make “best-effort” the default for when 
CAP_DAC_READ_SEARCH is available, but I’m not sure we should.  I believe 
in a case like NFS, we should let the user know we recommend 
“mandatory”.  In other cases it just depends.  If the user doesn’t care 
about how many FDs are open, “no” is perfectly OK.  Using file handles 
probably has a small performance penalty, so I don’t know how I feel 
about (defaulting to) using them if they aren’t necessary.)

Hanna

