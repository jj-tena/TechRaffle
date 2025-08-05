alias Techraffle.Repo
alias Techraffle.Raffles.Raffle
alias Techraffle.Charities.Charity

wildlife =
  %Charity{name: "Refugio de Vida Silvestre", slug: "refugio-vida-silvestre"}
  |> Repo.insert!()

food =
  %Charity{name: "Despensa de Alimentos", slug: "despensa-alimentos"}
  |> Repo.insert!()

hope =
  %Charity{name: "Hogares de Esperanza", slug: "hogares-esperanza"}
  |> Repo.insert!()

grace =
  %Charity{name: "Fundación Gracia", slug: "fundacion-gracia"}
  |> Repo.insert!()

%Raffle{
  prize: "Monitor LG UltraGear 27GL850-B",
  description: """
  Disfruta de una pantalla gaming de 27 pulgadas con resolución QHD y 144Hz para una experiencia visual increíblemente fluida y nítida. Perfecto para gamers y profesionales creativos.
  """,
  ticket_price: 4,
  status: :open,
  image_path: "/images/monitor-lg.jpg",
  charity: hope
}
|> Repo.insert!()

%Raffle{
  prize: "Ratón Logitech MX Master 3",
  description: """
  Ratón inalámbrico avanzado con precisión excepcional y ergonomía diseñada para horas de uso cómodo, ideal para productividad y diseño.
  """,
  ticket_price: 2,
  status: :upcoming,
  image_path: "/images/raton-logitech.jpg",
  charity: wildlife
}
|> Repo.insert!()

%Raffle{
  prize: "PlayStation 5",
  description: """
  La consola de última generación con gráficos y rendimiento de vanguardia para una experiencia de juego envolvente y rápida.
  """,
  ticket_price: 5,
  status: :close,
  image_path: "/images/ps5.jpg",
  charity: food
}
|> Repo.insert!()

%Raffle{
  prize: "Portátil Apple MacBook Air M2",
  description: """
  Un portátil ultraligero con procesador M2 para máxima potencia y eficiencia, ideal para trabajo, estudio y entretenimiento.
  """,
  ticket_price: 5,
  status: :open,
  image_path: "/images/macbook-air.jpg",
  charity: hope
}
|> Repo.insert!()

%Raffle{
  prize: "Teclado Mecánico Keychron K6",
  description: """
  Teclado compacto y personalizable con interruptores mecánicos para una escritura cómoda y precisa, perfecto para programadores y gamers.
  """,
  ticket_price: 2,
  status: :open,
  image_path: "/images/teclado-keychron.jpg",
  charity: food
}
|> Repo.insert!()

%Raffle{
  prize: "Auriculares Sony WH-1000XM4",
  description: """
  Auriculares inalámbricos con cancelación activa de ruido líder en la industria y una calidad de sonido superior para música y llamadas.
  """,
  ticket_price: 4,
  status: :upcoming,
  image_path: "/images/auriculares-sony.jpg",
  charity: grace
}
|> Repo.insert!()

%Raffle{
  prize: "Smartwatch Apple Watch Series 9",
  description: """
  El reloj inteligente más avanzado de Apple, con monitoreo de salud, notificaciones y diseño elegante para acompañarte todo el día.
  """,
  ticket_price: 4,
  status: :close,
  image_path: "/images/apple-watch.jpg",
  charity: food
}
|> Repo.insert!()

%Raffle{
  prize: "iPhone 16 Pro",
  description: """
  El último modelo de iPhone con cámara avanzada, rendimiento ultra rápido y diseño elegante. Ideal para quienes buscan lo mejor en tecnología móvil.
  """,
  ticket_price: 5,
  status: :open,
  image_path: "/images/iphone.jpg",
  charity: grace
}
|> Repo.insert!()

%Raffle{
  prize: "Nintendo Switch OLED",
  description: """
  Consola híbrida con pantalla OLED brillante, ideal para jugar en casa o en movilidad, con una biblioteca extensa de juegos para todas las edades.
  """,
  ticket_price: 4,
  status: :upcoming,
  image_path: "/images/nintendo-switch-oled.jpg",
  charity: wildlife
}
|> Repo.insert!()

%Raffle{
  prize: "Portátil Gaming ASUS ROG Strix G15",
  description: """
  Potente portátil para gaming con procesador AMD Ryzen y tarjeta gráfica NVIDIA RTX para el máximo rendimiento.
  """,
  ticket_price: 5,
  status: :upcoming,
  image_path: "/images/portatil-asus-rog.jpg",
  charity: grace
}
|> Repo.insert!()

%Raffle{
  prize: "Altavoz Inteligente Amazon Echo Dot",
  description: """
  Compacto altavoz con Alexa para controlar tu hogar inteligente, reproducir música y mucho más.
  """,
  ticket_price: 1,
  status: :close,
  image_path: "/images/echo-dot.jpg",
  charity: hope
}
|> Repo.insert!()

%Raffle{
  prize: "Xbox Series X",
  description: """
  La consola más poderosa de Xbox con gráficos 4K, tiempos de carga ultrarrápidos y un amplio catálogo de juegos.
  """,
  ticket_price: 5,
  status: :upcoming,
  image_path: "/images/xbox-series-x.jpg",
  charity: wildlife
}
|> Repo.insert!()
