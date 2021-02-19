Date: Fri, 19 Feb 2021 09:34:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210219143403.GA3270@redhat.com>
References: <20210217233046.81418-1-vgoyal@redhat.com> <87pn0wgtsx.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn0wgtsx.fsf@suse.de>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtiofsd: Add options to
	enable/disable posix acl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org

On Fri, Feb 19, 2021 at 11:50:54AM +0000, Luis Henriques wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Hi,
> >
> > This is V2 of the patches. Changes since v1 are.
> >
> > - Rebased on top of latest master.
> > - Took care of Miklos's comments to block acl xattrs if user
> >   explicitly disabled posix acl.
> >
> > Luis Henriques reported that fstest generic/099 fails with virtiofs.
> > Little debugging showed that we don't enable acl support. So this
> > patch series provides option to enable/disable posix acl support. By
> > default it is disabled.
> >
> > I have run blogbench and pjdfstests with posix acl enabled and
> > things work fine.
> >
> > Luis, can you please apply these patches, and run virtiofsd with
> > "-o posix_acl" and see if it fixes the failure you are seeing. I
> > ran the steps you provided manually and it fixes the issue for
> > me.
> 
> Sorry for the delay.  I've finally tested these patches and they indeed
> fix the problem I reported.  My only question about this fix is why is
> this option not enabled by default, since this is the documented behavior
> in acl(5) and umask(2)?  In fact, why is this an option at all? 

You mean why to not enable acl by default?

I am concerned about performance drop this can lead to because extra
GETXATTR(system.posix_acl_*) messages which will trigger if acls are enabled.
And not all users might require these. That's why I preferred to not enable
acl by default. Those who need it can enable it explicitly.

Another example is xattr support. Due to performance concerns, we don't
enable xattrs by default either.

Thanks
Vivek

