#import "/utils/todo.typ": TODO

= Apollon Standalone Deployment Setup
#align(left)[
  #text(size: 10pt)[Belemir Kürün]
]


To ensure that the reengineered version of Apollon is available reliably in production environments, we deployed the system using a reverse proxy configuration centered around modular services. The application consists of three subsystems: the Apollon webapp, a backend server responsible for WebSocket-based collaboration and RESTful API endpoints, and a persistent database for storing models. These components are containerized and managed using Docker Compose.

== Caddy Reverse Proxy

At the core of the deployment infrastructure is *Caddy*, a modern web server and reverse proxy that simplifies configuration, particularly for projects that rely heavily on secure WebSocket connections. All incoming HTTP and HTTPS traffic is routed through Caddy#footnote[https://caddyserver.com], which acts as a single entry point into the system. When a request arrives, Caddy evaluates the path. If the path begins with `/ws` or `/api`, the request is proxied to the Apollon server, which handles WebSocket communication for real-time collaboration or API requests for loading and storing diagrams. All other requests, including the base path, are directed to the Apollon webapp, which serves the frontend application.

We selected Caddy over alternatives such as Nginx because of its simplified setup and built-in support for automatic HTTPS via Let’s Encrypt. This eliminated the need for manual TLS certificate configuration and allowed us to maintain a clean and concise reverse proxy setup with native WebSocket support. The flexibility of Caddy made it especially well-suited for our use case, which requires consistent handling of real-time data streams across devices, including mobile clients.

== Hosting and Security

The entire system is hosted on a managed virtual machine. Docker Compose manages the containers and ensures that the services remain up through restart policies and built-in health checks. The firewall configuration on the server ensures that only the Caddy port (typically 443 for HTTPS traffic) is exposed to the outside world, while all internal services communicate over a private Docker network. Sensitive environment variables such as database credentials and API tokens are injected at runtime using `.env` files that are excluded from version control. This approach maintains both security and modularity, allowing for easier adaptation between staging and production environments.







