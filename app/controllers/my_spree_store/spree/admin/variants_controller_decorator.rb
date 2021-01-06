module MySpreeStore
  module Spree
    module Admin
      module VariantsControllerDecorator

        def create
          if @product.variant_migration_candidate?
            invoke_callbacks(:create, :before)
            @object.attributes = permitted_resource_params
            if @product.migrate_to_variant(@object.option_values)
              #TODO: Consider impact of skipping invoke_callbacks(:create, :after)
              flash[:success] = flash_message_for(@object, :successfully_created)
              respond_with(@object) do |format|
                format.html { redirect_to location_after_save }
                format.js   { render layout: false }
              end
            end
            #TODO: Consider failure scenarios
          else
            super
          end
        end
      end
    end
  end
end

::Spree::Admin::VariantsController.prepend MySpreeStore::Spree::Admin::VariantsControllerDecorator if
  ::Spree::Admin::VariantsController.included_modules.exclude?(MySpreeStore::Spree::Admin::VariantsControllerDecorator)
