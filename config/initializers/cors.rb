Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # in produzione restringa al dominio del frontend

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end