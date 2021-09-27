DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1632779120; bh=exJVQl+5l/J1P21jJlF7r+ha1GCZcerAibFKFxpJp1k=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=rWvUAc0OWJ1hz3B2mXWLyeQsTG/L2tghW00AOcabkCGa0Fg6Y/Sq/EYzwXwxVUDsiGuuNz1xYNmcKeiWpxDp+k4Pg4TCJ7LAZvLP3ThzlKnepOEWdRQIIjzANKwh7arkBf5rr78ofkE0XuA63vIVmRYkOBrwkOD2663UOlzp8dxeGDJBaUrNsqMbadtuc6fMy+DHoVj8JX+MdBPmNEtoCaj/fuy85tkT9e36TIM3fDB/cF9g3NOgErmXNN7qCNRpA47UTMJ+QyQo1nYXedip1iZcRXunxGv05dRhear0HQWBBB8D3E/UmBtDd9OE1Iw7QoI8VFuyLNJsyCMFYkO85Q==
References: <20210924192442.916927-3-vgoyal@redhat.com>
	<a02d3e08-3abc-448a-be32-2640d8a991e0@www.fastmail.com>
	<YU5gF9xDhj4g+0Oe@redhat.com>
	<8a46efbf-354c-db20-c24a-ee73d9bbe9d6@schaufler-ca.com>
	<YVHPxYRnZvs/dH7N@redhat.com>
	<753b1417-3a9c-3129-1225-ca68583acc32@schaufler-ca.com>
	<YVHpxiguEsjIHTjJ@redhat.com>
	<67e49606-f365-fded-6572-b8c637af01c5@schaufler-ca.com>
	<YVIZfHhS4X+5BNCS@redhat.com>
	<2e00fbff-b868-3a4f-ecc4-e5f1945834b8@schaufler-ca.com>
	<YVItb/GctH7PpL0f@redhat.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <5d6230dc-bba5-a5c1-2c54-da5e6ecfbf2e@schaufler-ca.com>
Date: Mon, 27 Sep 2021 14:45:13 -0700
MIME-Version: 1.0
In-Reply-To: <YVItb/GctH7PpL0f@redhat.com>
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
Cc: Colin Walters <walters@verbum.org>, Casey Schaufler <casey@schaufler-ca.com>, stephen.smalley.work@gmail.com, Miklos Szeredi <miklos@szeredi.hu>, virtio-fs@redhat.com, selinux@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On 9/27/2021 1:45 PM, Vivek Goyal wrote:
> On Mon, Sep 27, 2021 at 01:19:25PM -0700, Casey Schaufler wrote:
>> On 9/27/2021 12:20 PM, Vivek Goyal wrote:
>>> On Mon, Sep 27, 2021 at 10:56:59AM -0700, Casey Schaufler wrote:
>>>> On 9/27/2021 8:56 AM, Vivek Goyal wrote:
>>>>> On Mon, Sep 27, 2021 at 08:22:48AM -0700, Casey Schaufler wrote:
>>>>>> On 9/27/2021 7:05 AM, Vivek Goyal wrote:
>>>>>>> On Sun, Sep 26, 2021 at 05:53:11PM -0700, Casey Schaufler wrote:
>>>>>>>> On 9/24/2021 4:32 PM, Vivek Goyal wrote:
>>>>>>>>> On Fri, Sep 24, 2021 at 06:00:10PM -0400, Colin Walters wrote:
>>>>>>>>>> On Fri, Sep 24, 2021, at 3:24 PM, Vivek Goyal wrote:
>>>>>>>>>>> When a new inode is created, send its security context to server along
>>>>>>>>>>> with creation request (FUSE_CREAT, FUSE_MKNOD, FUSE_MKDIR and FUSE_SYMLINK).
>>>>>>>>>>> This gives server an opportunity to create new file and set security
>>>>>>>>>>> context (possibly atomically). In all the configurations it might not
>>>>>>>>>>> be possible to set context atomically.
>>>>>>>>>>>
>>>>>>>>>>> Like nfs and ceph, use security_dentry_init_security() to dermine security
>>>>>>>>>>> context of inode and send it with create, mkdir, mknod, and symlink requests.
>>>>>>>>>>>
>>>>>>>>>>> Following is the information sent to server.
>>>>>>>>>>>
>>>>>>>>>>> - struct fuse_secctx.
>>>>>>>>>>>   This contains total size of security context which follows this structure.
>>>>>>>>>>>
>>>>>>>>>>> - xattr name string.
>>>>>>>>>>>   This string represents name of xattr which should be used while setting
>>>>>>>>>>>   security context. As of now it is hardcoded to "security.selinux".
>>>>>>>>>> Any reason not to just send all `security.*` xattrs found on the inode? 
>>>>>>>>>>
>>>>>>>>>> (I'm not super familiar with this code, it looks like we're going from the LSM-cached version attached to the inode, but presumably since we're sending bytes we can just ask the filesytem for the raw data instead)
>>>>>>>>> So this inode is about to be created. There are no xattrs yet. And
>>>>>>>>> filesystem is asking LSMs, what security labels should be set on this
>>>>>>>>> inode before it is published. 
>>>>>>>> No. That's imprecise. It's what SELinux does. An LSM can add any
>>>>>>>> number of attributes on inode creation, or none. These attributes
>>>>>>>> may or may not be "security labels". Assuming that they are is the
>>>>>>>> kind of thinking that leads people like Linus to conclude that the
>>>>>>>> LSM community is clueless.
>>>>>>>>
>>>>>>>>
>>>>>>>>> For local filesystems it is somewhat easy. They are the one creating
>>>>>>>>> inode and can set all xattrs/labels before inode is added to inode
>>>>>>>>> cache.
>>>>>>>>>
>>>>>>>>> But for remote like filesystems, it is more tricky. Actual inode
>>>>>>>>> creation first will happen on server and then client will instantiate
>>>>>>>>> an inode based on information returned by server (Atleast that's
>>>>>>>>> what fuse does).
>>>>>>>>>
>>>>>>>>> So security_dentry_init_security() was created (I think by NFS folks)
>>>>>>>>> so that they can query the label and send it along with create
>>>>>>>>> request and server can take care of setting label (along with file
>>>>>>>>> creation).
>>>>>>>>>
>>>>>>>>> One limitation of security_dentry_init_security() is that it practically
>>>>>>>>> supports only one label. And only SELinux has implemented. So for
>>>>>>>>> all practical purposes this is a hook to obtain selinux label. NFS
>>>>>>>>> and ceph already use it in that way.
>>>>>>>>>
>>>>>>>>> Now there is a desire to be able to return more than one security
>>>>>>>>> labels and support smack and possibly other LSMs. Sure, that great.
>>>>>>>>> But I think for that we will have to implement a new hook which
>>>>>>>>> can return multiple labels and filesystems like nfs, ceph and fuse
>>>>>>>>> will have to be modified to cope with this new hook to support
>>>>>>>>> multiple lables. 
>>>>>>>>>
>>>>>>>>> And I am arguing that we can modify fuse when that hook has been
>>>>>>>>> implemented. There is no point in adding that complexity in fuse
>>>>>>>>> code as well all fuse-server implementations when there is nobody
>>>>>>>>> generating multiple labels. We can't even test it.
>>>>>>>> There's a little bit of chicken-and-egg going on here.
>>>>>>>> There's no point in accommodating multiple labels in
>>>>>>>> this code because you can't have multiple labels. There's
>>>>>>>> no point in trying to support multiple labels because
>>>>>>>> you can't use them in virtiofs and a bunch of other
>>>>>>>> places.
>>>>>>> Once security subsystem provides a hook to support multiple lables, then
>>>>>>> atleast one filesystem will have to be converted to make use of this new
>>>>>>> hook at the same time and rest of the filesystems can catch up later.
>>>>>> Clearly you haven't been following the work I've been doing on
>>>>>> module stacking. That's completely understandable. There aren't
>>>>>> new hooks being added, or at least haven't been yet. Some of the
>>>>>> existing hooks are getting changed to provide the data required
>>>>>> for multiple security modules (e.g. secids become a set of secids).
>>>>>> Filesystems that support xattrs properly are unaffected because,
>>>>>> for all it's shortcomings, the LSM layer hides the details of
>>>>>> the security modules sufficiently. 
>>>>>>
>>>>>> Which filesystem are you saying will have to "be converted"?
>>>>> When I grep for "security_dentry_init_security()" in current code,
>>>>> I see two users, ceph and nfs.
>>>> Neither of which support xattrs fully. Ceph can support them properly,
>>>> but does not by default. NFS is ancient and we've talked about it at
>>>> length. Also, the fact that they use security_dentry_init_security()
>>>> is a red herring. Really, this has no bearing on the issue of fuse.
>>> Frankly speaking, I am now beginning to lose what's being asked for,
>>> w.r.t this patch.
>> 1. Support for multiple concurrent security.* xattrs
> Supporting SMACK is not my priority right now. I am only interested
> in SELinux at this point of time. I am willing to do some extra
> work if SMACK can be easily incorporated in current framework. But
> if current infrastructure does not support it properly, I am not
> planning to write all that to support SMACK. That's a work for
> somebody else who needs to support SMACK over fuse/virtiofs.

Nuts. I was just getting comfortable with the level of cooperation
I've had from the SELinux side recently.

>> 2. Abandon mapping security.* attrs to user.* xattrs
> That I have moved away, for now. Planning to remap security.* xattrs
> to trusted.* and will ask users to give CAP_SYS_ADMIN to daemon.
>
> Once trusted xattrs are namespaced, this all should work very well.

That's good to hear.


>>> I see that NFS and ceph are supporting single security label at
>>> the time of file creation and I added support for the same for
>>> fuse.
>> NFS took that course because the IETF refused for a very long time
>> to accept a name+value pair in the protocol. The implementation
>> was a compromise.
>>
>>> You seem to want to have capability to send multiple "name,value,len"
>>> tuples so that you can support multiple xattrs/labels down the
>>> line.
>> No, so I can do it now. Smack keeps multiple xattrs on filesystem objects.
>> 	security.SMACK64		- the "security label"
>> 	security.SMACK64EXEC		- the Smack label to run the program with
>> 	security.SMACK64TRANSMUTE	- controls labeling on files created
>>
>> There has been discussion about using additional attributes for things
>> like socket labeling.
>>
>> This isn't hypothetical. It's real today. 
> It is real from SMACK point of view but it is not real from 
> security_dentry_init_security() hook point of view. What's equivalent
> of that hook to support SMACK and multiple labels?

When multiple security modules support this hook they will
each get called. So where today security_dentry_init_security()
calls selinux_dentry_init_security(), in the future it will
also call any other <lsm>_dentry_init_security() hook that
is registered. No LSM infrastructure change required.


>>> Even if I do that, I am not sure what to do with those xattrs at
>>> the other end. I am using /proc/thread-self/attr/fscreate to
>>> set the security attribute of file.
>> Either you don't realize that attr/fscreate is SELinux specific, or
>> you don't care, or possibly (and sadly) both.
> I do realize that it is SELinux specific and that's why I have raised
> the concern that it does not work with SMACK.
>
> What's the "fscreate" equivalent for SMACK so that I file server can
> set it before creation of file and get correct context file?

The Smack attribute will be inherited from the creating process.
There is no way to generally change the attribute of a file on
creation. The appropriateness of such a facility has been debated
long and loud over the years. SELinux, which implements so varied
a set of "security" controls opted for it. Smack, which sticks much
more closely to an access control model, considers it too dangerous.
You can change the Smack label with setxattr(1) if you have
CAP_MAC_ADMIN. If you really want the file created with a particular
Smack label you can change the process Smack label by writing to
/proc/self/attr/smack/current on newer kernels and /proc/self/attr/current
on older ones.


>>> https://listman.redhat.com/archives/virtio-fs/2021-September/msg00100.html
>>>
>>> How will this work with multiple labels. I think you will have to
>>> extend fscreate or create new interface to be able to deal with it.
>> Yeah. That thread didn't go to the LSM mail list. It was essentially
>> kept within the RedHat SELinux community. It's no wonder everyone
>> involved thought that your approach is swell. No one who would get
>> goobsmacked by it was on the thread.
> My goal is to support SELinux at this point of time. If you goal is
> to support SMACK, feel free to send patches on top to support that.

It helps to know what's going on before it becomes a major overhaul.

> I sent kernel patches to LSM list to make it plenty clear that this
> interface only supports single label which is SELinux. So there is
> no hiding here. And when I am supporting only SELinux, making use
> of fscreate makes perfect sense to me.

I bet it does.

>>> That's why I think that it seems premature that fuse interface be
>>> written to deal with multiple labels when rest of the infrastructure
>>> is not ready. It should be other way, instead. First rest of the
>>> infrastructure should be written and then all the users make use
>>> of new infra.
>> Today the LSM infrastructure allows a security module to use as many
>> xattrs as it likes. Again, Smack uses multiple security.* xattrs today.
> security_dentry_init_security() can handle that? If not, what's the
> equivalent.

Yes, it can.


>>> BTW, I am checking security_inode_init_security(). That seems to
>>> return max 2 xattrs as of now?
>>>
>>> #define MAX_LSM_EVM_XATTR       2
>>> struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
>> You're looking at the bowels of the EVM subsystem. That herring is red, too.
>>
>>> So we are allocating space for 3 xattrs. Last xattr is Null to signify
>>> end of array. So, we seem to use on xattr for LSM and another for EVM.
>>> Do I understand it correctly. Does that mean that smack stuff does
>>> not work even with security_inode_init_security(). Or there is something
>>> else going on.
>> There's something else going on.
> Help me understand what's going on. How are you returning multiple
> xattrs from security_inode_init_security() when you have allocated
> space for only one LSM xattr.

Look into CONFIG_EVM_EXTRA_SMACK_XATTRS if you like. As I said,
you're digging deeply into EVM at this point. It's not the LSM
infrastructure.

>
> Vivek
>


