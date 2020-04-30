From: Max Reitz <mreitz@redhat.com>
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm> <20200429145720.GA2835@work-vm>
	<8c73f374-fcc8-1684-b581-84a9ab501aa9@redhat.com>
	<20200430085812.GC2874@work-vm>
	<94924861-d934-0151-aca5-19ea9eb211e1@redhat.com>
Message-ID: <7bca4d0d-5735-b8ca-4b30-21fc47f10c69@redhat.com>
Date: Thu, 30 Apr 2020 13:38:58 +0200
MIME-Version: 1.0
In-Reply-To: <94924861-d934-0151-aca5-19ea9eb211e1@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Cr0jppYxlnBJVPb5HB4AGEm5hfWattA5y"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Cr0jppYxlnBJVPb5HB4AGEm5hfWattA5y
Content-Type: multipart/mixed; boundary="2HNnvSZGdCtjcq5p8D5Jlv4N6PB4CzrpT"

--2HNnvSZGdCtjcq5p8D5Jlv4N6PB4CzrpT
Content-Type: multipart/mixed; boundary="------------2F7EFAE0B68055935B9B9592"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------2F7EFAE0B68055935B9B9592
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 30.04.20 11:21, Max Reitz wrote:
> On 30.04.20 10:58, Dr. David Alan Gilbert wrote:
>> * Max Reitz (mreitz@redhat.com) wrote:
>>> On 29.04.20 16:57, Dr. David Alan Gilbert wrote:
>>>> * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
>>>>> * Max Reitz (mreitz@redhat.com) wrote:
>>>>>> Currently, setup_mounts() bind-mounts the shared directory without=

>>>>>> MS_REC.  This makes all submounts disappear.
>>>>>>
>>>>>> Pass MS_REC so that the guest can see submounts again.
>>>>>
>>>>> Thanks!
>>>>>
>>>>>> Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
>>>>>
>>>>> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
>>>>>
>>>>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>>>>>> ---
>>>>>>  tools/virtiofsd/passthrough_ll.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/pa=
ssthrough_ll.c
>>>>>> index 4c35c95b25..9d7f863e66 100644
>>>>>> --- a/tools/virtiofsd/passthrough_ll.c
>>>>>> +++ b/tools/virtiofsd/passthrough_ll.c
>>>>>> @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)=

>>>>>>      int oldroot;
>>>>>>      int newroot;
>>>>>> =20
>>>>>> -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
>>>>>> +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) =
{
>>>>>>          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", so=
urce, source);
>>>>>>          exit(1);
>>>>>>      }
>>>>>
>>>>> Do we want MS_SLAVE to pick up future mounts that might happenf rom=
 the
>>>>> host?
>>>>> What's the interaction between this and the MS_REC|MS_SLAVE that we=
 have
>>>>> a few lines above for / ?
>>>>
>>>> Just to confirm something from vgoyal, and what had confused me abou=
t
>>>> why we hadn't spotted this earlier.
>>>>
>>>> Even without this patch, the SLAVE stuff worked so if you start the
>>>> daemon and *then* mount under the shared directory, the guest sees i=
t
>>>> with or without this patch.
>>>
>>> Hm, I don=E2=80=99t.  Do you really?
>>
>> Yes! With your patch reverted:
>>
>> Start virtiofsd, mount in the guest:
>>
>> host:
>> # ./virtiofsd --socket-path=3D/tmp/vhostqemu -o source=3D/home/dgilber=
t/virtio-fs/fs  -o log_level=3Dwarn -o no_writeback
>>
>> guest:
>> # mount -t virtiofs myfs /sysroot
>=20
> OK, for some reason I didn=E2=80=99t try to mount in the guest first, b=
ut did
> the host mount after starting virtiofsd.
>=20
> My mount test uses multiple mounts, and two of them I see mounted, but
> three I still don=E2=80=99t see mounted.

And if I do a find /sysroot (or find /mnt in my case) in the guest
before mounting anything on the host, the mounts don=E2=80=99t appear in =
the
guest at all, but that=E2=80=99s kind of a virtiofsd bug (or feature?).  =
That
is, if it has opened some directory before it became a mountpoint, then
it stays not-a-mountpoint.

> Let me see whether I can come up with something reproducible that isn=E2=
=80=99t
> a script.

Unfortunately, I can=E2=80=99t.  I=E2=80=99ve attached the script.

It launches qemu, then in the guest you have to mount =E2=80=9Chost=E2=80=
=9D somewhere
(before the script emits =E2=80=9Cmounting=E2=80=9D, ideally).

I can see that in the guest, mnt0-0 is mounted, and mnt0-0/sub is, too,
but mnt0-1 and mnt1 aren=E2=80=99t.

With this patch here, everything is mounted.

Max

--------------2F7EFAE0B68055935B9B9592
Content-Type: application/x-shellscript;
 name="test.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="test.sh"

IyEvYmluL3NoCgpzZXQgLWUKCiNzdWRvIHNoIC1jICcuL3ZpcnRpb2ZzZCAtLXNvY2tldC1w
YXRoPS90bXAvdmZzZHNvY2swIC1vIHNvdXJjZT0kUFdEL3ZpcnRpb2ZzLXNoYXJlZCAtbyBj
YWNoZT1hbHdheXMgLWYgJicKc3VkbyBzaCAtYyAnLi92aXJ0aW9mc2QgLS1zb2NrZXQtcGF0
aD0vdG1wL3Zmc2Rzb2NrMCAtbyBzb3VyY2U9JFBXRC92aXJ0aW9mcy1zaGFyZWQgLW8gbm9f
d3JpdGViYWNrICYnCgpzbGVlcCAxCgpzdWRvIGNobW9kIGdvK3J3IC90bXAvdmZzZHNvY2sw
CgojIFRPRE86IEFkZCB5b3VyIGFyZ3VtZW50cyB0byBydW4gc29tZSB0ZXN0IHN5c3RlbQp4
ODZfNjQtc29mdG1tdS9xZW11LXN5c3RlbS14ODZfNjQgXAogICAgLWFjY2VsIGt2bSAtbSA0
RyBcCiAgICAtY2hhcmRldiBzb2NrZXQsaWQ9dmZzZHNvY2swLHBhdGg9L3RtcC92ZnNkc29j
azAgXAogICAgLWRldmljZSB2aG9zdC11c2VyLWZzLXBjaSxxdWV1ZS1zaXplPTEwMjQsY2hh
cmRldj12ZnNkc29jazAsdGFnPWhvc3QgXAogICAgLW9iamVjdCBtZW1vcnktYmFja2VuZC1m
aWxlLGlkPW1lbSxzaXplPTRHLG1lbS1wYXRoPS9kZXYvc2htLHNoYXJlPW9uIFwKICAgIC1u
dW1hIG5vZGUsbWVtZGV2PW1lbSAmCgpzbGVlcCAxCgpybSAtZiBmczAuaW1nIGZzMS5pbWcg
ZnMyLmltZwoKdHJ1bmNhdGUgLXMgNTEyTSBmczAuaW1nCnRydW5jYXRlIC1zIDUxMk0gZnMx
LmltZwp0cnVuY2F0ZSAtcyA1MTJNIGZzMi5pbWcKCm1rZnMueGZzIC1xIGZzMC5pbWcKCnNs
ZWVwIDEKCnJtIC1mIGZzMC5pbWcgZnMxLmltZyBmczIuaW1nCgp0cnVuY2F0ZSAtcyA1MTJN
IGZzMC5pbWcKdHJ1bmNhdGUgLXMgNTEyTSBmczEuaW1nCnRydW5jYXRlIC1zIDUxMk0gZnMy
LmltZwoKbWtmcy54ZnMgLXEgZnMwLmltZwpta2ZzLnhmcyAtcSBmczEuaW1nCm1rZnMueGZz
IC1xIGZzMi5pbWcKCnN1ZG8gbWtkaXIgLXAgdmlydGlvZnMtc2hhcmVkL21udDAtMApzdWRv
IG1rZGlyIC1wIHZpcnRpb2ZzLXNoYXJlZC9tbnQwLTEKc3VkbyBta2RpciAtcCB2aXJ0aW9m
cy1zaGFyZWQvbW50MQoKc3VkbyB0b3VjaCB2aXJ0aW9mcy1zaGFyZWQvbW50MC0wLzAtMC1u
b3QtbW91bnRlZApzdWRvIHRvdWNoIHZpcnRpb2ZzLXNoYXJlZC9tbnQwLTEvMC0xLW5vdC1t
b3VudGVkCnN1ZG8gdG91Y2ggdmlydGlvZnMtc2hhcmVkL21udDEvMS1ub3QtbW91bnRlZAoK
Zm9yIGkgaW4gJChzZXEgMCA1OSk7IGRvCiAgICBlY2hvICJNb3VudGluZyBpbiAkKCg2MCAt
IGkpKSBzIgogICAgc2xlZXAgMQpkb25lCgpkZXYwPSQoc3VkbyBsb3NldHVwIC1mIC0tc2hv
dyBmczAuaW1nKQpkZXYxPSQoc3VkbyBsb3NldHVwIC1mIC0tc2hvdyBmczEuaW1nKQpkZXYy
PSQoc3VkbyBsb3NldHVwIC1mIC0tc2hvdyBmczIuaW1nKQoKc3VkbyBtb3VudCAiJGRldjAi
IHZpcnRpb2ZzLXNoYXJlZC9tbnQwLTAKc3VkbyB0b3VjaCB2aXJ0aW9mcy1zaGFyZWQvbW50
MC0wL2RldjAtbW91bnRlZApzdWRvIG1vdW50ICIkZGV2MCIgdmlydGlvZnMtc2hhcmVkL21u
dDAtMQoKc3VkbyBta2RpciAtcCB2aXJ0aW9mcy1zaGFyZWQvbW50MC0wL3N1YgpzdWRvIHRv
dWNoIHZpcnRpb2ZzLXNoYXJlZC9tbnQwLTAvc3ViL2RldjItbm90LW1vdW50ZWQKc3VkbyBt
b3VudCAiJGRldjIiIHZpcnRpb2ZzLXNoYXJlZC9tbnQwLTAvc3ViCnN1ZG8gdG91Y2ggdmly
dGlvZnMtc2hhcmVkL21udDAtMC9zdWIvZGV2Mi1tb3VudGVkCgpzdWRvIG1vdW50ICIkZGV2
MSIgdmlydGlvZnMtc2hhcmVkL21udDEKc3VkbyB0b3VjaCB2aXJ0aW9mcy1zaGFyZWQvbW50
MS9kZXYxLW1vdW50ZWQKCnN1ZG8gbWtkaXIgLXAgdmlydGlvZnMtc2hhcmVkL21udDEvc3Vi
MApzdWRvIHRvdWNoIHZpcnRpb2ZzLXNoYXJlZC9tbnQxL3N1YjAvZGV2Mi1ub3QtbW91bnRl
ZAoKc3VkbyBtb3VudCAiJGRldjAiIHZpcnRpb2ZzLXNoYXJlZC9tbnQxL3N1YjAKCmVjaG8g
J01vdW50ZWQnCgp3YWl0CgpzdWRvIHVtb3VudCB2aXJ0aW9mcy1zaGFyZWQvbW50MC0wL3N1
YgpzdWRvIHVtb3VudCB2aXJ0aW9mcy1zaGFyZWQvbW50MC0wCnN1ZG8gdW1vdW50IHZpcnRp
b2ZzLXNoYXJlZC9tbnQwLTEKc3VkbyB1bW91bnQgdmlydGlvZnMtc2hhcmVkL21udDEvc3Vi
MApzdWRvIHVtb3VudCB2aXJ0aW9mcy1zaGFyZWQvbW50MQoKc3VkbyBsb3NldHVwIC1kICIk
ZGV2MCIKc3VkbyBsb3NldHVwIC1kICIkZGV2MSIKc3VkbyBsb3NldHVwIC1kICIkZGV2MiIK

--------------2F7EFAE0B68055935B9B9592--

--2HNnvSZGdCtjcq5p8D5Jlv4N6PB4CzrpT--

--Cr0jppYxlnBJVPb5HB4AGEm5hfWattA5y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6quNIACgkQ9AfbAGHV
z0CtEwgAjk7iJ2ZogEkcbY0K65SNx4q99ZhXoMT35dqZpXXlDr+B6oW1oC6sDHVH
wkOli1vzer1cgrBITm/pfoC36dlX8WHZ+4s3/riMVoLJSRm5v62oSaQKrHj8jno6
EO8UQo09FBOKHjdjwELqeupXIyUP1oUSTfrm9Fb8czJ2INSr0khABX/KjUiA6130
XZQJLwPEccY+k0XiD7LUfUrMm87NFg2Bx9vJGbZzirHbc6391fA5doIklIAoONxP
OpQ5innr4IBjEh+qS7dzvoUggKPQ/j7ipxYsrOjLADWFyCvBnBUL4Ng8Hk4k5TvH
CGgJvV6U/GY15OIgHVVj8NMFqwsBcQ==
=KHxH
-----END PGP SIGNATURE-----

--Cr0jppYxlnBJVPb5HB4AGEm5hfWattA5y--

