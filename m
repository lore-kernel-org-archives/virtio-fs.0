Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
From: "Liu, Jiang" <gerry@linux.alibaba.com>
In-Reply-To: <CAOQ4uxjDESmpEfOJ+PEVfnz=2pa1ahvUM3FWtzdkG1WaB8eRQQ@mail.gmail.com>
Date: Fri, 8 Jan 2021 17:25:07 +0800
Message-Id: <109B77BF-C2C9-4AAD-B11B-9ECF44600B44@linux.alibaba.com>
References: <20210104160013.GG2972@work-vm>
	<20210104184527.GC63879@redhat.com> <20210104185655.GN2972@work-vm>
	<CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
	<CAJfpegtHh_m9DpMqC+hBvvV1ioRcydj2cHqMzo41rLcXc148Zw@mail.gmail.com>
	<CAOQ4uxgfW2BZ04hSahymzyerz==YVNLyRmxkUysZPYmnt6n7QA@mail.gmail.com>
	<CAJfpegsSKfaFbpovOZpJQOP_xrpQpJa2mBK=xefV5k1XsCbfbQ@mail.gmail.com>
	<20210106165759.GA9679@redhat.com>
	<CAJfpegtO+X9rk5pTTRmDv9LWGK4fbvUuwNJvRP_o77B5Y5D3mA@mail.gmail.com>
	<CAOQ4uxjTerAAxvjpDmDMQO363ju01MsEhbgBmHHSQb92hoL1_g@mail.gmail.com>
	<20210108041252.GT80581@e18g06458.et15sqa>
	<CAOQ4uxjDESmpEfOJ+PEVfnz=2pa1ahvUM3FWtzdkG1WaB8eRQQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [fuse-devel] 'FORGET' ordering semantics (vs unlink
 & NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, bergwolf@hyper.sh, Vivek Goyal <vgoyal@redhat.com>



> On Jan 8, 2021, at 5:08 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> 
>>> Miklos,
>>> 
>>> I would like to point out that this discussion is relevant to any low level
>>> fuse filesystem, but especially those that are proxying a real filesystem.
>>> 
>>> I have raised this question before in the FUSE_PASSTHROUGH threads.
>>> There is a lot of code duplication among various low-level fuse projects and
>>> as we get to NFS export support and complex issues like this one, is it
>>> getting unlikely that all projects will handle this correctly.
>>> 
>>> Do you think there is room for some more generic code in libfuse and if
>>> so how? Following an example implementation (assuming it gets fixed)
>>> and hand picking fixes to projects cannot scale for long.
>>> 
>>> The challenge is that most of the generic code would be in lookup and
>>> maintaining the internal inode cache, but each filesystem may need
>>> different representations of the Inode object.
>>> 
>>> I was thinking of something along the lines of an OO library that
>>> implements the generic lookup/inode cache for a base FuseInode class
>>> that implementers can inherit from.
>>> 
>>> This doesn't need to be in the libfuse project at all.
>>> Seeing the virtiofsd already has a Rust implementation that is BSD
>>> licensed, maybe that can be used as a starting point?
>>> 
>>> David,
>>> 
>>> How hard do you think it would be to re-factor virtiofsd-rs to
>>> an implementation that inherits from a base passthroughfsd-rs?
>>> 
>>> BTW, is virtiofsd-rs the offical virtiofsd or an experimental one?
>>> Which tree does Miklos' patch apply to?
>>> 
>>> Anyone has other thoughts about how to reduce fragmentation in
>>> implementations?
>> 
>> There's an fuse-backend-rs[1] project hosted on cloud-hypervisor, it is
>> a library to communicate with the Linux FUSE clients, which includes:
>> 
>> - ABI layer, which defines all data structures shared between linux Fuse
>>  framework and Fuse daemons.
>> - API layer, defines the interfaces for Fuse daemons to implement a
>>  userspace file system.
>> - Transport layer, which supports both the Linux Fuse device and
>>  virtio-fs protocol.
>> - VFS/pseudo_fs, an abstraction layer to support multiple file systems
>>  by a single virtio-fs device.
>> - A sample passthrough file system implementation, which passes through
>>  files from daemons to clients.
>> 
>> I'm wondering if fuse-backend-rs is a proper project to work on, and
>> maybe virtiofsd-rs could be switched to use it as well in the future.
>> 
>> Thanks,
>> Eryu
>> 
>> [1] https://github.com/cloud-hypervisor/fuse-backend-rs
> 
> 
> Hi Eryu!
> 
> This looks very interesting.
> Can you guys say a few words about the maturity of this project.
> Does it have any CI? any beta/production workloads that use it?
> I would be happy to contribute the open_by_handle_at() changes
> if I know they will get properly tested.
> 
> As demonstrated in this demo fs [1], with xfs/ext4 as underlying filesystem,
> full NFS support can be implemented by implementing lookup in filesystem
> by inode only, before fuse adds support to LOOKUP_HANDLE in the protocol.
> 
> Thanks,
> Amir.
Hi Amir,
	This project is derived from crosvm and Cloud Hypervisor, and we have
extended it to support some Container centric usage mode. About quality, I 
think it may be some sort of “product”, but the project itself still lacks of a robust
CI system.
	The proposal you mentioned about open_by_handle_at() is very attractive:)
We have encountered some cases running out of file descriptors, we have also
encountered issues to enabling virtio-fs over nfs. Absolutely the open_by_handle_at() 
proposal helps here:)
	And the next big step of the project is to enable io_uring and rust async io:)
Thanks!

> 
> [1] https://github.com/amir73il/libfuse/commits/cachegwfs


