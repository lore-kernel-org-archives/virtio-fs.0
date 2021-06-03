DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:cc:references:from:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=fcPPrXjWwpiVtspPJ6xD6pkPja3x8jzHZWjndhWNiGg=;
	b=mpsawx8rZY2qiw7bPTHySj/8a36nGOLSQQrfynYGudBmgKhcnMik79Mgz+n+hzXKEj
	J/XlFEMIlG6n7VgeDuENiXyFlG/8His1Dw/LnfOCkJ0r4eM+X1U5DCEBEmOtclpyjgY7
	7SgPer8y/qDfKRbnpTeEciqQREmReqI6FNi76jgHNfQksgztz+QfPYnHVvRcBqDnwthg
	zS1+vKqSVw2SxGZczT33VyzFO/dEg/bi3d+29R5t5KHCCIDONrMN0mWnA4gAEBzKKztd
	5CBjPlXHfY6Q6x4gQ4gyLcmstn5HzY0RyWroXTph90i3rngbnuFwXetHNk3EEx5x/RsW
	+dzw==
References: <e1437314-4870-a3a3-e866-8be50282ce3c@gmail.com>
	<20210601130245.GA24846@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <ad7ecf43-9b3b-d64e-8bab-c5a82a73ae76@gmail.com>
Date: Thu, 3 Jun 2021 12:58:37 -0500
MIME-Version: 1.0
In-Reply-To: <20210601130245.GA24846@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] regression: lsetfilecon fails, breaks rpm, dpkg,
 dnf in virtiofs guests.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Ondrej Mosnacek <omosnace@redhat.com>


On 6/1/21 8:02 AM, Vivek Goyal wrote:
> On Sat, May 29, 2021 at 01:42:50PM -0500, Harry G. Coin wrote:
>> Some regression in virtio-fs has led to rpm/dnf/yum failing  in the same
>> guest it previously worked.
>>
>> linux 5.11.19-300.fc34.x86_64
>>
>> Specifically, all attempts to use dnf/yum lead to examples similar to this:
>>
>> Error unpacking rpm package dnf-4.7.0-1.fc34.noarch
>>   Upgrading        :
>> python3-dnf-plugins-core-4.0.21-1.fc34.noarch                                                                                                                                                     
>> 8/20
>> error: unpacking of archive failed on file /usr/bin/dnf;60b1b277: cpio:
>> (error 0x2)
>> error: dnf-4.7.0-1.fc34.noarch: install failed
>> error: lsetfilecon: (/etc/dnf/plugins/copr.conf,
>> system_u:object_r:etc_t:s0) Operation not permitted
>> error: Plugin selinux: hook fsm_file_prepare failed
> CCing Dan Walsh and Ondrej. They might have an idea.
>
> Thanks
> Vivek
>
>> (
>>
>> For all packages.  No updates are possible.  Possibly related to:
>> https://github.com/fedora-selinux/selinux-policy/pull/478/files/21a2df26cd605c55de7edc80e16907fcb76ccf08 
>> ?  What really gets me, is this error exists even though
>>
>> # getenforce
>> Permissive
>>
>> )
>>
>> The host is running btrfs.  ... virtiofsd --fd=50 -o
>> source=/vmsystems/fedora_generic,xattr,flock,posix_lock
>>
>> same effect with  .... virtiofsd --fd=36 -o
>> source=/vmsystems/dbl1,xattr,flock,no_posix_lock
>>
>> /etc/fstab:
>>
>> myfs / virtiofs seclabel 0 0



Here's a reproducer:

[root@registry1 ~]# getenforce

Permissive
[root@registry1 ~]# cat lsetfilecon.c
#include <selinux/selinux.h>
#include <stdio.h>
#include <errno.h>
 void perror(const char *s);

int main(int argc,char *argv[]){
  int i;
  i= lsetfilecon("/usr/bin/rngtest","system_u:object_r:bin_t:s0");
  //i=
lsetfilecon("/usr/bin/rngtest;60b9120b","system_u:object_r:bin_t:s0");
  printf("ret %lx\n",i);
  perror("\n");
  return 0;
}

[root@registry1 ~]# gcc lsetfilecon.c -lselinux -o lsetfilecon
[root@registry1 ~]# ./lsetfilecon
ret ffffffff

: Operation not permitted
[root@registry1 ~]# ls -l /usr/bin/rngtest
-rwxr-xr-x. 1 root root 21176 Apr 27 18:26 /usr/bin/rngtest

[root@registry1 ~]# uname -a
Linux registry1.xxxx 5.11.19-300.fc34.x86_64 #1 SMP Fri May 7 14:17:15
UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

On the host:


root@noc1:/vmsystems/registry1/usr/bin# getfattr -m - -d rngtest
# file: rngtest
security.selinux="system_u:object_r:bin_t:s0"

ls -l rngtest
-rwxr-xr-x. 1 root root 21176 Apr 27 18:26 rngtest


