using System;

namespace dotnetcore
{
    //Delegate Declaration
    public delegate void PrintMessage(string msg);
    //Class with static method to bind delegate 
    public class MessagePrinter{
        public static void PrintLine(string Message ){
            Console.WriteLine("==>"+Message);
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            //Create a PrintMessage delegate Object that points to MessagePrinter
            PrintMessage p = new PrintMessage(MessagePrinter.PrintLine);
            p("Hello World!");
            Console.ReadLine();
        }
    }
}
