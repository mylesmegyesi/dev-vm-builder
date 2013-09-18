module DevVmBuilder
  ISOS = [
    {
      :name          => 'ubuntu-13.04.amd64',
      :checksum      => '7d335ca541fc4945b674459cde7bffb9',
      :checksum_type => 'md5',
      :urls          => [
        'http://releases.ubuntu.com/13.04/ubuntu-13.04-server-amd64.iso',
        'http://nl.releases.ubuntu.com/13.04/ubuntu-13.04-server-amd64.iso'
      ]
    },
    {
      :name          => 'ubuntu-12.04.3.amd64',
      :checksum      => '61d5e67c70d97b33c13537461a0b153b41304ef412bb0e9d813bb157068c3c65',
      :checksum_type => 'sha256',
      :urls          => [
        'http://releases.ubuntu.com/12.04/ubuntu-12.04.3-server-amd64.iso',
      ]
    }
  ]
end
