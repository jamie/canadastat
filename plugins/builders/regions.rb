class Builders::Regions < SiteBuilder
  def build
    generator do
      site.data["regions"].each do |region|
        code = region["slug"]
        add_resource :regions, "#{code}.md" do
          layout "regions"
          permalink "/#{code}.ics"
        end
      end
    end
  end
end
