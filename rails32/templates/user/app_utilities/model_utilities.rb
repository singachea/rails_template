module ModelUtilities

  def sort_orders keys
    sort_key = self::SORT_KEYS
    return sort_key[:default] if keys.blank?
    ks = keys.downcase.gsub(/\s/, "").split(",") rescue []
    selects = ks.map do |key|
      sort_key[:asc].include?(key) ? "#{key} asc" : (sort_key[:desc].include?(key) ? "#{key} desc" : nil)
    end
    picks = selects.select{ |v| !v.nil? }
    picks.length == 0 ? sort_key[:default] : picks.join(", ")
  end


  def search_for options
    search_key = options[:search_key]
    criterion = options[:criterion]
    search_keys = self::SEARCH_KEYS
    search_keys.include?(criterion) ? self.where("#{criterion} LIKE ?", "%#{search_key}%") : self
  end

  def search_and_sort options
    search = search_for options
    search.order(sort_orders(options[:sort]))
  end

end