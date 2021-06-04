Date: Fri, 4 Jun 2021 09:16:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210604131638.GA269481@redhat.com>
References: <Mb7HI6c--3-2@tutanota.com>
	<CAJFHJrpEKH_gDz=CpEG=Sy2v-pXe_VoHsX3AJ2FFM7Njh0w0DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrpEKH_gDz=CpEG=Sy2v-pXe_VoHsX3AJ2FFM7Njh0w0DA@mail.gmail.com>
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

On Wed, Jun 02, 2021 at 05:32:49PM +0900, Chirantan Ekbote wrote:
> On Wed, Jun 2, 2021 at 1:01 AM <tecufanujacu@tutanota.com> wrote:
> >
> > Hello to everyone,
> >
> > I'm trying virtiofsd with proxmox from few weeks and I noticed a problem, virtiofsd doesn't garant write access at users allowed by group permission.
> >
> > The virtiofsd bin included in proxmox is v 7.32, but I have also tested the bins compiled from source from stable branch (v7.27) and dev branch (v7.33), and I also have tested the bin virtiofsd-rs. Always same problem.
> >
> > I opened an issue on gitlab and I asked in the proxmox forum but with almost zero interaction. Seems to me that virtiofsd isn't a lot used. Someone suggested me to write in the mailinglist for these technical things and here I am.
> >
> > To better make understand what problem I'm noticing I link the issue opened in the gitlab in which I have reported a lot of useful info and logs with a good formatting:
> > https://gitlab.com/qemu-project/qemu/-/issues/368
> >
> > To me seems really strange what is happening, am I doing some error or this really is a virtiofsd bug?
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

Hi Chirantan,

Thanks for the updating us with all the work you have already done to
tackle this issue. 

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

For the short term fix, this solution sounds reasonable. Only reason
we are swtiching to uid/gid of caller is not because of any permission
checks but to make sure new file is created with caller as owner (and
not root as owner). Permission checks are supposed to be done in
client. So if we set SECBIT_NO_SETUID_FIXUP securebit flag and
retain CAP_DAC_OVERRIDE after switching uid/gid, that should do it.

We still run in init_user_ns and already give CAP_DAC_OVERRIDE. man
says setting securebit flag requires CAP_SETPCAP. We don't give this
capability to daemon as of now. Looks like we will have to add it.

I do want to play with running virtiofsd in user namespace. I think
one of the problem still is who is going to choose the uid/gid range
for virtiofsd and make sure there are no conflicts with other
daemons. Also this will need support for changing uid/gids of files
according to mapping (Or now use idmapped mount support).

> 
> I guess a third option is to change the fuse protocol so that it also
> includes the supplementary groups of the calling process.  Then the
> server can also set its supplementary groups the same way before
> making the syscall.  Merging the necessary changes into the kernel is
> left as an exercise for the reader ;-)

This definitely sounds like a more long term solution to the problem.
Carry all supplemental group membership id in fuse message. Not sure
how much work this is.

Cc Miklos. He might have more thoughts on this.

Thanks
Vivek

> 
> 
> Chirantan
> 
> [1]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2217534
> [2]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2253493
> [3]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2260253
> [4]: https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/2684067
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

