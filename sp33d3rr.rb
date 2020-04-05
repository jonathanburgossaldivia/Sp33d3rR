# frozen_string_literal: true

require 'benchmark'
require 'nokogiri'
require 'open-uri'
require 'optparse'
require 'pastel'
require_relative './sp33d3rr_banners'

user_agents_path = File.join( File.dirname(__FILE__), './sp33d3rr_user_agents.txt' )
useragents = IO.readlines(user_agents_path)
CLEAR = "\e[H\e[2J"
RETURN = "\e[K"
@site = ''
@use_title = false
@use_url = true
@limit = 20

ARGV << '-h' if ARGV.empty?

options = OptionParser.new do |opts|
  opts.banner += '[arguments...]'
  opts.separator "\nDescription: Sp33d3rr is a web scraper,"
  opts.separator 'Sp33d3rr uses Nokogiri to search files from Bing.'
  opts.separator "\nThe following options are available:"
  opts.version = '0.0.1'
  opts.on('-s', '--site SITE', 'Search files from a website, by example: microsoft.com')\
         { |arg| @site = arg }
  opts.on('-t', '--title', 'Print only titles') { @use_title = true; @use_url = false }
  opts.on('-u', '--url', 'Print only urls') { @use_url = true; @use_title = false }
  opts.on('-b', '--both', 'Print titles and urls')\
         { @use_title = true; @use_url = true }
  opts.on('-l', '--limit LIMIT', /[0-9]{,5}/i,
          'Limit search') { |arg| @limit = arg.to_i }
  begin
    opts.parse!
    ARGV.push('-h') if ARGV.empty?
  rescue OptionParser::ParseError, OptionParser::InvalidOption,
         OptionParser::MissingArgument => e
    $stderr.puts e
    $stderr.puts '(-h or --help will show valid options)'
    exit 1
  end
end

if @site == ''
  puts 'Missing option: site'.ljust(40, '!')
  puts "\n" + options.to_s
  exit
else
  @site = @site.gsub(/http.?:\/\/|www\./, '')
  @site = 'http://www.' + @site
end

@random_useragent = useragents.sample
begin
  open(@site.to_s, 'User-Agent' => @random_useragent.to_s)
rescue => e
  puts 'ERROR TRYING TO CONNECT TO ' + @site.upcase.to_s
  puts e
  exit 1
end

pastel = Pastel.new
@search_content = {}
@num = 1
@rtf = []
@txt = []
@pdf = []
@xls = []
@doc = []
@ppt = []
@sql = []
@url = []
@rtf_count = ['rtf', 0]
@txt_count = ['txt', 0]
@pdf_count = ['pdf', 0]
@xls_count = ['xls', 0]
@doc_count = ['doc', 0]
@ppt_count = ['ppt', 0]
@sql_count = ['sql', 0]
@url_count = ['url', 0]

def bing_search(the_site, the_num)
  files_query = "http://www.bing.com/search?q=site:#{the_site}+\
               filetype:(rtf+txt+pdf+xls+doc+ppt+sql)\
               &first=#{the_num}&count=40&filter=0"

  url = open(files_query.to_s, 'User-Agent' => @random_useragent.to_s)
  doc = Nokogiri.HTML(url)

  doc.xpath('//li[@class="b_algo"]/h2/a[@href]').each do |link|
    @search_content[link.text.strip] = link['href']
  end
end

puts CLEAR
puts @banners.sample
puts ''.rjust(40, '-')
puts 'PROGRAM BY: '.rjust(40) + 'Jonathan Burgos'
puts 'GITHUB: '.rjust(40) + 'https://github.com/jonathanburgossaldivia'
puts ''.rjust(40, '-')

print 'PROCESSING, WAIT... ' + "\r"
search_benchmark = Benchmark.realtime do
  loop do
    bing_search(@site, @num)
    @search_content.each do |fin_title, fin_url|
      fin_title_clean = fin_title.gsub(/\“|\"|\:/, '')
      if fin_url.end_with?('rtf')
        @rtf.push([fin_title_clean.downcase, fin_url])
        @rft_count[1] += 1
      elsif fin_url.end_with?('txt')
        @txt.push([fin_title_clean.downcase, fin_url])
        @txt_count[1] += 1
      elsif fin_url.end_with?('pdf')
        @pdf.push([fin_title_clean.downcase, fin_url])
        @pdf_count[1] += 1
      elsif fin_url.end_with?('xls', 'xlsx')
        @xls.push([fin_title_clean.downcase, fin_url])
        @xls_count[1] += 1
      elsif fin_url.end_with?('doc', 'docx')
        @doc.push([fin_title_clean.downcase, fin_url])
        @doc_count[1] += 1
      elsif fin_url.end_with?('ppt', 'pptx')
        @ppt.push([fin_title_clean.downcase, fin_url])
        @ppt_count[1] += 1
      elsif fin_url.end_with?('sql')
        @sql.push([fin_title_clean.downcase, fin_url])
        @sql_count[1] += 1
      else
        @url.push([fin_title_clean.downcase, fin_url])
        @url_count[1] += 1
      end
    end
    @total_ext_count = @rtf_count[1] + @txt_count[1] + \
                       @pdf_count[1] + @xls_count[1] + \
                       @doc_count[1] + @ppt_count[1] + \
                       @sql_count[1] + @url_count[1]
    @num += 40
    if @total_ext_count > @limit.to_i
      break
    end
    @after_ext_count = @total_ext_count
    @search_content.clear
  end
end

total = search_benchmark.round.to_s + ' SECOND(S)'
print RETURN
puts pastel.underline('GENERAL INFO: '.rjust(40))
puts 'SITE: '.rjust(40) + @site.upcase.to_s
puts 'ITEMS FOUND: '.rjust(40) + @total_ext_count.to_s
puts 'BLOCK BENCHMARK: '.rjust(40) + total.to_s
puts pastel.underline('FILES FOUND: '.rjust(40))
all_count = [@rtf_count, @txt_count, @pdf_count,
             @xls_count, @doc_count, @ppt_count,
             @sql_count, @url_count]

all_count = all_count.sort_by { |ext| ext[1] }.reverse!

all_count.each do |ext_type|
  puts "#{ext_type[0]}: ".upcase.rjust(40) + ext_type[1].to_s
end

puts pastel.underline('FILE LIST: '.rjust(40))
[@rtf, @txt, @pdf, @xls, @doc, @ppt, @sql, @url].each do |type|
  type = type.sort_by { |a_sort| a_sort[1] }
  type = type.uniq
  type.each do |a_title, a_url|
    next unless type.count.positive?

    puts 'TITLE: ' + a_title.to_s if @use_title == true
    puts 'URL: ' + a_url.to_s if @use_url == true
  end
end
