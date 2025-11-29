import '../models/motivation_quote.dart';

class MotivationQuoteService {
  static final List<MotivationQuote> _quotes = [
    const MotivationQuote(
      quote: 'Günleri sayma, günlerini sayılmaya değer kıl.',
      author: 'Muhammad Ali',
    ),
    const MotivationQuote(
      quote: 'Bazıları olmasını ister, bazıları ise oldurur.',
      author: 'Michael Jordan',
    ),
    const MotivationQuote(
      quote: 'Dinlenmek için değil, bitirmek için dur.',
      author: 'Kobe Bryant',
    ),
    const MotivationQuote(
      quote: 'Ben antrenmanda yıllarca çalıştım, sadece 10 saniye koşmak için.',
      author: 'Usain Bolt',
    ),
    const MotivationQuote(
      quote: 'Benim rekabetim sadece kendimle.',
      author: 'Cristiano Ronaldo',
    ),
    const MotivationQuote(
      quote: 'Disiplin, nefret ettiğin şeyi, seviyormuş gibi yapmaktır.',
      author: 'Mike Tyson',
    ),
    const MotivationQuote(
      quote: 'Başarı tesadüf değildir. Çok çalışma ve fedakarlıktır.',
      author: 'Pele',
    ),
    const MotivationQuote(
      quote: 'Yorulduğunda değil, bittiğinde dur.',
      author: 'David Goggins',
    ),
    const MotivationQuote(
      quote: 'Şampiyon, kimse ona inanmazken de oynayandır.',
      author: 'Serena Williams',
    ),
    const MotivationQuote(
      quote: 'Yetenekli değilim, ben takıntılıyım.',
      author: 'Conor McGregor',
    ),
    const MotivationQuote(
      quote: 'Asla pes etmeyen birini yenemezsiniz.',
      author: 'Babe Ruth',
    ),
    const MotivationQuote(
      quote: 'Hayallerine ulaşmak için savaşmalısın.',
      author: 'Lionel Messi',
    ),
    const MotivationQuote(
      quote: 'Acı yoksa, kazanç da yok.',
      author: 'Arnold Schwarzenegger',
    ),
    const MotivationQuote(
      quote: 'Kan, ter ve saygı. İlk ikisini verirsin, sonuncusunu kazanırsın.',
      author: 'Dwayne \'The Rock\' Johnson',
    ),
    const MotivationQuote(
      quote: 'Bilmek yetmez, uygulamalıyız; istemek yetmez, yapmalıyız.',
      author: 'Bruce Lee',
    ),
    const MotivationQuote(
      quote: 'Önemli olan ne kadar sert vurduğun değil, ne kadar sert darbe alıp devam edebildiğindir.',
      author: 'Sylvester Stallone',
    ),
    const MotivationQuote(
      quote: 'Mazeretlerin karnını doyurmaz.',
      author: 'Jason Statham',
    ),
    const MotivationQuote(
      quote: 'Sağlam kafa, sağlam vücutta bulunur.',
      author: 'M. Kemal Atatürk',
    ),
    const MotivationQuote(
      quote: 'Mükemmellik bir eylem değil, bir alışkanlıktır.',
      author: 'Aristoteles',
    ),
    const MotivationQuote(
      quote: 'Kendini fethetmek, zaferlerin en büyüğüdür.',
      author: 'Platon',
    ),
    const MotivationQuote(
      quote: 'Zor olduğu için cesaret edemiyor değiliz, cesaret edemediğimiz için zordur.',
      author: 'Seneca',
    ),
    const MotivationQuote(
      quote: 'Durmadığın sürece ne kadar yavaş gittiğinin bir önemi yoktur.',
      author: 'Konfüçyüs',
    ),
    const MotivationQuote(
      quote: 'Cehennemin içinden geçiyorsan, yürümeye devam et.',
      author: 'Winston Churchill',
    ),
    const MotivationQuote(
      quote: 'Pürüzsüz bir deniz, asla usta bir denizci yetiştirmez.',
      author: 'Franklin D. Roosevelt',
    ),
    const MotivationQuote(
      quote: 'Sadece yap.',
      author: 'Nike',
    ),
    const MotivationQuote(
      quote: 'Gelecekteki sen, şu an yaptıkların için sana teşekkür edecek.',
      author: 'Anonim',
    ),
    const MotivationQuote(
      quote: 'Ter, yağların ağlamasıdır.',
      author: 'Anonim',
    ),
    const MotivationQuote(
      quote: 'Başlamak için harika olmana gerek yok, ama harika olmak için başlamalısın.',
      author: 'Anonim',
    ),
    const MotivationQuote(
      quote: 'Vücudun yapabilir, ikna etmen gereken tek şey zihnin.',
      author: 'Anonim',
    ),
    const MotivationQuote(
      quote: 'Bir saatlik antrenman, gününün sadece %4\'üdür. Mazeret yok.',
      author: 'Anonim',
    ),
  ];

  /// Günlük motivasyon mesajını döndürür
  /// Aynı gün aynı mesaj, ertesi gün farklı mesaj gösterilir
  static MotivationQuote getDailyQuote() {
    if (_quotes.isEmpty) {
      return const MotivationQuote(
        quote: 'Start your journey today!',
        author: 'ZoneRun',
      );
    }

    // Bugünün tarihini kullanarak deterministik bir index seç
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % _quotes.length;

    return _quotes[index];
  }

  /// Tüm mesajları döndürür (test/debug için)
  static List<MotivationQuote> getAllQuotes() => _quotes;
}

