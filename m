References: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
	<20210413140544.GD1235549@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <0985ca36-2ba5-9913-99a2-a887d0eb96d2@redhat.com>
Date: Tue, 13 Apr 2021 16:14:57 +0200
MIME-Version: 1.0
In-Reply-To: <20210413140544.GD1235549@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Current file handle status and open questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On 13.04.21 16:05, Vivek Goyal wrote:
> On Thu, Mar 18, 2021 at 06:09:58PM +0100, Max Reitz wrote:
>> Hi,
>>
>> As threatened in our last meeting, I’ve written this mail to give an
>> overview on where we stand with regards to virtiofsd(-rs) using file
>> handles.
>>
>> Technically, this should be a reply to the “Securint file handles”
>> thread, but this mail is so long I think it’s better to split it off.
>>
>> There are multiple problems that somehow relate to file handles, the
>> ones I’m aware of are:
>>
>> (A) We have a problem with too many FDs open.  To solve it, we could
>>      attach a file handle to each node, then close the FD (as far as
>>      possible) and reopen it when needed from the file handle.
>>
>> (B) We want to allow the guest to use persistent file handles.
>>
>> (C) For live migration, the problem isn’t even clear yet, but it seems
>>      like we’ll want to translate nodes into their file handles and
>>      transmit those and open them again on the destination (at least on
>>      shared filesystems).
>>
>> Now every case has its own specific tricky bits:
>>
>> Case (A) is something that we’d really like to have by default, and it
>> would need to work all the time during runtime.  So the problem here is
>> that we’d need CAP_DAC_READ_SEARCH, and we’d need it all the time, but
>> we don’t want that.  One interesting bit is that we don’t need these
>> file handles to be persistent between virtiofsd invocations.
> 
> Hi Max,
> 
> A question about CAP_DAC_READ_SEARCH. I get it that in long term we
> don't want it beacuse current limitation is that CAP_DAC_READ_SEARCH
> is needed in init_user_ns. And we want to run virtiofsd in user
> namespace and it will not have CAP_DAC_READ_SEARCH in init_user_ns.
> 
> But as of now we are running virtiofsd in init_user_ns
> CAP_DAC_READ_SEARCH.
> 
> So question is that if virtiofsd has CAP_DAC_READ_SEARCH, can we
> try to fall back to using name_to_handle_at()/open_by_handle_at()
> for lo_inode->fd. And this should help solve the problem
> A and C.
> 
> And once a solution comes along which does not require CAP_DAC_READ_SEARCH
> we could move to that. In fact virtiofsd probably will have to deal
> with both so that we could continue to work with older kernels.

For A, we basically don’t need to change anything regardless of whether 
(1) we have CAP_DAC_READ_SEARCH, or whether (2) we don’t have that 
capability, but the kernel supports MAC-ed file handles for that case.

When we want to replace lo_inode->fd, virtiofsd only generates file 
handles (and stores them instead of the fd) and opens them later (when 
the fd is needed), that’s it.  The only difference would be that it 
needs to pass a new flag (AT_HANDLE_MAC) when generating handles without 
CAP_DAC_READ_SEARCH.


And then we should be able to use those handles for live migration, too, 
yes.  As I said, I suppose perhaps we can just live with requiring 
CAP_DAC_READ_SEARCH during the initial phase.

Max

