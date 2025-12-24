import 'package:flutter/material.dart';

class LocationSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> options;
  final String? selectedValue; // Valor actual seleccionado
  final Function(String) onSelected;
  final bool isLoading; // Para mostrar carga en el mismo botón

  const LocationSelector({
    super.key,
    required this.label,
    required this.icon,
    required this.options,
    required this.onSelected,
    this.selectedValue,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // EL BOTÓN (Parece un Input pero abre un Modal)
        GestureDetector(
          onTap: isLoading ? null : () => _showSearchModal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    isLoading
                        ? "Cargando..."
                        : (selectedValue ?? "Seleccionar..."),
                    style: TextStyle(
                      color: selectedValue != null
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                else
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- EL MODAL OPTIMIZADO (ListView.builder) ---
  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1E33),
      isScrollControlled: true, // Permite que ocupe más pantalla
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return _SearchModalContent(
          options: options,
          onSelected: onSelected,
          title: label,
        );
      },
    );
  }
}

// Widget interno para manejar la búsqueda dentro del modal
class _SearchModalContent extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;
  final String title;

  const _SearchModalContent({
    required this.options,
    required this.onSelected,
    required this.title,
  });

  @override
  State<_SearchModalContent> createState() => _SearchModalContentState();
}

class _SearchModalContentState extends State<_SearchModalContent> {
  List<String> _filteredOptions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options; // Al inicio mostramos todo
  }

  void _filterList(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 70% de altura
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Barrita superior de adorno
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Text(
            "Seleccionar ${widget.title}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Buscador interno
          TextField(
            controller: _searchController,
            onChanged: _filterList,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Buscar...",
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // LISTA OPTIMIZADA (Lo que arregla el lag)
          Expanded(
            child: _filteredOptions.isEmpty
                ? const Center(
                    child: Text(
                      "No encontrado",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    // <--- ESTO ES LA CLAVE DE RENDIMIENTO
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      return ListTile(
                        title: Text(
                          option,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          widget.onSelected(option); // Devolvemos el valor
                          Navigator.pop(context); // Cerramos modal
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
