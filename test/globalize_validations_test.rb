# encoding: utf-8
#
require "test_helper"

class GlobalizeValidationsTest < ActiveSupport::TestCase
  class Page < ActiveRecord::Base
    translates :title, :body
    globalize_accessors
    globalize_validations

    validates :title, presence: true, uniqueness: true
    validate :validates_globalized_attributes
  end

  class PageWithLimitedGlobalizedLocales < ActiveRecord::Base
    self.table_name = :pages

    translates :title, :body
    globalize_accessors locales: [:en, :fr]
    globalize_validations

    validates :title, presence: true, uniqueness: true
    validate :validates_globalized_attributes
  end

  class PageWithLimitedLocales < ActiveRecord::Base
    self.table_name = :pages

    translates :title, :body
    globalize_accessors locales: [:en, :es, :fr]
    globalize_validations locales: [:en, :fr]

    validates :title, presence: true, uniqueness: true
    validate :validates_globalized_attributes
  end

  class PageWithLimitedLocalesAsProc < ActiveRecord::Base
    self.table_name = :pages

    translates :title, :body
    globalize_accessors
    globalize_validations locales: Proc.new { |page| page.available_locales }

    validates :title, presence: true, uniqueness: true
    validate :validates_globalized_attributes

    attr_accessor :available_locales
  end

  class PageWithoutCurrentLocales < ActiveRecord::Base
    self.table_name = :pages

    translates :title, :body
    globalize_accessors
    globalize_validations locales: [:es, :fr]

    validates :title, presence: true, uniqueness: true
    validate :validates_globalized_attributes
  end

  class PageWithComposedLocale < ActiveRecord::Base
    self.table_name = :pages

    translates :title, :body
    globalize_accessors locales: [:en, :"zh-TW"]
    globalize_validations

    validates :title, presence: true, uniqueness: true
    validate :validates_globalized_attributes
  end

  class PageWithValidDefault < ActiveRecord::Base
    self.table_name = :pages

    translates :title, :body
    globalize_accessors
    globalize_validations

    validates :title, length: { maximum: 5 }, allow_blank: true
    validate :validates_globalized_attributes
  end

  setup do
    assert_equal :en, I18n.locale
  end

  teardown do
    Page.destroy_all
  end

  test "validates with globalize_locales by default" do
    page = PageWithLimitedGlobalizedLocales.new
    assert_equal [:en, :fr], PageWithLimitedGlobalizedLocales.globalize_validations_locales
  end

  test "accepts valid object" do
    page = Page.new(title_en: "Title", title_fr: "Titre", title_es: "Titulo")
    assert page.valid?, "Must be valid with proper params"
  end

  test "validates for all locales" do
    page = Page.new

    assert page.invalid?, "Can't be valid with title present for all locales"

    assert_equal ["can't be blank"],  page.errors[:title_en]
    assert_equal ["can't be blank"],  page.errors[:title_fr]
    assert_equal ["can't be blank"],  page.errors[:title_es]
  end

  test "does not keep errors in none translated attribute names" do
    page = Page.new
    page.valid?

    assert_empty page.errors[:title]
  end

  test "validates uniqueness for primary locale" do
    Page.create!(title_en: "Title", title_es: "Titulo", title_fr: "Titre")
    page = Page.new(title_en: "Title", title_es: "Nuevo Titulo", title_fr: "Nouveau titre")

    assert page.invalid?, "Can't be valid with identical title"

    assert_equal ["has already been taken"], page.errors[:title_en]
    assert_empty page.errors[:title_es]
    assert_empty page.errors[:title_fr]
  end

  test "validates uniqueness for non-primary locales" do
    Page.create!(title_en: "Title", title_es: "Titulo", title_fr: "Titre")
    page = Page.new(title_en: "New Title", title_es: "Nuevo Titulo", title_fr: "Titre")

    assert page.invalid?, "Can't be valid with identical title"

    assert_equal ["has already been taken"], page.errors[:title_fr]
    assert_empty page.errors[:title_en]
    assert_empty page.errors[:title_es]
  end

  test "validates uniqueness against proper locale" do
    Page.create!(title_en: "Title", title_es: "Titulo", title_fr: "Titre")
    page = Page.new(title_en: "Titre", title_es: "Title", title_fr: "Titulo")

    assert page.valid?, "Must be valid when uniq per locale"
  end

  test "validates only limited locales" do
    page = PageWithLimitedLocales.new(title_en: "Title", title_fr: "Titre")
    assert page.valid?, "Must be valid if all chosen locales are satisfied."
  end

  test "validates only limited locales given as Proc" do
    page = PageWithLimitedLocalesAsProc.new(title_en: "Title", title_fr: "Titre")
    page.available_locales = [:en, :fr]

    assert page.valid?, "Must be valid if all locales given by the Proc are satisfied."
  end

  test "validates without locales given as Proc" do
    page = PageWithLimitedLocalesAsProc.new(title: "Title")
    page.available_locales = nil

    assert page.valid?, "Must be valid if all locales given by the Proc are satisfied."
  end

  test "validates only for the given locales, without current one" do
    page = PageWithoutCurrentLocales.new(title_es: "Titulo", title_fr: "Titre")
    assert page.valid?, "Must be valid if all chosen locales are satisfied."
  end

  test "validates with composed locales" do
    page = PageWithComposedLocale.new(title_en: "Title", title_zh_tw: "ชื่อเรื่อง")
    assert page.valid?, "Must be valid with composed locales"
  end

  test "returns errors for composed locales" do
    page = PageWithComposedLocale.new(title_en: "Title")
    page.valid?
    assert_equal ["can't be blank"], page.errors[:title_zh_tw]
  end

  test "returns only one error when only default locale is invalid and others are provided" do
    page = Page.new(title_fr: "title", title_es: "title")
    page.valid?
    assert_equal ["can't be blank"], page.errors[:title_en]
    assert_empty page.errors[:title_es]
    assert_empty page.errors[:title_fr]
  end

  test "return errors for all locales when default locale is invalid and others are not provided but have valid default" do
    page = PageWithValidDefault.new(title_en: "titlex")
    assert page.invalid?
    assert_equal ["is too long (maximum is 5 characters)"], page.errors[:title_en]
    assert_empty page.errors[:title_es]
    assert_empty page.errors[:title_fr]
  end
end
