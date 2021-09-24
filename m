DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1632520565; bh=DwLdTaIH5wbh33gGt4zSu0dsn+5fXtM8/mYtHBpFI4I=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=De2h6BVpadV/IGeUY9FLtxYAv5fILRgoPUGxbK0sQunVnKo6YWCE5R8rD+xAlmyu9eVXMaeAp1vzX8J7HaAjza9h/ucNiwYhCxooNYxwLZ5yUcBAEvBMTxT4mmO2Ht5xByx8YQ7BKesTk7+E3drpX/r4EaUFNwbTeqFt/UORBYBm9yDf2MUsqzbUEybLvre5vj2LETCV9/HItTgxObULdG6s+/dDym4mfjgGZaDAbo7t1jH4MqW/wJDrGCzQ/t2pyFDdKO/s5mQXOH71e56PPESVaQcJVfbF9OFTkokbTohRt41el3KCkXFHVN7zjhkB4433+v3l23UCBPASjAbs5g==
References: <20210924192442.916927-1-vgoyal@redhat.com>
	<20210924192442.916927-3-vgoyal@redhat.com>
	<a843a6d9-2e7a-768c-b742-fc190880b439@schaufler-ca.com>
	<YU4ypwtADWRn/A0p@redhat.com>
	<f92a082e-c329-f079-6765-ac8b44e45ee4@schaufler-ca.com>
	<YU5AQB/owpnC/yeZ@redhat.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <58812eb0-6ced-64bc-4d08-c82eca2bae11@schaufler-ca.com>
Date: Fri, 24 Sep 2021 14:55:58 -0700
MIME-Version: 1.0
In-Reply-To: <YU5AQB/owpnC/yeZ@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: Send security context of inode on
	file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>, stephen.smalley.work@gmail.com, virtio-fs@redhat.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 9/24/2021 2:16 PM, Vivek Goyal wrote:
> On Fri, Sep 24, 2021 at 01:54:20PM -0700, Casey Schaufler wrote:
>> On 9/24/2021 1:18 PM, Vivek Goyal wrote:
>>> On Fri, Sep 24, 2021 at 12:58:28PM -0700, Casey Schaufler wrote:
>>>> On 9/24/2021 12:24 PM, Vivek Goyal wrote:
>>>>> When a new inode is created, send its security context to server along
>>>>> with creation request (FUSE_CREAT, FUSE_MKNOD, FUSE_MKDIR and FUSE_SYMLINK).
>>>>> This gives server an opportunity to create new file and set security
>>>>> context (possibly atomically). In all the configurations it might not
>>>>> be possible to set context atomically.
>>>>>
>>>>> Like nfs and ceph, use security_dentry_init_security() to dermine security
>>>>> context of inode and send it with create, mkdir, mknod, and symlink requests.
>>>>>
>>>>> Following is the information sent to server.
>>>>>
>>>>> - struct fuse_secctx.
>>>>>   This contains total size of security context which follows this structure.
>>>>>
>>>>> - xattr name string.
>>>>>   This string represents name of xattr which should be used while setting
>>>>>   security context. As of now it is hardcoded to "security.selinux".
>>>> Why? It's not like "security.SMACK64' is a secret.
>>> Sorry, I don't understand what's the concern. Can you elaborate a bit
>>> more.
>> Sure. Interfaces that are designed as special case solutions for
>> SELinux tend to make my life miserable as the Smack maintainer and
>> for the efforts to complete LSM stacking. You make the change for
>> SELinux and leave the generalization as an exercise for some poor
>> sod like me to deal with later.
> I am not expecting you do to fuse work. Once you add the new security
> hook which can return multiple labels, I will gladly do fuse work
> to send multiple labels.
>
>>> I am hardcoding name to "security.selinux" because as of now only
>>> SELinux implements this hook.
>> Yes. A Smack hook implementation is on the todo list. If you hard code
>> this in fuse you're adding another thing that has to be done for
>> Smack support.
>>
>>>  And there is no way to know the name
>>> of xattr, so I have had to hardcode it. But tomorrow if interface
>>> changes so that name of xattr is also returned, we can easily get
>>> rid of hardcoding.
>> So why not make the interface do that now?
> Because its unnecessary complexity for me. When multiple label support
> is not even there, I need to write and test code to support multiple
> labels when support is not even there.

Subsystems that treat labels as a special case (as opposed to supporting xattrs
properly) make me sad.


>>> If another LSM decides to implement this hook, then we can send
>>> that name as well. Say "security.SMACK64".
>> Again, why not make it work that way now, and avoid having
>> to change the protocol later? Changing protocols and interfaces
>> is much harder than doing them generally in the first place.
> In case of fuse, it is not that complicated to change protocol and
> add new options. Once you add support for smack and multiple labels,
> I will gladly change fuse to be able to accomodate that.

Cool. I'll hold you to that. Priority has been bumped up.



>>>>> - security context.
>>>>>   This is the actual security context whose size is specified in fuse_secctx
>>>>>   struct.
>>>> The possibility of multiple security contexts on a file is real
>>>> in the not too distant future. Also, a file can have multiple relevant
>>>> security attributes at creation. Smack, for example, may assign a
>>>> security.SMACK64 and a security.SMACK64TRANSMUTE attribute. Your
>>>> interface cannot support either of these cases.
>>> Right. As of now it does not support capability to support multiple
>>> security context. But we should be easily able to extend the protocol
>>> whenever that supports lands in kernel.
>> No. Extending single data item protocols to support multiple
>> data items *hurts* most of the time. If it wasn't so much more
>> complicated you'd be doing it up front without fussing about it.
> Its unnecessary work at this point of time. Once multiple labels
> are supported, I can do this work.
>
> I think we will need to send extra structure which tells how many
> labels are going to follow. And then all the labels will follow
> with same format I am using for single label.
>
> struct fuse_secctx; xattr name string; actual label
>
>>>  Say a new option
>>> FUSE_SECURITY_CTX_EXT which will allow sending multiple security
>>> context labels (along with associated xattr names).
>>>
>>> As of now there is no need to increase the complexity of current
>>> implementation both in fuse as well as virtiofsd when kernel
>>> does not even support multiple lables using security_dentry_init_security()
>>> hook.
>> You're 100% correct. For your purpose today there's no reason to
>> do anything else. It would be really handy if I didn't have yet
>> another thing that I don't have the time to rewrite.
> I can help with adding fuse support once smack supports it. Right now
> I can't even test it even if I sign up for extra complexity.
>
> Vivek
>


