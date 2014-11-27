require 'digest'
require 'open-uri'
require 'net/http'
require 'fc2_get/version'

module Fc2Get
  module_function
  def mimi(video_id)
    Digest::MD5.hexdigest(video_id + '_gGddgPfeaf_gzyr')
  end

  def params_uri video_id
    URI("http://video.fc2.com/ginfo.php?mimi=#{mimi(video_id)}&upid=#{video_id}")
  end

  def decode_params params_str
    Hash[params_str.scan(/([^=]+)=([^&]*)&?/)]
  end

  def download_uri video_id
    params = decode_params(open(params_uri(video_id)).read)
    URI("#{params['filepath']}?mid=#{params['mid']}")
  end

  def download video_id, path = '.'
    video_uri = download_uri(video_id)
    file_path = File.directory?(path) ?
                File.expand_path(File.basename(video_uri.path), path) : path
    Net::HTTP.get_response(video_uri) do |res|
      size, total = 0, res.header['Content-Length'].to_i
      open file_path, 'w' do |io|
        res.read_body do |chunk|
          io.write chunk
          size += chunk.size
          print "%d%% done (%d of %d)\r" % [(size * 100) / total, size, total]
        end
      end
    end
  end
end
