DKIM-Filter: OpenDKIM Filter v2.11.0 agnus.defensec.nl 8AEE12A0065
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=defensec.nl;
	s=default; t=1607376175;
	bh=vfrDMTJG1ipDj0UWJdQMzuFQebhP2vkBljtUwSr5J68=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=JSWbPDsmALt0A9WMC1vfGcuncy6OnAYEyXAqbM65E/zbObT5yug5Gzn52U6toRW/6
	xC0WRLahpmvbe/isXzq3IFsEDWqx73hOaRFUqIWSs8Q2bEqldAvL9kKfuE+PUz5+Mo
	eT79LJ+d1jEeB+pbIp3NWwALEX5Qj33FCD247WC4=
From: Dominick Grift <dominick.grift@defensec.nl>
References: <CAFqZXNsGabHBfV36nNAVLJgEzjkBev-O3YZ1vnmXyVoaDdjiHQ@mail.gmail.com>
	<CAHC9VhRCu5W4YOzcidUhv7biVc+a4QrRknVn-57YVSM3vWZH+Q@mail.gmail.com>
	<20201207205209.GD3107@redhat.com>
Date: Mon, 07 Dec 2020 22:22:35 +0100
In-Reply-To: <20201207205209.GD3107@redhat.com> (Vivek Goyal's message of
	"Mon, 7 Dec 2020 15:52:09 -0500")
Message-ID: <ypjlczzlmhus.fsf@defensec.nl>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] virtiofs and its optional xattr support vs.
	fs_use_xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, SElinux list <selinux@vger.kernel.org>, Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Stephen, Zdenek Pytela <zpytela@redhat.com>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Dec 07, 2020 at 10:03:24AM -0500, Paul Moore wrote:
>> On Mon, Dec 7, 2020 at 9:43 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>> >
>> > Hi everyone,
>> >
>> > In [1] we ran into a problem with the current handling of filesystem
>> > labeling rules. Basically, it is only possible to specify either
>> > genfscon or fs_use_xattr for a given filesystem, but in the case of
>> > virtiofs, certain mounts may support security xattrs, while other ones
>> > may not.
>> 
>
> [ cc virtio-fs list and miklos ]
>> Quickly skimming the linked GH issue, it appears that the problem
>> really lies in the fact that virtiofs allows one to enable/disable
>> xattrs at mount time.  What isn't clear to me is why one would need to
>> disable xattrs, can you explain that use case?  Why does enabling
>> xattrs in virtiofs cause problems?
>
> Its not exactly a mount time option. Its a virtiofs file server option.
>
> xattr support by default is disabled because it has performance
> penalty. Users can enable it if they want to.

if SELinux is enabled then you should preferably just use fs_use xattr unconditionally

>
> So if virtiofsd starts without xattr support and somebody runs a
> VM with SELinux enabled, they should still be able to mount virtiofs,
> I guess (instead of failing it).

SELinux requires that everything is always labeled one way or another
and so if SELinux is enabled one should either use genfscon or fs_use xattr

Since is support fs_use xattr that should be the default and if any
would for any reason want to replace that with genfscon then that is
something they have to address (by excluding the fs_use xattr rule and
replacing it with a genfscon rule (not sure why anyone would ever want
that)

Gist is that if SELinux is enabled then one of the two should be
present, preferably fs_use xattr (so thats the default).

>
> Thanks
> Vivek
>

-- 
gpg --locate-keys dominick.grift@defensec.nl
Key fingerprint = FCD2 3660 5D6B 9D27 7FC6  E0FF DA7E 521F 10F6 4098
https://sks-keyservers.net/pks/lookup?op=get&search=0xDA7E521F10F64098
Dominick Grift

