Date: Mon, 3 Feb 2020 19:03:16 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200203190316.GC1922177@redhat.com>
References: <cover.1580403751.git.jtomko@redhat.com>
	<484b10cf2a837ba7bc13400321978aa2076f0967.1580403751.git.jtomko@redhat.com>
	<20200203164351.GV1922177@redhat.com> <20200203183609.GX18565@lpt>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200203183609.GX18565@lpt>
Subject: Re: [Virtio-fs] [libvirt PATCHv3 10/12] qemu: add code for handling
	virtiofsd
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?utf-8?Q?J=C3=A1n?= Tomko <jtomko@redhat.com>
Cc: libvir-list@redhat.com, virtio-fs@redhat.com

On Mon, Feb 03, 2020 at 07:36:09PM +0100, Ján Tomko wrote:
> [adding virtiofs list]
> 
> On Mon, Feb 03, 2020 at 04:43:51PM +0000, Daniel P. Berrangé wrote:
> > On Thu, Jan 30, 2020 at 06:06:26PM +0100, Ján Tomko wrote:
> > > Start virtiofsd for each <filesystem> device using it.
> > > 
> > > Pre-create the socket for communication with QEMU and pass it
> > > to virtiofsd.
> > > 
> > > Note that virtiofsd needs to run as root.
> > 
> > So we're not able to use  virtiofsd with the session libvirtd
> > which runs completely unprivileged ?
> > 
> 
> Not with the version of virtiofsd currently merged in the QEMU tree.
> 
> > I can understand the need to run as root if we want to support
> > chown() of files, or DAC_OVERRIDE, but I'm surprised it isn't
> > possible to run virtiofsd unprivileged & simply have a reduced
> > featureset where it can only create files as that one user.
> > 
> 
> Apart from the possibly missing features (I don't know how well
> virtiofsd internals are ready for those), current version of the
> daemon sets up namespaces and the seccomp sandbox.
> 
> > 
> > > +int
> > > +qemuVirtioFSStart(virLogManagerPtr logManager,
> > > +                  virQEMUDriverPtr driver,
> > > +                  virDomainObjPtr vm,
> > > +                  virDomainFSDefPtr fs)
> > > +{
> > > +    g_autoptr(virQEMUDriverConfig) cfg = virQEMUDriverGetConfig(driver);
> > > +    g_autoptr(virCommand) cmd = NULL;
> > > +    g_autofree char *socket_path = NULL;
> > > +    g_autofree char *pidfile = NULL;
> > > +    g_autofree char *logpath = NULL;
> > > +    pid_t pid = (pid_t) -1;
> > > +    VIR_AUTOCLOSE fd = -1;
> > > +    VIR_AUTOCLOSE logfd = -1;
> > > +    int ret = -1;
> > > +    int rc;
> > 
> > > +
> > > +    if (!(pidfile = qemuVirtioFSCreatePidFilename(cfg, vm->def, fs->info.alias)))
> > > +        goto cleanup;
> > > +
> > > +    if (!(socket_path = qemuVirtioFSCreateSocketFilename(vm, fs->info.alias)))
> > > +        goto cleanup;
> > > +
> > > +    if ((fd = qemuVirtioFSOpenChardev(driver, vm, socket_path)) < 0)
> > > +        goto cleanup;
> > > +
> > > +    logpath = qemuVirtioFSCreateLogFilename(cfg, vm->def, fs->info.alias);
> > > +
> > > +    if (cfg->stdioLogD) {
> > > +        if ((logfd = virLogManagerDomainOpenLogFile(logManager,
> > > +                                                    "qemu",
> > > +                                                    vm->def->uuid,
> > > +                                                    vm->def->name,
> > > +                                                    logpath,
> > > +                                                    0,
> > > +                                                    NULL, NULL)) < 0)
> > > +            goto cleanup;
> > > +    } else {
> > > +        if ((logfd = open(logpath, O_WRONLY | O_CREAT | O_APPEND, S_IRUSR | S_IWUSR)) < 0) {
> > > +            virReportSystemError(errno, _("failed to create logfile %s"),
> > > +                                 logpath);
> > > +            goto cleanup;
> > > +        }
> > > +        if (virSetCloseExec(logfd) < 0) {
> > > +            virReportSystemError(errno, _("failed to set close-on-exec flag on %s"),
> > > +                                 logpath);
> > > +            goto error;
> > > +        }
> > > +    }
> > > +
> > > +    if (!(cmd = qemuVirtioFSBuildCommandLine(cfg, fs, &fd)))
> > > +        goto cleanup;
> > > +
> > > +    virCommandSetPidFile(cmd, pidfile);
> > > +    virCommandSetOutputFD(cmd, &logfd);
> > > +    virCommandSetErrorFD(cmd, &logfd);
> > > +    virCommandNonblockingFDs(cmd);
> > > +    virCommandDaemonize(cmd);
> > 
> > We're not mandating "root" here, it is just inheriting the user that
> > libvirtd runs as. So IIUC ,this will run virtofsd as non-root when
> > used with session libvirtd, unless there's a check somewhere else
> > that prevents this scenario ?
> 
> I'll add a check.
> 
> > 
> > I'm also wondering about cgroups placement in this method, and
> > any use of SELinux
> > 
> 
> Placing it into a cgroup should be easy, AFAIK it does not need to
> access any devices.
> 
> As for SELinux, I don't think there's anything to be done other than
> updating the selinux-policy. Recursively relabeling the whole directory
> feels intrusive.

Even if we don't do relabelling, we'll still need more than just
policy work I believe.

If we assume a new  "virtiofsd_t" SELinux type.

Ff QEMU is launched svirt_t:s0:c123,c532, we will need to
explicitly spawn virtiofsd with the matching MCS category
eg virtiofsd_t:s0:c123,c532. The policy should  be written such
that the UNIX domain socket used for comms between QEMU and
virtiofsd requires this matching MCS category label.

This ensures that QEMU Guest-A can't connect to a virtiofsd used
by QEMU Guest-B and vica-verca.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

