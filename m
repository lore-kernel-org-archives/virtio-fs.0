Date: Mon, 2 Nov 2020 15:18:24 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20201102151824.GG138796@redhat.com>
References: <20201102150750.34565-1-dgilbert@redhat.com>
	<e1a007ed-7a9f-38cd-4003-144d0e99dd6e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1a007ed-7a9f-38cd-4003-144d0e99dd6e@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Seccomp: Add 'send' for syslog
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc: virtio-fs@redhat.com, amulmek1@in.ibm.com, qemu-devel@nongnu.org

On Mon, Nov 02, 2020 at 04:11:44PM +0100, Philippe Mathieu-Daudé wrote:
> On 11/2/20 4:07 PM, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > On ppc it looks like syslog ends up using 'send' rather than 'sendto'.
> > 
> > Reference: https://github.com/kata-containers/kata-containers/issues/1050
> > 
> > Reported-by: amulmek1@in.ibm.com
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_seccomp.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
> > index eb9af8265f..672fb72a31 100644
> > --- a/tools/virtiofsd/passthrough_seccomp.c
> > +++ b/tools/virtiofsd/passthrough_seccomp.c
> > @@ -118,6 +118,7 @@ static const int syscall_whitelist[] = {
> >  
> >  /* Syscalls used when --syslog is enabled */
> >  static const int syscall_whitelist_syslog[] = {
> 
> Is it worth restricting the syscall to POWER?

That would be wrong, as this is needed on multiple arches.

There is no real security benefit to restricting it either, as both
syscalls give you broadly equivalent abilities.

> 
>    #if defined(__powerpc64__)
> 
> > +    SCMP_SYS(send),
> 
>    #endif
> 
> >      SCMP_SYS(sendto),
> >  };



Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

