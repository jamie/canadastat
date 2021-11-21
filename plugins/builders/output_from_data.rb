class Builders::OutputFromData < SiteBuilder
  def build
    generator do
      # TODO: Figure out how to sanely load this from bridgetown.config.yml
      # site.config.collections.each do |collection, config|
      [["regions", {}]].each do |collection, config|
        #   next unless config["output_from_data"]
        site.data[collection].each.with_index do |entry, i|
          add_resource collection, "#{collection}_#{i}.md" do
            ___ entry
            layout collection
            # TODO: hardcoded 'ics' format here, instead load from config, or entry
            permalink "/:slug.ics"
          end
        end
      end
    end
  end
end
