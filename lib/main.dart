import 'package:flutter/material.dart';

void main() {
  runApp(const BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Biblioteca ADSO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Azul Institucional
          brightness: Brightness.light,
        ),
      ),
      home: const CatalogoAdaptativoScreen(),
    );
  }
}

// Modelo de datos simulado
class Libro {
  final int id;
  final String titulo;
  final String autor;
  final String categoria;
  final bool disponible;
  final String imagenUrl;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.categoria,
    required this.disponible,
    required this.imagenUrl,
  });
}

class CatalogoAdaptativoScreen extends StatefulWidget {
  const CatalogoAdaptativoScreen({super.key});

  @override
  State<CatalogoAdaptativoScreen> createState() => _CatalogoAdaptativoScreenState();
}

class _CatalogoAdaptativoScreenState extends State<CatalogoAdaptativoScreen> {
  // Datos de prueba para el catálogo
  final List<Libro> libros = [
    Libro(id: 1, titulo: 'Cien Años de Soledad', autor: 'Gabriel García Márquez', categoria: 'Novela', disponible: true, imagenUrl: 'https://via.placeholder.com/150'),
    Libro(id: 2, titulo: 'El Algoritmo Definitivo', autor: 'Pedro Domingos', categoria: 'Tecnología', disponible: true, imagenUrl: 'https://via.placeholder.com/150'),
    Libro(id: 3, titulo: 'Clean Code en Python', autor: 'Robert C. Martin', categoria: 'Software', disponible: false, imagenUrl: 'https://via.placeholder.com/150'),
    Libro(id: 4, titulo: 'Don Quijote de la Mancha', autor: 'Miguel de Cervantes', categoria: 'Clásico', disponible: true, imagenUrl: 'https://via.placeholder.com/150'),
    Libro(id: 5, titulo: 'FastAPI Web Development', autor: 'Sena ADSO', categoria: 'Tecnología', disponible: true, imagenUrl: 'https://via.placeholder.com/150'),
    Libro(id: 6, titulo: 'Estructuras de Datos', autor: 'Goodrich & Tamassia', categoria: 'Software', disponible: false, imagenUrl: 'https://via.placeholder.com/150'),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Biblioteca ADSO - Catálogo (${mediaQuery.size.width.toInt()}px)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint: Si el ancho es mayor o igual a 600px, muestra diseño de Tablet/Escritorio
          if (constraints.maxWidth >= 600) {
            return _buildTabletLayout(constraints);
          } else {
            return _buildMobileLayout(constraints, isLandscape);
          }
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.book), label: 'Catálogo'),
                NavigationDestination(icon: Icon(Icons.bookmark), label: 'Préstamos'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
              ],
            )
          : null, // Ocultar barra inferior en Tablets y usar menú lateral
    );
  }

  // --- LAYOUT PARA SMARTPHONES (< 600px) ---
  Widget _buildMobileLayout(BoxConstraints constraints, bool isLandscape) {
    int crossAxisCount = isLandscape ? 3 : 2;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBarraBusqueda(),
          const SizedBox(height: 12),
          Text(
            'Libros Disponibles (${libros.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.72,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: libros.length,
              itemBuilder: (context, index) {
                return _buildTarjetaLibro(libros[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- LAYOUT PARA TABLETS (>= 600px) ---
  Widget _buildTabletLayout(BoxConstraints constraints) {
    return Row(
      children: [
        // Menú Lateral de Navegación Persistente
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(icon: Icon(Icons.book), label: Text('Catálogo')),
            NavigationRailDestination(icon: Icon(Icons.bookmark), label: Text('Préstamos')),
            NavigationRailDestination(icon: Icon(Icons.person), label: Text('Perfil')),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        // Contenido Principal en Cuadrícula de 4 Columnas
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBarraBusqueda(),
                const SizedBox(height: 16),
                Text(
                  'Vista Adaptativa de Tablet / Escritorio',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 Columnas en Tablet
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: libros.length,
                    itemBuilder: (context, index) {
                      return _buildTarjetaLibro(libros[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Componente Reutilizable: Barra de Búsqueda
  Widget _buildBarraBusqueda() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar libro por título o autor...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  // Componente Reutilizable: Tarjeta de Libro Responsiva
  Widget _buildTarjetaLibro(Libro libro) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(
                Icons.book_sharp,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  libro.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  libro.autor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(libro.categoria, style: const TextStyle(fontSize: 10)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Icon(
                      libro.disponible ? Icons.check_circle : Icons.cancel,
                      color: libro.disponible ? Colors.green : Colors.red,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}