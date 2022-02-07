Message-ID: <c6386449-241b-0f7c-a460-f7e1d68f5a39@redhat.com>
Date: Mon, 7 Feb 2022 16:34:29 -0500
MIME-Version: 1.0
References: <20220202193935.268777-1-vgoyal@redhat.com>
	<YgEZDOcFr80tZGWd@redhat.com> <YgGM6pA2sXEAMa3a@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
In-Reply-To: <YgGM6pA2sXEAMa3a@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v5 0/9] virtiofsd: Add support for file
 security context at file creation
Reply-To: dwalsh@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 2/7/22 16:19, Vivek Goyal wrote:
> On Mon, Feb 07, 2022 at 01:05:16PM +0000, Daniel P. Berrangé wrote:
>> On Wed, Feb 02, 2022 at 02:39:26PM -0500, Vivek Goyal wrote:
>>> Hi,
>>>
>>> This is V5 of the patches. I posted V4 here.
>>>
>>> https://listman.redhat.com/archives/virtio-fs/2022-January/msg00041.html
>>>
>>> These will allow us to support SELinux with virtiofs. This will send
>>> SELinux context at file creation to server and server can set it on
>>> file.
>> I've not entirely figured it out from the code, so easier for me
>> to ask...
>>
>> How is the SELinux labelled stored on the host side ? It is stored
>> directly in the security.* xattr namespace,
> [ CC Dan Walsh ]
>
> I just tried to test the mode where I don't do xattr remapping and try
> to set /proc/pid/attr/fscreate with the context I want to set. It will
> set security.selinux xattr on host.
>
> But write to /proc/pid/attr/fscreate fails if host does not recognize
> the label sent by guest. I am running virtiofsd with unconfined_t but
> it still fails because guest is trying to create a file with
> "test_filesystem_filetranscon_t" and host does not recognize this
> label. Seeing following in audit logs.
>
> type=SELINUX_ERR msg=audit(1644268262.666:8111): op=fscreate invalid_context="unconfined_u:object_r:test_filesystem_filetranscon_t:s0"
>
> So if we don't remap xattrs and host has SELinux enabled, then it probably
> work in very limited circumstances where host and guest policies don't
> conflict. I guess its like running fedora 34 guest on fedora 34 host.
> I suspect that this will see very limited use. Though I have put the
> code in for the sake of completeness.
>
> Thanks
> Vivek
>
>> or is is subject to
>> xattr remapping that virtiofsd already supports.
>>
>> Storing directly means virtiofsd has to run in an essentially
>> unconfined context, to let it do arbitrary  changes on security.*
>> xattrs without being blocked by SELinux) and has risk that guest
>> initiated changes can open holes in the host confinement if
>> the exported FS is generally visible to processes on the host.
>>
>>
>> Using remapping lets virtiofsd be strictly isolated by SELinux
>> policy on the host, and ensures that guest context changes
>> can't open up holes in the host.
>>
>> Both are valid use cases, so I'd ultimately expect us to want
>> to support both, but my preference for a "default" behaviour
>> would be remapping.
>>
>> Regards,
>> Daniel
>> -- 
>> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
>> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
>> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
>>
I had a bug today, where someone tried to run a --privileged container 
with RHEL9 which attempted to place a label onto a volume from the RHEL8 
host and got a MAC_ADMIN avc and the label was denied.

Even unconfined domains are not allowed to place non-understood labels 
on disk.  The problem is when the processes on RHEL8 would look at the 
labeled file, they would just see it as unlabeled_t.


