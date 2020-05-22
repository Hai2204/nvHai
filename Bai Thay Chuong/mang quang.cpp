#include<stdio.h>
#include<conio.h>
#include<math.h>
int giaithua(int n)
{
	  if (n == 1)
        return 1;
    return n * giaithua(n - 1);
}

int main()
{
	int S,W,C = 3;
	float Y,U = 0.020833;
	float PB,P = Y/U;
	printf("nhap W: ");
	scanf("%d",W);
	for(int i = 0;i <=W;i++){
		S = S + pow(P,i)/giaithua(i);
	}
	PB = (pow(P,W)/giaithua(W))/S;
	printf("ket qua: %f",PB);
	
}
