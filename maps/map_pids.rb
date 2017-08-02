require 'csv'
require 'fileutils'
require 'json'

require 'mechanize'

urls = %w(
https://earthworks.stanford.edu/?bbox=28.959961+20.715015+47.592773+38.891033&per_page=100
https://earthworks.stanford.edu/?bbox=28.959961+20.715015+47.592773+38.891033&page=2&per_page=100
https://earthworks.stanford.edu/?bbox=28.959961+20.715015+47.592773+38.891033&page=3&per_page=100
https://earthworks.stanford.edu/?bbox=28.959961+20.715015+47.592773+38.891033&page=4&per_page=100
https://earthworks.stanford.edu/?bbox=28.959961+20.715015+47.592773+38.891033&page=5&per_page=100
)

@include_prefix = %w(
  harvard
  stanford
  princeton
)

@pids = []

@a = Mechanize.new

# def collectPid(pid)
#   prefix = pid.split('-')[0]
#   @pids << pid if @include_prefix.include? prefix
# end
#
# urls.each do |url|
#   @a.get(url) do |doc|
#     data = doc.css("//div.documentHeader")
#     data.each do |pid|
#       collectPid pid.attr('data-layer-id')
#     end
#
#   end
# end
#
# puts @pids


# @repos = %w(
# https://github.com/OpenGeoMetadata/edu.stanford.purl.git
# https://github.com/OpenGeoMetadata/edu.princeton.arks.git
# https://github.com/OpenGeoMetadata/edu.harvard.git
# )
#
# FileUtils.mkdir_p('work')
# FileUtils.cd('work')
#
# @repos.each do |repo|
#   `git clone #{repo}`
# end

# dirs = Dir.entries('work')
FileUtils.cd('../work')
#
harvard_layers   = JSON.parse(File.read('edu.harvard/layers.json'))
princeton_layers = JSON.parse(File.read('edu.princeton.arks/layers.json'))
stanford_layers  = JSON.parse(File.read('edu.stanford.purl/layers.json'))

CSV.foreach('../maps/map-layer-ids.csv') do |row|
  prefix = row.first.split('-')[0]
  suffix = row.first.sub("#{prefix}-",'')

  if(prefix == 'harvard')
    suffix.gsub!(/-/, '_') unless suffix.nil?
    suffix.upcase!
    suffix.prepend('HARVARD.SDE2.')

    path = "edu.harvard/#{harvard_layers[suffix]}/fgdc.xml" if harvard_layers[suffix]
    puts path
  end

  if(prefix == 'stanford')
    # these records aren't in the repo
    suffix.prepend('druid:')
    puts suffix
  end

end
