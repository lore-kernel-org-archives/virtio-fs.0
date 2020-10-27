MIME-Version: 1.0
References: <20201027085046.78098-1-stefanha@redhat.com>
In-Reply-To: <20201027085046.78098-1-stefanha@redhat.com>
From: Gal Hammer <ghammer@redhat.com>
Date: Tue, 27 Oct 2020 10:54:15 +0200
Message-ID: <CAA2ifQx7MS-r1RgsUc3AX+U6v+5Ben3thg4z-R4zM4CPSsmECw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000bf061b05b2a33119"
Subject: Re: [Virtio-fs] [PATCH virtio-fs.gitlab.io] Add CC-BY-SA-4.0 license
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

--000000000000bf061b05b2a33119
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Gal Hammer <ghammer@redhat.com>


On Tue, 27 Oct 2020 at 10:50, Stefan Hajnoczi <stefanha@redhat.com> wrote:

> There was no explicit license on the website (images, HTML, CSS, etc).
>
> Let's use the Creative Commons Attribution-ShareAlike 4.0 International
> license. The human-readable summary of the license follows.
>
>   You are free to:
>    * Share - copy and redistribute the material in any medium or format
>    * Adapt - remix, transform, and build upon the material for any
>      purpose, even commercially.
>
>   The licensor cannot revoke these freedoms as long as you follow the
>   license terms.
>
>   Under the following terms:
>    * Attribution - You must give appropriate credit, provide a link to
>      the license, and indicate if changes were made. You may do so in
>      any reasonable manner, but not in any way that suggests the
>      licensor endorses you or your use.
>
>    * ShareAlike - If you remix, transform, or build upon the material,
>      you must distribute your contributions under the same license as
>      the original.
>
>    * No additional restrictions - You may not apply legal terms or
>      technological measures that legally restrict others from doing
>      anything the license permits.
>
> This patch adds the full license text in the COPYING file and places a
> footer with the link to the license at the bottom of every web page.
>
> Reported-by: Fotis Xenakis <foxen@windowslive.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> Dave and Gal: Please post your Acked-by or Reviewed-by to confirm that
> you are placing your contributions under this license.
> ---
>  COPYING                   | 428 ++++++++++++++++++++++++++++++++++++++
>  public/design.html        |   4 +
>  public/howto-boot.html    |   4 +
>  public/howto-kata.html    |   4 +
>  public/howto-qemu.html    |   3 +
>  public/howto-windows.html |   4 +
>  public/index.html         |   4 +
>  public/style.css          |  17 ++
>  8 files changed, 468 insertions(+)
>  create mode 100644 COPYING
>
> diff --git a/COPYING b/COPYING
> new file mode 100644
> index 0000000..a73481c
> --- /dev/null
> +++ b/COPYING
> @@ -0,0 +1,428 @@
> +Attribution-ShareAlike 4.0 International
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Creative Commons Corporation ("Creative Commons") is not a law firm and
> +does not provide legal services or legal advice. Distribution of
> +Creative Commons public licenses does not create a lawyer-client or
> +other relationship. Creative Commons makes its licenses and related
> +information available on an "as-is" basis. Creative Commons gives no
> +warranties regarding its licenses, any material licensed under their
> +terms and conditions, or any related information. Creative Commons
> +disclaims all liability for damages resulting from their use to the
> +fullest extent possible.
> +
> +Using Creative Commons Public Licenses
> +
> +Creative Commons public licenses provide a standard set of terms and
> +conditions that creators and other rights holders may use to share
> +original works of authorship and other material subject to copyright
> +and certain other rights specified in the public license below. The
> +following considerations are for informational purposes only, are not
> +exhaustive, and do not form part of our licenses.
> +
> +     Considerations for licensors: Our public licenses are
> +     intended for use by those authorized to give the public
> +     permission to use material in ways otherwise restricted by
> +     copyright and certain other rights. Our licenses are
> +     irrevocable. Licensors should read and understand the terms
> +     and conditions of the license they choose before applying it.
> +     Licensors should also secure all rights necessary before
> +     applying our licenses so that the public can reuse the
> +     material as expected. Licensors should clearly mark any
> +     material not subject to the license. This includes other CC-
> +     licensed material, or material used under an exception or
> +     limitation to copyright. More considerations for licensors:
> +    wiki.creativecommons.org/Considerations_for_licensors
> +
> +     Considerations for the public: By using one of our public
> +     licenses, a licensor grants the public permission to use the
> +     licensed material under specified terms and conditions. If
> +     the licensor's permission is not necessary for any reason--for
> +     example, because of any applicable exception or limitation to
> +     copyright--then that use is not regulated by the license. Our
> +     licenses grant only permissions under copyright and certain
> +     other rights that a licensor has authority to grant. Use of
> +     the licensed material may still be restricted for other
> +     reasons, including because others have copyright or other
> +     rights in the material. A licensor may make special requests,
> +     such as asking that all changes be marked or described.
> +     Although not required by our licenses, you are encouraged to
> +     respect those requests where reasonable. More considerations
> +     for the public:
> +    wiki.creativecommons.org/Considerations_for_licensees
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Creative Commons Attribution-ShareAlike 4.0 International Public
> +License
> +
> +By exercising the Licensed Rights (defined below), You accept and agree
> +to be bound by the terms and conditions of this Creative Commons
> +Attribution-ShareAlike 4.0 International Public License ("Public
> +License"). To the extent this Public License may be interpreted as a
> +contract, You are granted the Licensed Rights in consideration of Your
> +acceptance of these terms and conditions, and the Licensor grants You
> +such rights in consideration of benefits the Licensor receives from
> +making the Licensed Material available under these terms and
> +conditions.
> +
> +
> +Section 1 -- Definitions.
> +
> +  a. Adapted Material means material subject to Copyright and Similar
> +     Rights that is derived from or based upon the Licensed Material
> +     and in which the Licensed Material is translated, altered,
> +     arranged, transformed, or otherwise modified in a manner requiring
> +     permission under the Copyright and Similar Rights held by the
> +     Licensor. For purposes of this Public License, where the Licensed
> +     Material is a musical work, performance, or sound recording,
> +     Adapted Material is always produced where the Licensed Material is
> +     synched in timed relation with a moving image.
> +
> +  b. Adapter's License means the license You apply to Your Copyright
> +     and Similar Rights in Your contributions to Adapted Material in
> +     accordance with the terms and conditions of this Public License.
> +
> +  c. BY-SA Compatible License means a license listed at
> +     creativecommons.org/compatiblelicenses, approved by Creative
> +     Commons as essentially the equivalent of this Public License.
> +
> +  d. Copyright and Similar Rights means copyright and/or similar rights
> +     closely related to copyright including, without limitation,
> +     performance, broadcast, sound recording, and Sui Generis Database
> +     Rights, without regard to how the rights are labeled or
> +     categorized. For purposes of this Public License, the rights
> +     specified in Section 2(b)(1)-(2) are not Copyright and Similar
> +     Rights.
> +
> +  e. Effective Technological Measures means those measures that, in the
> +     absence of proper authority, may not be circumvented under laws
> +     fulfilling obligations under Article 11 of the WIPO Copyright
> +     Treaty adopted on December 20, 1996, and/or similar international
> +     agreements.
> +
> +  f. Exceptions and Limitations means fair use, fair dealing, and/or
> +     any other exception or limitation to Copyright and Similar Rights
> +     that applies to Your use of the Licensed Material.
> +
> +  g. License Elements means the license attributes listed in the name
> +     of a Creative Commons Public License. The License Elements of this
> +     Public License are Attribution and ShareAlike.
> +
> +  h. Licensed Material means the artistic or literary work, database,
> +     or other material to which the Licensor applied this Public
> +     License.
> +
> +  i. Licensed Rights means the rights granted to You subject to the
> +     terms and conditions of this Public License, which are limited to
> +     all Copyright and Similar Rights that apply to Your use of the
> +     Licensed Material and that the Licensor has authority to license.
> +
> +  j. Licensor means the individual(s) or entity(ies) granting rights
> +     under this Public License.
> +
> +  k. Share means to provide material to the public by any means or
> +     process that requires permission under the Licensed Rights, such
> +     as reproduction, public display, public performance, distribution,
> +     dissemination, communication, or importation, and to make material
> +     available to the public including in ways that members of the
> +     public may access the material from a place and at a time
> +     individually chosen by them.
> +
> +  l. Sui Generis Database Rights means rights other than copyright
> +     resulting from Directive 96/9/EC of the European Parliament and of
> +     the Council of 11 March 1996 on the legal protection of databases,
> +     as amended and/or succeeded, as well as other essentially
> +     equivalent rights anywhere in the world.
> +
> +  m. You means the individual or entity exercising the Licensed Rights
> +     under this Public License. Your has a corresponding meaning.
> +
> +
> +Section 2 -- Scope.
> +
> +  a. License grant.
> +
> +       1. Subject to the terms and conditions of this Public License,
> +          the Licensor hereby grants You a worldwide, royalty-free,
> +          non-sublicensable, non-exclusive, irrevocable license to
> +          exercise the Licensed Rights in the Licensed Material to:
> +
> +            a. reproduce and Share the Licensed Material, in whole or
> +               in part; and
> +
> +            b. produce, reproduce, and Share Adapted Material.
> +
> +       2. Exceptions and Limitations. For the avoidance of doubt, where
> +          Exceptions and Limitations apply to Your use, this Public
> +          License does not apply, and You do not need to comply with
> +          its terms and conditions.
> +
> +       3. Term. The term of this Public License is specified in Section
> +          6(a).
> +
> +       4. Media and formats; technical modifications allowed. The
> +          Licensor authorizes You to exercise the Licensed Rights in
> +          all media and formats whether now known or hereafter created,
> +          and to make technical modifications necessary to do so. The
> +          Licensor waives and/or agrees not to assert any right or
> +          authority to forbid You from making technical modifications
> +          necessary to exercise the Licensed Rights, including
> +          technical modifications necessary to circumvent Effective
> +          Technological Measures. For purposes of this Public License,
> +          simply making modifications authorized by this Section 2(a)
> +          (4) never produces Adapted Material.
> +
> +       5. Downstream recipients.
> +
> +            a. Offer from the Licensor -- Licensed Material. Every
> +               recipient of the Licensed Material automatically
> +               receives an offer from the Licensor to exercise the
> +               Licensed Rights under the terms and conditions of this
> +               Public License.
> +
> +            b. Additional offer from the Licensor -- Adapted Material.
> +               Every recipient of Adapted Material from You
> +               automatically receives an offer from the Licensor to
> +               exercise the Licensed Rights in the Adapted Material
> +               under the conditions of the Adapter's License You apply.
> +
> +            c. No downstream restrictions. You may not offer or impose
> +               any additional or different terms or conditions on, or
> +               apply any Effective Technological Measures to, the
> +               Licensed Material if doing so restricts exercise of the
> +               Licensed Rights by any recipient of the Licensed
> +               Material.
> +
> +       6. No endorsement. Nothing in this Public License constitutes or
> +          may be construed as permission to assert or imply that You
> +          are, or that Your use of the Licensed Material is, connected
> +          with, or sponsored, endorsed, or granted official status by,
> +          the Licensor or others designated to receive attribution as
> +          provided in Section 3(a)(1)(A)(i).
> +
> +  b. Other rights.
> +
> +       1. Moral rights, such as the right of integrity, are not
> +          licensed under this Public License, nor are publicity,
> +          privacy, and/or other similar personality rights; however, to
> +          the extent possible, the Licensor waives and/or agrees not to
> +          assert any such rights held by the Licensor to the limited
> +          extent necessary to allow You to exercise the Licensed
> +          Rights, but not otherwise.
> +
> +       2. Patent and trademark rights are not licensed under this
> +          Public License.
> +
> +       3. To the extent possible, the Licensor waives any right to
> +          collect royalties from You for the exercise of the Licensed
> +          Rights, whether directly or through a collecting society
> +          under any voluntary or waivable statutory or compulsory
> +          licensing scheme. In all other cases the Licensor expressly
> +          reserves any right to collect such royalties.
> +
> +
> +Section 3 -- License Conditions.
> +
> +Your exercise of the Licensed Rights is expressly made subject to the
> +following conditions.
> +
> +  a. Attribution.
> +
> +       1. If You Share the Licensed Material (including in modified
> +          form), You must:
> +
> +            a. retain the following if it is supplied by the Licensor
> +               with the Licensed Material:
> +
> +                 i. identification of the creator(s) of the Licensed
> +                    Material and any others designated to receive
> +                    attribution, in any reasonable manner requested by
> +                    the Licensor (including by pseudonym if
> +                    designated);
> +
> +                ii. a copyright notice;
> +
> +               iii. a notice that refers to this Public License;
> +
> +                iv. a notice that refers to the disclaimer of
> +                    warranties;
> +
> +                 v. a URI or hyperlink to the Licensed Material to the
> +                    extent reasonably practicable;
> +
> +            b. indicate if You modified the Licensed Material and
> +               retain an indication of any previous modifications; and
> +
> +            c. indicate the Licensed Material is licensed under this
> +               Public License, and include the text of, or the URI or
> +               hyperlink to, this Public License.
> +
> +       2. You may satisfy the conditions in Section 3(a)(1) in any
> +          reasonable manner based on the medium, means, and context in
> +          which You Share the Licensed Material. For example, it may be
> +          reasonable to satisfy the conditions by providing a URI or
> +          hyperlink to a resource that includes the required
> +          information.
> +
> +       3. If requested by the Licensor, You must remove any of the
> +          information required by Section 3(a)(1)(A) to the extent
> +          reasonably practicable.
> +
> +  b. ShareAlike.
> +
> +     In addition to the conditions in Section 3(a), if You Share
> +     Adapted Material You produce, the following conditions also apply.
> +
> +       1. The Adapter's License You apply must be a Creative Commons
> +          license with the same License Elements, this version or
> +          later, or a BY-SA Compatible License.
> +
> +       2. You must include the text of, or the URI or hyperlink to, the
> +          Adapter's License You apply. You may satisfy this condition
> +          in any reasonable manner based on the medium, means, and
> +          context in which You Share Adapted Material.
> +
> +       3. You may not offer or impose any additional or different terms
> +          or conditions on, or apply any Effective Technological
> +          Measures to, Adapted Material that restrict exercise of the
> +          rights granted under the Adapter's License You apply.
> +
> +
> +Section 4 -- Sui Generis Database Rights.
> +
> +Where the Licensed Rights include Sui Generis Database Rights that
> +apply to Your use of the Licensed Material:
> +
> +  a. for the avoidance of doubt, Section 2(a)(1) grants You the right
> +     to extract, reuse, reproduce, and Share all or a substantial
> +     portion of the contents of the database;
> +
> +  b. if You include all or a substantial portion of the database
> +     contents in a database in which You have Sui Generis Database
> +     Rights, then the database in which You have Sui Generis Database
> +     Rights (but not its individual contents) is Adapted Material,
> +
> +     including for purposes of Section 3(b); and
> +  c. You must comply with the conditions in Section 3(a) if You Share
> +     all or a substantial portion of the contents of the database.
> +
> +For the avoidance of doubt, this Section 4 supplements and does not
> +replace Your obligations under this Public License where the Licensed
> +Rights include other Copyright and Similar Rights.
> +
> +
> +Section 5 -- Disclaimer of Warranties and Limitation of Liability.
> +
> +  a. UNLESS OTHERWISE SEPARATELY UNDERTAKEN BY THE LICENSOR, TO THE
> +     EXTENT POSSIBLE, THE LICENSOR OFFERS THE LICENSED MATERIAL AS-IS
> +     AND AS-AVAILABLE, AND MAKES NO REPRESENTATIONS OR WARRANTIES OF
> +     ANY KIND CONCERNING THE LICENSED MATERIAL, WHETHER EXPRESS,
> +     IMPLIED, STATUTORY, OR OTHER. THIS INCLUDES, WITHOUT LIMITATION,
> +     WARRANTIES OF TITLE, MERCHANTABILITY, FITNESS FOR A PARTICULAR
> +     PURPOSE, NON-INFRINGEMENT, ABSENCE OF LATENT OR OTHER DEFECTS,
> +     ACCURACY, OR THE PRESENCE OR ABSENCE OF ERRORS, WHETHER OR NOT
> +     KNOWN OR DISCOVERABLE. WHERE DISCLAIMERS OF WARRANTIES ARE NOT
> +     ALLOWED IN FULL OR IN PART, THIS DISCLAIMER MAY NOT APPLY TO YOU.
> +
> +  b. TO THE EXTENT POSSIBLE, IN NO EVENT WILL THE LICENSOR BE LIABLE
> +     TO YOU ON ANY LEGAL THEORY (INCLUDING, WITHOUT LIMITATION,
> +     NEGLIGENCE) OR OTHERWISE FOR ANY DIRECT, SPECIAL, INDIRECT,
> +     INCIDENTAL, CONSEQUENTIAL, PUNITIVE, EXEMPLARY, OR OTHER LOSSES,
> +     COSTS, EXPENSES, OR DAMAGES ARISING OUT OF THIS PUBLIC LICENSE OR
> +     USE OF THE LICENSED MATERIAL, EVEN IF THE LICENSOR HAS BEEN
> +     ADVISED OF THE POSSIBILITY OF SUCH LOSSES, COSTS, EXPENSES, OR
> +     DAMAGES. WHERE A LIMITATION OF LIABILITY IS NOT ALLOWED IN FULL OR
> +     IN PART, THIS LIMITATION MAY NOT APPLY TO YOU.
> +
> +  c. The disclaimer of warranties and limitation of liability provided
> +     above shall be interpreted in a manner that, to the extent
> +     possible, most closely approximates an absolute disclaimer and
> +     waiver of all liability.
> +
> +
> +Section 6 -- Term and Termination.
> +
> +  a. This Public License applies for the term of the Copyright and
> +     Similar Rights licensed here. However, if You fail to comply with
> +     this Public License, then Your rights under this Public License
> +     terminate automatically.
> +
> +  b. Where Your right to use the Licensed Material has terminated under
> +     Section 6(a), it reinstates:
> +
> +       1. automatically as of the date the violation is cured, provided
> +          it is cured within 30 days of Your discovery of the
> +          violation; or
> +
> +       2. upon express reinstatement by the Licensor.
> +
> +     For the avoidance of doubt, this Section 6(b) does not affect any
> +     right the Licensor may have to seek remedies for Your violations
> +     of this Public License.
> +
> +  c. For the avoidance of doubt, the Licensor may also offer the
> +     Licensed Material under separate terms or conditions or stop
> +     distributing the Licensed Material at any time; however, doing so
> +     will not terminate this Public License.
> +
> +  d. Sections 1, 5, 6, 7, and 8 survive termination of this Public
> +     License.
> +
> +
> +Section 7 -- Other Terms and Conditions.
> +
> +  a. The Licensor shall not be bound by any additional or different
> +     terms or conditions communicated by You unless expressly agreed.
> +
> +  b. Any arrangements, understandings, or agreements regarding the
> +     Licensed Material not stated herein are separate from and
> +     independent of the terms and conditions of this Public License.
> +
> +
> +Section 8 -- Interpretation.
> +
> +  a. For the avoidance of doubt, this Public License does not, and
> +     shall not be interpreted to, reduce, limit, restrict, or impose
> +     conditions on any use of the Licensed Material that could lawfully
> +     be made without permission under this Public License.
> +
> +  b. To the extent possible, if any provision of this Public License is
> +     deemed unenforceable, it shall be automatically reformed to the
> +     minimum extent necessary to make it enforceable. If the provision
> +     cannot be reformed, it shall be severed from this Public License
> +     without affecting the enforceability of the remaining terms and
> +     conditions.
> +
> +  c. No term or condition of this Public License will be waived and no
> +     failure to comply consented to unless expressly agreed to by the
> +     Licensor.
> +
> +  d. Nothing in this Public License constitutes or may be interpreted
> +     as a limitation upon, or waiver of, any privileges and immunities
> +     that apply to the Licensor or You, including from the legal
> +     processes of any jurisdiction or authority.
> +
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Creative Commons is not a party to its public
> +licenses. Notwithstanding, Creative Commons may elect to apply one of
> +its public licenses to material it publishes and in those instances
> +will be considered the =E2=80=9CLicensor.=E2=80=9D The text of the Creat=
ive Commons
> +public licenses is dedicated to the public domain under the CC0 Public
> +Domain Dedication. Except for the limited purpose of indicating that
> +material is shared under a Creative Commons public license or as
> +otherwise permitted by the Creative Commons policies published at
> +creativecommons.org/policies, Creative Commons does not authorize the
> +use of the trademark "Creative Commons" or any other trademark or logo
> +of Creative Commons without its prior written consent including,
> +without limitation, in connection with any unauthorized modifications
> +to any of its public licenses or any other arrangements,
> +understandings, or agreements concerning use of licensed material. For
> +the avoidance of doubt, this paragraph does not form part of the
> +public licenses.
> +
> +Creative Commons may be contacted at creativecommons.org.
> +
> diff --git a/public/design.html b/public/design.html
> index c05f20d..76dc564 100644
> --- a/public/design.html
> +++ b/public/design.html
> @@ -167,5 +167,9 @@
>      <p>The vhost-user device backend implements the bulk of virtio-fs.
> It is
>      possible to use the vhost-user device backend with any hypervisor th=
at
>      supports the vhost-user interface.</p>
> +
> +    <div class=3D"footer">
> +        <p>This website is published under the <a href=3D"
> https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons
> Attribution-ShareAlike 4.0 International</a> license. The source code is
> available <a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/
> ">here</a>.</p>
> +    </div>
>    </body>
>  </html>
> diff --git a/public/howto-boot.html b/public/howto-boot.html
> index f4eda4b..976cedc 100644
> --- a/public/howto-boot.html
> +++ b/public/howto-boot.html
> @@ -66,6 +66,10 @@
>      <p>This assumes you are using a monolithic kernel.  Use of an
> initramfs has not been tested and may require further steps.</p>
>
>      <p>For details on launching QEMU, see the <a
> href=3D"/howto-qemu.html">QEMU HowTo</a>.</p>
> +
> +    <div class=3D"footer">
> +        <p>This website is published under the <a href=3D"
> https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons
> Attribution-ShareAlike 4.0 International</a> license. The source code is
> available <a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/
> ">here</a>.</p>
> +    </div>
>    </body>
>  </html>
>
> diff --git a/public/howto-kata.html b/public/howto-kata.html
> index dfa4059..295c851 100644
> --- a/public/howto-kata.html
> +++ b/public/howto-kata.html
> @@ -228,6 +228,10 @@ ExecStart=3D/usr/bin/dockerd-current -D \
>      <h2>Running containers</h2>
>      <p>Launch a container:</p>
>      <pre>docker run --runtime kata-runtime -it busybox sh</pre>
> +
> +    <div class=3D"footer">
> +        <p>This website is published under the <a href=3D"
> https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons
> Attribution-ShareAlike 4.0 International</a> license. The source code is
> available <a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/
> ">here</a>.</p>
> +    </div>
>    </body>
>  </html>
>
> diff --git a/public/howto-qemu.html b/public/howto-qemu.html
> index 3969927..9cd90fb 100644
> --- a/public/howto-qemu.html
> +++ b/public/howto-qemu.html
> @@ -214,6 +214,9 @@ tree by:
>
>     The mount options are unchanged.
>
> +<div class=3D"footer">
> +    <p>This website is published under the <a href=3D"
> https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons
> Attribution-ShareAlike 4.0 International</a> license. The source code is
> available <a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/
> ">here</a>.</p>
> +</div>
>  </body>
>  </html>
>
> diff --git a/public/howto-windows.html b/public/howto-windows.html
> index d9415b5..89214b9 100644
> --- a/public/howto-windows.html
> +++ b/public/howto-windows.html
> @@ -88,5 +88,9 @@
>          Z: and downward. Use the "-m" command line parameter to explicit=
ly
>          select a drive letter.
>      </p>
> +
> +    <div class=3D"footer">
> +        <p>This website is published under the <a href=3D"
> https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons
> Attribution-ShareAlike 4.0 International</a> license. The source code is
> available <a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/
> ">here</a>.</p>
> +    </div>
>    </body>
>  </html>
> diff --git a/public/index.html b/public/index.html
> index f9f499e..28ce838 100644
> --- a/public/index.html
> +++ b/public/index.html
> @@ -111,6 +111,10 @@
>        operations.  Virtual machines refresh metadata when the version
> number
>        has changed since they last cached a copy.
>      </p>
> +
> +    <div class=3D"footer">
> +        <p>This website is published under the <a href=3D"
> https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons
> Attribution-ShareAlike 4.0 International</a> license. The source code is
> available <a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/
> ">here</a>.</p>
> +    </div>
>    </body>
>  </html>
>
> diff --git a/public/style.css b/public/style.css
> index 0e15f11..689728d 100644
> --- a/public/style.css
> +++ b/public/style.css
> @@ -33,3 +33,20 @@ pre {
>      width: 446px;
>      height: 238px;
>  }
> +
> +.footer {
> +  background-color: #313236;
> +  max-width: 800px;
> +  padding: 10px;
> +  color: #ddd;
> +  font-size: 12px;
> +}
> +
> +.footer a {
> +  color: #aaa;
> +  text-decoration: none;
> +}
> +
> +.footer a:hover {
> +  color: #fff;
> +}
> --
> 2.26.2
>
>

--000000000000bf061b05b2a33119
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:verdana,=
sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family:ver=
dana,sans-serif">
Reviewed-by: Gal Hammer &lt;<a href=3D"mailto:ghammer@redhat.com">ghammer@r=
edhat.com</a>&gt;</div><div class=3D"gmail_default" style=3D"font-family:ve=
rdana,sans-serif"><br></div></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Tue, 27 Oct 2020 at 10:50, Stefan Hajnoczi=
 &lt;<a href=3D"mailto:stefanha@redhat.com">stefanha@redhat.com</a>&gt; wro=
te:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">There was no=
 explicit license on the website (images, HTML, CSS, etc).<br>
<br>
Let&#39;s use the Creative Commons Attribution-ShareAlike 4.0 International=
<br>
license. The human-readable summary of the license follows.<br>
<br>
=C2=A0 You are free to:<br>
=C2=A0 =C2=A0* Share - copy and redistribute the material in any medium or =
format<br>
=C2=A0 =C2=A0* Adapt - remix, transform, and build upon the material for an=
y<br>
=C2=A0 =C2=A0 =C2=A0purpose, even commercially.<br>
<br>
=C2=A0 The licensor cannot revoke these freedoms as long as you follow the<=
br>
=C2=A0 license terms.<br>
<br>
=C2=A0 Under the following terms:<br>
=C2=A0 =C2=A0* Attribution - You must give appropriate credit, provide a li=
nk to<br>
=C2=A0 =C2=A0 =C2=A0the license, and indicate if changes were made. You may=
 do so in<br>
=C2=A0 =C2=A0 =C2=A0any reasonable manner, but not in any way that suggests=
 the<br>
=C2=A0 =C2=A0 =C2=A0licensor endorses you or your use.<br>
<br>
=C2=A0 =C2=A0* ShareAlike - If you remix, transform, or build upon the mate=
rial,<br>
=C2=A0 =C2=A0 =C2=A0you must distribute your contributions under the same l=
icense as<br>
=C2=A0 =C2=A0 =C2=A0the original.<br>
<br>
=C2=A0 =C2=A0* No additional restrictions - You may not apply legal terms o=
r<br>
=C2=A0 =C2=A0 =C2=A0technological measures that legally restrict others fro=
m doing<br>
=C2=A0 =C2=A0 =C2=A0anything the license permits.<br>
<br>
This patch adds the full license text in the COPYING file and places a<br>
footer with the link to the license at the bottom of every web page.<br>
<br>
Reported-by: Fotis Xenakis &lt;<a href=3D"mailto:foxen@windowslive.com" tar=
get=3D"_blank">foxen@windowslive.com</a>&gt;<br>
Signed-off-by: Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.com" t=
arget=3D"_blank">stefanha@redhat.com</a>&gt;<br>
---<br>
Dave and Gal: Please post your Acked-by or Reviewed-by to confirm that<br>
you are placing your contributions under this license.<br>
---<br>
=C2=A0COPYING=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0| 428 ++++++++++++++++++++++++++++++++++++++<br>
=C2=A0public/design.html=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +<br>
=C2=A0public/howto-boot.html=C2=A0 =C2=A0 |=C2=A0 =C2=A04 +<br>
=C2=A0public/howto-kata.html=C2=A0 =C2=A0 |=C2=A0 =C2=A04 +<br>
=C2=A0public/howto-qemu.html=C2=A0 =C2=A0 |=C2=A0 =C2=A03 +<br>
=C2=A0public/howto-windows.html |=C2=A0 =C2=A04 +<br>
=C2=A0public/index.html=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A04 +<=
br>
=C2=A0public/style.css=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 17 ++<br>
=C2=A08 files changed, 468 insertions(+)<br>
=C2=A0create mode 100644 COPYING<br>
<br>
diff --git a/COPYING b/COPYING<br>
new file mode 100644<br>
index 0000000..a73481c<br>
--- /dev/null<br>
+++ b/COPYING<br>
@@ -0,0 +1,428 @@<br>
+Attribution-ShareAlike 4.0 International<br>
+<br>
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
+<br>
+Creative Commons Corporation (&quot;Creative Commons&quot;) is not a law f=
irm and<br>
+does not provide legal services or legal advice. Distribution of<br>
+Creative Commons public licenses does not create a lawyer-client or<br>
+other relationship. Creative Commons makes its licenses and related<br>
+information available on an &quot;as-is&quot; basis. Creative Commons give=
s no<br>
+warranties regarding its licenses, any material licensed under their<br>
+terms and conditions, or any related information. Creative Commons<br>
+disclaims all liability for damages resulting from their use to the<br>
+fullest extent possible.<br>
+<br>
+Using Creative Commons Public Licenses<br>
+<br>
+Creative Commons public licenses provide a standard set of terms and<br>
+conditions that creators and other rights holders may use to share<br>
+original works of authorship and other material subject to copyright<br>
+and certain other rights specified in the public license below. The<br>
+following considerations are for informational purposes only, are not<br>
+exhaustive, and do not form part of our licenses.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0Considerations for licensors: Our public licenses are<=
br>
+=C2=A0 =C2=A0 =C2=A0intended for use by those authorized to give the publi=
c<br>
+=C2=A0 =C2=A0 =C2=A0permission to use material in ways otherwise restricte=
d by<br>
+=C2=A0 =C2=A0 =C2=A0copyright and certain other rights. Our licenses are<b=
r>
+=C2=A0 =C2=A0 =C2=A0irrevocable. Licensors should read and understand the =
terms<br>
+=C2=A0 =C2=A0 =C2=A0and conditions of the license they choose before apply=
ing it.<br>
+=C2=A0 =C2=A0 =C2=A0Licensors should also secure all rights necessary befo=
re<br>
+=C2=A0 =C2=A0 =C2=A0applying our licenses so that the public can reuse the=
<br>
+=C2=A0 =C2=A0 =C2=A0material as expected. Licensors should clearly mark an=
y<br>
+=C2=A0 =C2=A0 =C2=A0material not subject to the license. This includes oth=
er CC-<br>
+=C2=A0 =C2=A0 =C2=A0licensed material, or material used under an exception=
 or<br>
+=C2=A0 =C2=A0 =C2=A0limitation to copyright. More considerations for licen=
sors:<br>
+=C2=A0 =C2=A0 <a href=3D"http://wiki.creativecommons.org/Considerations_fo=
r_licensors" rel=3D"noreferrer" target=3D"_blank">wiki.creativecommons.org/=
Considerations_for_licensors</a><br>
+<br>
+=C2=A0 =C2=A0 =C2=A0Considerations for the public: By using one of our pub=
lic<br>
+=C2=A0 =C2=A0 =C2=A0licenses, a licensor grants the public permission to u=
se the<br>
+=C2=A0 =C2=A0 =C2=A0licensed material under specified terms and conditions=
. If<br>
+=C2=A0 =C2=A0 =C2=A0the licensor&#39;s permission is not necessary for any=
 reason--for<br>
+=C2=A0 =C2=A0 =C2=A0example, because of any applicable exception or limita=
tion to<br>
+=C2=A0 =C2=A0 =C2=A0copyright--then that use is not regulated by the licen=
se. Our<br>
+=C2=A0 =C2=A0 =C2=A0licenses grant only permissions under copyright and ce=
rtain<br>
+=C2=A0 =C2=A0 =C2=A0other rights that a licensor has authority to grant. U=
se of<br>
+=C2=A0 =C2=A0 =C2=A0the licensed material may still be restricted for othe=
r<br>
+=C2=A0 =C2=A0 =C2=A0reasons, including because others have copyright or ot=
her<br>
+=C2=A0 =C2=A0 =C2=A0rights in the material. A licensor may make special re=
quests,<br>
+=C2=A0 =C2=A0 =C2=A0such as asking that all changes be marked or described=
.<br>
+=C2=A0 =C2=A0 =C2=A0Although not required by our licenses, you are encoura=
ged to<br>
+=C2=A0 =C2=A0 =C2=A0respect those requests where reasonable. More consider=
ations<br>
+=C2=A0 =C2=A0 =C2=A0for the public:<br>
+=C2=A0 =C2=A0 <a href=3D"http://wiki.creativecommons.org/Considerations_fo=
r_licensees" rel=3D"noreferrer" target=3D"_blank">wiki.creativecommons.org/=
Considerations_for_licensees</a><br>
+<br>
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
+<br>
+Creative Commons Attribution-ShareAlike 4.0 International Public<br>
+License<br>
+<br>
+By exercising the Licensed Rights (defined below), You accept and agree<br=
>
+to be bound by the terms and conditions of this Creative Commons<br>
+Attribution-ShareAlike 4.0 International Public License (&quot;Public<br>
+License&quot;). To the extent this Public License may be interpreted as a<=
br>
+contract, You are granted the Licensed Rights in consideration of Your<br>
+acceptance of these terms and conditions, and the Licensor grants You<br>
+such rights in consideration of benefits the Licensor receives from<br>
+making the Licensed Material available under these terms and<br>
+conditions.<br>
+<br>
+<br>
+Section 1 -- Definitions.<br>
+<br>
+=C2=A0 a. Adapted Material means material subject to Copyright and Similar=
<br>
+=C2=A0 =C2=A0 =C2=A0Rights that is derived from or based upon the Licensed=
 Material<br>
+=C2=A0 =C2=A0 =C2=A0and in which the Licensed Material is translated, alte=
red,<br>
+=C2=A0 =C2=A0 =C2=A0arranged, transformed, or otherwise modified in a mann=
er requiring<br>
+=C2=A0 =C2=A0 =C2=A0permission under the Copyright and Similar Rights held=
 by the<br>
+=C2=A0 =C2=A0 =C2=A0Licensor. For purposes of this Public License, where t=
he Licensed<br>
+=C2=A0 =C2=A0 =C2=A0Material is a musical work, performance, or sound reco=
rding,<br>
+=C2=A0 =C2=A0 =C2=A0Adapted Material is always produced where the Licensed=
 Material is<br>
+=C2=A0 =C2=A0 =C2=A0synched in timed relation with a moving image.<br>
+<br>
+=C2=A0 b. Adapter&#39;s License means the license You apply to Your Copyri=
ght<br>
+=C2=A0 =C2=A0 =C2=A0and Similar Rights in Your contributions to Adapted Ma=
terial in<br>
+=C2=A0 =C2=A0 =C2=A0accordance with the terms and conditions of this Publi=
c License.<br>
+<br>
+=C2=A0 c. BY-SA Compatible License means a license listed at<br>
+=C2=A0 =C2=A0 =C2=A0<a href=3D"http://creativecommons.org/compatiblelicens=
es" rel=3D"noreferrer" target=3D"_blank">creativecommons.org/compatiblelice=
nses</a>, approved by Creative<br>
+=C2=A0 =C2=A0 =C2=A0Commons as essentially the equivalent of this Public L=
icense.<br>
+<br>
+=C2=A0 d. Copyright and Similar Rights means copyright and/or similar righ=
ts<br>
+=C2=A0 =C2=A0 =C2=A0closely related to copyright including, without limita=
tion,<br>
+=C2=A0 =C2=A0 =C2=A0performance, broadcast, sound recording, and Sui Gener=
is Database<br>
+=C2=A0 =C2=A0 =C2=A0Rights, without regard to how the rights are labeled o=
r<br>
+=C2=A0 =C2=A0 =C2=A0categorized. For purposes of this Public License, the =
rights<br>
+=C2=A0 =C2=A0 =C2=A0specified in Section 2(b)(1)-(2) are not Copyright and=
 Similar<br>
+=C2=A0 =C2=A0 =C2=A0Rights.<br>
+<br>
+=C2=A0 e. Effective Technological Measures means those measures that, in t=
he<br>
+=C2=A0 =C2=A0 =C2=A0absence of proper authority, may not be circumvented u=
nder laws<br>
+=C2=A0 =C2=A0 =C2=A0fulfilling obligations under Article 11 of the WIPO Co=
pyright<br>
+=C2=A0 =C2=A0 =C2=A0Treaty adopted on December 20, 1996, and/or similar in=
ternational<br>
+=C2=A0 =C2=A0 =C2=A0agreements.<br>
+<br>
+=C2=A0 f. Exceptions and Limitations means fair use, fair dealing, and/or<=
br>
+=C2=A0 =C2=A0 =C2=A0any other exception or limitation to Copyright and Sim=
ilar Rights<br>
+=C2=A0 =C2=A0 =C2=A0that applies to Your use of the Licensed Material.<br>
+<br>
+=C2=A0 g. License Elements means the license attributes listed in the name=
<br>
+=C2=A0 =C2=A0 =C2=A0of a Creative Commons Public License. The License Elem=
ents of this<br>
+=C2=A0 =C2=A0 =C2=A0Public License are Attribution and ShareAlike.<br>
+<br>
+=C2=A0 h. Licensed Material means the artistic or literary work, database,=
<br>
+=C2=A0 =C2=A0 =C2=A0or other material to which the Licensor applied this P=
ublic<br>
+=C2=A0 =C2=A0 =C2=A0License.<br>
+<br>
+=C2=A0 i. Licensed Rights means the rights granted to You subject to the<b=
r>
+=C2=A0 =C2=A0 =C2=A0terms and conditions of this Public License, which are=
 limited to<br>
+=C2=A0 =C2=A0 =C2=A0all Copyright and Similar Rights that apply to Your us=
e of the<br>
+=C2=A0 =C2=A0 =C2=A0Licensed Material and that the Licensor has authority =
to license.<br>
+<br>
+=C2=A0 j. Licensor means the individual(s) or entity(ies) granting rights<=
br>
+=C2=A0 =C2=A0 =C2=A0under this Public License.<br>
+<br>
+=C2=A0 k. Share means to provide material to the public by any means or<br=
>
+=C2=A0 =C2=A0 =C2=A0process that requires permission under the Licensed Ri=
ghts, such<br>
+=C2=A0 =C2=A0 =C2=A0as reproduction, public display, public performance, d=
istribution,<br>
+=C2=A0 =C2=A0 =C2=A0dissemination, communication, or importation, and to m=
ake material<br>
+=C2=A0 =C2=A0 =C2=A0available to the public including in ways that members=
 of the<br>
+=C2=A0 =C2=A0 =C2=A0public may access the material from a place and at a t=
ime<br>
+=C2=A0 =C2=A0 =C2=A0individually chosen by them.<br>
+<br>
+=C2=A0 l. Sui Generis Database Rights means rights other than copyright<br=
>
+=C2=A0 =C2=A0 =C2=A0resulting from Directive 96/9/EC of the European Parli=
ament and of<br>
+=C2=A0 =C2=A0 =C2=A0the Council of 11 March 1996 on the legal protection o=
f databases,<br>
+=C2=A0 =C2=A0 =C2=A0as amended and/or succeeded, as well as other essentia=
lly<br>
+=C2=A0 =C2=A0 =C2=A0equivalent rights anywhere in the world.<br>
+<br>
+=C2=A0 m. You means the individual or entity exercising the Licensed Right=
s<br>
+=C2=A0 =C2=A0 =C2=A0under this Public License. Your has a corresponding me=
aning.<br>
+<br>
+<br>
+Section 2 -- Scope.<br>
+<br>
+=C2=A0 a. License grant.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A01. Subject to the terms and conditions of this =
Public License,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the Licensor hereby grants You a worldw=
ide, royalty-free,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 non-sublicensable, non-exclusive, irrev=
ocable license to<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exercise the Licensed Rights in the Lic=
ensed Material to:<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 a. reproduce and Share the Licen=
sed Material, in whole or<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in part; and<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b. produce, reproduce, and Share=
 Adapted Material.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A02. Exceptions and Limitations. For the avoidanc=
e of doubt, where<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Exceptions and Limitations apply to You=
r use, this Public<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 License does not apply, and You do not =
need to comply with<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 its terms and conditions.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A03. Term. The term of this Public License is spe=
cified in Section<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6(a).<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A04. Media and formats; technical modifications a=
llowed. The<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Licensor authorizes You to exercise the=
 Licensed Rights in<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 all media and formats whether now known=
 or hereafter created,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 and to make technical modifications nec=
essary to do so. The<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Licensor waives and/or agrees not to as=
sert any right or<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 authority to forbid You from making tec=
hnical modifications<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 necessary to exercise the Licensed Righ=
ts, including<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 technical modifications necessary to ci=
rcumvent Effective<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Technological Measures. For purposes of=
 this Public License,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 simply making modifications authorized =
by this Section 2(a)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (4) never produces Adapted Material.<br=
>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A05. Downstream recipients.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 a. Offer from the Licensor -- Li=
censed Material. Every<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0recipient of the Li=
censed Material automatically<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0receives an offer f=
rom the Licensor to exercise the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Licensed Rights und=
er the terms and conditions of this<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Public License.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b. Additional offer from the Lic=
ensor -- Adapted Material.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Every recipient of =
Adapted Material from You<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0automatically recei=
ves an offer from the Licensor to<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exercise the Licens=
ed Rights in the Adapted Material<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0under the condition=
s of the Adapter&#39;s License You apply.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c. No downstream restrictions. Y=
ou may not offer or impose<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0any additional or d=
ifferent terms or conditions on, or<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0apply any Effective=
 Technological Measures to, the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Licensed Material i=
f doing so restricts exercise of the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Licensed Rights by =
any recipient of the Licensed<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Material.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A06. No endorsement. Nothing in this Public Licen=
se constitutes or<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 may be construed as permission to asser=
t or imply that You<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 are, or that Your use of the Licensed M=
aterial is, connected<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 with, or sponsored, endorsed, or grante=
d official status by,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the Licensor or others designated to re=
ceive attribution as<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 provided in Section 3(a)(1)(A)(i).<br>
+<br>
+=C2=A0 b. Other rights.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A01. Moral rights, such as the right of integrity=
, are not<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 licensed under this Public License, nor=
 are publicity,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 privacy, and/or other similar personali=
ty rights; however, to<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the extent possible, the Licensor waive=
s and/or agrees not to<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 assert any such rights held by the Lice=
nsor to the limited<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extent necessary to allow You to exerci=
se the Licensed<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Rights, but not otherwise.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A02. Patent and trademark rights are not licensed=
 under this<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Public License.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A03. To the extent possible, the Licensor waives =
any right to<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 collect royalties from You for the exer=
cise of the Licensed<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Rights, whether directly or through a c=
ollecting society<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 under any voluntary or waivable statuto=
ry or compulsory<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 licensing scheme. In all other cases th=
e Licensor expressly<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reserves any right to collect such roya=
lties.<br>
+<br>
+<br>
+Section 3 -- License Conditions.<br>
+<br>
+Your exercise of the Licensed Rights is expressly made subject to the<br>
+following conditions.<br>
+<br>
+=C2=A0 a. Attribution.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A01. If You Share the Licensed Material (includin=
g in modified<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 form), You must:<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 a. retain the following if it is=
 supplied by the Licensor<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0with the Licensed M=
aterial:<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i. identific=
ation of the creator(s) of the Licensed<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Mate=
rial and any others designated to receive<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attr=
ibution, in any reasonable manner requested by<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the =
Licensor (including by pseudonym if<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desi=
gnated);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ii. a copyright no=
tice;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iii. a notice that =
refers to this Public License;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iv. a notice that =
refers to the disclaimer of<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 warr=
anties;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0v. a URI or =
hyperlink to the Licensed Material to the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exte=
nt reasonably practicable;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b. indicate if You modified the =
Licensed Material and<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retain an indicatio=
n of any previous modifications; and<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c. indicate the Licensed Materia=
l is licensed under this<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Public License, and=
 include the text of, or the URI or<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hyperlink to, this =
Public License.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A02. You may satisfy the conditions in Section 3(=
a)(1) in any<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reasonable manner based on the medium, =
means, and context in<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 which You Share the Licensed Material. =
For example, it may be<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reasonable to satisfy the conditions by=
 providing a URI or<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hyperlink to a resource that includes t=
he required<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 information.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A03. If requested by the Licensor, You must remov=
e any of the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 information required by Section 3(a)(1)=
(A) to the extent<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reasonably practicable.<br>
+<br>
+=C2=A0 b. ShareAlike.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0In addition to the conditions in Section 3(a), if You =
Share<br>
+=C2=A0 =C2=A0 =C2=A0Adapted Material You produce, the following conditions=
 also apply.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A01. The Adapter&#39;s License You apply must be =
a Creative Commons<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 license with the same License Elements,=
 this version or<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 later, or a BY-SA Compatible License.<b=
r>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A02. You must include the text of, or the URI or =
hyperlink to, the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Adapter&#39;s License You apply. You ma=
y satisfy this condition<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in any reasonable manner based on the m=
edium, means, and<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 context in which You Share Adapted Mate=
rial.<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A03. You may not offer or impose any additional o=
r different terms<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 or conditions on, or apply any Effectiv=
e Technological<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Measures to, Adapted Material that rest=
rict exercise of the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rights granted under the Adapter&#39;s =
License You apply.<br>
+<br>
+<br>
+Section 4 -- Sui Generis Database Rights.<br>
+<br>
+Where the Licensed Rights include Sui Generis Database Rights that<br>
+apply to Your use of the Licensed Material:<br>
+<br>
+=C2=A0 a. for the avoidance of doubt, Section 2(a)(1) grants You the right=
<br>
+=C2=A0 =C2=A0 =C2=A0to extract, reuse, reproduce, and Share all or a subst=
antial<br>
+=C2=A0 =C2=A0 =C2=A0portion of the contents of the database;<br>
+<br>
+=C2=A0 b. if You include all or a substantial portion of the database<br>
+=C2=A0 =C2=A0 =C2=A0contents in a database in which You have Sui Generis D=
atabase<br>
+=C2=A0 =C2=A0 =C2=A0Rights, then the database in which You have Sui Generi=
s Database<br>
+=C2=A0 =C2=A0 =C2=A0Rights (but not its individual contents) is Adapted Ma=
terial,<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0including for purposes of Section 3(b); and<br>
+=C2=A0 c. You must comply with the conditions in Section 3(a) if You Share=
<br>
+=C2=A0 =C2=A0 =C2=A0all or a substantial portion of the contents of the da=
tabase.<br>
+<br>
+For the avoidance of doubt, this Section 4 supplements and does not<br>
+replace Your obligations under this Public License where the Licensed<br>
+Rights include other Copyright and Similar Rights.<br>
+<br>
+<br>
+Section 5 -- Disclaimer of Warranties and Limitation of Liability.<br>
+<br>
+=C2=A0 a. UNLESS OTHERWISE SEPARATELY UNDERTAKEN BY THE LICENSOR, TO THE<b=
r>
+=C2=A0 =C2=A0 =C2=A0EXTENT POSSIBLE, THE LICENSOR OFFERS THE LICENSED MATE=
RIAL AS-IS<br>
+=C2=A0 =C2=A0 =C2=A0AND AS-AVAILABLE, AND MAKES NO REPRESENTATIONS OR WARR=
ANTIES OF<br>
+=C2=A0 =C2=A0 =C2=A0ANY KIND CONCERNING THE LICENSED MATERIAL, WHETHER EXP=
RESS,<br>
+=C2=A0 =C2=A0 =C2=A0IMPLIED, STATUTORY, OR OTHER. THIS INCLUDES, WITHOUT L=
IMITATION,<br>
+=C2=A0 =C2=A0 =C2=A0WARRANTIES OF TITLE, MERCHANTABILITY, FITNESS FOR A PA=
RTICULAR<br>
+=C2=A0 =C2=A0 =C2=A0PURPOSE, NON-INFRINGEMENT, ABSENCE OF LATENT OR OTHER =
DEFECTS,<br>
+=C2=A0 =C2=A0 =C2=A0ACCURACY, OR THE PRESENCE OR ABSENCE OF ERRORS, WHETHE=
R OR NOT<br>
+=C2=A0 =C2=A0 =C2=A0KNOWN OR DISCOVERABLE. WHERE DISCLAIMERS OF WARRANTIES=
 ARE NOT<br>
+=C2=A0 =C2=A0 =C2=A0ALLOWED IN FULL OR IN PART, THIS DISCLAIMER MAY NOT AP=
PLY TO YOU.<br>
+<br>
+=C2=A0 b. TO THE EXTENT POSSIBLE, IN NO EVENT WILL THE LICENSOR BE LIABLE<=
br>
+=C2=A0 =C2=A0 =C2=A0TO YOU ON ANY LEGAL THEORY (INCLUDING, WITHOUT LIMITAT=
ION,<br>
+=C2=A0 =C2=A0 =C2=A0NEGLIGENCE) OR OTHERWISE FOR ANY DIRECT, SPECIAL, INDI=
RECT,<br>
+=C2=A0 =C2=A0 =C2=A0INCIDENTAL, CONSEQUENTIAL, PUNITIVE, EXEMPLARY, OR OTH=
ER LOSSES,<br>
+=C2=A0 =C2=A0 =C2=A0COSTS, EXPENSES, OR DAMAGES ARISING OUT OF THIS PUBLIC=
 LICENSE OR<br>
+=C2=A0 =C2=A0 =C2=A0USE OF THE LICENSED MATERIAL, EVEN IF THE LICENSOR HAS=
 BEEN<br>
+=C2=A0 =C2=A0 =C2=A0ADVISED OF THE POSSIBILITY OF SUCH LOSSES, COSTS, EXPE=
NSES, OR<br>
+=C2=A0 =C2=A0 =C2=A0DAMAGES. WHERE A LIMITATION OF LIABILITY IS NOT ALLOWE=
D IN FULL OR<br>
+=C2=A0 =C2=A0 =C2=A0IN PART, THIS LIMITATION MAY NOT APPLY TO YOU.<br>
+<br>
+=C2=A0 c. The disclaimer of warranties and limitation of liability provide=
d<br>
+=C2=A0 =C2=A0 =C2=A0above shall be interpreted in a manner that, to the ex=
tent<br>
+=C2=A0 =C2=A0 =C2=A0possible, most closely approximates an absolute discla=
imer and<br>
+=C2=A0 =C2=A0 =C2=A0waiver of all liability.<br>
+<br>
+<br>
+Section 6 -- Term and Termination.<br>
+<br>
+=C2=A0 a. This Public License applies for the term of the Copyright and<br=
>
+=C2=A0 =C2=A0 =C2=A0Similar Rights licensed here. However, if You fail to =
comply with<br>
+=C2=A0 =C2=A0 =C2=A0this Public License, then Your rights under this Publi=
c License<br>
+=C2=A0 =C2=A0 =C2=A0terminate automatically.<br>
+<br>
+=C2=A0 b. Where Your right to use the Licensed Material has terminated und=
er<br>
+=C2=A0 =C2=A0 =C2=A0Section 6(a), it reinstates:<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A01. automatically as of the date the violation i=
s cured, provided<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 it is cured within 30 days of Your disc=
overy of the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 violation; or<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A02. upon express reinstatement by the Licensor.<=
br>
+<br>
+=C2=A0 =C2=A0 =C2=A0For the avoidance of doubt, this Section 6(b) does not=
 affect any<br>
+=C2=A0 =C2=A0 =C2=A0right the Licensor may have to seek remedies for Your =
violations<br>
+=C2=A0 =C2=A0 =C2=A0of this Public License.<br>
+<br>
+=C2=A0 c. For the avoidance of doubt, the Licensor may also offer the<br>
+=C2=A0 =C2=A0 =C2=A0Licensed Material under separate terms or conditions o=
r stop<br>
+=C2=A0 =C2=A0 =C2=A0distributing the Licensed Material at any time; howeve=
r, doing so<br>
+=C2=A0 =C2=A0 =C2=A0will not terminate this Public License.<br>
+<br>
+=C2=A0 d. Sections 1, 5, 6, 7, and 8 survive termination of this Public<br=
>
+=C2=A0 =C2=A0 =C2=A0License.<br>
+<br>
+<br>
+Section 7 -- Other Terms and Conditions.<br>
+<br>
+=C2=A0 a. The Licensor shall not be bound by any additional or different<b=
r>
+=C2=A0 =C2=A0 =C2=A0terms or conditions communicated by You unless express=
ly agreed.<br>
+<br>
+=C2=A0 b. Any arrangements, understandings, or agreements regarding the<br=
>
+=C2=A0 =C2=A0 =C2=A0Licensed Material not stated herein are separate from =
and<br>
+=C2=A0 =C2=A0 =C2=A0independent of the terms and conditions of this Public=
 License.<br>
+<br>
+<br>
+Section 8 -- Interpretation.<br>
+<br>
+=C2=A0 a. For the avoidance of doubt, this Public License does not, and<br=
>
+=C2=A0 =C2=A0 =C2=A0shall not be interpreted to, reduce, limit, restrict, =
or impose<br>
+=C2=A0 =C2=A0 =C2=A0conditions on any use of the Licensed Material that co=
uld lawfully<br>
+=C2=A0 =C2=A0 =C2=A0be made without permission under this Public License.<=
br>
+<br>
+=C2=A0 b. To the extent possible, if any provision of this Public License =
is<br>
+=C2=A0 =C2=A0 =C2=A0deemed unenforceable, it shall be automatically reform=
ed to the<br>
+=C2=A0 =C2=A0 =C2=A0minimum extent necessary to make it enforceable. If th=
e provision<br>
+=C2=A0 =C2=A0 =C2=A0cannot be reformed, it shall be severed from this Publ=
ic License<br>
+=C2=A0 =C2=A0 =C2=A0without affecting the enforceability of the remaining =
terms and<br>
+=C2=A0 =C2=A0 =C2=A0conditions.<br>
+<br>
+=C2=A0 c. No term or condition of this Public License will be waived and n=
o<br>
+=C2=A0 =C2=A0 =C2=A0failure to comply consented to unless expressly agreed=
 to by the<br>
+=C2=A0 =C2=A0 =C2=A0Licensor.<br>
+<br>
+=C2=A0 d. Nothing in this Public License constitutes or may be interpreted=
<br>
+=C2=A0 =C2=A0 =C2=A0as a limitation upon, or waiver of, any privileges and=
 immunities<br>
+=C2=A0 =C2=A0 =C2=A0that apply to the Licensor or You, including from the =
legal<br>
+=C2=A0 =C2=A0 =C2=A0processes of any jurisdiction or authority.<br>
+<br>
+<br>
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
+<br>
+Creative Commons is not a party to its public<br>
+licenses. Notwithstanding, Creative Commons may elect to apply one of<br>
+its public licenses to material it publishes and in those instances<br>
+will be considered the =E2=80=9CLicensor.=E2=80=9D The text of the Creativ=
e Commons<br>
+public licenses is dedicated to the public domain under the CC0 Public<br>
+Domain Dedication. Except for the limited purpose of indicating that<br>
+material is shared under a Creative Commons public license or as<br>
+otherwise permitted by the Creative Commons policies published at<br>
+<a href=3D"http://creativecommons.org/policies" rel=3D"noreferrer" target=
=3D"_blank">creativecommons.org/policies</a>, Creative Commons does not aut=
horize the<br>
+use of the trademark &quot;Creative Commons&quot; or any other trademark o=
r logo<br>
+of Creative Commons without its prior written consent including,<br>
+without limitation, in connection with any unauthorized modifications<br>
+to any of its public licenses or any other arrangements,<br>
+understandings, or agreements concerning use of licensed material. For<br>
+the avoidance of doubt, this paragraph does not form part of the<br>
+public licenses.<br>
+<br>
+Creative Commons may be contacted at <a href=3D"http://creativecommons.org=
" rel=3D"noreferrer" target=3D"_blank">creativecommons.org</a>.<br>
+<br>
diff --git a/public/design.html b/public/design.html<br>
index c05f20d..76dc564 100644<br>
--- a/public/design.html<br>
+++ b/public/design.html<br>
@@ -167,5 +167,9 @@<br>
=C2=A0 =C2=A0 =C2=A0&lt;p&gt;The vhost-user device backend implements the b=
ulk of virtio-fs.=C2=A0 It is<br>
=C2=A0 =C2=A0 =C2=A0possible to use the vhost-user device backend with any =
hypervisor that<br>
=C2=A0 =C2=A0 =C2=A0supports the vhost-user interface.&lt;/p&gt;<br>
+<br>
+=C2=A0 =C2=A0 &lt;div class=3D&quot;footer&quot;&gt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;p&gt;This website is published under the &=
lt;a href=3D&quot;<a href=3D"https://creativecommons.org/licenses/by-sa/4.0=
/" rel=3D"noreferrer" target=3D"_blank">https://creativecommons.org/license=
s/by-sa/4.0/</a>&quot;&gt;Creative Commons Attribution-ShareAlike 4.0 Inter=
national&lt;/a&gt; license. The source code is available &lt;a href=3D&quot=
;<a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/" rel=3D"noref=
errer" target=3D"_blank">https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/<=
/a>&quot;&gt;here&lt;/a&gt;.&lt;/p&gt;<br>
+=C2=A0 =C2=A0 &lt;/div&gt;<br>
=C2=A0 =C2=A0&lt;/body&gt;<br>
=C2=A0&lt;/html&gt;<br>
diff --git a/public/howto-boot.html b/public/howto-boot.html<br>
index f4eda4b..976cedc 100644<br>
--- a/public/howto-boot.html<br>
+++ b/public/howto-boot.html<br>
@@ -66,6 +66,10 @@<br>
=C2=A0 =C2=A0 =C2=A0&lt;p&gt;This assumes you are using a monolithic kernel=
.=C2=A0 Use of an initramfs has not been tested and may require further ste=
ps.&lt;/p&gt;<br>
<br>
=C2=A0 =C2=A0 =C2=A0&lt;p&gt;For details on launching QEMU, see the &lt;a h=
ref=3D&quot;/howto-qemu.html&quot;&gt;QEMU HowTo&lt;/a&gt;.&lt;/p&gt;<br>
+<br>
+=C2=A0 =C2=A0 &lt;div class=3D&quot;footer&quot;&gt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;p&gt;This website is published under the &=
lt;a href=3D&quot;<a href=3D"https://creativecommons.org/licenses/by-sa/4.0=
/" rel=3D"noreferrer" target=3D"_blank">https://creativecommons.org/license=
s/by-sa/4.0/</a>&quot;&gt;Creative Commons Attribution-ShareAlike 4.0 Inter=
national&lt;/a&gt; license. The source code is available &lt;a href=3D&quot=
;<a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/" rel=3D"noref=
errer" target=3D"_blank">https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/<=
/a>&quot;&gt;here&lt;/a&gt;.&lt;/p&gt;<br>
+=C2=A0 =C2=A0 &lt;/div&gt;<br>
=C2=A0 =C2=A0&lt;/body&gt;<br>
=C2=A0&lt;/html&gt;<br>
<br>
diff --git a/public/howto-kata.html b/public/howto-kata.html<br>
index dfa4059..295c851 100644<br>
--- a/public/howto-kata.html<br>
+++ b/public/howto-kata.html<br>
@@ -228,6 +228,10 @@ ExecStart=3D/usr/bin/dockerd-current -D \<br>
=C2=A0 =C2=A0 =C2=A0&lt;h2&gt;Running containers&lt;/h2&gt;<br>
=C2=A0 =C2=A0 =C2=A0&lt;p&gt;Launch a container:&lt;/p&gt;<br>
=C2=A0 =C2=A0 =C2=A0&lt;pre&gt;docker run --runtime kata-runtime -it busybo=
x sh&lt;/pre&gt;<br>
+<br>
+=C2=A0 =C2=A0 &lt;div class=3D&quot;footer&quot;&gt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;p&gt;This website is published under the &=
lt;a href=3D&quot;<a href=3D"https://creativecommons.org/licenses/by-sa/4.0=
/" rel=3D"noreferrer" target=3D"_blank">https://creativecommons.org/license=
s/by-sa/4.0/</a>&quot;&gt;Creative Commons Attribution-ShareAlike 4.0 Inter=
national&lt;/a&gt; license. The source code is available &lt;a href=3D&quot=
;<a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/" rel=3D"noref=
errer" target=3D"_blank">https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/<=
/a>&quot;&gt;here&lt;/a&gt;.&lt;/p&gt;<br>
+=C2=A0 =C2=A0 &lt;/div&gt;<br>
=C2=A0 =C2=A0&lt;/body&gt;<br>
=C2=A0&lt;/html&gt;<br>
<br>
diff --git a/public/howto-qemu.html b/public/howto-qemu.html<br>
index 3969927..9cd90fb 100644<br>
--- a/public/howto-qemu.html<br>
+++ b/public/howto-qemu.html<br>
@@ -214,6 +214,9 @@ tree by:<br>
<br>
=C2=A0 =C2=A0 The mount options are unchanged.<br>
<br>
+&lt;div class=3D&quot;footer&quot;&gt;<br>
+=C2=A0 =C2=A0 &lt;p&gt;This website is published under the &lt;a href=3D&q=
uot;<a href=3D"https://creativecommons.org/licenses/by-sa/4.0/" rel=3D"nore=
ferrer" target=3D"_blank">https://creativecommons.org/licenses/by-sa/4.0/</=
a>&quot;&gt;Creative Commons Attribution-ShareAlike 4.0 International&lt;/a=
&gt; license. The source code is available &lt;a href=3D&quot;<a href=3D"ht=
tps://gitlab.com/virtio-fs/virtio-fs.gitlab.io/" rel=3D"noreferrer" target=
=3D"_blank">https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/</a>&quot;&gt;=
here&lt;/a&gt;.&lt;/p&gt;<br>
+&lt;/div&gt;<br>
=C2=A0&lt;/body&gt;<br>
=C2=A0&lt;/html&gt;<br>
<br>
diff --git a/public/howto-windows.html b/public/howto-windows.html<br>
index d9415b5..89214b9 100644<br>
--- a/public/howto-windows.html<br>
+++ b/public/howto-windows.html<br>
@@ -88,5 +88,9 @@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Z: and downward. Use the &quot;-m&quot; c=
ommand line parameter to explicitly<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0select a drive letter.<br>
=C2=A0 =C2=A0 =C2=A0&lt;/p&gt;<br>
+<br>
+=C2=A0 =C2=A0 &lt;div class=3D&quot;footer&quot;&gt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;p&gt;This website is published under the &=
lt;a href=3D&quot;<a href=3D"https://creativecommons.org/licenses/by-sa/4.0=
/" rel=3D"noreferrer" target=3D"_blank">https://creativecommons.org/license=
s/by-sa/4.0/</a>&quot;&gt;Creative Commons Attribution-ShareAlike 4.0 Inter=
national&lt;/a&gt; license. The source code is available &lt;a href=3D&quot=
;<a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/" rel=3D"noref=
errer" target=3D"_blank">https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/<=
/a>&quot;&gt;here&lt;/a&gt;.&lt;/p&gt;<br>
+=C2=A0 =C2=A0 &lt;/div&gt;<br>
=C2=A0 =C2=A0&lt;/body&gt;<br>
=C2=A0&lt;/html&gt;<br>
diff --git a/public/index.html b/public/index.html<br>
index f9f499e..28ce838 100644<br>
--- a/public/index.html<br>
+++ b/public/index.html<br>
@@ -111,6 +111,10 @@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0operations.=C2=A0 Virtual machines refresh metad=
ata when the version number<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0has changed since they last cached a copy.<br>
=C2=A0 =C2=A0 =C2=A0&lt;/p&gt;<br>
+<br>
+=C2=A0 =C2=A0 &lt;div class=3D&quot;footer&quot;&gt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;p&gt;This website is published under the &=
lt;a href=3D&quot;<a href=3D"https://creativecommons.org/licenses/by-sa/4.0=
/" rel=3D"noreferrer" target=3D"_blank">https://creativecommons.org/license=
s/by-sa/4.0/</a>&quot;&gt;Creative Commons Attribution-ShareAlike 4.0 Inter=
national&lt;/a&gt; license. The source code is available &lt;a href=3D&quot=
;<a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/" rel=3D"noref=
errer" target=3D"_blank">https://gitlab.com/virtio-fs/virtio-fs.gitlab.io/<=
/a>&quot;&gt;here&lt;/a&gt;.&lt;/p&gt;<br>
+=C2=A0 =C2=A0 &lt;/div&gt;<br>
=C2=A0 =C2=A0&lt;/body&gt;<br>
=C2=A0&lt;/html&gt;<br>
<br>
diff --git a/public/style.css b/public/style.css<br>
index 0e15f11..689728d 100644<br>
--- a/public/style.css<br>
+++ b/public/style.css<br>
@@ -33,3 +33,20 @@ pre {<br>
=C2=A0 =C2=A0 =C2=A0width: 446px;<br>
=C2=A0 =C2=A0 =C2=A0height: 238px;<br>
=C2=A0}<br>
+<br>
+.footer {<br>
+=C2=A0 background-color: #313236;<br>
+=C2=A0 max-width: 800px;<br>
+=C2=A0 padding: 10px;<br>
+=C2=A0 color: #ddd;<br>
+=C2=A0 font-size: 12px;<br>
+}<br>
+<br>
+.footer a {<br>
+=C2=A0 color: #aaa;<br>
+=C2=A0 text-decoration: none;<br>
+}<br>
+<br>
+.footer a:hover {<br>
+=C2=A0 color: #fff;<br>
+}<br>
-- <br>
2.26.2<br>
<br>
</blockquote></div>

--000000000000bf061b05b2a33119--

