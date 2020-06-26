import random
import time
start_time =time.time();
numbers = [123,100,44,125,122,33,111,23,44,99,108,17,106];   
print(len(numbers));
encryptedData = [];
ekey = 46;
mod = 112;

for x in numbers:
    encryptedValue = int((x+ekey)%mod);
    encryptedData.append(encryptedValue);

print(encryptedData);
print("--- %s seconds ---" % (time.time() - start_time));



