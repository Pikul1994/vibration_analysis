%================================================================== 

% Program do obrobki i wstepnej analizy danych laboratoryjnych 

%================================================================== 

% Autor inz. Kamil Pikulski, Warszawa 2019 

% Wydzial Samochodow i Maszyn Roboczych, Politechnika Warszawskiej 

% Instytut Podstaw Budowy Maszyn 

% W celu unikniecia bledow - brak polskich znakow 

%================================================================== 

% Czyszczenie danych z poprzednich obliczeń 

  clear all;  

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

% Import danych 

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

% Z pliku excel - zarejestrowane predkosci 

% Dane wczytywane sa do macierzy  

  [Wyniki_czas] = xlsread('dane.xlsx', 'B2:AG4097');  

% Z pliku excel - czas rejestracji 

% Dane wczytywane sa do wektora 

  [Czas] = xlsread('dane.xlsx', 'A2:A4097');  

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

% Szybka Transformata Fouriera  

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

% Petla wykonujaca Szybka Transformate Fouriera i zapisujaca kolejne 

% transformaty jako kolejne kolumny wektora WynikSTF 

  for i = 1: 32 

    STF = fft(Wyniki_czas(:, i));  

      WynikSTF(:, i)= STF;  

  end 

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

% Przejscie z dziedziny czasu na  

% czestotliwosci 

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

% Okres probkowania 

  DT = Czas(2,1) - Czas(1,1);  

% Czestotliwosc probkowania 

  FS=1/DT;  

% Krok czestotliwosci 

  DF = FS/size(Czas,1);  

% Zakres analizowanych czestotliwosci od 0 do FS/2 ze wzgledu na symetrie 

  freq = 0:DF:FS/2;  

% Ilosc wierszy w macierzy WynikSTF podzielona na dwa + 1 

% Musi byc tyle samo danych dla czestotliwosci jak i dla FFT 

  w = size(WynikSTF,1)/2 +1;  

% Wartosc bezwzgledna z Szybkiej Transformaty Fouriera 

  x=abs(WynikSTF) 

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

% Stworzenie krzywych dla kazdego z pomiarow oraz poszukiwanie ekstremow 

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

      for j = 1:32 

        l=(j - 1)*0. 1 

       h=figure;  

       plot(freq,x(1:w, j)) 

       title(['Widmo amplitudowe, ugiecie ',num2str(l), ' mm']) 

       xlabel('Czestotliwosc [Hz]') 

       ylabel('Amplituda') 

    % zapis do plikow.png 

       saveas(h, sprintf('krzywa%d.png', j)) 

    % zapis do plikow.fig 

       saveas(h, sprintf('krzywa%d.fig', j)) 

    % poszukiwanie extremow oraz czestosci dla ktorych ekstrema 

    % wystepuja 

       [pks,locs] = findpeaks(x(1:w,j), freq, 'MinPeakProminence',2,'MinPeakDistance',20', 'NPeaks',4);  

    % sortowanie czestotliwosci (dla ktorych wystepuja ekstrema) od 

    % najmniejszych do najwiekszych 

       B=sort(locs)';  

    % instrukcje warunkowe zapewniajace unikniecie bledow przy 

    % tworzeniu matrycy czestosci drgan wlasnych 

       if length(B)==3 

         B(4,1)=0 

       end 

       if length(B)==2 

         B(4,1)=0 

         B(3,1)=0 

       end 

       if length(B)==2 

         B(4,1)=0 

         B(3,1)=0 

         B(2,1)=0 

       end 

    % stworzenie macierzy czestosci drgan wlasnych 

       maksima(:, j)=B 

    % stworzenie widm z zaznaczonymi wartosciami maksymalnymi 

       findpeaks(x(1:w, j), freq, 'MinPeakProminence',2, 'MinPeakDistance',20', 'NPeaks',0, 'Annotate', 'peaks') 

       title(['Widmo amplitudowe (zaznaczone ekstrema), ugiecie ', num2str(l), ' mm']) 

       xlabel('Czestotliwosc [Hz]') 

       ylabel('Amplituda') 

       axis([0 300 0 80]) 

       % zapis do plikow.png 

       saveas(h, sprintf('peaks%d.png', j)) 

       % zapis do plikow.fig 

       saveas(h, sprintf('peaks%d.fig', j)) 

      end   

     % zapis macierzy czestosci drgan wlasnych do pliku. xls 

     xlswrite('czestosci. xls', maksima, 'page1', 'A1');  
