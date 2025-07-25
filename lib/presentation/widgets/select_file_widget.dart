import 'package:dauco/presentation/blocs/load_file_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectFileWidget extends StatelessWidget {
  const SelectFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(237, 247, 238, 255),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
        onPressed: () {
          context.read<LoadFileBloc>().add(LoadFileEvent());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Añadir datos',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Color.fromARGB(255, 43, 45, 66),
                )),
            const SizedBox(width: 10),
            const Icon(Icons.drive_folder_upload_outlined,
                size: 28, color: Color.fromARGB(255, 55, 57, 82)),
          ],
        ),
      ),
    );
  }
}
