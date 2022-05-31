Return-Path: <vgoyal@redhat.com>
Date: Tue, 31 May 2022 18:50:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YpabpsCK2CBbOPQL@redhat.com>
References: <BY5PR14MB3893A6AA17C5FEBE843B640286D99@BY5PR14MB3893.namprd14.prod.outlook.com>
 <Yo8xDlTWijVMVNli@stefanha-x1.localdomain>
 <20220526080646.vsfmqgxyiglhe64r@mhamilton>
 <YpVBKsogLU8/5kiV@redhat.com>
 <BY5PR14MB3893602BAEFA362A5C62485386DC9@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR14MB3893602BAEFA362A5C62485386DC9@BY5PR14MB3893.namprd14.prod.outlook.com>
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Pra.. Dew.." <linux_learner@outlook.com>
Cc: Sergio Lopez <slp@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Tue, May 31, 2022 at 10:25:12PM +0000, Pra.. Dew.. wrote:
> Thank you so much Vivek. I enabled the trace in the code itself and ran it. The only message I got was InvalidParam message below. I did not get any other message.  We are going to try changing the structure [VhostUserMemRegMsg]  padding to see if that fixes the problem. Is there anything else we should try?

Hi Prashant,

I was trying to look at some of the code today and looks like
error message might be coming from vhost crate
(src/vhost_user/slave_req_handler.rs).

I don't understand the whole logic very well. So I will defer it to
Sergio if something can be done to support older qemu.

Thanks
Vivek

> ________________________________
> From: Vivek Goyal <vgoyal@redhat.com>
> Sent: Monday, May 30, 2022 10:11 PM
> To: Sergio Lopez <slp@redhat.com>; Prashant Dewan <linux_learner@outlook.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>; virtio-fs@redhat.com <virtio-fs@redhat.com>
> Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
> 
> On Thu, May 26, 2022 at 10:06:46AM +0200, Sergio Lopez wrote:
> > On Thu, May 26, 2022 at 08:49:34AM +0100, Stefan Hajnoczi wrote:
> > > On Thu, May 26, 2022 at 05:34:42AM +0000, Prashant Dewan wrote:
> > > > Hello Stefan,
> > > >
> > > > Here is the output from virtofsd..
> > > >
> > > > ------------------------------------
> > > > - Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu 2022-05-26 04:41:57 UTC. --
> > > > May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-user device daemon.<<Placeholder: run this daemon as non-privileged user>>.
> > > > May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z INFO  virtiofsd] Waiting for vhost-user socket connection...
> > > > May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:27:11Z INFO  virtiofsd] Client connected, servicing requests
> > > > May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:27:33Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest(InvalidParam)
> 
> So looks like following gave error message. There is no error messsage
> from the actual thread which failed. This is just the main thread
> waiting.
> 
>     if let Err(e) = daemon.wait() {
>         match e {
>             HandleRequest(PartialMessage) => info!("Client disconnected, shutting down"),
>             _ => error!("Waiting for daemon failed: {:?}", e),
>         }
>     }
> 
> I can't find "InvalidParam" in rust virtiofsd code. Does that mean,
> that this error is being returned by one of the crates we are using.
> 
> Prashant, you could try running rust virtiofsd with option "-d" to enable
> debug messages and that might show something interesting.
> 
> Also, if you are able to reproduce the problem all the time, I think
> you can start virtiofsd under gdb and see where exactly is it failing.
> 
> Thanks
> Vivek
> 
> > >
> > > virtiofsd terminated. I have CCed Sergio and German, who may have
> > > suggestions about what to check next.
> >
> > Hi,
> >
> > Could you please tell us which QEMU version are you running, and paste
> > here the its command line?
> >
> > Thanks,
> > Sergio.
> 
> 
> 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://nam12.safelinks.protection.outlook.com/?url=https%3A%2F%2Flistman.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;data=05%7C01%7C%7Cc4d5792347234799874008da42896937%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637895455186641964%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=ox5y7KH0DjiooIeJ367DZiexKQutIouWSCi5OLld%2BNY%3D&amp;reserved=0
> 
