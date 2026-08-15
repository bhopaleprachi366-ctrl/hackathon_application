// import 'package:flutter/material.dart';
// import 'Add_services.dart';
// import 'edit_services.dart';

// class MyServicesPage extends StatelessWidget {
//   const MyServicesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),

//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         title: const Text(
//           'My Services',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             const Text(
//               'Your Services',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 6),

//             const Text(
//               'Manage the services you provide.',
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),

//             const SizedBox(height: 20),

//             // Add Service Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AddServicePage(),
//                     ),
//                   );
//                   // Navigate to Add Service
//                 },
//                 icon: const Icon(Icons.add),
//                 label: const Text(
//                   'Add New Service',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

<<<<<<< HEAD
            // Service List
            Expanded(
              child: ListView(
                children: [
                  _buildServiceCard(
                    context,
                    title: 'Home Cleaning',
                    description: 'Professional home cleaning service',
                    price: '₹499',
                    subscribers: '18 Subscribers',
                  ),
=======
//             // Service List
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildServiceCard (
//                     context,
//                     title: 'Home Cleaning',
//                     description: 'Professional home cleaning service',
//                     price: '₹499',
//                     subscribers: '18 Subscribers',
//                   ),
>>>>>>> dcbf4c8294c70fc1bf7432787d0ed95fc8c40f02

//                   const SizedBox(height: 12),

//                   _buildServiceCard(
//                     context,
//                     title: 'Laundry Service',
//                     description: 'Fast and reliable laundry service',
//                     price: '₹299',
//                     subscribers: '12 Subscribers',
//                   ),

//                   const SizedBox(height: 12),

//                   _buildServiceCard(
//                     context,
//                     title: 'Car Washing',
//                     description: 'Complete car cleaning and washing',
//                     price: '₹399',
//                     subscribers: '8 Subscribers',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

<<<<<<< HEAD
  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String description,
    required String price,
    required String subscribers,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
=======
//   Widget _buildServiceCard(
//     BuildContext context,{
//     required String title,
//     required String description,
//     required String price,
//     required String subscribers,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),

//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
>>>>>>> dcbf4c8294c70fc1bf7432787d0ed95fc8c40f02

//       child: Row(
//         children: [
//           // Service Icon
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFEFF6FF),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.miscellaneous_services_outlined,
//               color: Color(0xFF2563EB),
//               size: 28,
//             ),
//           ),

//           const SizedBox(width: 14),

//           // Service Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 5),

//                 Text(
//                   description,
//                   style: const TextStyle(fontSize: 13, color: Colors.grey),
//                 ),

//                 const SizedBox(height: 8),

//                 Row(
//                   children: [
//                     Text(
//                       price,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2563EB),
//                       ),
//                     ),

//                     const SizedBox(width: 12),

//                     Text(
//                       subscribers,
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

<<<<<<< HEAD
          // More Options
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditServicePage(
                      serviceName: 'Home Cleaning',
                      category: 'Cleaning',
                      description: 'Professional home cleaning service',
                      price: '499',
                    ),
                  ),
                ); // Edit Service
              } else if (value == 'delete') {
                // Delete Service
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Color(0xFF2563EB)),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
=======
//           // More Options
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.more_vert, color: Colors.grey),
//             onSelected: (value) {
//               if (value == 'edit') {
//                 Navigator.push(
//                     context,
//                      MaterialPageRoute(
//                       builder: (context) => const EditServicePage(
//                         serviceName: 'Home Cleaning',
//                          category: 'Cleaning',
//                          description: 'Professional home cleaning service',
//                          price: '499',
//                         ),
//                      ),
//                    );                // Edit Service
//               } else if (value == 'delete') {
//                 // Delete Service
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'edit',
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit_outlined, color: Color(0xFF2563EB)),
//                     SizedBox(width: 10),
//                     Text('Edit'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'delete',
//                 child: Row(
//                   children: [
//                     Icon(Icons.delete_outline, color: Colors.red),
//                     SizedBox(width: 10),
//                     Text('Delete'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
>>>>>>> dcbf4c8294c70fc1bf7432787d0ed95fc8c40f02
