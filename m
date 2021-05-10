Date: Mon, 10 May 2021 17:40:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210510214005.GA207370@horse>
References: <20210507185909.GA40951@redhat.com>
 <YJlsJB/Ami4/jq4X@work-vm>
MIME-Version: 1.0
In-Reply-To: <YJlsJB/Ami4/jq4X@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] Few queries about virtiofsd read implementation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Mon, May 10, 2021 at 06:23:48PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > Hi David/Stefan,
> > 
> > I am browsing through the code of read requests (FUSE_READ) in virtiofsd
> > (and in virtiofs) and I have few questions. You folks probably know the
> > answers.
> > 
> > 1. virtio_send_data_iov(), reads the data from file into the scatter list.
> >   Some of the code looks strange.
> > 
> >   We seem to be retrying read if we read less number of bytes than what
> >   client asked for. I am wondering shoudl this really be our
> >   responsibility or client should deal with it. I am assuming that client
> >   should be ready to deal with less number of bytes read.
> > 
> >   So what was the thought process behind retrying.
> > 
> >           if (ret < len && ret) {
> >             fuse_log(FUSE_LOG_DEBUG, "%s: ret < len\n", __func__);
> >             /* Skip over this much next time around */
> >             skip_size = ret;
> >             buf->buf[0].pos += ret;
> >             len -= ret;
> > 
> >             /* Lets do another read */
> >             continue;
> >         }
> > 
> > - After this we have code where if number of bytes read are not same
> >   as we expect to, then we return EIO.
> > 
> >           if (ret != len) {
> >             fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n", __func__);
> >             ret = EIO;
> >             free(in_sg_cpy);
> >             goto err;
> >         }
> > 
> >   When do we hit this. IIUC, preadv() will return.
> > 
> >   A. Either number of bytes we expected (no issues)
> >   B. 0 in case of EOF (We break out of loop and just return to client with
> >   		      number of bytes we have read so far).
> >   C. <0 (This is error case and we return error to client)
> >   D. X bytes which is less than len. 
> > 
> > To handle D we have code to retry. So when do we hit the above if
> > condition where "ret !=len). Is this a dead code. Or I missed something.
> 
> I think you're right, that's dead.
> And oyu're probably also right that we could just take it easy and
> return less data to the client if preadv just gives us part of it.

Also, looks like we never return error to client.  virtio_send_data_iov()
only sends reply back if preadv() reads requested bytes or reads less due
to EOF. If preadv() returnes error, then we return to caller with error.
And I don't see anybody propagating that error back to client.

lo_read()
  fuse_reply_data()
    fuse_send_data_iov()
      fuse_send_data_iov_fallback()
        virtio_send_data_iov()

fuse_reply_data() returns error only if ret > 0 and that's not the case
here. In fact that seems to be another piece of dead code for virtiofs.

Thanks
Vivek

