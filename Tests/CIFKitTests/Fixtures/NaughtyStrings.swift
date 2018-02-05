import Foundation

// Taken from The Big List of Naughty Strings:
// https://github.com/minimaxir/big-list-of-naughty-strings
let naughtyStrings: [String] = [
    "",
    "undefined",
    "undef",
    "null",
    "NULL",
    "(null)",
    "nil",
    "NIL",
    "true",
    "false",
    "True",
    "False",
    "TRUE",
    "FALSE",
    "None",
    "hasOwnProperty",
    "\\",
    "\\\\",
    "0",
    "1",
    "1.00",
    "$1.00",
    "1/2",
    "1E2",
    "1E02",
    "1E+02",
    "-1",
    "-1.00",
    "-$1.00",
    "-1/2",
    "-1E2",
    "-1E02",
    "-1E+02",
    "1/0",
    "0/0",
    "-2147483648/-1",
    "-9223372036854775808/-1",
    "-0",
    "-0.0",
    "+0",
    "+0.0",
    "0.00",
    "0..0",
    ".",
    "0.0.0",
    "0,00",
    "0,,0",
    ",",
    "0,0,0",
    "0.0/0",
    "1.0/0.0",
    "0.0/0.0",
    "1,0/0,0",
    "0,0/0,0",
    "--1",
    "-",
    "-.",
    "-,",
    "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999",
    "NaN",
    "Infinity",
    "-Infinity",
    "INF",
    "1#INF",
    "-1#IND",
    "1#QNAN",
    "1#SNAN",
    "1#IND",
    "0x0",
    "0xffffffff",
    "0xffffffffffffffff",
    "0xabad1dea",
    "123456789012345678901234567890123456789",
    "1,000.00",
    "1 000.00",
    "1'000.00",
    "1,000,000.00",
    "1 000 000.00",
    "1'000'000.00",
    "1.000,00",
    "1 000,00",
    "1'000,00",
    "1.000.000,00",
    "1 000 000,00",
    "1'000'000,00",
    "01000",
    "08",
    "09",
    "2.2250738585072011e-308",
    ",./;'[]\\-=",
    "<>?:\"{}|_+",
    "!@#$%^&*()`~",
    "",
    "­؀؁؂؃؄؅؜۝܏᠎​‌‍‎‏‪‫‬‭‮⁠⁡⁢⁣⁤⁦⁧⁨⁩⁪⁫⁬⁭⁮⁯﻿￹￺￻𑂽𛲠𛲡𛲢𛲣𝅳𝅴𝅵𝅶𝅷𝅸𝅹𝅺󠀁󠀠󠀡󠀢󠀣󠀤󠀥󠀦󠀧󠀨󠀩󠀪󠀫󠀬󠀭󠀮󠀯󠀰󠀱󠀲󠀳󠀴󠀵󠀶󠀷󠀸󠀹󠀺󠀻󠀼󠀽󠀾󠀿󠁀󠁁󠁂󠁃󠁄󠁅󠁆󠁇󠁈󠁉󠁊󠁋󠁌󠁍󠁎󠁏󠁐󠁑󠁒󠁓󠁔󠁕󠁖󠁗󠁘󠁙󠁚󠁛󠁜󠁝󠁞󠁟󠁠󠁡󠁢󠁣󠁤󠁥󠁦󠁧󠁨󠁩󠁪󠁫󠁬󠁭󠁮󠁯󠁰󠁱󠁲󠁳󠁴󠁵󠁶󠁷󠁸󠁹󠁺󠁻󠁼󠁽󠁾󠁿",
    "﻿",
    "￾",
    "Ω≈ç√∫˜µ≤≥÷",
    "åß∂ƒ©˙∆˚¬…æ",
    "œ∑´®†¥¨ˆøπ“‘",
    "¡™£¢∞§¶•ªº–≠",
    "¸˛Ç◊ı˜Â¯˘¿",
    "ÅÍÎÏ˝ÓÔÒÚÆ☃",
    "Œ„´‰ˇÁ¨ˆØ∏”’",
    "`⁄€‹›ﬁﬂ‡°·‚—±",
    "⅛⅜⅝⅞",
    "ЁЂЃЄЅІЇЈЉЊЋЌЍЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя",
    "٠١٢٣٤٥٦٧٨٩",
    "⁰⁴⁵",
    "₀₁₂",
    "⁰⁴⁵₀₁₂",
    "ด้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็ ด้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็ ด้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็",
    "'",
    "\"",
    "''",
    "\"\"",
    "'\"'",
    "\"''''\"'\"",
    "\"'\"'\"''''\"",
    "<foo val=“bar” />",
    "<foo val=“bar” />",
    "<foo val=”bar“ />",
    "<foo val=`bar' />",
    "田中さんにあげて下さい",
    "パーティーへ行かないか",
    "和製漢語",
    "部落格",
    "사회과학원 어학연구소",
    "찦차를 타고 온 펲시맨과 쑛다리 똠방각하",
    "社會科學院語學研究所",
    "울란바토르",
    "𠜎𠜱𠝹𠱓𠱸𠲖𠳏",
    "Ⱥ",
    "Ⱦ",
    "ヽ༼ຈل͜ຈ༽ﾉ ヽ༼ຈل͜ຈ༽ﾉ ",
    "(｡◕ ∀ ◕｡)",
    "｀ｨ(´∀｀∩",
    "__ﾛ(,_,*)",
    "・(￣∀￣)・:*:",
    "ﾟ･✿ヾ╲(｡◕‿◕｡)╱✿･ﾟ",
    ",。・:*:・゜’( ☻ ω ☻ )。・:*:・゜’",
    "(╯°□°）╯︵ ┻━┻)",
    "(ﾉಥ益ಥ）ﾉ﻿ ┻━┻",
    "┬─┬ノ( º _ ºノ)",
    "( ͡° ͜ʖ ͡°)",
    "😍",
    "👩🏽",
    "👾 🙇 💁 🙅 🙆 🙋 🙎 🙍",
    "🐵 🙈 🙉 🙊",
    "❤️ 💔 💌 💕 💞 💓 💗 💖 💘 💝 💟 💜 💛 💚 💙",
    "✋🏿 💪🏿 👐🏿 🙌🏿 👏🏿 🙏🏿",
    "🚾 🆒 🆓 🆕 🆖 🆗 🆙 🏧",
    "0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟",
    "🇺🇸🇷🇺🇸 🇦🇫🇦🇲🇸",
    "🇺🇸🇷🇺🇸🇦🇫🇦🇲",
    "🇺🇸🇷🇺🇸🇦",
    "１２３",
    "١٢٣",
    "ثم نفس سقطت وبالتحديد،, جزيرتي باستخدام أن دنو. إذ هنا؟ الستار وتنصيب كان. أهّل ايطاليا، بريطانيا-فرنسا قد أخذ. سليمان، إتفاقية بين ما, يذكر الحدود أي بعد, معاملة بولندا، الإطلاق عل إيو.",
    "בְּרֵאשִׁית, בָּרָא אֱלֹהִים, אֵת הַשָּׁמַיִם, וְאֵת הָאָרֶץ",
    "הָיְתָהtestالصفحات التّحول",
    "﷽",
    "ﷺ",
    "مُنَاقَشَةُ سُبُلِ اِسْتِخْدَامِ اللُّغَةِ فِي النُّظُمِ الْقَائِمَةِ وَفِيم يَخُصَّ التَّطْبِيقَاتُ الْحاسُوبِيَّةُ، ",
    "​",
    " ",
    "᠎",
    "　",
    "﻿",
    "␣",
    "␢",
    "␡",
    "‪‪test‪",
    "‫test‫",
    """
    test
    """,
    "test⁠test‫",
    "⁦test⁧",
    "Ṱ̺̺̕o͞ ̷i̲̬͇̪͙n̝̗͕v̟̜̘̦͟o̶̙̰̠kè͚̮̺̪̹̱̤ ̖t̝͕̳̣̻̪͞h̼͓̲̦̳̘̲e͇̣̰̦̬͎ ̢̼̻̱̘h͚͎͙̜̣̲ͅi̦̲̣̰̤v̻͍e̺̭̳̪̰-m̢iͅn̖̺̞̲̯̰d̵̼̟͙̩̼̘̳ ̞̥̱̳̭r̛̗̘e͙p͠r̼̞̻̭̗e̺̠̣͟s̘͇̳͍̝͉e͉̥̯̞̲͚̬͜ǹ̬͎͎̟̖͇̤t͍̬̤͓̼̭͘ͅi̪̱n͠g̴͉ ͏͉ͅc̬̟h͡a̫̻̯͘o̫̟̖͍̙̝͉s̗̦̲.̨̹͈̣",
    "̡͓̞ͅI̗̘̦͝n͇͇͙v̮̫ok̲̫̙͈i̖͙̭̹̠̞n̡̻̮̣̺g̲͈͙̭͙̬͎ ̰t͔̦h̞̲e̢̤ ͍̬̲͖f̴̘͕̣è͖ẹ̥̩l͖͔͚i͓͚̦͠n͖͍̗͓̳̮g͍ ̨o͚̪͡f̘̣̬ ̖̘͖̟͙̮c҉͔̫͖͓͇͖ͅh̵̤̣͚͔á̗̼͕ͅo̼̣̥s̱͈̺̖̦̻͢.̛̖̞̠̫̰",
    "̗̺͖̹̯͓Ṯ̤͍̥͇͈h̲́e͏͓̼̗̙̼̣͔ ͇̜̱̠͓͍ͅN͕͠e̗̱z̘̝̜̺͙p̤̺̹͍̯͚e̠̻̠͜r̨̤͍̺̖͔̖̖d̠̟̭̬̝͟i̦͖̩͓͔̤a̠̗̬͉̙n͚͜ ̻̞̰͚ͅh̵͉i̳̞v̢͇ḙ͎͟-҉̭̩̼͔m̤̭̫i͕͇̝̦n̗͙ḍ̟ ̯̲͕͞ǫ̟̯̰̲͙̻̝f ̪̰̰̗̖̭̘͘c̦͍̲̞͍̩̙ḥ͚a̮͎̟̙͜ơ̩̹͎s̤.̝̝ ҉Z̡̖̜͖̰̣͉̜a͖̰͙̬͡l̲̫̳͍̩g̡̟̼̱͚̞̬ͅo̗͜.̟",
    "̦H̬̤̗̤͝e͜ ̜̥̝̻͍̟́w̕h̖̯͓o̝͙̖͎̱̮ ҉̺̙̞̟͈W̷̼̭a̺̪͍į͈͕̭͙̯̜t̶̼̮s̘͙͖̕ ̠̫̠B̻͍͙͉̳ͅe̵h̵̬͇̫͙i̹͓̳̳̮͎̫̕n͟d̴̪̜̖ ̰͉̩͇͙̲͞ͅT͖̼͓̪͢h͏͓̮̻e̬̝̟ͅ ̤̹̝W͙̞̝͔͇͝ͅa͏͓͔̹̼̣l̴͔̰̤̟͔ḽ̫.͕",
    "Z̮̞̠͙͔ͅḀ̗̞͈̻̗Ḷ͙͎̯̹̞͓G̻O̭̗̮",
    "˙ɐnbᴉlɐ ɐuƃɐɯ ǝɹolop ʇǝ ǝɹoqɐl ʇn ʇunpᴉpᴉɔuᴉ ɹodɯǝʇ poɯsnᴉǝ op pǝs 'ʇᴉlǝ ƃuᴉɔsᴉdᴉpɐ ɹnʇǝʇɔǝsuoɔ 'ʇǝɯɐ ʇᴉs ɹolop ɯnsdᴉ ɯǝɹo˥",
    "00˙Ɩ$-",
    "Ｔｈｅ ｑｕｉｃｋ ｂｒｏｗｎ ｆｏｘ ｊｕｍｐｓ ｏｖｅｒ ｔｈｅ ｌａｚｙ ｄｏｇ",
    "𝐓𝐡𝐞 𝐪𝐮𝐢𝐜𝐤 𝐛𝐫𝐨𝐰𝐧 𝐟𝐨𝐱 𝐣𝐮𝐦𝐩𝐬 𝐨𝐯𝐞𝐫 𝐭𝐡𝐞 𝐥𝐚𝐳𝐲 𝐝𝐨𝐠",
    "𝕿𝖍𝖊 𝖖𝖚𝖎𝖈𝖐 𝖇𝖗𝖔𝖜𝖓 𝖋𝖔𝖝 𝖏𝖚𝖒𝖕𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖑𝖆𝖟𝖞 𝖉𝖔𝖌",
    "𝑻𝒉𝒆 𝒒𝒖𝒊𝒄𝒌 𝒃𝒓𝒐𝒘𝒏 𝒇𝒐𝒙 𝒋𝒖𝒎𝒑𝒔 𝒐𝒗𝒆𝒓 𝒕𝒉𝒆 𝒍𝒂𝒛𝒚 𝒅𝒐𝒈",
    "𝓣𝓱𝓮 𝓺𝓾𝓲𝓬𝓴 𝓫𝓻𝓸𝔀𝓷 𝓯𝓸𝔁 𝓳𝓾𝓶𝓹𝓼 𝓸𝓿𝓮𝓻 𝓽𝓱𝓮 𝓵𝓪𝔃𝔂 𝓭𝓸𝓰",
    "𝕋𝕙𝕖 𝕢𝕦𝕚𝕔𝕜 𝕓𝕣𝕠𝕨𝕟 𝕗𝕠𝕩 𝕛𝕦𝕞𝕡𝕤 𝕠𝕧𝕖𝕣 𝕥𝕙𝕖 𝕝𝕒𝕫𝕪 𝕕𝕠𝕘",
    "𝚃𝚑𝚎 𝚚𝚞𝚒𝚌𝚔 𝚋𝚛𝚘𝚠𝚗 𝚏𝚘𝚡 𝚓𝚞𝚖𝚙𝚜 𝚘𝚟𝚎𝚛 𝚝𝚑𝚎 𝚕𝚊𝚣𝚢 𝚍𝚘𝚐",
    "⒯⒣⒠ ⒬⒰⒤⒞⒦ ⒝⒭⒪⒲⒩ ⒡⒪⒳ ⒥⒰⒨⒫⒮ ⒪⒱⒠⒭ ⒯⒣⒠ ⒧⒜⒵⒴ ⒟⒪⒢",
    "If you're reading this, you've been in a coma for almost 20 years now. We're trying a new technique. We don't know where this message will end up in your dream, but we hope it works. Please wake up, we miss you.",
    "Roses are \u{001b}[0;31mred\\u001b[0m, violets are \u{001b}[0;34mblue. Hope you enjoy terminal hue",
    "But now...\u{001b}[20Cfor my greatest trick...\u{001b}[8m",
    "Powerلُلُصّبُلُلصّبُررً ॣ ॣh ॣ ॣ冗"
]

