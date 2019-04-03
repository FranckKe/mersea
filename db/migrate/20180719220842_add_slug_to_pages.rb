class AddSlugToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :slug, :string

    Page.find_each.each do |page|
      page.update_attributes!(slug: page.name.parameterize.truncate(80, omission: ''))
    end
  end
end
