module MySpreeStore
  module Spree
    module ProductDecorator

      # To convert a non-variant product with stock/history to a variant:
      # 1. Start with a "one of a kind" product (i.e. "Beautiful Blue Orb")
      # 2. Through admin, add an appropriate option type to the product
      #    (i.e. "Color") but not the variant itself.
      # 3. From the console, load the product record and an appropriate
      #    option_value record (i.e. "Blue")
      # 4. Call the method (i.e. orb.migrate_to_variant(blue)). This will
      #    turn the master variant into a regular variant, associate it with
      #    the option value, and create a replacement master variant.
      # 5. If needed, through admin, edit the product's name to remove
      #    anything specific to the variant (i.e. "Beautiful Orb")
      # 6. Additional variants (i.e. Red, Green) can be added through admin.
      # 7. Viewing the product in the spree storefront will now show the
      #    previous stock on the correct variant, along with the new variants.
      def migrate_to_variant(option_value)
        old_master = master
        new_master = old_master.dup
        new_master.update!(sku: '')
        old_master.option_values << option_value
        old_master.update!(is_master: false)
      end
    end
  end
end

::Spree::Product.prepend MySpreeStore::Spree::ProductDecorator if
  ::Spree::Product.included_modules.exclude?(MySpreeStore::Spree::ProductDecorator)
