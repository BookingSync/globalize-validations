ActiveRecord::Schema.define(:version => 0) do

  create_table "pages", :force => true do |t|
    t.integer  "position"
  end

  create_table "page_translations", :force => true do |t|
    t.references :page
    t.string "title"
    t.text "body"
    t.string "locale"
  end

end
