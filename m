References: <20210317124100.2bepcspqmi6knspi@mhamilton>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <03544dfe-8745-1c83-8410-65a607c0e1c1@redhat.com>
Date: Thu, 18 Mar 2021 10:55:29 +0100
MIME-Version: 1.0
In-Reply-To: <20210317124100.2bepcspqmi6knspi@mhamilton>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Notifications from virtiofsd-rs project
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>, virtio-fs@redhat.com

On 17.03.21 13:41, Sergio Lopez wrote:
> Hi,
> 
> I've just created a service [1] that receives GitLab webhook events
> from the virtiofsd-rs project and sends an email to this mailing
> list.
> 
> To keep the noise as low as possible, it only sends an event when an
> Issue or Merge Request is opened, reopened, merged or closed. If you
> want to receive a notification for other events (such as when a
> comment is added to an Issue or MR), you'd still need to subscribe to
> them (you can subscribe only to a single Issue or MR) using the GitLab
> interface.
> 
> In case you want to filter those messages, the mails will have
> "virtiofs-bot@sinrega.org" as the sender.
> 
> If you find those notifications to be an inconvenience, please let me
> now.
> 
> Thanks!
> Sergio.
> 
> [1] https://gitlab.com/slp/gitlab-webhooks-email

Thanks a lot! :)

Max

