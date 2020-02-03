Date: Mon, 3 Feb 2020 19:36:09 +0100
From: =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Message-ID: <20200203183609.GX18565@lpt>
References: <cover.1580403751.git.jtomko@redhat.com>
	<484b10cf2a837ba7bc13400321978aa2076f0967.1580403751.git.jtomko@redhat.com>
	<20200203164351.GV1922177@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7WMexqIhC8AwFtpM"
Content-Disposition: inline
In-Reply-To: <20200203164351.GV1922177@redhat.com>
Subject: Re: [Virtio-fs] [libvirt PATCHv3 10/12] qemu: add code for handling
	virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: libvir-list@redhat.com, virtio-fs@redhat.com


--7WMexqIhC8AwFtpM
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[adding virtiofs list]

On Mon, Feb 03, 2020 at 04:43:51PM +0000, Daniel P. Berrang=E9 wrote:
>On Thu, Jan 30, 2020 at 06:06:26PM +0100, J=E1n Tomko wrote:
>> Start virtiofsd for each <filesystem> device using it.
>>
>> Pre-create the socket for communication with QEMU and pass it
>> to virtiofsd.
>>
>> Note that virtiofsd needs to run as root.
>
>So we're not able to use  virtiofsd with the session libvirtd
>which runs completely unprivileged ?
>

Not with the version of virtiofsd currently merged in the QEMU tree.

>I can understand the need to run as root if we want to support
>chown() of files, or DAC_OVERRIDE, but I'm surprised it isn't
>possible to run virtiofsd unprivileged & simply have a reduced
>featureset where it can only create files as that one user.
>

Apart from the possibly missing features (I don't know how well
virtiofsd internals are ready for those), current version of the
daemon sets up namespaces and the seccomp sandbox.

>
>> +int
>> +qemuVirtioFSStart(virLogManagerPtr logManager,
>> +                  virQEMUDriverPtr driver,
>> +                  virDomainObjPtr vm,
>> +                  virDomainFSDefPtr fs)
>> +{
>> +    g_autoptr(virQEMUDriverConfig) cfg =3D virQEMUDriverGetConfig(drive=
r);
>> +    g_autoptr(virCommand) cmd =3D NULL;
>> +    g_autofree char *socket_path =3D NULL;
>> +    g_autofree char *pidfile =3D NULL;
>> +    g_autofree char *logpath =3D NULL;
>> +    pid_t pid =3D (pid_t) -1;
>> +    VIR_AUTOCLOSE fd =3D -1;
>> +    VIR_AUTOCLOSE logfd =3D -1;
>> +    int ret =3D -1;
>> +    int rc;
>
>> +
>> +    if (!(pidfile =3D qemuVirtioFSCreatePidFilename(cfg, vm->def, fs->i=
nfo.alias)))
>> +        goto cleanup;
>> +
>> +    if (!(socket_path =3D qemuVirtioFSCreateSocketFilename(vm, fs->info=
=2Ealias)))
>> +        goto cleanup;
>> +
>> +    if ((fd =3D qemuVirtioFSOpenChardev(driver, vm, socket_path)) < 0)
>> +        goto cleanup;
>> +
>> +    logpath =3D qemuVirtioFSCreateLogFilename(cfg, vm->def, fs->info.al=
ias);
>> +
>> +    if (cfg->stdioLogD) {
>> +        if ((logfd =3D virLogManagerDomainOpenLogFile(logManager,
>> +                                                    "qemu",
>> +                                                    vm->def->uuid,
>> +                                                    vm->def->name,
>> +                                                    logpath,
>> +                                                    0,
>> +                                                    NULL, NULL)) < 0)
>> +            goto cleanup;
>> +    } else {
>> +        if ((logfd =3D open(logpath, O_WRONLY | O_CREAT | O_APPEND, S_I=
RUSR | S_IWUSR)) < 0) {
>> +            virReportSystemError(errno, _("failed to create logfile %s"=
),
>> +                                 logpath);
>> +            goto cleanup;
>> +        }
>> +        if (virSetCloseExec(logfd) < 0) {
>> +            virReportSystemError(errno, _("failed to set close-on-exec =
flag on %s"),
>> +                                 logpath);
>> +            goto error;
>> +        }
>> +    }
>> +
>> +    if (!(cmd =3D qemuVirtioFSBuildCommandLine(cfg, fs, &fd)))
>> +        goto cleanup;
>> +
>> +    virCommandSetPidFile(cmd, pidfile);
>> +    virCommandSetOutputFD(cmd, &logfd);
>> +    virCommandSetErrorFD(cmd, &logfd);
>> +    virCommandNonblockingFDs(cmd);
>> +    virCommandDaemonize(cmd);
>
>We're not mandating "root" here, it is just inheriting the user that
>libvirtd runs as. So IIUC ,this will run virtofsd as non-root when
>used with session libvirtd, unless there's a check somewhere else
>that prevents this scenario ?

I'll add a check.

>
>I'm also wondering about cgroups placement in this method, and
>any use of SELinux
>

Placing it into a cgroup should be easy, AFAIK it does not need to
access any devices.

As for SELinux, I don't think there's anything to be done other than
updating the selinux-policy. Recursively relabeling the whole directory
feels intrusive.

Jano

>> +
>> +    if (qemuExtDeviceLogCommand(driver, vm, cmd, "virtiofsd") < 0)
>> +        goto cleanup;
>> +
>> +    rc =3D virCommandRun(cmd, NULL);
>> +    logfd =3D -1;

--7WMexqIhC8AwFtpM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEQeJGMrnL0ADuclbP+YPwO/Mat50FAl44aBQACgkQ+YPwO/Ma
t52Vgwf9FXE+72S0zj80p9USmzsYoe5/VxD08Fz8ItDOjrLX+76SRIaTV4ZFtCbs
4ImvHNoGm68frUnxv5zQZFBjOplyH8YyRV46zK1Bf6WndmlqEF35pfTQYLmgcLQV
T6rD2avAefl5sjc0kHUDp+OjdwNmF20D9CK/HclL3QuEm8fx7G9DrU3j4Yl+N/ia
W0U6tfxDahFOmFNNfB8Ue8jEPbwILW4lYZiSyIT8NiR94m/P+OJeGOe3cBAopdXK
Q2lX4/DvLJwOWkof07gXDnV+jV/uIaU9OjJdzwYMNxT0dBJwXuIvk6YbEU3C4DPo
Q7Cm14mxTX4KRF4R47AmNobzkuH33g==
=W7+k
-----END PGP SIGNATURE-----

--7WMexqIhC8AwFtpM--

