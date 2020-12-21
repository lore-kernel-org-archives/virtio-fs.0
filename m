References: <20201216211125.19496-1-lersek@redhat.com>
	<f307b0a1-a885-4379-15f3-a3ac1a5f2a5d@arm.com>
	<5f75d127-a110-f256-19ad-4aa120332d6c@redhat.com>
	<7d1d4694-8fe2-7a63-7679-a6c0a0287113@arm.com>
	<dc5a7c47-8a9d-1f88-107e-7c3a483d5c91@redhat.com>
From: Ard Biesheuvel <ard.biesheuvel@arm.com>
Message-ID: <ba471de0-0744-9d65-2107-29471ddc8d20@arm.com>
Date: Mon, 21 Dec 2020 11:10:12 +0100
MIME-Version: 1.0
In-Reply-To: <dc5a7c47-8a9d-1f88-107e-7c3a483d5c91@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [edk2 PATCH 00/48] ArmVirtPkg,
	OvmfPkg: virtio filesystem driver
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>, devel@edk2.groups.io, virtio-fs@redhat.com
Cc: Jordan Justen <jordan.l.justen@intel.com>, Leif Lindholm <leif@nuviainc.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>

On 12/21/20 2:46 AM, Laszlo Ersek wrote:
> On 12/20/20 11:15, Ard Biesheuvel wrote:
>> On 12/20/20 1:09 AM, Laszlo Ersek wrote:
> 
>>> The only thing I couldn't test that way was (obviously) building on
>>> Windows. So clearly now that I've tried merging the series at
>>> <https://github.com/tianocore/edk2/pull/1248>, that's what fails.
>>> Because, this is the first time that EmbeddedPkg/TimeBaseLib is seen
>>> by the Visual Studio compiler, and Visual Studio complains:
>>>
>>>> ERROR - Compiler #2220 from
>>>> d:\a\1\s\EmbeddedPkg\Library\TimeBaseLib\TimeBaseLib.c(111):   the
>>>> following warning is treated as an error
>>>> WARNING - Compiler #4244 from
>>>> d:\a\1\s\EmbeddedPkg\Library\TimeBaseLib\TimeBaseLib.c(111):   '=':
>>>> conversion from 'UINTN' to 'UINT32', possible loss of data
>>>
>>> It happens to be correct:
>>>
>>>     99  /**
>>>    100    Converts EFI_TIME to Epoch seconds (elapsed since 1970 JANUARY 01, 00:00:00 UTC)
>>>    101   **/
>>>    102  UINT32
>>>    103  EFIAPI
>>>    104  EfiTimeToEpoch (
>>>    105    IN  EFI_TIME  *Time
>>>    106    )
>>>    107  {
>>>    108    UINT32 EpochDays;   // Number of days elapsed since EPOCH_JULIAN_DAY
>>>    109    UINT32 EpochSeconds;
>>>    110
>>>    111    EpochDays = EfiGetEpochDays (Time);
>>>    112
>>>    113    EpochSeconds = (EpochDays * SEC_PER_DAY) + ((UINTN)Time->Hour * SEC_PER_HOUR) + (Time->Minute * SEC_PER_MIN) + Time->Second;
>>>    114
>>>    115    return EpochSeconds;
>>>    116  }
>>>
>>> This was discussed on the list earlier, when the function was duplicated
>>> for the HTTP dynamic command:
>>>
>>> - https://edk2.groups.io/g/devel/message/64933
>>> - https://edk2.groups.io/g/devel/message/65186
>>>
>>> Compare EfiTimeToEpoch() in
>>> "ShellPkg/DynamicCommand/HttpDynamicCommand/Http.c".
>>>
>>>    430  STATIC
>>>    431  UINTN
>>>    432  EFIAPI
>>>    433  EfiTimeToEpoch (
>>>    434    IN  EFI_TIME  *Time
>>>    435    )
>>>    436  {
>>>    437    //
>>>    438    // Number of days elapsed since EPOCH_JULIAN_DAY.
>>>    439    //
>>>    440    UINTN EpochDays;
>>>    441    UINTN EpochSeconds;
>>>    442
>>>    443    EpochDays = EfiGetEpochDays (Time);
>>>    444
>>>    445    EpochSeconds = (EpochDays * SEC_PER_DAY) +
>>>    446                   ((UINTN)Time->Hour * SEC_PER_HOUR) +
>>>    447                   (Time->Minute * SEC_PER_MIN) + Time->Second;
>>>    448
>>>    449    return EpochSeconds;
>>>    450  }
>>>
>>> So, in order to merge this series, I'll first have to fix
>>> EfiTimeToEpoch() in EmbeddedPkg :(
>>>
>>> I wish the fixed version in
>>> "ShellPkg/DynamicCommand/HttpDynamicCommand/Http.c" had been contributed
>>> back to EmbeddedPkg.
>>>
>>> Anyway, that is for 2021.
> 
> (given the fantastic opportunities provided by the COVID-19 pandemic, to
> catch up with family and friends around Christmas /s, I might as well
> treat the discussion of this patch series during my PTO as something
> welcome that takes my mind off of how much I miss the people I can't
> meet this year)
> 
>> Thanks for clearing up the outstanding questions.
>>
>> For the EmbeddedPkg change from UINT32 to UINTN
>>
>> Acked-by: Ard Biesheuvel <ard.biesheuvel@arm.com>
>>
>> although I suppose you will have to preserve the prototype, so adding
>> a (UINT32) cast to line 111 is probably the best approach here.
> 
> I ended up installing a brand new Windows 10 + VS2019 virtual machine,
> as I got fed up with the nasty surprises in the PRs (and I refuse to
> publish my work-in-progress branch just for the sake of setting off CI
> on it).
> 
> Two consequences:
> 
> (1) I'll squash the following trivial updates into two of the patches,
> for my next merge request attempt:
> 
>  5:  bb254f89067a !  7:  17a76bbec317 OvmfPkg/VirtioFsDxe: add a scatter-gather list data type
>     @@ -20,6 +20,8 @@
>          Signed-off-by: Laszlo Ersek <lersek@redhat.com>
>          Message-Id: <20201216211125.19496-6-lersek@redhat.com>
>          Acked-by: Ard Biesheuvel <ard.biesheuvel@arm.com>
>     +    [lersek@redhat.com: suppress useless VS2019 warning about signed/unsigned
>     +     comparison in VirtioFsSgListsValidate()]
> 
>      diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
>      --- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
>     @@ -213,7 +215,7 @@
>      +    // can be added to the virtio queue, after the other descriptors added
>      +    // previously.
>      +    //
>     -+    if (SgList->NumVec > MAX_UINT16 - DescriptorsNeeded ||
>     ++    if (SgList->NumVec > (UINTN)(MAX_UINT16 - DescriptorsNeeded) ||
>      +        DescriptorsNeeded + SgList->NumVec > VirtioFs->QueueSize) {
>      +      return EFI_UNSUPPORTED;
>      +    }
> 
> and
> 
> 46:  4f42ecc2d9bb ! 48:  b807d3c0b54b OvmfPkg/VirtioFsDxe: add helper for determining access time updates
>     @@ -12,6 +12,8 @@
>          Signed-off-by: Laszlo Ersek <lersek@redhat.com>
>          Message-Id: <20201216211125.19496-47-lersek@redhat.com>
>          Acked-by: Ard Biesheuvel <ard.biesheuvel@arm.com>
>     +    [lersek@redhat.com: suppress bogus VS2019 warning about lack of
>     +     initialization for ZeroTime]
> 
>      diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
>      --- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
>     @@ -92,7 +94,7 @@
>      +  EFI_TIME              *Time[3];
>      +  EFI_TIME              *NewTime[ARRAY_SIZE (Time)];
>      +  UINTN                 Idx;
>     -+  STATIC CONST EFI_TIME ZeroTime;
>     ++  STATIC CONST EFI_TIME ZeroTime = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
>      +  BOOLEAN               Change[ARRAY_SIZE (Time)];
>      +  UINT64                Seconds[ARRAY_SIZE (Time)];
>      +
> 
> (2) I've written three patches in total for fixing EfiTimeToEpoch(),
> including the prototype:
> 
> (2a) edk2-platforms:
> 
>   1  Silicon/Marvell/RealTimeClockLib: make EpochSeconds, WakeupSeconds UINTN
> 
>      Silicon/Marvell/Armada7k8k/Library/RealTimeClockLib/RealTimeClockLib.c | 14 ++++++++++----
>      1 file changed, 10 insertions(+), 4 deletions(-)
> 
> (other RealTimeClockLib instances / EfiTimeToEpoch() callers in
> edk2-platforms need no updates; furthermore, edk2-non-osi contains no
> EfiTimeToEpoch() calls at all)
> 
> (2b) edk2:
> 
>   1  ArmPlatformPkg/PL031RealTimeClockLib: cast EfiTimeToEpoch() val. to UINT32
> 
>      ArmPlatformPkg/Library/PL031RealTimeClockLib/PL031RealTimeClockLib.c | 2 +-
>      1 file changed, 1 insertion(+), 1 deletion(-)
> 
>   2  EmbeddedPkg/TimeBaseLib: remove useless truncation to 32-bit
> 
>      EmbeddedPkg/Include/Library/TimeBaseLib.h     | 2 +-
>      EmbeddedPkg/Library/TimeBaseLib/TimeBaseLib.c | 6 +++---
>      2 files changed, 4 insertions(+), 4 deletions(-)
> 
> If you're reading this before 2021, please let me know if you'd tolerate
> receiving these patches for approval still in 2020. (The edk2-platforms
> patch theoretically belongs to Leif and Marcin, but if Leif has stopped
> consuming work email (which we all should have by now, I guess...), then
> I believe you could ACK that patch in Leif's stead.)
> 

No problem.

-- 
Ard.

