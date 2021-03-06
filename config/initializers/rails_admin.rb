I18n.default_locale = :fr

RailsAdmin.config do |config|
  config.main_app_name = %w(Mersea BackOffice)

  ### Popular gems integration

  ## == ActiveStorage ==
  # https://github.com/sferik/rails_admin/issues/3014
  config.excluded_models = ['ActiveStorage::Blob', 'ActiveStorage::Attachment', 'AccessToken']

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  ## == RailsAdminImport ==
  config.configure_with(:import) do |config|
    config.logging = true
  end

config.model 'Admin' do
  visible false
end

  config.actions do
    dashboard # mandatory
    index   # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app do
      except ['Report']
    end
    # rails_admin_state
    state
    # rails_admin_import
    all
    import
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
