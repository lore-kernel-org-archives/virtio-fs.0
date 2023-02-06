Return-Path: <hreitz@redhat.com>
Message-ID: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
Date: Mon, 6 Feb 2023 13:35:33 +0100
MIME-Version: 1.0
From: Hanna Czenczek <hreitz@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] vhost-user (virtio-fs) migration: back end state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

Hi Stefan,

For true virtio-fs migration, we need to migrate the daemon’s (back 
end’s) state somehow.  I’m addressing you because you had a talk on this 
topic at KVM Forum 2021. :)

As far as I understood your talk, the only standardized way to migrate a 
vhost-user back end’s state is via dbus-vmstate.  I believe that 
interface is unsuitable for our use case, because we will need to 
migrate more than 1 MB of state.  Now, that 1 MB limit has supposedly 
been chosen arbitrarily, but the introducing commit’s message says that 
it’s based on the idea that the data must be supplied basically 
immediately anyway (due to both dbus and qemu migration requirements), 
and I don’t think we can meet that requirement.

Has there been progress on the topic of standardizing a vhost-user back 
end state migration channel besides dbus-vmstate?  I’ve looked around 
but didn’t find anything.  If there isn’t anything yet, is there still 
interest in the topic?

Of course, we could use a channel that completely bypasses qemu, but I 
think we’d like to avoid that if possible.  First, this would require 
adding functionality to virtiofsd to configure this channel.  Second, 
not storing the state in the central VM state means that migrating to 
file doesn’t work (well, we could migrate to a dedicated state file, 
but...).  Third, setting up such a channel after virtiofsd has sandboxed 
itself is hard.  I guess we should set up the migration channel before 
sandboxing, which constrains runtime configuration (basically this would 
only allow us to set up a listening server, I believe).  Well, and 
finally, it isn’t a standard way, which won’t be great if we’re planning 
to add a standard way anyway.

Thanks!

Hanna

