import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: CompositeExample(),
        ),
      ),
    );
  }
}

class CompositeExample extends StatelessWidget {
  const CompositeExample({Key? key}) : super(key: key);

  Widget buildMediaDirectory() {
    var musicDirectory = Directory('Music')
      ..addFile(const AudioFile('Darude - Sandstorm.mp3', 2612453))
      ..addFile(const AudioFile('Toto - Africa.mp3', 3219811))
      ..addFile(const AudioFile('Bag Raiders - Shooting Stars.mp3', 3811214));
    var moviesDirectory = Directory('Movies')
      ..addFile(const VideoFile('The Matrix.avi', 951495532))
      ..addFile(const VideoFile('The Matrix Reloaded', 1251495532));
    var catPicturesDirectory = Directory('Cats')
      ..addFile(const ImageFile('Cat 1.jpg', 844497))
      ..addFile(const ImageFile('Cat 2.jpg', 975363))
      ..addFile(const ImageFile('Cat 3.jpg', 1975363));
    var picturesDirectory = Directory('Pictures')
      ..addFile(catPicturesDirectory)
      ..addFile(const ImageFile('Not a cat', 2971361));
    var mediaDirectory = Directory('Media', true)
      ..addFile(musicDirectory)
      ..addFile(moviesDirectory)
      ..addFile(picturesDirectory)
      ..addFile(Directory('New Folder'))
      ..addFile(const TextFile('Nothing suspicious here.txt', 430791))
      ..addFile(const TextFile('TeamTrees', 1042));
    return mediaDirectory;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: buildMediaDirectory(),
      ),
    );
  }
}

abstract class IFile {
  int getSize();
  Widget render(BuildContext context);
}

class File extends StatelessWidget implements IFile {
  const File(this.title, this.size, this.icon, {Key? key}) : super(key: key);
  final String title;
  final int size;
  final IconData icon;
  @override
  int getSize() {
    return size;
  }

  @override
  Widget render(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: Icon(icon),
        trailing: Text(
          FileSizeConverter.bytesToString(size),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Colors.black54),
        ),
        dense: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render(context);
  }
}

class AudioFile extends File {
  const AudioFile(String title, int size)
      : super(title, size, Icons.music_note);
}

class ImageFile extends File {
  const ImageFile(String title, int size) : super(title, size, Icons.image);
}

class TextFile extends File {
  const TextFile(String title, int size)
      : super(title, size, Icons.description);
}

class VideoFile extends File {
  const VideoFile(String title, int size) : super(title, size, Icons.movie);
}

class FileSizeConverter {
  static String bytesToString(int bytes) {
    var sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var len = bytes.toDouble();
    var order = 0;
    while (len >= 1024 && order++ < sizes.length - 1) {
      len /= 1024;
    }
    return '${len.toStringAsFixed(2)} ${sizes[order]}';
  }
}

class Directory extends StatelessWidget implements IFile {
  Directory(this.title, [this.isInitiallyExpanded = false]);
  final String title;
  final bool isInitiallyExpanded;
  final List<IFile> files = [];
  void addFile(IFile file) {
    files.add(file);
  }

  @override
  int getSize() {
    var sum = 0;
    for (var file in files) {
      sum += file.getSize();
    }
    return sum;
  }

  @override
  Widget render(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.folder),
        title: Text('$title (${FileSizeConverter.bytesToString(getSize())})'),
        children: files.map((file) => file.render(context)).toList(),
        initiallyExpanded: isInitiallyExpanded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render(context);
  }
}
