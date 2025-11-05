% Yardimci kural: Sayısal uyku saatini 'az', 'orta', 'cok' olarak kategorize eder.
uyku_suresi(az, S) :- S < 6.
uyku_suresi(orta, S) :- S >= 6, S =< 8.
uyku_suresi(cok, S) :- S > 8.

% Ana Uyku Kurali: Girdilere (saat, kafein, stres) gore uyku kalitesini 'kotu', 'orta' veya 'iyi' olarak belirler.
uyku_kalitesi(Saat, Kafein, Stres, YatmaSaati, Kalite) :-
    uyku_suresi(UykuDurum, Saat),
    (   (UykuDurum = az ; Kafein = yuksek ; Stres = yuksek ; YatmaSaati > 23 ; YatmaSaati < 21) ->
        Kalite = kotu ;
     (UykuDurum = orta, (Stres = orta ; Kafein = orta)) ->
        Kalite = orta ;
     Kalite = iyi ).

% Kilo, aktivite ve sıcaklığa göre günlük ideal su ihtiyacını (litre) olarak hesaplar.
su_ihtiyaci(Kilo, Aktivite, Sicaklik, SuLitre) :-
    Temel is Kilo * 0.035,
    (Aktivite = dusuk -> EkstraA = 0 ; Aktivite = orta -> EkstraA = 0.5 ; EkstraA = 1.0),
    (Sicaklik = serin -> EkstraS = 0 ; Sicaklik = iliman -> EkstraS = 0.3 ; EkstraS = 0.7),
    SuLitre is Temel + EkstraA + EkstraS.

% İhtiyaç duyulan su ile içilen suyu karşılaştırarak duruma uygun bir yorum yapar.
su_yorumu(IcilenMiktar, Ihtiyac, Yorum) :-
    Fark is Ihtiyac - IcilenMiktar,
    ( Fark > 0.5 -> Yorum = 'Ihtiyacinizdan oldukca az su iciyorsunuz.' ;
      Fark > 0.2 -> Yorum = 'Ihtiyaciniza yakin, biraz daha artirabilirsiniz.' ;
      Fark < -0.7 -> Yorum = 'Ihtiyacinizdan fazla su iciyorsunuz.' ;
      Yorum = 'Su tuketiminiz ideal gorunuyor.'
    ).

% Stres seviyesi ve uyku kalitesine bakarak bir sağlık tavsiyesi oluşturur.
stres_tavsiyesi(Stres, UykuKalite, Tavsiye) :-
    ( (Stres = yuksek, UykuKalite = kotu) ->
        Tavsiye = 'Stresiniz ve uyku kaliteniz kötü. Derin nefes, meditasyon ve erken yatma önerilir.' ;
      Stres = yuksek ->
        Tavsiye = 'Stresiniz yüksek. Meditasyon ve kısa molalar iyi gelir.' ;
      Stres = orta ->
        Tavsiye = 'Orta düzey stres. Kısa molalar yeterli olabilir.' ;
      Stres = dusuk ->
        Tavsiye = 'Stresiniz düşük. Harika! Mevcut durumunuzu koruyun.' ;
      Tavsiye = 'Stres durumu icin bir yorum yok.'
    ).

% Ruh hali (Ruh) ve boş zaman tercihine (Bos) göre kişiye özel bir aktivite önerisi sunar.
aktivite_onerisi(Ruh, Bos, Oneri) :-
    ( (Ruh = mutlu, Bos = evde) -> Oneri = 'Evde kitap okuyabilir veya film izleyebilirsiniz.' ;
      (Ruh = mutlu, Bos = disari) -> Oneri = 'Disari cikip yürüyüş yapabilirsiniz.' ;
      (Ruh = yorulmus, Bos = evde) -> Oneri = 'Dinlenin veya hafif bir muzik acabilirsiniz.' ;
      (Ruh = yorulmus, Bos = disari) -> Oneri = 'Kısa bir yürüyüş enerji verebilir.' ;
      (Ruh = stresli, Bos = evde) -> Oneri = 'Meditasyon veya nefes egzersizleri yapabilirsiniz.' ;
      (Ruh = stresli, Bos = disari) -> Oneri = 'Doğada kısa bir yürüyüş stresi azaltabilir.' ;
      Oneri = 'Keyfinize gore bir aktivite secin.' % Varsayilan durum
    ).


% ---------- MAIN (ANA BASLATICI KURAL) ----------
% Programın ana kuralıdır; tüm soruları sorar, modülleri çalıştırır ve sonuçları ekrana basar.
basla :-
    write('=== GELİŞMİŞ YAŞAM VE GÜNLÜK KARAR ASİSTANI ==='), nl, nl,
    
    write('Gunde kac saat uyuyorsunuz? (Orn: 7): '), read(UykuSaat),
    write('Kafein tuketiminiz (az/orta/yuksek): '), read(Kafein),
    write('Stres seviyeniz (dusuk/orta/yuksek): '), read(Stres),
    write('Yatma saatiniz (24 saat formatinda, Orn: 23): '), read(YatmaSaat),
    write('Kilonuz (kg) (Orn: 70): '), read(Kilo),
    write('Aktivite duzeyiniz (dusuk/orta/yuksek): '), read(Aktivite),
    write('Hava durumu (serin/iliman/sicak): '), read(HavaDurum),
    write('Gunde ortalama kac litre su iciyorsunuz? (Orn: 1.5): '), read(SuMiktar),
    write('Ruh haliniz (mutlu/yorulmus/stresli): '), read(RuhHali),
    write('Bos zaman tercihiniz (evde/disari): '), read(BosZaman),
    nl,
    
    uyku_kalitesi(UykuSaat, Kafein, Stres, YatmaSaat, UykuKalite),
    su_ihtiyaci(Kilo, Aktivite, HavaDurum, SuIhtiyaci),
    su_yorumu(SuMiktar, SuIhtiyaci, SuYorumu),
    stres_tavsiyesi(Stres, UykuKalite, StresTavsiyesi),
    aktivite_onerisi(RuhHali, BosZaman, AktiviteOneri),

    write('--- ANALIZ SONUCU ---'), nl,
    format('Uyku Kalitesi: ~w~n', [UykuKalite]),
    format('Gunluk Su Ihtiyaciniz: ~2f litre. (Siz ~w litre iciyorsunuz. ~w)~n', [SuIhtiyaci, SuMiktar, SuYorumu]),
    format('Stres Tavsiyesi: ~w~n', [StresTavsiyesi]),
    format('Günlük Aktivite Önerisi: ~w~n', [AktiviteOneri]),
    write('-------------------------'), nl.