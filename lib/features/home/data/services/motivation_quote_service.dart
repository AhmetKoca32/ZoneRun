import '../models/motivation_quote.dart';

class MotivationQuoteService {
  static final List<MotivationQuote> _quotesTr = [
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
      quote:
          'Önemli olan ne kadar sert vurduğun değil, ne kadar sert darbe alıp devam edebildiğindir.',
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
      quote:
          'Zor olduğu için cesaret edemiyor değiliz, cesaret edemediğimiz için zordur.',
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
    const MotivationQuote(quote: 'Sadece yap.', author: 'Nike'),
    const MotivationQuote(
      quote: 'Gelecekteki sen, şu an yaptıkların için sana teşekkür edecek.',
      author: 'Anonim',
    ),
    const MotivationQuote(
      quote: 'Ter, yağların ağlamasıdır.',
      author: 'Anonim',
    ),
    const MotivationQuote(
      quote:
          'Başlamak için harika olmana gerek yok, ama harika olmak için başlamalısın.',
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
    const MotivationQuote(
      quote: 'Yapamazsın diyenlere inat yap!',
      author: 'Anonim',
    ),
    const MotivationQuote(
      quote: 'Başarı, hazır olanlara değil; harekete geçenlere gelir.',
      author: 'Tony Robbins',
    ),
    const MotivationQuote(
      quote: 'Dünden ders alın, bugün için yaşayın, yarın için umutlu olun.',
      author: 'Albert Einstein',
    ),
  ];

  static final List<MotivationQuote> _quotesEn = [
    const MotivationQuote(
      quote: 'Don’t count the days, make the days count.',
      author: 'Muhammad Ali',
    ),
    const MotivationQuote(
      quote: 'Some people want it to happen, some make it happen.',
      author: 'Michael Jordan',
    ),
    const MotivationQuote(
      quote: 'Don’t stop to rest, stop when you\'re done.',
      author: 'Kobe Bryant',
    ),
    const MotivationQuote(
      quote: 'I trained for years just to run ten seconds.',
      author: 'Usain Bolt',
    ),
    const MotivationQuote(
      quote: 'My only competition is myself.',
      author: 'Cristiano Ronaldo',
    ),
    const MotivationQuote(
      quote: 'Discipline is doing what you hate as if you love it.',
      author: 'Mike Tyson',
    ),
    const MotivationQuote(
      quote: 'Success is no accident. It is hard work and sacrifice.',
      author: 'Pele',
    ),
    const MotivationQuote(
      quote: 'Don’t stop when you’re tired, stop when you’re done.',
      author: 'David Goggins',
    ),
    const MotivationQuote(
      quote: 'A champion is someone who plays when no one believes in them.',
      author: 'Serena Williams',
    ),
    const MotivationQuote(
      quote: 'I’m not talented, I’m obsessed.',
      author: 'Conor McGregor',
    ),
    const MotivationQuote(
      quote: 'You just can’t beat the person who never gives up.',
      author: 'Babe Ruth',
    ),
    const MotivationQuote(
      quote: 'No pain, no gain.',
      author: 'Arnold Schwarzenegger',
    ),
    const MotivationQuote(
      quote: 'Blood, sweat and respect. First two you give, last one you earn.',
      author: 'Dwayne \'The Rock\' Johnson',
    ),
    const MotivationQuote(
      quote: 'Knowing is not enough; we must apply. Willing is not enough; we must do.',
      author: 'Bruce Lee',
    ),
    const MotivationQuote(
      quote:
          'It’s not about how hard you hit. It’s about how hard you can get hit and keep moving forward.',
      author: 'Sylvester Stallone',
    ),
    const MotivationQuote(
      quote: 'Excuses don’t burn calories.',
      author: 'Jason Statham',
    ),
    const MotivationQuote(
      quote: 'A sound mind is in a sound body.',
      author: 'M. Kemal Atatürk',
    ),
    const MotivationQuote(
      quote: 'Excellence is not an act but a habit.',
      author: 'Aristotle',
    ),
    const MotivationQuote(
      quote: 'To conquer yourself is the greatest victory.',
      author: 'Plato',
    ),
    const MotivationQuote(
      quote:
          'It is not because things are difficult that we do not dare; it is because we do not dare that they are difficult.',
      author: 'Seneca',
    ),
    const MotivationQuote(
      quote: 'It does not matter how slowly you go as long as you do not stop.',
      author: 'Confucius',
    ),
    const MotivationQuote(
      quote: 'If you’re going through hell, keep going.',
      author: 'Winston Churchill',
    ),
    const MotivationQuote(
      quote: 'A smooth sea never made a skilled sailor.',
      author: 'Franklin D. Roosevelt',
    ),
    const MotivationQuote(quote: 'Just do it.', author: 'Nike'),
    const MotivationQuote(
      quote: 'The future you will thank you for what you do today.',
      author: 'Anonymous',
    ),
    const MotivationQuote(
      quote: 'Sweat is your fat crying.',
      author: 'Anonymous',
    ),
    const MotivationQuote(
      quote:
          'You don’t have to be great to start, but you have to start to be great.',
      author: 'Anonymous',
    ),
    const MotivationQuote(
      quote: 'Your body can, it’s your mind you have to convince.',
      author: 'Anonymous',
    ),
    const MotivationQuote(
      quote: 'One hour of training is only 4% of your day. No excuses.',
      author: 'Anonymous',
    ),
    const MotivationQuote(
      quote: 'Do it to prove the doubters wrong.',
      author: 'Anonymous',
    ),
    const MotivationQuote(
      quote: 'Success comes not to the prepared, but to those who take action.',
      author: 'Tony Robbins',
    ),
    const MotivationQuote(
      quote: 'Learn from yesterday, live for today, hope for tomorrow.',
      author: 'Albert Einstein',
    ),
  ];

  /// Günlük motivasyon mesajını döndürür
  /// Aynı gün aynı mesaj, ertesi gün farklı mesaj gösterilir
  static MotivationQuote getDailyQuote({String localeCode = 'tr'}) {
    final isEnglish = localeCode.toLowerCase().startsWith('en');
    final list = isEnglish ? _quotesEn : _quotesTr;

    if (list.isEmpty) {
      return const MotivationQuote(
        quote: 'Start your journey today!',
        author: 'ZoneRun',
      );
    }

    // Bugünün tarihini kullanarak deterministik bir index seç
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % list.length;

    return list[index];
  }

  /// Tüm mesajları döndürür (test/debug için)
  static List<MotivationQuote> getAllQuotes({String localeCode = 'tr'}) {
    final isEnglish = localeCode.toLowerCase().startsWith('en');
    return List.unmodifiable(isEnglish ? _quotesEn : _quotesTr);
  }
}
