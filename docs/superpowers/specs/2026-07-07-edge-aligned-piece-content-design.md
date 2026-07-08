# Dış Kenar Hizalı Dilim İçeriği Yerleşimi — Tasarım Dokümanı

**Tarih:** 2026-07-07
**Kapsam:** `YKPieceUI` içerik yerleşimi (konumlandırma + boyutlandırma)
**Branch:** `feature/edge-aligned-content`

## 1. Problem

Mevcut yerleşim mantığında iki hata var (ekran görüntüsüyle doğrulandı):

1. **İçerik taşması:** İçerik merkezi, yarıçapın sabit bir oranına (`normalSliceContentRadiusRatio: 0.62`) yerleştiriliyor ve görsel boyutu yalnızca yarıçapla ölçekleniyor (`imageWidthScaleNormalSlice: 0.30`). Görsel + boşluk + metin toplam yüksekliği bu merkez noktasından dışa taşabiliyor. İçeriği dilim sınırına göre kısıtlayan hiçbir kontrol yok; yalnızca arka plan `clipShape` ile kırpılıyor.
2. **İnce dilimde görsel-metin çakışması:** İnce dilimde metin `rotationEffect(-90°)` ile döndürülüyor. `rotationEffect` yalnızca görsel bir dönüşümdür; layout sistemi metni hâlâ yatay sanır. Çakışma, elle ayarlanmış sabit ofsetlerle (`thinSliceImageVerticalOffsetRatio: -0.22`) ve sabit bir `0.30 × 0.42 radius` çerçeveyle önlenmeye çalışılıyor. Uzun metinlerde (ör. "Diamond Chest") bu sabitler yetmiyor ve metin görselin alanına giriyor.

## 2. Çözüm Özeti

İçerik, **dış kenardan sabit bir boşluk (edge padding) bırakarak** hizalanır ve dilimin gerçek geometrisine (açı + yarıçap) göre **deterministik** olarak boyutlandırılır. İçeriğin dış ucu tüm dilimlerde kenardan eşit uzaklıkta olur; içerik içeri doğru büyür. Taşma yapısal olarak imkânsız hale gelir.

### Hizalama davranışı (bilinçli tercih)

Dilimler arasında **dış kenar hizası** korunur; içerik merkezleri farklı yarıçaplarda kalabilir. Küçük içerikli dilimde içerik kenara yakın durur, büyük içerikli dilimde daha içeri uzanır. (Merkez hizalı alternatif değerlendirildi ve kullanıcı tercihiyle elendi.)

## 3. Mimari

Değişiklikler `YKPieceUI.swift` ile sınırlıdır; ayrıca bir yeni environment key dosyası ve modifier eklenir. `PieSliceShape`, `YKSpinWheel`, `YKSpinController`, `SpinModel` değişmez.

### 3.1 Geometri hesaplayıcısı (saf katman)

`YKPieceUI.swift` içinde, view'dan bağımsız, `internal` bir hesaplayıcı eklenir (mevcut `PieceLayoutConstants` kalıbına uygun):

- **Girdiler:** `sliceAngle`, `spacingAngle`, `innerRadius`, `outerRadius`, `edgePaddingRatio`, içerik senaryosu (yalnız metin / yalnız görsel / görsel+metin / custom / custom+metin), `verticalSpacing`.
- **Çıktılar:** görsel kare boyutu, metin çerçevesi (genişlik × yükseklik), toplam içerik yüksekliği, içerik merkezinin yarıçapı.

İki kısıt birlikte uygulanır:

1. **Radyal kısıt:** içerik `innerRadius` ile `outerRadius − edgePadding` arasına sığmalıdır. Toplam yükseklik bu aralığı aşarsa bileşenler orantılı küçültülür.
2. **Enine (kiriş) kısıtı:** etkili yarım açı `θ = (sliceAngle/2 − spacingAngle)` olmak üzere, içeriğin en iç noktasındaki kiriş genişliği `2·r·sin(θ)`'dir. Kare görsel için kapalı-form çözüm kullanılır:
   `boyut ≤ 2·sin(θ)·(outerRadius − edgePadding) / (1 + 2·sin(θ))`
   Böylece dar dilimlerde görsel otomatik küçülür.

İçerik merkezi: `contentCenterRadius = outerRadius − edgePadding − toplamYükseklik / 2`.

### 3.2 Deterministik çerçeveler

Runtime ölçüm (GeometryReader/PreferenceKey) kullanılmaz; tüm boyutlar önceden hesaplanır:

- **Görsel:** kare çerçeve (`boyut × boyut`), içinde `resizable().scaledToFit()`. En-boy oranı ne olursa olsun kapladığı alan bellidir.
- **Metin:** hesaplanmış genişlik × (satır sayısı · satır yüksekliği) sabit çerçevesi; `minimumScaleFactor` ile içine sığar. Font boyutu mevcut mantıktaki gibi yarıçapla ölçeklenir, ancak çerçeve kiriş kısıtına göre daraltılır.

### 3.3 İnce dilim düzeltmesi

Metin `-90°` döndürüldükten sonra **genişlik/yükseklik değerleri takas edilmiş sabit bir çerçeveye** sarılır; böylece döndürülmüş metin layout'ta gerçek yerini kaplar. `thinSliceImageVerticalOffsetRatio`, `contentVerticalOffsetRatio` gibi elle ayarlanmış ofsetler ve `0.30 × 0.42` sabit çerçeve silinir. İnce dilim dizilimi radyal eksende olur: görsel dışta, metin içte.

### 3.4 Beş içerik senaryosu korunur

`contentView(radius:)` içindeki senaryo yapısı aynen kalır: (1) yalnız metin, (2) yalnız görsel, (3) yalnız custom view, (4) custom view + metin, (5) görsel + metin. Hepsi yeni geometri hesaplayıcısından beslenir.

### 3.5 Yeni environment key

Mevcut key kalıbıyla birebir:

- **Dosya:** `Sources/YKSpinWheel/EnvironmentVariables/YKPiece/YKPieceContentEdgePaddingKey.swift`
- **Değer:** `Double`, yarıçapın oranı olarak (varsayılan `0.05`). Oran tercih edildi çünkü çark her konteyner boyutunda aynı görünmelidir.
- **Modifier:** `YKPieceEnvironmentVariablesViewModifiers.swift` içine `ykPieceContentEdgePadding(_:)`.

Diğer tüm ölçek sabitleri `private` kalır; API yüzeyi bunun dışında büyümez.

## 4. Hata / Sınır Durumları

- **Custom view (`AnyView`):** hesaplanan kare çerçeve `.frame` ile önerilir; kullanıcı içeride sabit boyut verdiyse taşabilir. Zorla kırpma yapılmaz; davranış doc-comment'te belirtilir.
- **Aşırı dar dilim** (kiriş kısıtı görseli çok küçültürse): görsel hesaplanan boyuta kadar küçülür; alt sınır dayatılmaz. Metin `minimumScaleFactor` ile küçülür.
- **`totalWeight = 0` / `sliceAngle = 0`:** geometri fonksiyonları sıfır/negatif alanda güvenli davranır (boyutları 0'a sabitler), crash olmaz.

## 5. Test

- İskelet haldeki `Tests/YKSpinWheelTests` doldurulur: geometri hesaplayıcısının saf fonksiyonları için birim testler.
  - Kiriş kısıtı kapalı-form çözümünün doğruluğu (dar/geniş açı örnekleri).
  - Radyal kısıt: `içerik dış ucu ≤ outerRadius − edgePadding` her senaryoda.
  - Sınır durumlar: `sliceAngle = 0`, çok küçük açı, `innerRadius ≈ outerRadius`.
- Görsel doğrulama: `YKPieceUI_Previews` ve `YKSpinWheel_Previews` mevcut önizlemeleri; ekran görüntüsündeki senaryo (ağırlıklı 4 dilim, uzun metinli ince dilim) önizlemeye eklenir.

## 6. Görünür Davranış Değişikliği

Mevcut kullanıcılar için içerik konumu biraz dışa kayar (kenar hizalı olduğu için). Bu bilinçli bir görsel iyileştirmedir; geriye dönük uyumluluk katmanı eklenmez.
