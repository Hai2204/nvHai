using System;
using System.Text;
using System.Threading.Tasks;
using System.Linq;

namespace Bai_Thay_chương
{
    class Program
    {
        /// <summary>
        /// đây là hàm tính giai thừa x
        /// </summary>
        /// <param name="x">Giá trị nguyên</param>
        /// <returns></returns>
        static double gt(double x)
        {
            if (x == 1)
                return 1;
            return x * gt(x - 1);
        }
        /// <summary>
        /// Đây là hàm tính tử và mẫu của sx tắc nghẽn PB
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns></returns>
        static double ham1(double x,double y)
        {
            if (y <= 1)
                return 0;
            else return Math.Pow(x, y) / gt(y);
        }

        
        static void Main(string[] args)
        {
            Console.OutputEncoding = Encoding.UTF8;
            Double μ = 0.020833, P, m = 0;
            double B = 0.6, ɣ;
            double PB;
            int w, c;
            Console.WriteLine("nhập số bước sóng w = ");
            w = int.Parse(Console.ReadLine());
            Console.WriteLine("nhập số bộ chuyển đổi bước sóng c = ");
            c = int.Parse(Console.ReadLine());
            ɣ = B * (w * μ);
            P = ɣ / μ;
            for (float i = 0; i <= w; i++)
            {
                m = m + ham1(P, i);
            }
            PB = ham1(P, w) / m;
            Console.WriteLine("Xác suất tắc nghẽn PB = {0} với {1} bước sóng và {2} bộ chuyển đổi", PB, w, c);
            Console.WriteLine();



        }
    }
}
