Date: Thu, 30 Jul 2020 10:10:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200730141020.GA149245@redhat.com>
References: <20200729221410.147556-1-vgoyal@redhat.com>
	<20200729221410.147556-3-vgoyal@redhat.com>
	<20200730085937.GA3477223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200730085937.GA3477223@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/5] virtiofsd: create lock/pid file in per
	user cache dir
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org

On Thu, Jul 30, 2020 at 09:59:37AM +0100, Daniel P. Berrang=E9 wrote:
> On Wed, Jul 29, 2020 at 06:14:07PM -0400, Vivek Goyal wrote:
> > Right now we create lock/pid file in /usr/local/var/... and unprivliged
> > user does not have access to create files there.
> >=20
> > So create this file in per user cache dir as queried as specified
> > by environment variable XDG_RUNTIME_DIR.
> >=20
> > Note: "su $USER" does not update XDG_RUNTIME_DIR and it still points to
> > root user's director. So for now I create a directory /tmp/$UID to save
> > lock/pid file. Dan pointed out that it can be a problem if a malicious
> > app already has /tmp/$UID created. So we probably need to get rid of th=
is.
>=20
> IMHO use of "su $USER" is simply user error and we don't need to
> care about workarounds. They will see the startup fail due to
> EPERM on /run/user/0 directory, and then they'll have to fix
> their command to use "su - $USER" to setup a clean environment.

I tried "su - $USER". That clears the old XDG_RUNTIME_DIR but does
not set new one. So now we have an empty XDG_RUNTIME_DIR env variable.
But good thing is that now g_get_user_runtime_dir() returns
"/home/$USER/.cache" and we can store user specific temp files there.

So I agree that I will get rid of all the logic to create /tmp/$USER.
"su $USER" will not be a supported path.

>=20
>=20
> > +    /*
> > +     * Unpriviliged users don't have access to /usr/local/var. Hence
> > +     * store lock/pid file in per user directory. Use environment
> > +     * variable XDG_RUNTIME_DIR.
> > +     * If one logs into the system as root and then does "su" then
> > +     * XDG_RUNTIME_DIR still points to root user directory. In that
> > +     * case create a directory for user in /tmp/$UID
> > +     */
> > +    if (unprivileged) {
> > +        gchar *user_dir =3D NULL;
> > +        gboolean create_dir =3D false;
> > +        user_dir =3D g_strdup(g_get_user_runtime_dir());
> > +        if (!user_dir || g_str_has_suffix(user_dir, "/0")) {
> > +            user_dir =3D g_strdup_printf("/tmp/%d", geteuid());
> > +            create_dir =3D true;
> > +        }
>=20
> As above, I don't think we need to have this fallback code to deal
> with something that is just user error.
>=20
> Also, g_get_user_runtime_dir() is guaranteed to return non-NULL.

Thanks. I will get rid of (!user_dir) case.

>=20
> > +
> > +        if (create_dir && g_mkdir_with_parents(user_dir, S_IRWXU) < 0)=
 {
> > +            fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s:=
 %s",
> > +                     __func__, user_dir, strerror(errno));
> > +            g_free(user_dir);
> > +            return false;
> > +        }
> > +        dir =3D g_strdup(user_dir);
>=20
> Don't we also want to be appending "virtiofsd" to this directory path
> like we do in the privileged case ?

Yes. I forgot to append "virtiofsd" dir. Will do.

Thanks
Vivek

