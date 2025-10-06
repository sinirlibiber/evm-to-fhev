EVM'den FHEVM'e Dönüştürücü
Bu depo, EVM benzeri bytecode'ları Fully Homomorphic Encryption Virtual Machine (FHEVM) uyumlu işlemlere dönüştüren basit bir Python tabanlı araç sunar. TFHE kütüphanesi kullanılarak temel aritmetik işlemler (örneğin, ADD, MUL) için gizlilik koruyucu hesaplamalar simüle edilir.
HadesGuard/evm-to-fhevm reposundan ilham alınarak oluşturulmuştur. Eğitim amaçlıdır ve EVM opcode'larının Zama'nın fhEVM gibi FHE ortamlarına nasıl uyarlanabileceğini gösterir.
Özellikler

Basit EVM bytecode'larını (PUSH, ADD, MUL) FHE işlemlerine dönüştürür.
Değerleri şifreler ve homomorfik olarak hesaplamalar yapar.
Örnek Solidity kontratı ve testler içerir.

Kurulum

Depoyu klonlayın: git clone https://github.com/kullaniciadiniz/evm-to-fhevm-converter.git
Bağımlılıkları yükleyin: pip install -r requirements.txt
Not: TFHE, yerel kütüphaneler için conda ile kurulumu gerektirebilir.



Kullanım
Dönüştürücüyü çalıştırın:
python src/fhevm_converter.py

Bu, örnek bir bytecode çalıştırır ve şifresi çözülmüş sonucu gösterir.
Testleri çalıştırın:
python -m unittest tests/test_converter.py

Örnek

Bytecode: ['PUSH', 5, 'PUSH', 3, 'ADD'] → Sonuç: 8 (şifreli hesaplanır).

Sınırlamalar

Sadece temel opcode'ları destekler; tam EVM uyumluluğu için genişletilebilir.
Performans: FHE hesaplamaları yoğun işlem gerektirir.
Gerçek FHEVM için Zama'nın SDK'sını kullanın.

Lisans
MIT Lisansı
