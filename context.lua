return {
    server_name = "api.production.local",
    port = 8443,
    ssl_enabled = true,
    max_clients = 2048,
    upstream_nodes = {
        "192.168.1.10:8001",
        "192.168.1.11:8002",
        "192.168.1.12:8003"
    },
    routes = {
        { path = "/api/v1", target = "backend_pool", rate_limit = "100r/s" },
        { path = "/static", target = "/var/www/static", rate_limit = "off" },
        { path = "/health", target = "internal_health", rate_limit = "off" }
    }
}
