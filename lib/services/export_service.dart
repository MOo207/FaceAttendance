import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  ExportService? _exportService;

  ExportService? get exportService => _exportService;

  String convertListToCsv(List<List<dynamic>> data) {
    final StringBuffer csvBuffer = StringBuffer();
    for (var row in data) {
      csvBuffer.writeln(row.join(","));
    }
    return csvBuffer.toString();
  }

  Future<void> writeDataToCSV(List<List<dynamic>> data) async {
    try {
      final String dir = (await getExternalStorageDirectory())!.path;
      // String dateTime = DateTime.now().toString();
      // final String filePath = '$dir/$dateTime.csv';
      // random number to avoid file name conflict
      final String filePath = '$dir/attendance_${Random().nextInt(10000)}.csv';

      // Define the CSV header
      final List<String> header = ['ID', 'NAME', 'TIME', 'ATTENDANCE'];

      // Combine the header with the data
      List<List<dynamic>> rows = [header, ...data];

      // Convert the rows list to a CSV string
      String csvText = convertListToCsv(rows);

      File csvFile = File(filePath);
      await csvFile.writeAsString(csvText);
      print('CSV file saved to $filePath');
      await openCSVFile(filePath);
    } catch (e) {
      print('Error writing to CSV file: $e');
    }
  }

  Future<void> openCSVFile(String path) async {
    try {
      if (await File(path).exists()) {
        await OpenFile.open(path);
      } else {
        print('File not found');
      }
    } catch (e) {
      print('Error opening CSV file: $e');
    }
  }
}
