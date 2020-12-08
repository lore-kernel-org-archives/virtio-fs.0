References: <061ca370-eba8-55bc-c974-7a8e595ca9ee@redhat.com>
	<20201207183332.GG3135@work-vm>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <023059b9-ee98-d045-3797-7a0d73dbf390@redhat.com>
Date: Tue, 8 Dec 2020 03:19:15 +0100
MIME-Version: 1.0
In-Reply-To: <20201207183332.GG3135@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] debug log timestamp idea
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On 12/07/20 19:33, Dr. David Alan Gilbert wrote:
> * Laszlo Ersek (lersek@redhat.com) wrote:
>> Hi again :)
>>
>> I find the current debug log hard to associate with actions I perform in
>> the client; primarily because the timestamps are not human-readable, and
>> so I can't easily notice time boundaries between actions.
>>
>> For comparison:
>>
>> [2020-12-07 18:11:35.51+0100] [ID: 00000003] fv_queue_thread: Got queue event on Queue 1
>> [2020-12-07 18:11:35.51+0100] [ID: 00000003] fv_queue_thread: Queue 1 gave evalue: 1 available: in: 16 out: 64
>> [2020-12-07 18:11:35.51+0100] [ID: 00000003] fv_queue_thread: Waiting for Queue 1 event
>> [2020-12-07 18:11:35.51+0100] [ID: 00000006] fv_queue_worker: elem 0: with 2 out desc of length 64
>> [2020-12-07 18:11:35.51+0100] [ID: 00000006] unique: 108, opcode: RELEASEDIR (29), nodeid: 1, insize: 64, pid: 1
>> [2020-12-07 18:11:35.51+0100] [ID: 00000006]    unique: 108, success, outsize: 16
>> [2020-12-07 18:11:35.51+0100] [ID: 00000006] virtio_send_msg: elem 0: with 1 in desc of length 16
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] virtio_loop: Got VU event
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] fv_queue_set_started: qidx=1 started=0
>> [2020-12-07 18:17:54.82+0100] [ID: 00000003] fv_queue_thread: kill event on queue 1 - quitting
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] fv_remove_watch: TODO! fd=9
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] virtio_loop: Waiting for VU event
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] virtio_loop: Got VU event
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] virtio_loop: Waiting for VU event
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] virtio_loop: Got VU event
>> [2020-12-07 18:17:54.82+0100] [ID: 00000001] virtio_loop: Waiting for VU event
>> [2020-12-07 18:17:54.85+0100] [ID: 00000001] virtio_loop: Unexpected poll revents 11
>> [2020-12-07 18:17:54.85+0100] [ID: 00000001] virtio_loop: Exit
> 
> So, you don't think in Unix time, hmmmmm....

At least not in nanosecond precision :)

> 
>> I think this is nicer; note the clear visual jump between "18:11:35" and
>> "18:17:54"
>>
>> The patch:
>>
>>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>>> index 0e4c7ddce0a8..5522f96d33d0 100644
>>> --- a/tools/virtiofsd/passthrough_ll.c
>>> +++ b/tools/virtiofsd/passthrough_ll.c
>>> @@ -3302,9 +3302,19 @@ static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
>>>      }
>>>
>>>      if (current_log_level == FUSE_LOG_DEBUG) {
>>> -        if (!use_syslog) {
>>> -            localfmt = g_strdup_printf("[%" PRId64 "] [ID: %08ld] %s",
>>> -                                       get_clock(), syscall(__NR_gettid), fmt);
>>> +        struct timespec ts;
>>> +        if (!use_syslog && clock_gettime (CLOCK_REALTIME, &ts) == 0) {
>>> +            struct tm tm;
>>> +            char sec_fmt[20];
> 
> Are you sure that shouldn't be 21?

Yes, sure:

$ wc -L <<< "2020-12-07 18:17:54"
19

(But it would be more defensive to check the return value of strftime(),
yes.)


> 
>>> +            char zone_fmt[6];
>>> +
>>> +            localtime_r(&ts.tv_sec, &tm);
>>> +            strftime(sec_fmt, sizeof sec_fmt, "%Y-%m-%d %H:%M:%S", &tm);
>>> +            strftime(zone_fmt, sizeof zone_fmt, "%z", &tm);
>>> +
>>> +            localfmt = g_strdup_printf("[%s.%02ld%s] [ID: %08ld] %s", sec_fmt,
>>> +                                       ts.tv_nsec / (10L * 1000 * 1000),
>>> +                                       zone_fmt, syscall(__NR_gettid), fmt);
> 
> I wonder about using:
> https://developer.gnome.org/glib/stable/glib-GDateTime.html#g-date-time-format-iso8601
> 
> instead?

I've known of that format; I just can't befriend the capital T stuck in
the middle. Makes for a difficult reading:

https://en.wikipedia.org/wiki/ISO_8601#Combined_date_and_time_representations

  "2007-04-05T14:30"

Well, wikipedia says, "Separating date and time parts with other
characters such as space is not allowed in ISO 8601, but allowed in its
profile RFC 3339".

Hmm.... yes it seems mentioned at the end of this paragraph:
<https://tools.ietf.org/html/rfc3339#section-5.6>:

      NOTE: ISO 8601 defines date and time separated by "T".
      Applications using this syntax may choose, for the sake of
      readability, to specify a full-date and full-time separated by
      (say) a space character.

I'm glad I'm not alone with the opinion that the "T" makes for a hard
reading.

Not sure if g_date_time_format_iso8601() supports RFC 3339 though.

> 
>>>          } else {
>>>              localfmt = g_strdup_printf("[ID: %08ld] %s", syscall(__NR_gettid),
>>>                                         fmt);
>>> @@ -3428,6 +3438,8 @@ int main(int argc, char *argv[])
>>>      struct lo_map_elem *reserve_elem;
>>>      int ret = -1;
>>>
>>> +    tzset();
>>> +
>>>      /* Don't mask creation mode, kernel already did that */
>>>      umask(0);
>>
>> The patch probably violates a bunch of QEMU standards (such as referring
>> to CLOCK_REALTIME, using localtime_r() which may not be available on
>> Windows (?), etc). I'm OK to carry it myself for debugging, I just
>> thought I'd ask for opinions.
> 
> I don't think any of those things are problems to stop a patch going in
> - virtiofsd is only built on Linux (I think) - if you send a patch that
> passes qemu's scripts/checkpatch.pl or has a reasonable reason why not
> then I'd be fine with that.

Should virtiofsd patches be cross-posted to this list and qemu-devel, or
posted just to this list (and then a maintainer submits a pull request
to qemu-devel later)?

Thanks!
Laszlo

