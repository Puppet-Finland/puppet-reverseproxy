#
# @summary Install and configure Apache reverse proxy with TLS
#
define reverseproxy::vhost
(
  String               $site_name = $::fqdn,
  Array[Hash]          $proxy_pass,
  Array[String]        $request_headers,
  Stdlib::AbsolutePath $doc_root,
  Stdlib::AbsolutePath $cert_path,
  Stdlib::AbsolutePath $key_path,
  Stdlib::AbsolutePath $chain_path,
)
{
  include ::apache::mod::headers
  include ::apache::mod::rewrite

  ::apache::vhost { $site_name:
    servername      => $site_name,
    port            => '80',
    docroot         => $doc_root,
    redirect_status => 'permanent',
    redirect_dest   => "https://${site_name}/",
  }

  ::apache::vhost { "${site_name}-ssl":
    servername      => $site_name,
    port            => '443',
    docroot         => $doc_root,
    proxy_pass      => $proxy_pass,
    request_headers => $request_headers,
    ssl             => true,
    ssl_cert        => $cert_path,
    ssl_key         => $key_path,
    ssl_chain       => $chain_path,
  }
}
