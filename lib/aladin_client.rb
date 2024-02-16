require 'httparty'

class BookCategory 
  IT_BOOK = "351"
end

class AladinClient
  include HTTParty
  base_uri = "www.aladin.co.kr"

  # URL Prefix
  ITEM_LIST_PATH = "/ttb/api/itemlist.aspx"
  ITEM_LOOKUP_PATH = "/ttb/api/itemlookup.aspx"

  def initialize
    HTTParty.get("https://kodingwarrior.github.io")
    ttbkey = ENV['ALADIN_TTB_KEY']
    @query = { 
      ttbkey:, 
      output: 'js', 
      itemidtype: "itemid",
      cover: 'big',
      version: '20131101',
    }
  end

  def item_list(start: 1, maxresults: 50)
    query = { 
      **@query,
      querytype: 'itemnewall',
      start:,
      maxresults:,
      categoryid: BookCategory::IT_BOOK 
    }
    options = { query: }
    result = _get(ITEM_LIST_PATH, options)
    
    result['item']
  end 

  def item_lookup(item_id)
    query = { **@query, itemid: item_id }
    options = { query: }
    _get(ITEM_LOOKUP_PATH, options)
  end

  private

  def _get(path, options)
    HTTParty.get("https://www.aladin.co.kr#{path}", options)
  end
end
