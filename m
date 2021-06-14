From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <YMOPM87ZdWWQOUsR@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
	=?utf-8?Q?=C3=A9=22's?= message of
	"Fri, 11 Jun 2021 17:28:35 +0100")
References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-4-berrange@redhat.com>
	<YMOPM87ZdWWQOUsR@redhat.com>
Date: Mon, 14 Jun 2021 18:43:00 +0200
Message-ID: <87a6nsgzxn.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 3/7] net/rocker: use GDateTime for
 formatting timestamp in debug messages
Reply-To: quintela@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Daniel P. =?utf-8?Q?Berrang=C3=A9?=" <berrange@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, Max Reitz <mreitz@redhat.com>, Brad Smith <brad@comstyle.com>

Daniel P. Berrangé <berrange@redhat.com> wrote:
> ping: anyone willing to give a review of this one
>
> On Wed, May 05, 2021 at 11:36:58AM +0100, Daniel P. Berrangé wrote:
>> The GDateTime APIs provided by GLib avoid portability pitfalls, such
>> as some platforms where 'struct timeval.tv_sec' field is still 'long'
>> instead of 'time_t'. When combined with automatic cleanup, GDateTime
>> often results in simpler code too.
>> 
>> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
>> ---
>>  hw/net/rocker/rocker.h | 11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>> 
>> diff --git a/hw/net/rocker/rocker.h b/hw/net/rocker/rocker.h
>> index 941c932265..412fa44d01 100644
>> --- a/hw/net/rocker/rocker.h
>> +++ b/hw/net/rocker/rocker.h
>> @@ -25,14 +25,9 @@
>>  #if defined(DEBUG_ROCKER)
>>  #  define DPRINTF(fmt, ...) \
>>      do {                                                           \
>> -        struct timeval tv;                                         \
>> -        char timestr[64];                                          \
>> -        time_t now;                                                \
>> -        gettimeofday(&tv, NULL);                                   \
>> -        now = tv.tv_sec;                                           \
>> -        strftime(timestr, sizeof(timestr), "%T", localtime(&now)); \
>> -        fprintf(stderr, "%s.%06ld ", timestr, tv.tv_usec);         \
>> -        fprintf(stderr, "ROCKER: " fmt, ## __VA_ARGS__);           \
>> +        g_autoptr(GDateTime) now = g_date_time_new_now_local();    \
>> +        g_autofree char *nowstr = g_date_time_format(now, "%T.%f");\
>> +        fprintf(stderr, "%s ROCKER: " fmt, nowstr, ## __VA_ARGS__);\
>>      } while (0)
>>  #else
>>  static inline GCC_FMT_ATTR(1, 2) int DPRINTF(const char *fmt, ...)

Reviewed-by: Juan Quintela <quintela@redhat.com>


