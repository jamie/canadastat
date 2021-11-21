class Builders::Regions < SiteBuilder
  def build
    generator do
      site.data["regions"].each do |region|
        code = region["code"]
        add_resource :regions, "#{code}.md" do
          layout "ical"
          permalink "/#{code}.ics"
        end
      end
    end
  end
end
