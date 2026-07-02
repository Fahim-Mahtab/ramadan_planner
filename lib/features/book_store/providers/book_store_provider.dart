import 'package:flutter/foundation.dart';
import '../models/book_model.dart';

class BookStoreProvider with ChangeNotifier {
  final List<BookModel> _books = [
    BookModel(
      title: 'Fortress of the Muslim',
      author: 'Sa\'id bin Ali bin Wahf Al-Qahtani',
      price: 8.99,
      description: 'A comprehensive collection of authentic duas and adhkar for daily life, known as Hisnul Muslim.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2023/10/Fortress-of-Muslim-600x600.png',
    ),
    BookModel(
      title: 'The Sealed Nectar',
      author: 'Saifur Rahman Al-Mubarakpuri',
      price: 12.99,
      description: 'A detailed biography of the Prophet Muhammad (PBUH), winner of the first Islamic book contest.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2023/10/The-Sealed-Nectar-600x600.png',
    ),
    BookModel(
      title: 'Riyad-us-Saliheen',
      author: 'Imam Nawawi',
      price: 14.99,
      description: 'A classic collection of Hadith covering all aspects of faith, manners, and worship.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2023/10/Riyad-us-Saliheen-600x600.png',
    ),
    BookModel(
      title: 'Stories of the Prophets',
      author: 'Ibn Kathir',
      price: 11.99,
      description: 'Inspiring stories of the prophets from Adam to Isa (AS) as narrated in the Quran and authentic Hadith.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2018/02/Stories-of-the-Prophets-600x600.png',
    ),
    BookModel(
      title: 'Tafsir Ibn Kathir (Abridged)',
      author: 'Ibn Kathir',
      price: 19.99,
      description: 'An abridged English translation of the renowned Tafsir of the Noble Quran.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2018/02/Tafsir-Ibn-Kathir-Volume-2-600x600.png',
    ),
    BookModel(
      title: 'The Quran (English Translation)',
      author: 'Saheeh International',
      price: 9.99,
      description: 'Clear, accurate English translation of the Quran with Arabic text.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2024/01/The-Quran-English-Translation-600x600.png',
    ),
    BookModel(
      title: 'Bulugh al-Maram',
      author: 'Ibn Hajar al-Asqalani',
      price: 13.99,
      description: 'A collection of Hadith used as a primary source for Islamic jurisprudence.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2023/10/Bulugh-al-Maram-600x600.png',
    ),
    BookModel(
      title: 'Reclaim Your Heart',
      author: 'Yasmin Mogahed',
      price: 10.99,
      description: 'A profound book about finding spiritual healing and breaking free from emotional attachments.',
      imageUrl: 'https://cdn.kitabghor.com/storage/2023/10/Reclaim-Your-Heart-600x600.png',
    ),
  ];

  List<BookModel> get books => _books;
}
