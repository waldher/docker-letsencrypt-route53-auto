# Let's Encrypt DNS Verifier using AWS Route53

This is an image for successfully verifying a domain name hosted on Route53 with Let's Encrypt.

This is can be run regularly (i.e. daily) to ensure that a certificate is up to date, and is well suited as an alternative to HTTP verification, when this is inconvenient such as when running highly distributed HTTP servers.

This uses [dehydrated](https://github.com/lukas2511/dehydrated) to communicate with Let's Encrypt and [lexicon](https://github.com/AnalogJ/lexicon) to interact with AWS Route53

## Usage

### Create IAM User for Lexicon

First, you'll need an AWS access key and secret to use. Using a key that's as narrowly scoped as possible is recommended, such as the following. Replace ZONE_HEX_ID with your Route53 Zone's ID:

```
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetHostedZone"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/ZONE_HEX_ID"
      ]
    }
  ]
}
```

### Running the command

In the following example, replace the access key and secret key with that of the above mentioned IAM user, and replace DOMAIN with the domain you wish to verify.

`docker run --rm -ti -e PROVIDER=route53 -e LEXICON_ROUTE53_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE -e LEXICON_ROUTE53_ACCESS_SECRET=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY -v /var/acme-accounts:/work/accounts -v /var/certs:/work/certs waldher/letsencrypt-route53-auto -d DOMAIN`

Your certificates will then be stored in `/var/certs`. Monitor stdout for any errors. Also note that renewals will be skipped for certificates with more than 30 days left before expiration. Further command line options can be found in the [dehydrated](https://github.com/lukas2511/dehydrated) documentation.
