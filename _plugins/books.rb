module Jekyll
  class StatusPage < Page
    def initialize(site, status)
      @site = site
      @name = "#{status}.html"
      @base = site.source
      @dir = '/'
      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'status_page.html')
      books = YAML.load(File.read(File.join(@base, '_data/books.yaml')))
      self.data['books'] = books.find_all {|b| b["status"] == status}
      self.data['title'] = "#{site.config['name']}: #{status.capitalize}"
    end
  end

  class StatusPageGenerator < Generator
    safe true
    def generate(site)
      ["reading", "done", "want"].each do |status|
        p = StatusPage.new(site, status)
        site.pages << p
      end
    end
  end

end
