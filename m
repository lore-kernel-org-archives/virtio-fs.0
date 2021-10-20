Date: Wed, 20 Oct 2021 14:53:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXBlmogJyeinUsXk@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
	<20210916084045.31684-12-hreitz@redhat.com>
	<YW8VBVsCqdUrm+M7@redhat.com>
	<161f36dc-2046-9b0b-deac-3fe039849103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <161f36dc-2046-9b0b-deac-3fe039849103@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 11/12] virtiofsd: Optionally fill
	lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Reitz <hreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Oct 20, 2021 at 12:00:07PM +0200, Hanna Reitz wrote:

[..]
> > > @@ -1302,13 +1512,26 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > >           goto out;
> > >       }
> > > -    newfd = openat(dir_path_fd.fd, name, O_PATH | O_NOFOLLOW);
> > > -    if (newfd == -1) {
> > > -        goto out_err;
> > > +    fh = get_file_handle(lo, dir_path_fd.fd, name, &can_open_handle);
> > > +    if (!fh || !can_open_handle) {
> > > +        /*
> > > +         * If we will not be able to open the file handle again
> > > +         * (can_open_handle is false), open an FD that we can put into
> > > +         * lo_inode (in case we need to create a new lo_inode).
> > > +         */
> > > +        newfd = openat(dir_path_fd.fd, name, O_PATH | O_NOFOLLOW);
> > > +        if (newfd == -1) {
> > > +            goto out_err;
> > > +        }
> > >       }
> > > -    res = do_statx(lo, newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
> > > -                   &mnt_id);
> > > +    if (newfd >= 0) {
> > > +        res = do_statx(lo, newfd, "", &e->attr,
> > > +                       AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, &mnt_id);
> > > +    } else {
> > > +        res = do_statx(lo, dir_path_fd.fd, name, &e->attr,
> > > +                       AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, &mnt_id);
> > > +    }
> > >       if (res == -1) {
> > >           goto out_err;
> > >       }
> > > @@ -1318,9 +1541,19 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > >           e->attr_flags |= FUSE_ATTR_SUBMOUNT;
> > Can this FUSE_ATTR_SUBMOUNT check be racy w.r.t file handles. I mean
> > say we open the file handle, and before we call do_statx(), another
> > mount shows up on the directory in queustion. So stats now belong
> > to file in new mount and we will think it is a SUBMOUNT. So effectively
> > now we have fh belonging to old file but stats belonging to new file
> > in new mount?
> 
> Yes.  Not just the submount, but the whole stat information, so also the
> file type that goes into the lo_inode.
> 
> I thought this wasn’t too bad, though now I don’t really know why. Perhaps
> it was just how I started the implementation and I never could get myself to
> care enough (not good, I know).  Thanks for making me care! :)
> 
> We could theoretically open an O_PATH FD from the file handle to get the
> stat information from it, but that wouldn’t work for un-openable file
> handles.
> 
> So I think the best is to open an O_PATH FD unconditionally first, and then
> generate the file handle from it.  Then we can stat the FD.

Yes, this sounds like a more reasonable appraoch. This O_PATH fd will be
temporary in nature, so it should not be a problem.

[..]
> > > + *
> > > + * Passing true for cap_dac_read_search adds CAP_DAC_READ_SEARCH to the
> > > + * allowlist.
> > >    */
> > > -static void setup_capabilities(char *modcaps_in)
> > > +static void setup_capabilities(char *modcaps_in, bool cap_dac_read_search)
> > >   {
> > >       char *modcaps = modcaps_in;
> > >       pthread_mutex_lock(&cap.mutex);
> > > @@ -4012,6 +4266,17 @@ static void setup_capabilities(char *modcaps_in)
> > >           exit(1);
> > >       }
> > > +    /*
> > > +     * If we need CAP_DAC_READ_SEARCH (for file handles), add that, too.
> > > +     */
> > > +    if (cap_dac_read_search &&
> > > +        capng_update(CAPNG_ADD, CAPNG_PERMITTED | CAPNG_EFFECTIVE,
> > > +                     CAP_DAC_READ_SEARCH)) {
> > > +        fuse_log(FUSE_LOG_ERR, "%s: capng_update failed for "
> > > +                 "CAP_DAC_READ_SEARCH\n", __func__);
> > > +        exit(1);
> > > +    }
> > > +
> > >       /*
> > >        * The modcaps option is a colon separated list of caps,
> > >        * each preceded by either + or -.
> > > @@ -4158,7 +4423,7 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
> > >       }
> > >       setup_seccomp(enable_syslog);
> > > -    setup_capabilities(g_strdup(lo->modcaps));
> > > +    setup_capabilities(g_strdup(lo->modcaps), lo->inode_file_handles);
> > >   }
> > >   /* Set the maximum number of open file descriptors */
> > > @@ -4498,6 +4763,14 @@ int main(int argc, char *argv[])
> > >       lo.use_statx = true;
> > > +#if !defined(CONFIG_STATX) || !defined(STATX_MNT_ID)
> > > +    if (lo.inode_file_handles) {
> > > +        fuse_log(FUSE_LOG_WARNING,
> > > +                 "No statx() or mount ID support: Will not be able to use file "
> > > +                 "handles for inodes\n");
> > > +    }
> > Again, I think we should error out if user asked for file handle support
> > explicitly and we can't enable it. But if we end up enabling by default,
> > it probably is fine to just log a message and not use it.
> > 
> > This begs the question what happens if filesystem does not support the
> > file handles. Ideally, I would think that we can error out.But for
> > submounts check will happen much later. For root mount atleast we
> > should be able to check at startup time and make sure file handles are
> > supported by filesystem.
> 
> I disagree, because we’ve decided that enabling file handles means
> best-effort.

Only for the cases where failure is temporary in nature or submounts don't
support file handles, right?

I thought you agreed that we should fail if we can't use file handles at
all.

> As for CONFIG_STATX or STATX_MNT_ID, those are things that
> will matter less over time anyway (because they will always be present).

This failure seems permanent and one will not be able to use file handles
at all.

Anyway, it probably will be nice to have first patch in the series, which
is just documentation patch and explains this best-effort nature of
file handle option and when to expect failure and when it will silently
fallback to O_PATH fd.

Vivek

