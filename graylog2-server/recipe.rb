class Graylog2Server < FPM::Cookery::Recipe
  homepage    'http://graylog2.org'
  name        'graylog2-server'
  version     '0.10.0'
  source      "http://download.graylog2.org/#{name}/#{name}-#{version}.tar.gz"
  md5         '7f02dc4ca30dd79289c95c42e248ea12'

  revision    '2'
  vendor      'aussielunix'
  maintainer  'Mick Pollard <aussielunix@gmail.com>'
  license     'GPL-3'
  description 'graylog2-server is the server part of an open source log management solution that stores your logs in elasticsearch.'
  arch	      'amd64'
  section     'admin'

  depends     'java-runtime-headless'

  config_files '/etc/graylog2-server/graylog2.conf',
               '/etc/graylog2-server/elasticsearch.yml'

  pre_install    'preinst'
  post_install   'postinst'

  pre_uninstall  'prerm'
  post_uninstall 'postrm'

  def build
    inline_replace 'bin/graylog2ctl' do |s|
      s.gsub! 'GRAYLOG2_SERVER_JAR=graylog2-server.jar', 'GRAYLOG2_SERVER_JAR=' + share('graylog2-server/graylog2-server.jar')
      s.gsub! 'GRAYLOG2_CONF=/etc/graylog2.conf', 'GRAYLOG2_CONF=' + etc('graylog2-server/graylog2.conf')
      s.gsub! 'GRAYLOG2_PID=/tmp/graylog2.pid', 'GRAYLOG2_PID=' + var('run/graylog2-server.pid')
      s.gsub! 'LOG_FILE=log/graylog2-server.log', 'LOG_FILE=' + var('log/graylog2-server/graylog2-server.log')
    end

    inline_replace 'graylog2.conf.example' do |s|
      s.gsub! '/etc/graylog2-elasticsearch.yml', etc('graylog2-server/elasticsearch.yml')
    end
  end

  def install
    etc('init.d').install_p 'bin/graylog2ctl', 'graylog2-server'
    etc('graylog2-server').install_p 'graylog2.conf.example', 'graylog2.conf'
    etc('graylog2-server').install_p 'elasticsearch.yml.example', 'elasticsearch.yml'

    share('graylog2-server').install workdir('COPYING')
    share('graylog2-server').install workdir('README')
    share('graylog2-server').install 'build_date'
    share('graylog2-server').install 'graylog2-server.jar'
  end
end
