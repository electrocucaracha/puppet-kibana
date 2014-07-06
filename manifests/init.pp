class kibana(
  $version     = '3.0.1',
  $destination = '/opt') {

  $filename = "kibana-${version}"
  $tar_file = "${filename}.tar.gz"
  $url      = "https://download.elasticsearch.org/kibana/kibana/${tar_file}"
  $www_dir  = "/var/www"

  class { 'apache': }

  exec { "wget ${filename}":
    command => "wget -q ${url} -O ${destination}/${tar_file}",
    path => ["/usr/bin", "/bin"],
  }

  exec { "untar ${filename}":
    command => "tar -xf ${destination}/${tar_file} -C ${www_dir}",
    path => ["/usr/bin", "/bin"],
    subscribe => Exec["wget ${filename}"],
    refreshonly => true,
    require => Class["apache"],
  }

  apache::vhost { 'localhost':
    port    => '80',
    docroot => "${www_dir}/${filename}",
  }
}