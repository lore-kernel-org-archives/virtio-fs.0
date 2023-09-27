Return-Path: <hreitz@redhat.com>
Message-ID: <565ce7ae-d0a1-c40f-f57b-4dc11234e4b0@redhat.com>
Date: Wed, 27 Sep 2023 10:13:52 +0200
MIME-Version: 1.0
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230925204852.GG323580@fedora>
 <fc005d50-03ba-0b8f-d9af-64a5297395a3@redhat.com>
 <CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com>
Content-Type: multipart/alternative;
 boundary="------------UnQbM7jNXFMeXGQcfcN0W0uS"
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 0/5] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, "Michael S . Tsirkin" <mst@redhat.com>

This is a multi-part message in MIME format.
--------------UnQbM7jNXFMeXGQcfcN0W0uS
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit

On 26.09.23 21:20, Stefan Hajnoczi wrote:
>
>
> On Tue, Sep 26, 2023, 09:33 Hanna Czenczek <hreitz@redhat.com> wrote:
>
>     On 25.09.23 22:48, Stefan Hajnoczi wrote:
>     > On Fri, Sep 15, 2023 at 12:25:25PM +0200, Hanna Czenczek wrote:
>     >> RFC:
>     >>
>     https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html
>     >>
>     >> v1:
>     >>
>     https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html
>     >>
>     >> v2:
>     >>
>     https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html
>     >>
>     >> Hi,
>     >>
>     >> I’ve decided not to work on vhost-user SUSPEND/RESUME for now –
>     it is
>     >> not technically required for virtio-fs migration, which is the
>     actual
>     >> priority for me now.  While we do want to have SUSPEND/RESUME
>     at some
>     >> point, the only practically existing reason for it is to be able to
>     >> implement vhost-level resetting in virtiofsd, but that is not
>     related to
>     >> migration.
>     > QEMU sends VHOST_USER_SET_STATUS 0 in vhost_dev_stop(). Are you
>     assuming
>     > that virtiofs back-ends do not reset the device upon receiving this
>     > message?
>
>
>     Absolutely.  vhost_dev_stop() is not in the migration-specific
>     path, but
>     is called whenever the vCPUs are stopped, which indeed happens to be
>     part of migration, but is also used in other cases, like QMP
>     stop.  We
>     have identified that it is wrong that we reset the back-end just
>     because
>     the vCPUs are stopped (e.g. on migration), but it is what we do right
>     now when the VM is paused (e.g. through QMP stop).
>
>     Therefore, stateful back-ends cannot implement reset lest stop/cont
>     breaks the device.  I don’t think anybody really cares whether a
>     vhost-user back-end actually resets its internal state (if there
>     is any)
>     when the guest driver asks for a reset on the virtio level, as
>     long as
>     the guest driver is then able to initialize the device afterwards.
>
>
> Some devices send configuration change notifications. For example, 
> virtio-net speed and duplex changes.
>
> Imagine a network boot ROM runs and the firmware resets the virtio-net 
> device when transferring control to the loaded kernel. Before the 
> kernel driver initializes the device again, the vhost-user-net 
> back-end reports a speed or duplex change and sends a Configuration 
> Change Notification to the guest. The guest receives a spurious 
> interrupt because the vhost-user-net device wasn't actually reset.

I don’t see how this relates to my argument that no stateful back-end 
can implement a full reset because doing so would break stop/cont.

If vhost-user-net were stateful (which it isn’t, AFAIK), it could choose 
to implement a work-around such that it would stop sending notifications 
on reset, but not reset its internal state.  Then, when qemu restores 
vring state in vhost_dev_start(), it would resume sending 
notifications.  But again, I fail to see how this is not already an 
issue for stop/cont.

> I'm concerned that ignoring reset matters (admittedly in corner cases) 
> and think that stateful device functionality shouldn't be added to the 
> vhost-user protocol without a solution for reset.

I disagree.  We have a stateful device already, whether we add 
functionality acknowledging this to the protocol or not.  The problem 
exists.  It is independent of migration.  If there’s a problem because 
of this with migration, there’s a problem with stop/cont, too, that must 
already have been worked around.

> This patch series changes the vhost-user protocol, which is used by 
> many different devices, not just virtiofs. The solution should work 
> for vhost-user devices of any type and not be based on what we can get 
> away with when running the current QEMU + virtiofsd.

My argument was generic.  Any existing stateful device implementation 
must implement reset in such a way that it won’t break stop/cont, i.e., 
it must not reset its internal state.

>
>     I do
>     think people care that stop/cont works, so it follows to me that no
>     stateful back-end will reset its internal state when receiving a
>     virtio/vhost reset.  If they do, stop/cont breaks, which is a
>     user-visible bug that needs to be addressed – either properly by
>     implementing SUSPEND/RESUME in both qemu and the affected
>     back-ends, or
>     by using a similar work-around to virtiofsd, which is to ignore reset
>     commands.
>
>
> Properly, please.

You misunderstand me.  I’m not presenting the choice I have.  I’m 
presenting the choices existing implementations *have had until this 
point*.  *None* chose to do it properly.  I don’t know of stateful 
implementations besides virtiofsd, but virtiofsd chose to be content 
with not implementing reset and thus having things “just work”.

The work-arounds must exist already.

>
>
>     It’s hard for me to imagine that people don’t care that stop/cont
>     breaks
>     some vhost-user back-end, but suddenly would start to care that
>     migration doesn’t work – especially given that first of all
>     someone will
>     need to manually implement any migration support in that back-end
>     even
>     with this series, which means that really, the only back-end we are
>     talking about here is our virtiofsd.  To this day I’m not even
>     aware of
>     any other back-end that has internal state.
>
>
> Another one I can think of is vhost-user-gpu.

I sure hope stop/cont works for them.

> Why did you give up on implementing SUSPEND/RESUME?

Because I think it’s unnecessary for implementing migration, and 
migration is what’s on my priority list.  None of these issues are new, 
they have always existed with stop/cont, work-arounds must be in place 
to make stop/cont work, and because I don’t see the difference in how 
stop/cont is used outside of migration and how it is used during 
migration, I assume those work-arounds must work for migration as well.

Implementing virtio-fs migration is a chain of dependencies.  We need at 
least the specification to be in qemu before we can start sending merge 
requests to the vhost Rust crates to implement support there.  We need 
that support there before we can make the changes to virtiofsd.

Adding SUSPEND/RESUME adds another hard dependency to the whole 
discussion (this would have to go on before this series), which has 
proven absolutely clearly in the past months that it is a very complex 
finnicky isue that would take a ton of time still.  And I can’t justify 
that for myself, given that I don’t see any practically existing problem.

PS: As far as I remember, vhost-user doesn’t even have a working reset 
today.  vhost_dev_stop() calls vhost_reset_status(), which is a no-op 
unless the back-end supports SET_STATUS.  The only back-end 
implementation we found (while discussing SUSPEND/RESUME) to support 
SET_STATUS was dpdk, but while it logs SET_STATUS 0 as a reset, it 
doesn’t do a reset, i.e. doesn’t call reset_device(), which it would do 
on RESET_OWNER.

Hanna
--------------UnQbM7jNXFMeXGQcfcN0W0uS
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 26.09.23 21:20, Stefan Hajnoczi
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com">
      <meta http-equiv="content-type" content="text/html; charset=UTF-8">
      <div dir="ltr">
        <div dir="ltr">
          <div dir="ltr">
            <div dir="auto">
              <div><br>
                <br>
                <div class="gmail_quote">
                  <div dir="ltr" class="gmail_attr">On Tue, Sep 26,
                    2023, 09:33 Hanna Czenczek &lt;<a
                      href="mailto:hreitz@redhat.com" target="_blank"
                      moz-do-not-send="true"
                      class="moz-txt-link-freetext">hreitz@redhat.com</a>&gt;
                    wrote:<br>
                  </div>
                  <blockquote class="gmail_quote" style="margin:0px 0px
                    0px 0.8ex;border-left:1px solid
                    rgb(204,204,204);padding-left:1ex">On 25.09.23
                    22:48, Stefan Hajnoczi wrote:<br>
                    &gt; On Fri, Sep 15, 2023 at 12:25:25PM +0200, Hanna
                    Czenczek wrote:<br>
                    &gt;&gt; RFC:<br>
                    &gt;&gt; <a
href="https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html"
                      rel="noreferrer noreferrer" target="_blank"
                      moz-do-not-send="true"
                      class="moz-txt-link-freetext">https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html</a><br>
                    &gt;&gt;<br>
                    &gt;&gt; v1:<br>
                    &gt;&gt; <a
href="https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html"
                      rel="noreferrer noreferrer" target="_blank"
                      moz-do-not-send="true"
                      class="moz-txt-link-freetext">https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html</a><br>
                    &gt;&gt;<br>
                    &gt;&gt; v2:<br>
                    &gt;&gt; <a
href="https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html"
                      rel="noreferrer noreferrer" target="_blank"
                      moz-do-not-send="true"
                      class="moz-txt-link-freetext">https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html</a><br>
                    &gt;&gt;<br>
                    &gt;&gt; Hi,<br>
                    &gt;&gt;<br>
                    &gt;&gt; I’ve decided not to work on vhost-user
                    SUSPEND/RESUME for now – it is<br>
                    &gt;&gt; not technically required for virtio-fs
                    migration, which is the actual<br>
                    &gt;&gt; priority for me now.  While we do want to
                    have SUSPEND/RESUME at some<br>
                    &gt;&gt; point, the only practically existing reason
                    for it is to be able to<br>
                    &gt;&gt; implement vhost-level resetting in
                    virtiofsd, but that is not related to<br>
                    &gt;&gt; migration.<br>
                    &gt; QEMU sends VHOST_USER_SET_STATUS 0 in
                    vhost_dev_stop(). Are you assuming<br>
                    &gt; that virtiofs back-ends do not reset the device
                    upon receiving this<br>
                    &gt; message?<br>
                  </blockquote>
                </div>
              </div>
              <div dir="auto">
                <div class="gmail_quote">
                  <blockquote class="gmail_quote" style="margin:0px 0px
                    0px 0.8ex;border-left:1px solid
                    rgb(204,204,204);padding-left:1ex">
                    <br>
                    Absolutely.  vhost_dev_stop() is not in the
                    migration-specific path, but <br>
                    is called whenever the vCPUs are stopped, which
                    indeed happens to be <br>
                    part of migration, but is also used in other cases,
                    like QMP stop.  We <br>
                    have identified that it is wrong that we reset the
                    back-end just because <br>
                    the vCPUs are stopped (e.g. on migration), but it is
                    what we do right <br>
                    now when the VM is paused (e.g. through QMP stop).<br>
                    <br>
                    Therefore, stateful back-ends cannot implement reset
                    lest stop/cont <br>
                    breaks the device.  I don’t think anybody really
                    cares whether a <br>
                    vhost-user back-end actually resets its internal
                    state (if there is any) <br>
                    when the guest driver asks for a reset on the virtio
                    level, as long as <br>
                    the guest driver is then able to initialize the
                    device afterwards.</blockquote>
                  <div><br>
                  </div>
                  <div>Some devices send configuration change
                    notifications. For example, virtio-net speed and
                    duplex changes.</div>
                  <div><br>
                  </div>
                  <div>Imagine a network boot ROM runs and the firmware
                    resets the virtio-net device when transferring
                    control to the loaded kernel. Before the kernel
                    driver initializes the device again, the
                    vhost-user-net back-end reports a speed or duplex
                    change and sends a Configuration Change Notification
                    to the guest. The guest receives a spurious
                    interrupt because the vhost-user-net device wasn't
                    actually reset.</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </blockquote>
    <br>
    I don’t see how this relates to my argument that no stateful
    back-end can implement a full reset because doing so would break
    stop/cont.<br>
    <br>
    If vhost-user-net were stateful (which it isn’t, AFAIK), it could
    choose to implement a work-around such that it would stop sending
    notifications on reset, but not reset its internal state.  Then,
    when qemu restores vring state in vhost_dev_start(), it would resume
    sending notifications.  But again, I fail to see how this is not
    already an issue for stop/cont.<br>
    <br>
    <blockquote type="cite"
cite="mid:CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com">
      <div dir="ltr">
        <div dir="ltr">
          <div dir="ltr">
            <div dir="auto">
              <div dir="auto">
                <div class="gmail_quote">
                  <div>I'm concerned that ignoring reset matters
                    (admittedly in corner cases) and think that stateful
                    device functionality shouldn't be added to the
                    vhost-user protocol without a solution for reset.</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </blockquote>
    <br>
    I disagree.  We have a stateful device already, whether we add
    functionality acknowledging this to the protocol or not.  The
    problem exists.  It is independent of migration.  If there’s a
    problem because of this with migration, there’s a problem with
    stop/cont, too, that must already have been worked around.<br>
    <br>
    <blockquote type="cite"
cite="mid:CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com">
      <div dir="ltr">
        <div dir="ltr">
          <div dir="ltr">
            <div dir="auto">
              <div dir="auto">
                <div class="gmail_quote">
                  <div>This patch series changes the vhost-user
                    protocol, which is used by many different devices,
                    not just virtiofs. The solution should work for
                    vhost-user devices of any type and not be based on
                    what we can get away with when running the current
                    QEMU + virtiofsd.<br>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </blockquote>
    <br>
    My argument was generic.  Any existing stateful device
    implementation must implement reset in such a way that it won’t
    break stop/cont, i.e., it must not reset its internal state.<br>
    <br>
    <blockquote type="cite"
cite="mid:CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com">
      <div dir="ltr">
        <div dir="ltr">
          <div dir="ltr">
            <div dir="auto">
              <div dir="auto">
                <div class="gmail_quote">
                  <div><br>
                  </div>
                  <blockquote class="gmail_quote" style="margin:0px 0px
                    0px 0.8ex;border-left:1px solid
                    rgb(204,204,204);padding-left:1ex">I do <br>
                    think people care that stop/cont works, so it
                    follows to me that no <br>
                    stateful back-end will reset its internal state when
                    receiving a <br>
                    virtio/vhost reset.  If they do, stop/cont breaks,
                    which is a <br>
                    user-visible bug that needs to be addressed – either
                    properly by <br>
                    implementing SUSPEND/RESUME in both qemu and the
                    affected back-ends, or <br>
                    by using a similar work-around to virtiofsd, which
                    is to ignore reset <br>
                    commands.<br>
                  </blockquote>
                </div>
              </div>
              <div dir="auto"><br>
              </div>
              <div>Properly, please.<br>
              </div>
            </div>
          </div>
        </div>
      </div>
    </blockquote>
    <br>
    You misunderstand me.  I’m not presenting the choice I have.  I’m
    presenting the choices existing implementations *have had until this
    point*.  *None* chose to do it properly.  I don’t know of stateful
    implementations besides virtiofsd, but virtiofsd chose to be content
    with not implementing reset and thus having things “just work”.<br>
    <br>
    The work-arounds must exist already.<br>
    <br>
    <blockquote type="cite"
cite="mid:CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com">
      <div dir="ltr">
        <div dir="ltr">
          <div dir="ltr">
            <div dir="auto">
              <div dir="auto"><br>
              </div>
              <div dir="auto">
                <div class="gmail_quote">
                  <blockquote class="gmail_quote" style="margin:0px 0px
                    0px 0.8ex;border-left:1px solid
                    rgb(204,204,204);padding-left:1ex">
                    <br>
                    It’s hard for me to imagine that people don’t care
                    that stop/cont breaks <br>
                    some vhost-user back-end, but suddenly would start
                    to care that <br>
                    migration doesn’t work – especially given that first
                    of all someone will <br>
                    need to manually implement any migration support in
                    that back-end even <br>
                    with this series, which means that really, the only
                    back-end we are <br>
                    talking about here is our virtiofsd.  To this day
                    I’m not even aware of <br>
                    any other back-end that has internal state.<br>
                  </blockquote>
                  <div><br>
                  </div>
                  <div>Another one I can think of is vhost-user-gpu.</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </blockquote>
    <br>
    I sure hope stop/cont works for them.<br>
    <br>
    <blockquote type="cite"
cite="mid:CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com">
      <div dir="ltr">
        <div dir="ltr">
          <div dir="ltr">
            <div dir="auto">
              <div dir="auto">
                <div class="gmail_quote">
                  <div>Why did you give up on implementing
                    SUSPEND/RESUME?<br>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </blockquote>
    <br>
    Because I think it’s unnecessary for implementing migration, and
    migration is what’s on my priority list.  None of these issues are
    new, they have always existed with stop/cont, work-arounds must be
    in place to make stop/cont work, and because I don’t see the
    difference in how stop/cont is used outside of migration and how it
    is used during migration, I assume those work-arounds must work for
    migration as well.<br>
    <br>
    Implementing virtio-fs migration is a chain of dependencies.  We
    need at least the specification to be in qemu before we can start
    sending merge requests to the vhost Rust crates to implement support
    there.  We need that support there before we can make the changes to
    virtiofsd.<br>
    <br>
    Adding SUSPEND/RESUME adds another hard dependency to the whole
    discussion (this would have to go on before this series), which has
    proven absolutely clearly in the past months that it is a very
    complex finnicky isue that would take a ton of time still.  And I
    can’t justify that for myself, given that I don’t see any
    practically existing problem.<br>
    <br>
    PS: As far as I remember, vhost-user doesn’t even have a working
    reset today.  vhost_dev_stop() calls vhost_reset_status(), which is
    a no-op unless the back-end supports SET_STATUS.  The only back-end
    implementation we found (while discussing SUSPEND/RESUME) to support
    SET_STATUS was dpdk, but while it logs SET_STATUS 0 as a reset, it
    doesn’t do a reset, i.e. doesn’t call reset_device(), which it would
    do on RESET_OWNER.<br>
    <br>
    Hanna<br>
  </body>
</html>

--------------UnQbM7jNXFMeXGQcfcN0W0uS--

