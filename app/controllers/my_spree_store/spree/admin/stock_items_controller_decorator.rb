module MySpreeStore
  module Spree
    module Admin
      module StockItemsControllerDecorator

        def create
          variant = ::Spree::Variant.find(params[:variant_id])
          stock_location = ::Spree::StockLocation.find(params[:stock_location_id])
          stock_movement = stock_location.stock_movements.build(stock_movement_params)
          stock_movement.stock_item = stock_location.set_up_stock_item(variant)

          if stock_movement.save
            flash[:success] = flash_message_for(stock_movement, :successfully_created)
            $kafka_producer.produce(stock_movement.to_json, topic: "stock", partition_key: variant.id)
          else
            flash[:error] = ::Spree.t(:could_not_create_stock_movement)
          end

          redirect_back fallback_location: spree.stock_admin_product_url(variant.product)
        end
      end
    end
  end
end

::Spree::Admin::StockItemsController.prepend MySpreeStore::Spree::Admin::StockItemsControllerDecorator if
  ::Spree::Admin::StockItemsController.included_modules.exclude?(MySpreeStore::Spree::Admin::StockItemsControllerDecorator)
