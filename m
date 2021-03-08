References: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
	<20210308090650.i5ow6pq23asygrod@mhamilton>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <b2b29e3c-f87b-03fd-a465-2ac6d1084a82@redhat.com>
Date: Mon, 8 Mar 2021 11:52:58 +0100
MIME-Version: 1.0
In-Reply-To: <20210308090650.i5ow6pq23asygrod@mhamilton>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Securing file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On 08.03.21 10:06, Sergio Lopez wrote:
> On Fri, Mar 05, 2021 at 05:22:56PM +0100, Max Reitz wrote:
>> == Summary ==
>>
>> So, my current position is:
>>
>> - Bind mounts don’t help with restricting file handles to the exported
>>    directory.
>>
>> - A MAC is not very elegant, and we might encounter problems where a
>>    file may be moved outside of the shared directory, but remains
>>    accessible (because moving a file doesn’t change its handle).
>>    (If we consider that a problem.  NFS evidently doesn’t, because
>>    without subtree_check, it has absolutely no protection against
>>    arbitrary file handles being opened (on the FS where the export
>>    resides), so valid file handles always remain valid.)
>>
>> - A solution such as NFS’s subtree_check (i.e., storing the file’s
>>    parent’s handle in addition to the file’s handle itself, then
>>    verifying that the file does still reside in that directory when the
>>    handle is opened, and then going up the tree to see whether we can
>>    trace it back to the shared directory) is interesting and can perhaps
>>    be considered elegant, but it requires iterating the directory the
>>    file resides in when it is opened, and it will result in file handles
>>    being invalidated whenever a file is moved (outside of its directory).
>>    Perhaps also other issues.  In any case, there are reasons why NFS has
>>    basically deprecated this.
>>
>> Opinions? :)
> 
> While the MAC option doesn't look too bad to me, I can't help but feel
> that we're working around a kernel (mis)feature, which is something
> that's risky and tends to backfire.

Which misfeature do you mean exactly?  That you can open arbitrary files 
by specifying the right magic number (i.e. its handle)?

That in itself is nothing we’re really working around, but rather 
something that we actively want to pass through to the guest.

If you mean the part of that feature where you can’t really find out the 
path to a file opened this way, well...  I’d say it’s kind of the point, 
really, because the handle is supposed to be independent of the path, as 
evidenced by the trouble NFS seemed to have with subtree_check.

> It also worries me the fact that
> we'd need to run virtiofsd with CAP_DAC_READ_SEARCH.

Well, to me it’s a decision the user needs to make, whether they want 
persistent file handles in the guest or not.

We could think about having an extra process that has 
CAP_DAC_READ_SEARCH and opens FDs for virtiofsd (doing the respective 
security checks), but I don’t know whether that would really be worth 
the effort.

> IIUC, we need this to avoid the need to keep an FD open for each entry
> that's in the Guest's lookup cache, which is something that's probably
> going to become a problem once we have dozens of virtiofsd instances
> servicing VMs on the same Host (BTW, this is already a problem on
> macOS, where the default *system-wide* NOFILE limit is a little over
> 10,000).

Regarding the use of file handles, I consider that a lower priority 
(because like you, I’m not sure file handles are the ideal solution for 
this).  The main priority right now would be to just get persistent file 
handles working in the guest.

Maybe having them working also helps with migration, but it’s entirely 
possible that there is no advantage in having file handles in the guest 
for migration and it’ll be sufficient to have them in virtiofsd.  We’ll see.

> Perhaps we should try to aim higher and propose some kernel
> extensions that would fit better our needs?

I believe we can try other ways than file handles to reduce the FD 
usage, and I believe we want to try other ways precisely because of the 
capability.  But I also think we want working file handles anyway, so 
solving the FD issue some other way won’t mean we don’t need working 
file handles.

Max

