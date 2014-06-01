#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'nokogiri'
require 'open-uri'
require 'optparse'
require 'yaml'
require 'URI'
require 'pp'

def russian_to_english_date(date_string)
  return "long ago" if date_string == 'давно'
  str = date_string.gsub(/январь|февраль|март|апрель|май|июнь|июль|август|сентябрь|октябрь|ноябрь|декабрь/, 'январь' => 'Jan', 'февраль' => 'Feb', 'март' => 'Mar', 'апрель' => 'Apr', 'май' => 'May', 'июнь' => 'Jun', 'июль' => 'Jul', 'август' => 'Aug', 'сентябрь' => 'Sep', 'октябрь' => 'Oct', 'ноябрь' => 'Nov', 'декабрь' => 'Dec')
  DateTime.strptime(str, '%b %Y').strftime('%Y-%m-%d')
end

class Book
  def self.get_books(books, status)
    url = "http://bibla.ru/#{options[:user]}/#{status}/"
    Nokogiri::HTML(open(url)).css('li.book').each do |book|
      books << Book.new(book, status).to_hash
    end
    books
  end

  def initialize(book, status)
    @book = book
    @status = status
  end

  def to_hash
    begin
      h = { 'title' => @book.css('h2.title span').text,
        'author' => @book.css('h3 a').text,
        'status' => @status}
      img = @book.css('img')
      unless img.empty?
        uri = URI.parse(img.attribute('src').to_s)
        `wget http://bibla.ru#{uri.path} -nc -P images 2>/dev/null`
        h['image'] = uri.path.split('/').last
      end
      read = @book.css('div.info div.content div.reading-times')
      h['read'] = russian_to_english_date(read[0].text.strip) unless read.empty?
    rescue Exception => e
      puts @book
      pp e.message
      pp e.backtrace.inspect
      raise e
    end
    h
  end
end

options = {:out => "_data/books.yaml", :force => false}

OptionParser.new do |opts|
  opts.banner = "Usage: ./parse_bibla.rb [options]"

  opts.on('-u', '--user USER', 'username on bibla.ru') do |user|
    options[:user] = user
  end
  opts.on('-o', '--out FILE', 'output file, default: _data/books.yaml') do |out|
    options[:out] = out
  end
  opts.on('-f', '--force', 'overwrite output file, default: false') do
    options[:force] = true
  end
end.parse!

abort("Please specify --user") if options[:user] == nil

if (!options[:force] && FileTest.exist?(options[:out]))
  puts "#{options[:out]} already exists, overwrite (y/n) ?"
  abort if gets.chomp != 'y'
end

books = Book.get_books([], 'now')
books = Book.get_books(books, 'read')
books = Book.get_books(books, 'want')

File.open(options[:out], 'w') {|f| f.write books.to_yaml }
puts "Done"

