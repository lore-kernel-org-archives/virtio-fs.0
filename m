From: Laszlo Ersek <lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
	<20201216211125.19496-43-lersek@redhat.com>
	<f2f96f90-6d81-ae05-0986-15b4f08e6b7b@arm.com>
	<edc5fedc-0723-370c-c827-eff36bb42fb4@redhat.com>
Message-ID: <7083dc33-ae05-105c-5784-de24c1818cdf@redhat.com>
Date: Sat, 19 Dec 2020 23:54:47 +0100
MIME-Version: 1.0
In-Reply-To: <edc5fedc-0723-370c-c827-eff36bb42fb4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [edk2 PATCH 42/48] OvmfPkg/VirtioFsDxe: add helper
 for composing rename/move destination path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ard Biesheuvel <ard.biesheuvel@arm.com>, devel@edk2.groups.io, virtio-fs@redhat.com
Cc: Jordan Justen <jordan.l.justen@intel.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>

On 12/19/20 23:40, Laszlo Ersek wrote:
> On 12/18/20 18:39, Ard Biesheuvel wrote:
>> On 12/16/20 10:11 PM, Laszlo Ersek wrote:
>>> The EFI_FILE_PROTOCOL.SetInfo() member is somewhat under-specified; one of
>>> its modes of operation is renaming/moving the file.
>>>
>>> In order to create the destination pathname in canonical format, 2*2=4
>>> cases have to be considered. For the sake of discussion, assume the
>>> current canonical pathname of a VIRTIO_FS_FILE is "/home/user/f1.txt".
>>> Then, consider the following rename/move requests from
>>> EFI_FILE_PROTOCOL.SetInfo():
>>>
>>>   Destination requested  Destination  Move into   Destination in
>>>   by SetInfo()           relative?    directory?  canonical format
>>>   ---------------------  -----------  ----------  -----------------------
>>>   L"\\dir\\f2.txt"       no           no          "/dir/f2.txt"
>>
>> What happens in the above case if /dir/f2.txt is an existing directory?
> 
> 
> Short answer:
> 
> The present patch only constructs the destination pathname. The rename
> attempt you describe is caught
> 
> - either by the subsequent patch, if the existing dest directory is open
>   by the guest driver,
> 
> - or else, by the host kernel, due to the RENAME_NOREPLACE flag set in
>   the patch before this one.

... I'm sorry, I need to correct a bit: the guest-side check I quoted
below is not meant to protect from the destination being overwritten, it
is supposed to protect against the *source disappearing* (and against
breaking other VIRTIO_FS_FILEs' canonical pathnames due to that). So,
the answer to your question is: it is caught by RENAME_NOREPLACE.

Everything else I said stands, it's just that the particular guest-side
check is related to a different question -- namely, "what if
'/home/user/f1.txt' is a directory".

Thanks, and sorry about the confusion,
Laszlo


> Long (very long) answer, in opposite order of the above cases:
> 
> - If "/dir/f2.txt" were an existing name (regardless of the type of the
>   host-side inode that it referred to), then the FUSE_RENAME2 request
>   would fail: the host kernel would reject the renameat2() system call
>   made by virtiofsd. This would be due to the RENAME_NOREPLACE flag:
> 
>     https://man7.org/linux/man-pages/man2/rename.2.html
>     include/uapi/linux/fs.h
> 
>   which is set in
> 
>     [edk2 PATCH 41/48]
>     OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_RENAME2
> 
>   using the macro name VIRTIO_FS_FUSE_RENAME2_REQ_F_NOREPLACE.
> 
>   Thus, if the request reached the host kernel, an -EEXIST errno would
>   come back to the guest driver.
> 
> (
> 
> - If the movement source were a non-directory and the destination were a
>   directory, then that would fail (also in the host kernel at the
>   latest) even with the simpler (flag-less) FUSE_RENAME request, which
>   virtiofsd translates to the renameat() syscall, with -EISDIR.
> 
> - If both source and destination were directories, and the destination
>   were not empty, then even the flag-less renameat() would fail with
>   -ENOTEMPTY.
> 
> - If both source and destination were directories, and the destination
>   were empty, then renameat() would replace the destination [*]; but
>   renameat2() with RENAME_NOREPLACE will not.
> 
>   [*] mkdir source-dir target-dir
>       ls -lid source-dir target-dir
>       touch source-dir/file.txt
>       mv -T source-dir target-dir
>       ls -lid target-dir
>       ls -l target-dir/file.txt
> 
> )
> 
> 
> Then, in addition to RENAME_NOREPLACE, there's a guest-side check in
> 
>   [edk2 PATCH 43/48]
>   OvmfPkg/VirtioFsDxe: handle file rename/move in EFI_FILE_PROTOCOL.SetInfo
> 
> that was inspired by "FatPkg/EnhancedFatDxe". Namely:
> 
>> +  //
>> +  // Check if the rename would break the canonical pathnames of other
>> +  // VIRTIO_FS_FILE instances of the same VIRTIO_FS.
>> +  //
>> +  if (VirtioFsFile->IsDirectory) {
>> +    UINTN      PathLen;
>> +    LIST_ENTRY *OpenFilesEntry;
>> +
>> +    PathLen = AsciiStrLen (VirtioFsFile->CanonicalPathname);
>> +    BASE_LIST_FOR_EACH (OpenFilesEntry, &VirtioFs->OpenFiles) {
>> +      VIRTIO_FS_FILE *OtherFile;
>> +
>> +      OtherFile = VIRTIO_FS_FILE_FROM_OPEN_FILES_ENTRY (OpenFilesEntry);
>> +      if (OtherFile != VirtioFsFile &&
>> +          AsciiStrnCmp (VirtioFsFile->CanonicalPathname,
>> +            OtherFile->CanonicalPathname, PathLen) == 0 &&
>> +          (OtherFile->CanonicalPathname[PathLen] == '\0' ||
>> +           OtherFile->CanonicalPathname[PathLen] == '/')) {
>> +        //
>> +        // OtherFile refers to the same directory as VirtioFsFile, or is a
>> +        // (possibly indirect) child of the directory referred to by
>> +        // VirtioFsFile.
>> +        //
>> +        Status = EFI_ACCESS_DENIED;
>> +        goto FreeDestination;
>> +      }
>> +    }
>> +  }
> 
> This is why "VIRTIO_FS.OpenFiles" is a list, and not just a reference
> count -- for this simple guest-side check, I needed to go through the
> other open VIRTIO_FS_FILEs for the same VIRTIO_FS one by one. Just
> knowing how many of them existed wouldn't be enough.
> 
> This guest-side check is by no means foolproof; after all, you can do
> whatever you want on the host side, underneath the guest driver's feet.
> 
> But, catching such "async tricks" is not a goal for this driver.
> EFI_FILE_PROTOCOL is not equipped to deal with such async changes by
> design. At best, it can return EFI_MEDIA_CHANGED, when (e.g.) removable
> media is replaced. But even if I could detect such a situation in the
> virtio-fs driver, it would be counter-productive: when a host-side file
> changes, that's something the guest wants to pick up one way or another,
> we don't want the driver to switch to returning EFI_MEDIA_CHANGED for
> all further requests indiscriminately.
> 
> Synchronization between host and guest is pretty simple for the
> interactive use case: whenever your shell prompt returns, on the host or
> in the guest (meaning the UEFI shell prompt in the latter), you can
> Alt-TAB to the other terminal, and manipulate files from there.
> 
> Synchronization between host-side and guest-side scripts should be
> possible with polling directory listings, and renaming / moving regular
> files (files should be prepared in "private" directories, and then moved
> into place when done, for the other side to notice).
> 
> So, the above guest-side check exists for the usual case when the
> relevant sub-hierarchy of the shared directory doesn't change
> asynchronously to VIRTIO_FS_FILE's being open; when the guest-side check
> fires in this optimistic situation, the FUSE_RENAME2 request isn't even
> sent. And for when the guest-side check isn't good enough, that's when
> the RENAME_NOREPLACE flag becomes relevant -- I wanted to avoid
> unwittingly deleting entries in the shared directory by guest-initiated
> renames.
> 
> Sorry about the long answer. I feel it's not really possible to address
> your question without talking about asynchrony between host and guest. I
> had thought about it before, and I figured, shoehorning a shared
> filesystem into a non-shared filesystem abstraction should be acceptable
> this way. The use case is to support Alt-TABbing between your guest and
> host terminals, and running such UEFI unit tests in the guest that take
> input from the host filesystem and produce output to the host
> filesystem. A highly async / parallel operation is a non-goal.
> 
> Thanks!
> Laszlo

