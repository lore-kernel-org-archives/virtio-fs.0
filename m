DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:references:from:subject:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=4HUPvdqM90ksyTXbMSZtNAz+3Gtxp4GXVHhpBB7Jn6o=;
	b=CN+mvFKKsB3K6pN1/dReYyZeAvnofOuAc+w03y7yYkARt13qkoGjyCZpFLlVrsSLd6
	3Uq8fgMGc8Ga4Id6XYkf9MTmbnMYJ5aRXOhL+miEtAmXrp63ouxw7vlruX5ueMc5BE81
	6sFolZy5ByD00uiFfIaO+xLy2Hv/bXmiPwB1WRApYZ5tMIRdu+nnFZugLMIP3DMTdUtc
	MAocTrqmdovd0pmzGkpX8IJMbWlorE/1ojUrAH5G51MitG5fwA0OF8u1TKD8ggNXEiTu
	QHXMtEdKqUUEud/p68A0e0mxHt+rxiiHJ/ZKamlEoCrAlNe7xj+ACrzadjr5pglOnVJA
	2LzA==
References: <CAFqZXNsGabHBfV36nNAVLJgEzjkBev-O3YZ1vnmXyVoaDdjiHQ@mail.gmail.com>
	<CAHC9VhRCu5W4YOzcidUhv7biVc+a4QrRknVn-57YVSM3vWZH+Q@mail.gmail.com>
	<20201207205209.GD3107@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <0d6f34cf-e28e-0035-2c97-4ce8f76e7ef7@gmail.com>
Date: Mon, 7 Dec 2020 15:06:07 -0600
MIME-Version: 1.0
In-Reply-To: <20201207205209.GD3107@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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
To: virtio-fs@redhat.com


On 12/7/20 2:52 PM, Vivek Goyal wrote:
> On Mon, Dec 07, 2020 at 10:03:24AM -0500, Paul Moore wrote:
>> On Mon, Dec 7, 2020 at 9:43 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>>> Hi everyone,
>>>
>>> In [1] we ran into a problem with the current handling of filesystem
>>> labeling rules. Basically, it is only possible to specify either
>>> genfscon or fs_use_xattr for a given filesystem, but in the case of
>>> virtiofs, certain mounts may support security xattrs, while other ones
>>> may not.
> [ cc virtio-fs list and miklos ]
>> Quickly skimming the linked GH issue, it appears that the problem
>> really lies in the fact that virtiofs allows one to enable/disable
>> xattrs at mount time.  What isn't clear to me is why one would need to
>> disable xattrs, can you explain that use case?  Why does enabling
>> xattrs in virtiofs cause problems?
> Its not exactly a mount time option. Its a virtiofs file server option.
>
> xattr support by default is disabled because it has performance
> penalty. Users can enable it if they want to.
>
> So if virtiofsd starts without xattr support and somebody runs a
> VM with SELinux enabled, they should still be able to mount virtiofs,
> I guess (instead of failing it).

I think the earlier virtio mount docs permitted an immutable SElinux
spec for everything in a virtiofs mount , whether or not the the
underlying host had xattrs enabled.  Should the mount fail or should
there be a default SELinux spec for the case there are no xattrs in the
host and SELinux is running?   There's a question for which good
arguments exist on both sides.    Case:  I installed a package that had
'restorecon' commands in the install script, but that otherwise
presupposed no SELinux awareness on the user's part.   All the 'I want
it to just work' users saw was a failed package installation.  The post
of a bug to the package maintainers, who then post a bug to the selinux
devs. The SELinux support folks all say 'well it worked for us', and all
the virtiofs users running on xattr enabled hosts 'see no problem'. 
Prevent that frustration:  it's better to fail at mount time on the
guest if selinux is enabled on the guest, xattrs and are not available
in the host, with a very visible 'do this to fix it' error message. 
That way you generate awareness of a 'selinux issue' before it's a mystery.


Harry




