module ActiveAdmin
  module Views
    module Pages
      class Show < Base

        def config
          active_admin_config.get_page_presenter(:show) || ::ActiveAdmin::PagePresenter.new
        end

        def title
          case config[:title]
          when Symbol, Proc
            call_method_or_proc_on(resource, config[:title])
          when String
            config[:title]
          else
            default_title
          end
        end

        def main_content
          if config.block
            # Eval the show config from the controller
            instance_exec resource, &config.block
          else
            default_main_content
          end
        end

        def attributes_table(*args, &block)
          panel(I18n.t('active_admin.details', :model => active_admin_config.resource_label)) do
            attributes_table_for resource_with_decorator, *args, &block
          end
        end

        def resource_with_decorator
          r = resource
          r.respond_to?(:decorator) ? r.decorator : r
        end

        protected

        def default_title
          "#{active_admin_config.resource_label}: #{display_name(resource)}"
        end

        module DefaultMainContent
          def default_main_content
            attributes_table *default_attribute_table_rows
          end

          def default_attribute_table_rows
            resource.class.columns.collect{|column| column.name.to_sym }
          end
        end

        include DefaultMainContent
      end
    end
  end
end
