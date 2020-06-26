
import random
import time
start_time =time.time();
numbers = [123,100,44,125,122,33,111,23,44,99,108,17,106,112,123,100,44,125,122,33,111,23,44,99,108,17,106,112];   
print(len(numbers));
coprime = [];
encryptedData = [];
coprimeCount=0;
p= int(15);
q = int(p+5);
rand=0;
randp=0;
randq=0;
mod=0;
lamda=0;
a=0;
b=0;
temp_a=0;

i =1;
while i<=q:
    rand = random.randint(1,15);
    #print(rand,"---", i);
    if i==p:
       randp = int(rand);
    if i==q:
        randq=int(rand);
    i = i +1;

mod = randp*randq;
lamda = (randp-1)*(randq-1);
print("p value:", randp);
print("q value:", randq);
print("modulus:", mod);
print("lambda",lamda);

for x in range(lamda):
    a=lamda;
    b=x;
    while b!=0:
        temp_a=a;
        a=b;
        b=temp_a%b;
    if(a==1):
        coprime.append(x);

print("coprime list:", coprime);
length = len(coprime);
print(length);
print(length);
if (length%2==0):
    pos = int(length/2);
    

else:
    pos = int((length+1)/2);
 
ekey = coprime[pos];
print("encryption key:", ekey);

for x in numbers:
    encryptedValue = int(x+ekey%mod);
    encryptedData.append(encryptedValue);

print(encryptedData);
print("--- %s seconds ---" % (time.time() - start_time));







