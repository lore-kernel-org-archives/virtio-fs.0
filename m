DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1622831430; 
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=GRnGcVqClqlshFLP45iUfUskDNNYqVoywXjKLvek7Mk=;
	b=DGolW2xwgAB9iODmic/MlWehuSJ9Vq8zyTU+g9nZzDHKG08Y/exrmqYgqclKu7IS
	jcFzNArqkrkdc9HxF9SYWOGvZM6NIdT0rbue9wOiPMvimMkZl06nJ2ifJsNmmD1HsQz
	i6Vr2Y1l6kHhXI0yRHjWqzWIlLxXkqTJLOh2LmdBoiVX+HW6wpTtEVs60QFh//cyuF/
	T8I5F6O77A3YQ0Uijg1BDOaOLvNFERZqbcbuVh5pu9YbHDLRJWxq04PbYxb4/QzYMDm
	w8BStcCt1W9TNp3e0zi3ZnPfyUr/xk4NaeyFbVMY6YwgGi54v7NpKJrAjhU5kYoFYsT
	c5m2cMm6WQ==
Date: Fri, 4 Jun 2021 20:30:30 +0200 (CEST)
From: tecufanujacu@tutanota.com
Message-ID: <MbNHbdZ--3-2@tutanota.com>
In-Reply-To: <CAJFHJrpEKH_gDz=CpEG=Sy2v-pXe_VoHsX3AJ2FFM7Njh0w0DA@mail.gmail.com>
References: <Mb7HI6c--3-2@tutanota.com>
	<CAJFHJrpEKH_gDz=CpEG=Sy2v-pXe_VoHsX3AJ2FFM7Njh0w0DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/alternative; 
	boundary="----=_Part_85402_1406358136.1622831430624"
Subject: Re: [Virtio-fs] virtiofsd: doesn't garant write access at users
 allowed by group permission
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>

------=_Part_85402_1406358136.1622831430624
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks for this great explanation, now everything is more clear to me.

Basically this problem happens every time there is permissions configuration just a little bit more advanced and at the moment there isn't an on the fly solution that doesn't need kernel patching and recompiling.

Good to know.


2 giu 2021, 10:32 da chirantan@chromium.org:

> On Wed, Jun 2, 2021 at 1:01 AM <tecufanujacu@tutanota.com> wrote:
>
>>
>> Hello to everyone,
>>
>> I'm trying virtiofsd with proxmox from few weeks and I noticed a problem, virtiofsd doesn't garant write access at users allowed by group permission.
>>
>> The virtiofsd bin included in proxmox is v 7.32, but I have also tested the bins compiled from source from stable branch (v7.27) and dev branch (v7.33), and I also have tested the bin virtiofsd-rs. Always same problem.
>>
>> I opened an issue on gitlab and I asked in the proxmox forum but with almost zero interaction. Seems to me that virtiofsd isn't a lot used. Someone suggested me to write in the mailinglist for these technical things and here I am.
>>
>> To better make understand what problem I'm noticing I link the issue opened in the gitlab in which I have reported a lot of useful info and logs with a good formatting:
>> https://gitlab.com/qemu-project/qemu/-/issues/368
>>
>> To me seems really strange what is happening, am I doing some error or this really is a virtiofsd bug?
>>
>
> I'm pretty sure this is a virtiofsd issue because we ran into the same
> problem on crosvm.  The issue is that the server changes its uid/gid
> to the uid/gid in the fuse context before making the syscall.  This
> ensures that the file/directory appears atomically with the correct
> metadata.  However, this causes an EACCES error when the following
> conditions are
> met:
>
> * The parent directory has g+rw permissions with gid A
> * The process has gid B but has A in its list of supplementary groups
>
> In this case the fuse context only contains gid B, which doesn't have
> permission to modify the parent directory.
>
> There are a couple of ways to fix this problem:
>
> The first one we tried was to split file/directory creation into 2
> stages [1].  Basically for files we first create a temporary with
> O_TMPFILE and then initialize the metadata before linking it into the
> directory tree.  The main issue with this is that we're duplicating
> the work that kernel already does on open and turning a single syscall
> in the VM into several syscalls on the host, which adds a significant
> amount of latency.  You also have to deal with a bunch of esoteric
> corner cases for file systems that the kernel would normally just
> handle automatically [2][3].  For directories, there is no O_TMPFILE
> equivalent so we had to do a gross hack of creating a directory with a
> random name and then renaming it to the correct one once all the
> metadata was properly initialized.  In theory you could create the
> directory in a separate "work dir" first but you have to be careful if
> the original directory uses selinux.  From what I understand, rename
> preserves the security context so to ensure the security context is
> properly inherited from the parent directory you need to create a new
> directory anyway.  Or figure out what the correct context should be
> and set it in the work dir before the rename.
>
> The second solution, which is also what we're using now, is to set the
> SECBIT_NO_SETUID_FIXUP flag.  This flag prevents the kernel from
> dropping caps when the process changes its uid/gid so the permission
> checks are skipped as long as the server has the appropriate
> capabilities (CAP_DAC_OVERRIDE, I think?).  Doing this lets us drop
> all the special handling code and just go back to making a single
> syscall and letting the kernel figure out the rest [4].  The crosvm fs
> device always runs as root in a user namespace with the proper caps so
> this works for us but obviously will not work if virtiofsd doesn't
> have the caps to begin with.  At that point the first option may be
> the only choice.
>
> I guess a third option is to change the fuse protocol so that it also
> includes the supplementary groups of the calling process.  Then the
> server can also set its supplementary groups the same way before
> making the syscall.  Merging the necessary changes into the kernel is
> left as an exercise for the reader ;-)
>
>
> Chirantan
>
> [1]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2217534
> [2]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2253493
> [3]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2260253
> [4]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2684067
>


------=_Part_85402_1406358136.1622831430624
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3DUTF-8=
">
  </head>
  <body>
<div>Thanks for this great explanation, now everything is more clear to me.=
<br></div><div dir=3D"auto"><br></div><div dir=3D"auto">Basically this prob=
lem happens every time there is permissions configuration just a little bit=
 more advanced and at the moment there isn't an on the fly solution that do=
esn't need kernel patching and recompiling.<br></div><div dir=3D"auto"><br>=
</div><div dir=3D"auto">Good to know.<br></div><div><br></div><div><br></di=
v><div>2 giu 2021, 10:32 da chirantan@chromium.org:<br></div><blockquote cl=
ass=3D"tutanota_quote" style=3D"border-left: 1px solid #93A3B8; padding-lef=
t: 10px; margin-left: 5px;"><div>On Wed, Jun 2, 2021 at 1:01 AM &lt;tecufan=
ujacu@tutanota.com&gt; wrote:<br></div><blockquote><div><br></div><div>Hell=
o to everyone,<br></div><div><br></div><div>I'm trying virtiofsd with proxm=
ox from few weeks and I noticed a problem, virtiofsd doesn't garant write a=
ccess at users allowed by group permission.<br></div><div><br></div><div>Th=
e virtiofsd bin included in proxmox is v 7.32, but I have also tested the b=
ins compiled from source from stable branch (v7.27) and dev branch (v7.33),=
 and I also have tested the bin virtiofsd-rs. Always same problem.<br></div=
><div><br></div><div>I opened an issue on gitlab and I asked in the proxmox=
 forum but with almost zero interaction. Seems to me that virtiofsd isn't a=
 lot used. Someone suggested me to write in the mailinglist for these techn=
ical things and here I am.<br></div><div><br></div><div>To better make unde=
rstand what problem I'm noticing I link the issue opened in the gitlab in w=
hich I have reported a lot of useful info and logs with a good formatting:<=
br></div><div>https://gitlab.com/qemu-project/qemu/-/issues/368<br></div><d=
iv><br></div><div>To me seems really strange what is happening, am I doing =
some error or this really is a virtiofsd bug?<br></div></blockquote><div><b=
r></div><div>I'm pretty sure this is a virtiofsd issue because we ran into =
the same<br></div><div>problem on crosvm.  The issue is that the server cha=
nges its uid/gid<br></div><div>to the uid/gid in the fuse context before ma=
king the syscall.  This<br></div><div>ensures that the file/directory appea=
rs atomically with the correct<br></div><div>metadata.  However, this cause=
s an EACCES error when the following<br></div><div>conditions are<br></div>=
<div>met:<br></div><div><br></div><div>* The parent directory has g+rw perm=
issions with gid A<br></div><div>* The process has gid B but has A in its l=
ist of supplementary groups<br></div><div><br></div><div>In this case the f=
use context only contains gid B, which doesn't have<br></div><div>permissio=
n to modify the parent directory.<br></div><div><br></div><div>There are a =
couple of ways to fix this problem:<br></div><div><br></div><div>The first =
one we tried was to split file/directory creation into 2<br></div><div>stag=
es [1].  Basically for files we first create a temporary with<br></div><div=
>O_TMPFILE and then initialize the metadata before linking it into the<br><=
/div><div>directory tree.  The main issue with this is that we're duplicati=
ng<br></div><div>the work that kernel already does on open and turning a si=
ngle syscall<br></div><div>in the VM into several syscalls on the host, whi=
ch adds a significant<br></div><div>amount of latency.  You also have to de=
al with a bunch of esoteric<br></div><div>corner cases for file systems tha=
t the kernel would normally just<br></div><div>handle automatically [2][3].=
  For directories, there is no O_TMPFILE<br></div><div>equivalent so we had=
 to do a gross hack of creating a directory with a<br></div><div>random nam=
e and then renaming it to the correct one once all the<br></div><div>metada=
ta was properly initialized.  In theory you could create the<br></div><div>=
directory in a separate "work dir" first but you have to be careful if<br><=
/div><div>the original directory uses selinux.  From what I understand, ren=
ame<br></div><div>preserves the security context so to ensure the security =
context is<br></div><div>properly inherited from the parent directory you n=
eed to create a new<br></div><div>directory anyway.  Or figure out what the=
 correct context should be<br></div><div>and set it in the work dir before =
the rename.<br></div><div><br></div><div>The second solution, which is also=
 what we're using now, is to set the<br></div><div>SECBIT_NO_SETUID_FIXUP f=
lag.  This flag prevents the kernel from<br></div><div>dropping caps when t=
he process changes its uid/gid so the permission<br></div><div>checks are s=
kipped as long as the server has the appropriate<br></div><div>capabilities=
 (CAP_DAC_OVERRIDE, I think?).  Doing this lets us drop<br></div><div>all t=
he special handling code and just go back to making a single<br></div><div>=
syscall and letting the kernel figure out the rest [4].  The crosvm fs<br><=
/div><div>device always runs as root in a user namespace with the proper ca=
ps so<br></div><div>this works for us but obviously will not work if virtio=
fsd doesn't<br></div><div>have the caps to begin with.  At that point the f=
irst option may be<br></div><div>the only choice.<br></div><div><br></div><=
div>I guess a third option is to change the fuse protocol so that it also<b=
r></div><div>includes the supplementary groups of the calling process.  The=
n the<br></div><div>server can also set its supplementary groups the same w=
ay before<br></div><div>making the syscall.  Merging the necessary changes =
into the kernel is<br></div><div>left as an exercise for the reader ;-)<br>=
</div><div><br></div><div><br></div><div>Chirantan<br></div><div><br></div>=
<div>[1]: https://chromium-review.googlesource.com/c/chromiumos/platform/cr=
osvm/+/2217534<br></div><div>[2]: https://chromium-review.googlesource.com/=
c/chromiumos/platform/crosvm/+/2253493<br></div><div>[3]: https://chromium-=
review.googlesource.com/c/chromiumos/platform/crosvm/+/2260253<br></div><di=
v>[4]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosv=
m/+/2684067<br></div></blockquote><div dir=3D"auto"><br></div>  </body>
</html>

------=_Part_85402_1406358136.1622831430624--

