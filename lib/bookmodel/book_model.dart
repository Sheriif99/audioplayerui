class Book{
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Book({
    required this.title, 
    required this.description, 
    required this.url, 
    required this.coverUrl});


static List<Book> books =[
  Book(title: "Hamlet", 
  description: "William Shakespear", 
  url: "assets/mp3File/sampleAudio.mp3", 
  coverUrl: "assets/Images/Hamlet.jpeg",
  ),
  Book(title: "title", 
  description: "description", 
  url: "url", 
  coverUrl: "coverUrl")
];
}
